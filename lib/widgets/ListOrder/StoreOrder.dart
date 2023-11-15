import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:petsecom/widgets/ListOrder/StatusOrder/StatusDetailOrder.dart';
import '../../Constants/constants.dart';
import '../../Controllers/auth.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class StoreOrder extends StatefulWidget {
  const StoreOrder({super.key});

  @override
  State<StoreOrder> createState() => _StoreOrderState();
}

class _StoreOrderState extends State<StoreOrder> {
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

  double calculateStoreTotal(List<dynamic> products) {
    double storeTotal = 0;
    for (var product in products) {
      double price = double.parse(product['price']);
      int quantity = product['qty'];
      storeTotal += price * quantity;
    }
    return storeTotal;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Expanded(
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
                final cartData = snapshot.data as List<dynamic>;

                return ListView.builder(
                    shrinkWrap: true,
                    itemCount: cartData.length,
                    itemBuilder: (context, index) {
                      final storeName = cartData[index]['store_name'];
                      final orderID = cartData[index]['code'];
                      final products =
                          cartData[index]['products'] as List<dynamic>;
                      final firstProduct =
                          products.isNotEmpty ? products[0] : null;
                      final status = firstProduct != null
                          ? firstProduct['status']
                          : 'Belum ada status';

                      double subTotal = calculateStoreTotal(products);
                      return Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: Colors.white,
                            boxShadow: [
                              BoxShadow(
                                  color: Colors.black.withOpacity(0.4),
                                  blurRadius: 1,
                                  offset: Offset(0.0, 0.75)),
                            ],
                          ),
                          child: Container(
                            padding: EdgeInsets.symmetric(vertical: 2),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Container(
                                      padding:
                                          EdgeInsets.only(left: 20, top: 10),
                                      child: Text(
                                        storeName,
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 14),
                                      ),
                                    ),
                                    Spacer(),
                                    Container(
                                      margin:
                                          EdgeInsets.only(right: 35, top: 10),
                                      child: Container(
                                        child: Text(
                                          'Code : $orderID',
                                          style: TextStyle(
                                              color: Colors.blue,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 10),
                                        ),
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
                                            padding: EdgeInsets.symmetric(
                                                vertical: 5),
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
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
                                                        offset:
                                                            Offset(0.0, 0.75)),
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
                                                          decoration:
                                                              BoxDecoration(
                                                            color: Colors.white,
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        30),
                                                          ),
                                                          child: Center(
                                                            child: Container(
                                                              decoration:
                                                                  BoxDecoration(
                                                                color: Colors
                                                                    .white,
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            15),
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
                                                                    width: 125,
                                                                    child: Text(
                                                                      '${product['product_name']}',
                                                                      style: TextStyle(
                                                                          fontWeight: FontWeight
                                                                              .bold,
                                                                          fontSize:
                                                                              12),
                                                                    ),
                                                                  ),
                                                                  Container(
                                                                    margin: EdgeInsets
                                                                        .only(
                                                                            left:
                                                                                10),
                                                                    child: Text(
                                                                      'Qty: ${product['qty']}',
                                                                      style:
                                                                          TextStyle(
                                                                        color: Colors
                                                                            .grey,
                                                                        fontWeight:
                                                                            FontWeight.bold,
                                                                        fontSize:
                                                                            10,
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                              SizedBox(
                                                                  height: 5),
                                                              Row(
                                                                children: [
                                                                  Container(
                                                                    child: Text(
                                                                      'Rp ${product['total_price']}',
                                                                      style:
                                                                          TextStyle(
                                                                        color: Colors
                                                                            .black,
                                                                        fontWeight:
                                                                            FontWeight.bold,
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
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Container(
                                      padding:
                                          EdgeInsets.only(left: 10, bottom: 10),
                                      child: Column(
                                        children: [
                                          Container(
                                            child: Text(
                                              "Sub Total",
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 12),
                                            ),
                                          ),
                                          Container(
                                            padding: EdgeInsets.only(left: 10),
                                            child: Text(
                                              "Rp ${subTotal.toStringAsFixed(0)}",
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 16,
                                                  color: Colors.deepOrange),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Spacer(),
                                    Row(
                                      children: [
                                        GestureDetector(
                                          onTap: () {
                                            String orderCode =
                                                cartData[index]['code'];
                                            Navigator.of(context)
                                                .push(MaterialPageRoute(
                                              builder: (context) =>
                                                  StatusDetailOrder(
                                                      orderCode: orderCode),
                                            ));
                                          },
                                          child: Container(
                                            padding: EdgeInsets.all(10),
                                            margin: EdgeInsets.symmetric(
                                                horizontal: 15, vertical: 5),
                                            decoration: BoxDecoration(
                                              color: Colors.deepOrange,
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                            ),
                                            child: Center(
                                              child: Text(
                                                status,
                                                style: TextStyle(
                                                    fontSize: 12,
                                                    color: Colors.white,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                              ],
                            ),
                          ),
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
