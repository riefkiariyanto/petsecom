import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import '../../Constants/constants.dart';
import 'package:petsecom/Controllers/auth.dart';

class ItemCartDetail extends StatefulWidget {
  final String storeName;

  ItemCartDetail({
    Key? key,
    required this.storeName,
  }) : super(key: key);
  @override
  State<ItemCartDetail> createState() => _ItemCartDetailState();
}

class _ItemCartDetailState extends State<ItemCartDetail> {
  Future<List<dynamic>> fetchCartData() async {
    final urlCart = '${url}list-cart';
    final authController = Get.find<AuthController>();
    final userID = await authController.getUserID();
    final response = await http.get(Uri.parse(urlCart));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      List<Map<String, dynamic>> cartList =
          List<Map<String, dynamic>>.from(data['data']);

      List<Map<String, dynamic>> filteredCartList = cartList.where((cartItem) {
        return cartItem['id_user'] == userID &&
            cartItem['store_name'] == widget.storeName;
      }).toList();

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
                );
              } else if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              } else {
                final cartData = snapshot.data as List<dynamic>;
                return ListView.builder(
                    shrinkWrap: true,
                    itemCount: cartData.length,
                    itemBuilder: (context, index) {
                      final cartItem = cartData[index];
                      final storeName = cartItem['store_name'];
                      final products = cartItem['products'] as List<dynamic>;
                      return Container(
                        padding: EdgeInsets.symmetric(vertical: 2),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Container(
                                  padding: EdgeInsets.only(left: 20, top: 10),
                                  child: Text(
                                    cartItem['store_name'] as String,
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14),
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                Expanded(
                                  child: Divider(
                                    indent: 12,
                                    endIndent: 12,
                                    color: Colors.grey[200],
                                    thickness: 1.0,
                                  ),
                                )
                              ],
                            ),
                            Column(
                              children: [
                                ListView.builder(
                                    shrinkWrap: true,
                                    physics: NeverScrollableScrollPhysics(),
                                    itemCount: products.length,
                                    itemBuilder: (context, pIndex) {
                                      final product = products[pIndex];
                                      final productName =
                                          product['product_name'];
                                      final productImage = product['image'];
                                      final productPrice = product['price'];
                                      var productQty = product['qty'];

                                      return Container(
                                        padding:
                                            EdgeInsets.symmetric(vertical: 5),
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 5.0),
                                          child: Container(
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(20),
                                              color: Colors.white,
                                              boxShadow: [
                                                BoxShadow(
                                                    color: Colors.black
                                                        .withOpacity(0.1),
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
                                                            BorderRadius
                                                                .circular(30),
                                                      ),
                                                      child: Center(
                                                        child: Container(
                                                          decoration:
                                                              BoxDecoration(
                                                            color: Colors.white,
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        30),
                                                            image:
                                                                DecorationImage(
                                                              image: NetworkImage(
                                                                  "${urlImage}storage/${product['image']}"),
                                                              fit: BoxFit
                                                                  .scaleDown,
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                    SizedBox(width: 12),
                                                    Expanded(
                                                      child: Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Row(
                                                            children: [
                                                              Container(
                                                                width: 110,
                                                                child: Text(
                                                                  '${product['product_name']}',
                                                                  overflow:
                                                                      TextOverflow
                                                                          .ellipsis,
                                                                  maxLines: 2,
                                                                  style: TextStyle(
                                                                      fontSize:
                                                                          12),
                                                                ),
                                                              ),
                                                              Spacer(),
                                                              Text(
                                                                'Qty : ',
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .grey
                                                                        .shade400,
                                                                    fontSize:
                                                                        11,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold),
                                                              ),
                                                              Container(
                                                                padding: EdgeInsets
                                                                    .only(
                                                                        right:
                                                                            20),
                                                                child: Text(
                                                                  ' ${productQty.toString()}',
                                                                  style: TextStyle(
                                                                      fontSize:
                                                                          11,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold),
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                          SizedBox(height: 10),
                                                          Row(
                                                            children: [
                                                              Container(
                                                                child: Text(
                                                                  'Rp ${product['price']}',
                                                                  style:
                                                                      TextStyle(
                                                                    color: Colors
                                                                        .black,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
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
                                        ),
                                      );
                                    }),
                              ],
                            ),
                          ],
                        ),
                      );
                    } // use it
                    );
              }
            }),
      ),
    );
  }
}
