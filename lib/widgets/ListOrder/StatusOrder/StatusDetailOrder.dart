import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:petsecom/widgets/ListOrder/StatusOrder/ItemOrdeStatus.dart';

import '../../../Constants/constants.dart';
import '../../../Controllers/auth.dart';

class StatusDetailOrder extends StatefulWidget {
  final String orderCode;

  const StatusDetailOrder({Key? key, required this.orderCode})
      : super(key: key);
  @override
  State<StatusDetailOrder> createState() => _StatusDetailOrderState();
}

class _StatusDetailOrderState extends State<StatusDetailOrder> {
  Map<String, dynamic> orderData = {};

  Future<Map<String, dynamic>> fetchOrderData() async {
    final urlCart = '${url}list-transaction-cart';
    final response = await http.get(Uri.parse(urlCart));
    final authController = Get.find<AuthController>();
    final userID = await authController.getUserID();

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      List<Map<String, dynamic>> cartList =
          List<Map<String, dynamic>>.from(data['data']);

      List<Map<String, dynamic>> filteredCartList = cartList
          .where((cartItem) => cartItem['code'] == widget.orderCode)
          .toList();

      Map<String, dynamic> orderData =
          filteredCartList.isNotEmpty ? filteredCartList.first : {};

      return orderData;
    } else {
      throw Exception('Failed to load data');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false, // set it to false
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        bottomOpacity: 0.0,
        elevation: 0.0,
        title: Text(
          "Detail Order",
          style: TextStyle(
              fontSize: 15, fontWeight: FontWeight.bold, color: Colors.black),
        ),
        centerTitle: true,
        leading: IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: Icon(Icons.arrow_back, color: Colors.grey[700]),
        ),
      ),
      body: FutureBuilder(
          future: fetchOrderData(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else {
              orderData = snapshot.data as Map<String, dynamic>;
              return Column(
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 20, vertical: 5),
                            child: Column(
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(10),
                                    boxShadow: [
                                      BoxShadow(
                                          color: Colors.black.withOpacity(0.1),
                                          blurRadius: 1,
                                          offset: Offset(0.0, 0.75)),
                                    ],
                                  ),
                                  padding: EdgeInsets.symmetric(horizontal: 10),
                                  child: Row(
                                    children: [
                                      Container(
                                        padding: EdgeInsets.symmetric(
                                            vertical: 10, horizontal: 5),
                                        child: Text(
                                          'Shipping Address ',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 16),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  height: 15,
                                ),
                                Container(
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(10),
                                    boxShadow: [
                                      BoxShadow(
                                          color: Colors.black.withOpacity(0.1),
                                          blurRadius: 1,
                                          offset: Offset(0.0, 0.75)),
                                    ],
                                  ),
                                  child: Container(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 10, vertical: 10),
                                    child: Column(
                                      children: [
                                        Row(
                                          children: [
                                            Text(
                                              orderData['user']['name'] ?? '',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 16),
                                            ),
                                          ],
                                        ),
                                        Divider(),
                                        Row(
                                          children: [
                                            Container(
                                              width: 180,
                                              child: Text(
                                                orderData['user']['address'] ??
                                                    '',
                                              ),
                                            ),
                                          ],
                                        ),
                                        SizedBox(
                                          height: 2,
                                        ),
                                        Row(
                                          children: [
                                            Text(
                                              orderData['user']['phone'] ?? '',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 14),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 15,
                                ),
                                Container(
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(10),
                                    boxShadow: [
                                      BoxShadow(
                                          color: Colors.black.withOpacity(0.1),
                                          blurRadius: 1,
                                          offset: Offset(0.0, 0.75)),
                                    ],
                                  ),
                                  child: Container(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 2, vertical: 2),
                                    child: Column(
                                      children: [
                                        Row(
                                          children: [
                                            ItemOrderStatus(
                                              orderCode: widget.orderCode,
                                              storeName:
                                                  orderData['store_name'] ?? '',
                                            ),
                                          ],
                                        ),
                                        SizedBox(
                                          height: 5,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 15,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                        topRight: Radius.circular(10),
                        topLeft: Radius.circular(10),
                      ),
                      color: Colors.orange,
                      boxShadow: [
                        BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 1,
                            offset: Offset(0.0, 0.75)),
                      ],
                    ),
                    child: Column(
                      children: [
                        Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: 20, vertical: 10),
                          child: Row(
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Total Payment',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 12,
                                        color: Colors.grey[100]),
                                  ),
                                  Text(
                                    'Rp ${NumberFormat('###').format(orderData['total_price'] ?? 0)}',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 19,
                                        color: Colors.white),
                                  ),
                                ],
                              ),
                              Spacer(),
                              GestureDetector(
                                onTap: () {},
                                child: Container(
                                  height: 40,
                                  width: 80,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: Colors.orange[700],
                                    boxShadow: [
                                      BoxShadow(
                                          color: Colors.black.withOpacity(0.1),
                                          blurRadius: 1,
                                          offset: Offset(0.0, 0.75)),
                                    ],
                                  ),
                                  child: Center(
                                    child: Text(
                                      'CeckOut',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                          color: Colors.white),
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              );
            }
          }),
    );
  }
}
