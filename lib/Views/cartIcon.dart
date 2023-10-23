import 'dart:async';

import 'package:flutter/widgets.dart';
import 'dart:convert';
import 'package:badges/badges.dart' as badges;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart' hide Badge;
import 'package:http/http.dart' as http;
import 'package:get/get.dart';
import '../Constants/constants.dart';
import '../Controllers/auth.dart';
import '../widgets/Cart/CartPage.dart';

class CartIcon extends StatelessWidget {
  final _totalProductsController = StreamController<int>();
  Stream<int> get totalProductsStream => _totalProductsController.stream;
  Future<int> fetchTotalProductsByUserId() async {
    final urlCart = '${url}list-cart';

    final authController = Get.find<AuthController>();
    final response = await http.get(Uri.parse(urlCart));
    final userID = await authController.getUserID();

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      List<Map<String, dynamic>> cartList =
          List<Map<String, dynamic>>.from(data['data']);

      // Calculate the total products for the specified userId
      int totalProducts = 0;

      for (var cartItem in cartList) {
        if (cartItem['id_user'] == userID) {
          final products = cartItem['products'] as List<dynamic>;
          for (var product in products) {
            totalProducts += product['qty'] as int;
          }
        }
      }

      return totalProducts;
    } else {
      throw Exception('Failed to load data');
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<int>(
        future: fetchTotalProductsByUserId(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: Container(
                height: 10,
                width: 10,
                child: CircularProgressIndicator(
                  strokeWidth: 2.0,
                  color: Colors.brown.shade100,
                ),
              ),
            );
          }
          // Data has been successfully fetched
          final totalProducts = snapshot.data;

          return Center(
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (BuildContext context) {
                      return const CartPage();
                    },
                  ),
                );
              },
              child: badges.Badge(
                badgeContent: Text(
                  totalProducts.toString(),
                  style: TextStyle(
                      fontSize: 12,
                      color: Colors.white,
                      fontWeight: FontWeight.bold),
                ),
                child: Icon(
                  Icons.shopping_bag_outlined,
                  color: Colors.grey[200],
                ),
                badgeStyle: badges.BadgeStyle(
                    shape: badges.BadgeShape.square,
                    badgeColor: Colors.deepOrange,
                    borderRadius: BorderRadius.circular(4)),
              ),
            ),
          );
        });
  }
}
