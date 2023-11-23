import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:petsecom/widgets/CheckoutPayment/checkout.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import '../../Constants/constants.dart';
import 'package:petsecom/Controllers/auth.dart';

class StoreCart extends StatefulWidget {
  const StoreCart({super.key});

  @override
  State<StoreCart> createState() => _StoreCartState();
}

class _StoreCartState extends State<StoreCart> {
  Future<List<dynamic>> fetchCartData() async {
    final urlCart = '${url}list-cart';
    final authController = Get.find<AuthController>();
    final userID = await authController.getUserID();
    final response = await http.get(Uri.parse(urlCart));

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

  Future<void> _deleteProductFromCart(String idCart) async {
    final apiUrl = '${url}delete-cart/$idCart';

    final response = await http.delete(
      Uri.parse(apiUrl),
    );
    if (response.statusCode == 200) {
      print('Product deleted successfully');
      setState(() {});
    } else {
      print('Error deleting product');
    }
  }

  Future<void> plusButtonProductQty(String cartId, int currentQty) async {
    final urlQty = Uri.parse('${url}update-cart-quantity/$cartId');
    int newQty = currentQty + 1;

    try {
      final response = await http.put(
        urlQty,
        headers: {
          'Content-Type': 'application/json',
        },
        body: '{"qty": $newQty}',
      );
      if (response.statusCode == 200) {
        setState(() {});
      } else {
        print('Gagal mengupdate qty: ${response.statusCode}');
      }
    } catch (e) {
      print('Terjadi kesalahan: $e');
    }
  }

  Future<void> minButtonProductQty(String cartId, int currentQty) async {
    final urlQty = Uri.parse('${url}update-cart-quantity/$cartId');
    int newQty = currentQty - 1;

    try {
      final response = await http.put(
        urlQty,
        headers: {
          'Content-Type': 'application/json',
        },
        body: '{"qty": $newQty}',
      );
      if (response.statusCode == 200) {
        setState(() {});
      } else {
        print('Gagal mengupdate qty: ${response.statusCode}');
      }
    } catch (e) {
      print('Terjadi kesalahan: $e');
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
                                                                      '${product['product_name']}', // snapshot.data['data']['id'],
                                                                      style: TextStyle(
                                                                          fontWeight: FontWeight
                                                                              .bold,
                                                                          fontSize:
                                                                              12),
                                                                    ),
                                                                  ),
                                                                  Spacer(),
                                                                  Container(
                                                                    margin: EdgeInsets.only(
                                                                        bottom:
                                                                            15),
                                                                    child:
                                                                        FutureBuilder(
                                                                      builder:
                                                                          (context,
                                                                              snapshot) {
                                                                        return GestureDetector(
                                                                          onTap:
                                                                              () async {
                                                                            _deleteProductFromCart(product['id_cart'].toString());
                                                                          },
                                                                          child:
                                                                              Container(
                                                                            width:
                                                                                20,
                                                                            height:
                                                                                20,
                                                                            decoration:
                                                                                BoxDecoration(
                                                                              color: Colors.red[400],
                                                                              borderRadius: BorderRadius.circular(4),
                                                                            ),
                                                                            child:
                                                                                Icon(
                                                                              Icons.delete,
                                                                              color: Colors.white,
                                                                              size: 15,
                                                                            ),
                                                                          ),
                                                                        );
                                                                      },
                                                                      future:
                                                                          null,
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
                                                                      'Rp ${product['price']}',
                                                                      style:
                                                                          TextStyle(
                                                                        color: Colors
                                                                            .black,
                                                                        fontWeight:
                                                                            FontWeight.bold,
                                                                      ),
                                                                    ),
                                                                  ),
                                                                  Spacer(),
                                                                  Row(
                                                                    children: [
                                                                      Container(
                                                                        child:
                                                                            GestureDetector(
                                                                          onTap: productQty > 1
                                                                              ? () async {
                                                                                  final cartId = product['id_cart'].toString();
                                                                                  await minButtonProductQty(cartId, productQty);
                                                                                }
                                                                              : null,
                                                                          child:
                                                                              Container(
                                                                            width:
                                                                                20,
                                                                            height:
                                                                                20,
                                                                            decoration:
                                                                                BoxDecoration(
                                                                              color: Colors.grey[300],
                                                                              borderRadius: BorderRadius.circular(4),
                                                                            ),
                                                                            child:
                                                                                Icon(
                                                                              Icons.remove,
                                                                              color: Colors.white,
                                                                              size: 15,
                                                                            ),
                                                                          ),
                                                                        ),
                                                                      ),
                                                                      SizedBox(
                                                                        width:
                                                                            10,
                                                                      ),
                                                                      Text(
                                                                        productQty
                                                                            .toString(),
                                                                        style: TextStyle(
                                                                            fontWeight:
                                                                                FontWeight.bold),
                                                                      ),
                                                                      SizedBox(
                                                                        width:
                                                                            10,
                                                                      ),
                                                                      GestureDetector(
                                                                        onTap:
                                                                            () async {
                                                                          final cartId =
                                                                              product['id_cart'].toString();
                                                                          final currentQty =
                                                                              product['qty'];
                                                                          await plusButtonProductQty(
                                                                              cartId,
                                                                              currentQty);
                                                                        },
                                                                        child:
                                                                            Container(
                                                                          width:
                                                                              20,
                                                                          height:
                                                                              20,
                                                                          decoration:
                                                                              BoxDecoration(
                                                                            color:
                                                                                Colors.blueAccent,
                                                                            borderRadius:
                                                                                BorderRadius.circular(4),
                                                                          ),
                                                                          child:
                                                                              Icon(
                                                                            Icons.add,
                                                                            color:
                                                                                Colors.white,
                                                                            size:
                                                                                15,
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
                                              "Rp ${calculateStoreTotal(products).toStringAsFixed(0)}",
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
                                            List<int> idCarts = [];
                                            for (var product in cartData[index]
                                                ['products']) {
                                              if (product['id_cart'] is int) {
                                                idCarts.add(product['id_cart']);
                                              } else if (product['id_cart']
                                                  is String) {
                                                idCarts.add(int.parse(
                                                    product['id_cart']));
                                              }
                                            }

                                            Navigator.of(context)
                                                .push(MaterialPageRoute(
                                              builder: (context) => CheckOut(
                                                storeName: storeName,
                                                storeTotal: calculateStoreTotal(
                                                    products),
                                                idClient: cartData[index]
                                                    ['id_client'],
                                                idCarts: idCarts,
                                              ),
                                            ));
                                          },
                                          child: Container(
                                            padding: EdgeInsets.all(10),
                                            margin: EdgeInsets.symmetric(
                                                horizontal: 15, vertical: 5),
                                            decoration: BoxDecoration(
                                              color: Colors.deepOrange,
                                              borderRadius:
                                                  BorderRadius.circular(14),
                                            ),
                                            child: Center(
                                              child: Text(
                                                'Checkout',
                                                style: TextStyle(
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
                    });
              }
            }),
      ),
    );
  }
}
