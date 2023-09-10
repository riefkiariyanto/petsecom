import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:http/http.dart' as http;
import '../../Constants/constants.dart';
import 'package:petsecom/Controllers/auth.dart';

import 'CartController.dart';

class CartItem extends StatefulWidget {
  const CartItem({super.key});

  @override
  State<CartItem> createState() => _CartItemState();
}

class _CartItemState extends State<CartItem> {
  double totalCartPrice = 0; // Deklarasikan secara global
  Map<int, int> productQuantities = {}; // Map to store product quantities

  static Future<List<dynamic>> getItemCart() async {
    final urlCart = '${url}list-cart';
    final authController = Get.find<AuthController>();
    final userID = await authController.getUserID();

    try {
      http.Response response = await http.get(Uri.parse(urlCart));
      if (response.statusCode == 200) {
        var jsonData = json.decode(response.body);
        List<dynamic> data = jsonData['data'];

        // Filter data based on user_id
        List filteredData =
            data.where((item) => item['id_user'] == userID).toList();

        return filteredData;
      } else {
        print("Error - Status Code: ${response.statusCode}");
        print("Error - Message: ${response.body}");
        return [];
      }
    } catch (e) {
      print('Error: $e');
      return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Expanded(
        child: FutureBuilder(
            future: getItemCart(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                    child:
                        CircularProgressIndicator() // Show a loading indicator
                    );
              } else if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return Center(child: Text('No data available.'));
              } else {
                List? filteredData = snapshot.data;
                double totalCartPrice =
                    0.0; // Initialize the total price variable

                return ListView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true, // use it
                    itemCount: filteredData?.length,
                    itemBuilder: (context, index) {
                      final cartItem = filteredData?[index];
                      final product = cartItem['products'];
                      final productId =
                          product['id_product']; // Get the product ID
                      if (!productQuantities.containsKey(productId)) {
                        productQuantities[productId] = 1;
                      }
                      final productPrice = double.parse(
                          product['price']); // Parse price as double
                      // Increment total price
                      final productQty =
                          productQuantities[productId]; // Get the quantity
                      totalCartPrice += productPrice * productQty!;
                      return Container(
                        padding: EdgeInsets.symmetric(vertical: 5),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 5.0),
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              color: Colors.white,
                              boxShadow: [
                                BoxShadow(
                                    color: Colors.black.withOpacity(0.1),
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
                                        borderRadius: BorderRadius.circular(30),
                                      ),
                                      child: Center(
                                        child: Container(
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius:
                                                BorderRadius.circular(30),
                                            image: DecorationImage(
                                              image: NetworkImage(
                                                  "${urlImage}storage/${product['image']}"),
                                              fit: BoxFit.scaleDown,
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
                                                width: 125,
                                                child: Text(
                                                  'Rp ${totalCartPrice.toStringAsFixed(2)}', // snapshot.data['data']['id'],
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 12),
                                                ),
                                              ),
                                              Spacer(),
                                              Container(
                                                margin:
                                                    EdgeInsets.only(bottom: 15),
                                                child: FutureBuilder(builder:
                                                    (context, snapshot) {
                                                  return GestureDetector(
                                                    onTap: () async {
                                                      var response =
                                                          await http.delete(
                                                        Uri.parse(
                                                            "${url}delete-cart/${filteredData?[index]['id']}"),
                                                      );
                                                      if (response.statusCode ==
                                                          200) {
                                                        setState(() {
                                                          filteredData
                                                              ?.removeAt(index);
                                                        });
                                                      } else {
                                                        List updatedData =
                                                            await getItemCart();
                                                        setState(() {
                                                          filteredData =
                                                              updatedData;
                                                        });
                                                        Get.snackbar(
                                                          'Success', // Judul snackbar
                                                          'Item deleted successfully', // Pesan snackbar
                                                          backgroundColor:
                                                              Colors
                                                                  .transparent,
                                                        );
                                                      }
                                                    },
                                                    child: Container(
                                                      width: 20,
                                                      height: 20,
                                                      decoration: BoxDecoration(
                                                        color: Colors.red[400],
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(4),
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
                                                      onTap: productQty >= 2
                                                          ? () {
                                                              setState(() {
                                                                productQuantities[
                                                                        productId] =
                                                                    (productQuantities[productId] ??
                                                                            0) -
                                                                        1;
                                                              });
                                                            }
                                                          : null,
                                                      child: Container(
                                                        width: 20,
                                                        height: 20,
                                                        decoration:
                                                            BoxDecoration(
                                                          color:
                                                              Colors.grey[300],
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(4),
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
                                                    productQty.toString(),
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                  SizedBox(
                                                    width: 10,
                                                  ),
                                                  GestureDetector(
                                                    onTap: () {
                                                      setState(() {
                                                        productQuantities[
                                                                productId] =
                                                            (productQuantities[
                                                                        productId] ??
                                                                    0) +
                                                                1;
                                                      });
                                                    },
                                                    child: Container(
                                                      width: 20,
                                                      height: 20,
                                                      decoration: BoxDecoration(
                                                        color:
                                                            Colors.blueAccent,
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(4),
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
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    });
              }
            }),
      ),
    );
  }
}
