import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:http/http.dart' as http;
import '../../Constants/constants.dart';
import 'package:petsecom/Controllers/auth.dart';

import 'CartController.dart';

class CartProduct extends StatefulWidget {
  const CartProduct({super.key});

  @override
  State<CartProduct> createState() => _CartItemState();
}

class _CartItemState extends State<CartProduct> {
  double totalCartPrice = 0; // Deklarasikan secara global
  Map<int, int> productQuantities = {};

  Future<List<dynamic>> fetchCartData() async {
    final urlCart = '${url}list-cart';
    final authController = Get.find<AuthController>();
    final userID = await authController.getUserID();
    final response = await http.get(Uri.parse(urlCart));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      List<Map<String, dynamic>> cartList =
          List<Map<String, dynamic>>.from(data['data']);
      // Filter the cart list based on userID
      List<Map<String, dynamic>> filteredCartList =
          cartList.where((cartItem) => cartItem['id_user'] == userID).toList();

      return filteredCartList;
    } else {
      throw Exception('Failed to load data');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Expanded(
        child: FutureBuilder(
            future: fetchCartData(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: CircularProgressIndicator(),
                ); // Show a loading indicator
              } else if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              } else {
                final cartData = snapshot.data as List<dynamic>;

                return ListView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true, // use it
                    itemCount: cartData.length,
                    itemBuilder: (context, index) {
                      final cartItem = cartData[index];
                      final products = cartItem['products'] as List<dynamic>;

                      return ListView.builder(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: products.length,
                          itemBuilder: (context, pIndex) {
                            final product = products[pIndex];
                            final productName = product['product_name'];
                            final productImage = product['image'];
                            final productPrice = product['price'];
                            final productQty = product['qty'];
                            (
                              context,
                            ) {
                              return Container(
                                padding: EdgeInsets.symmetric(vertical: 5),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 5.0),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(20),
                                      color: Colors.white,
                                      boxShadow: [
                                        BoxShadow(
                                            color:
                                                Colors.black.withOpacity(0.1),
                                            blurRadius: 1,
                                            offset: Offset(0.0, 0.75)),
                                      ],
                                    ),
                                    child: Container(
                                      margin: EdgeInsets.all(5),
                                      child: GestureDetector(
                                        child: Row(
                                          children: [
                                            Container(
                                              height: 100,
                                              width: 100,
                                              decoration: BoxDecoration(
                                                color: Colors.white,
                                                borderRadius:
                                                    BorderRadius.circular(30),
                                              ),
                                              child: Center(
                                                child: Container(
                                                  decoration: BoxDecoration(
                                                    color: Colors.white,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            30),
                                                    image: DecorationImage(
                                                      image: AssetImage(
                                                          'images/dasboard.PNG'),
                                                      fit: BoxFit.fitHeight,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                            SizedBox(width: 12),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            };
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Container(
                                        width: 125,
                                        child: Text(
                                          'Rp ${product['product_name']}', // snapshot.data['data']['id'],
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 12),
                                        ),
                                      ),
                                      Spacer(),
                                      Container(
                                        margin: EdgeInsets.only(bottom: 15),
                                        child: FutureBuilder(
                                            builder: (context, snapshot) {
                                          return GestureDetector(
                                            onTap: () async {
                                              // var response = await http.delete(
                                              //   Uri.parse(
                                              //       "${url}delete-cart/${filteredData?[index]['id']}"),
                                              // );
                                              // if (response.statusCode == 200) {
                                              //   setState(() {
                                              //     filteredData?.removeAt(index);
                                              //   });
                                              // } else {
                                              //   List updatedData =
                                              //       await getItemCart();
                                              //   setState(() {
                                              //     filteredData = updatedData;
                                              //   });
                                              //   Get.snackbar(
                                              //     'Success', // Judul snackbar
                                              //     'Item deleted successfully', // Pesan snackbar
                                              //     backgroundColor:
                                              //         Colors.transparent,
                                              //   );
                                              // }
                                            },
                                            child: Container(
                                              width: 20,
                                              height: 20,
                                              decoration: BoxDecoration(
                                                color: Colors.red[400],
                                                borderRadius:
                                                    BorderRadius.circular(4),
                                              ),
                                              child: Icon(
                                                Icons.delete,
                                                color: Colors.white,
                                                size: 15,
                                              ),
                                            ),
                                          );
                                        }),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 5),
                                  Row(
                                    children: [
                                      Container(
                                        child: Text(
                                          'Rp ${product['price']}',
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                      Spacer(),
                                      Row(
                                        children: [
                                          Container(
                                            child: GestureDetector(
                                              onTap: () {},
                                              child: Container(
                                                width: 20,
                                                height: 20,
                                                decoration: BoxDecoration(
                                                  color: Colors.grey[300],
                                                  borderRadius:
                                                      BorderRadius.circular(4),
                                                ),
                                                child: Icon(
                                                  Icons.remove,
                                                  color: Colors.white,
                                                  size: 15,
                                                ),
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            width: 10,
                                          ),
                                          Text(
                                            'productQty',
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold),
                                          ),
                                          SizedBox(
                                            width: 10,
                                          ),
                                          GestureDetector(
                                            onTap: () {
                                              // setState(() {
                                              //   productQuantities[productId] =
                                              //       (productQuantities[
                                              //                   productId] ??
                                              //               0) +
                                              //           1;
                                              // });
                                            },
                                            child: Container(
                                              width: 20,
                                              height: 20,
                                              decoration: BoxDecoration(
                                                color: Colors.blueAccent,
                                                borderRadius:
                                                    BorderRadius.circular(4),
                                              ),
                                              child: Icon(
                                                Icons.add,
                                                color: Colors.white,
                                                size: 15,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            );
                          });
                    });
              }
            }),
      ),
    );
  }
}
