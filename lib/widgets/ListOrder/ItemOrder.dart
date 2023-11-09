import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '../../Constants/constants.dart';
import '../../Controllers/auth.dart';

class ItemOrder extends StatefulWidget {
  const ItemOrder({super.key});

  @override
  State<ItemOrder> createState() => _ItemOrderState();
}

class _ItemOrderState extends State<ItemOrder> {
  Future<List<Map<String, dynamic>>> fetchOrderData() async {
    final urlCart = '${url}list-transaction-cart';
    final response = await http.get(Uri.parse(urlCart));
    final authController = Get.find<AuthController>();
    final userID = await authController.getUserID();

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      List<Map<String, dynamic>> cartList =
          List<Map<String, dynamic>>.from(data['data']);

      List<Map<String, dynamic>> filteredCartList =
          cartList.where((cartItem) => cartItem['id_user'] == userID).toList();

      return filteredCartList;
    } else {
      throw Exception('Failed to load data');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: FutureBuilder(
        future: fetchOrderData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else {
            final orderList = snapshot.data as List<dynamic>;

            return ListView.builder(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: orderList.length,
              itemBuilder: (context, index) {
                final order = orderList[index];
                final products = order['products'] as List<dynamic>;

                return Column(
                  children: products.map((product) {
                    return Container(
                      padding: EdgeInsets.symmetric(vertical: 5),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10.0),
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: Colors.white,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                blurRadius: 1,
                                offset: Offset(0.0, 0.75),
                              ),
                            ],
                          ),
                          child: Container(
                            margin: EdgeInsets.all(5),
                            child: Row(
                              children: [
                                Container(
                                  height: 100,
                                  width: 100,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(30),
                                  ),
                                  child: Center(
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(30),
                                        image: DecorationImage(
                                          image: NetworkImage(
                                            product['image'],
                                          ),
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Container(
                                            width: 100,
                                            child: Text(
                                              product['product_name'],
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 12,
                                              ),
                                            ),
                                          ),
                                          Spacer(),
                                          Container(
                                            margin: EdgeInsets.only(
                                              bottom: 15,
                                              right: 20,
                                            ),
                                            child: Container(
                                              child: Text(
                                                'Qty: ${product['qty']}',
                                                style: TextStyle(
                                                  color: Colors.grey,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 10,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      SizedBox(height: 5),
                                      Row(
                                        children: [
                                          Container(
                                            child: Text(
                                              'Rp ${product['total_price']}',
                                              style: TextStyle(
                                                color: Colors.black,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                );
              },
            );
          }
        },
      ),
    );
  }
}
