import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../../../Constants/constants.dart';

class ItemOrderStatus extends StatefulWidget {
  final String orderCode;
  final String storeName;
  const ItemOrderStatus(
      {Key? key, required this.orderCode, required this.storeName})
      : super(key: key);
  @override
  State<ItemOrderStatus> createState() => _ItemOrderStatusState();
}

class _ItemOrderStatusState extends State<ItemOrderStatus> {
  late Future<Map<String, dynamic>> _fetchTransactionCartData;

  Future<Map<String, dynamic>> fetchTransactionCartData() async {
    final urlCart = '${url}list-transaction-cart';
    final response = await http.get(Uri.parse(urlCart));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      Map<String, dynamic> transactionData = {
        'storeName': '',
        'orderItems': <dynamic>[],
      };

      for (var transaction in data['data']) {
        if (transaction['code'] == widget.orderCode) {
          transactionData['storeName'] = transaction['store_name'];
          transactionData['orderItems'] =
              transaction['products'] as List<dynamic>;
          break;
        }
      }

      return transactionData;
    } else {
      throw Exception('Failed to load data');
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchTransactionCartData = fetchTransactionCartData();
  }

  @override
  Widget build(BuildContext context) {
    return Flexible(
      child: FutureBuilder(
        future: _fetchTransactionCartData,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else {
            final transactionData = snapshot.data as Map<String, dynamic>;
            final storeName = transactionData['storeName'];
            final orderItems = transactionData['orderItems'] as List<dynamic>;

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: EdgeInsets.only(left: 20, top: 10),
                      child: Text(
                        storeName as String,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
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
                      itemCount: orderItems.length,
                      itemBuilder: (context, pIndex) {
                        final product = orderItems[pIndex];
                        final productName = product['product_name'];
                        final productImage = product['image'];
                        final productPrice = product['price'];
                        var productQty = product['qty'];

                        return Container(
                          padding: EdgeInsets.symmetric(vertical: 5),
                          child: Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 5.0),
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
                                                  BorderRadius.circular(30),
                                              image: DecorationImage(
                                                image: NetworkImage(
                                                  "${urlImage}storage/${product['image']}",
                                                ),
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
                                                  width: 110,
                                                  child: Text(
                                                    '${product['product_name']}',
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    maxLines: 2,
                                                    style:
                                                        TextStyle(fontSize: 12),
                                                  ),
                                                ),
                                                Spacer(),
                                                Text(
                                                  'Qty : ',
                                                  style: TextStyle(
                                                    color: Colors.grey.shade400,
                                                    fontSize: 11,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                                Container(
                                                  padding: EdgeInsets.only(
                                                      right: 20),
                                                  child: Text(
                                                    ' ${productQty.toString()}',
                                                    style: TextStyle(
                                                      fontSize: 11,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
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
                                                    style: TextStyle(
                                                      color: Colors.black,
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
                      },
                    ),
                  ],
                ),
              ],
            );
          }
        },
      ),
    );
  }
}
