import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:petsecom/widgets/Checkout/EditShipping.dart';
import 'package:petsecom/widgets/Checkout/ItemOrder.dart';
import 'package:petsecom/widgets/Checkout/PaymentPage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:random_string/random_string.dart';

import '../../Constants/constants.dart';

class CheckOut extends StatefulWidget {
  final String storeName;
  final double storeTotal;

  CheckOut({
    Key? key,
    required this.storeName,
    required this.storeTotal,
  }) : super(key: key);

  @override
  State<CheckOut> createState() => _CheckOutState();
}

class _CheckOutState extends State<CheckOut> {
  Map<String, dynamic> userData = {};
  Future getUser() async {
    final prefs = await SharedPreferences.getInstance();
    String _data;
    _data = prefs.getString('_data') ?? '';
    return json.decode(_data);
  }

  Future<void> postTransaction(Map<String, dynamic> transactionData) async {
    final apiUrl = '${url}add-transaction';

    final response = await http.post(
      Uri.parse(apiUrl),
      headers: <String, String>{
        'Content-Type': 'application/json',
      },
      body: jsonEncode(transactionData),
    );

    if (response.statusCode == 200) {
      print('Transaction was successful');
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => PaymentPage()),
      );
    } else {
      print('Transaction failed with status code: ${response.statusCode}');
    }
  }

  bool isChecked = false;
  Color getColor(Set<MaterialState> states) {
    const Set<MaterialState> interactiveStates = <MaterialState>{
      MaterialState.pressed,
      MaterialState.hovered,
      MaterialState.focused,
    };
    if (states.any(interactiveStates.contains)) {
      return Colors.grey;
    }
    return Colors.green;
  }

  Future<void> saveAddressToSharedPreferences(
      Map<String, dynamic> addressData) async {
    final prefs = await SharedPreferences.getInstance();
    final userData = prefs.getString('_data');

    Map<String, dynamic> userDataMap = json.decode(userData!);

    userDataMap['user']['name'] = addressData['name'];
    userDataMap['user']['address'] = addressData['address'];
    userDataMap['user']['phone'] = addressData['phone'];

    final updatedUserData = json.encode(userDataMap);
    prefs.setString('_data', updatedUserData);
  }

  String randomCode = randomAlpha(3) + randomNumeric(2);

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
          "CheckOut",
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
          future: getUser(),
          builder: (context, snapshot) {
            return Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        Container(
                          padding:
                              EdgeInsets.symmetric(horizontal: 20, vertical: 5),
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
                                    Text(
                                      'Shipping Address ',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16),
                                    ),
                                    Spacer(),
                                    Container(
                                      child: TextButton(
                                        onPressed: () {
                                          showDialog(
                                            context: context,
                                            builder: (BuildContext context) {
                                              return EditShipping(
                                                initialData: {
                                                  'name': snapshot.data['user']
                                                      ['name'],
                                                  'address': snapshot
                                                      .data['user']['address'],
                                                  'phone': snapshot.data['user']
                                                      ['phone'],
                                                },
                                                onAddressSaved: (newAddress) {
                                                  saveAddressToSharedPreferences(
                                                      newAddress);

                                                  setState(() {});
                                                },
                                              );
                                            },
                                          );
                                        },
                                        child: Text(
                                          'Edit Shipping Addreess',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 12,
                                              color: Colors.green[300]),
                                        ),
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
                                            snapshot.data['user']['name'],
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
                                                snapshot.data['user']
                                                    ['address'],
                                              )),
                                          Spacer(),
                                          Checkbox(
                                            checkColor: Colors.white,
                                            fillColor: MaterialStateProperty
                                                .resolveWith(getColor),
                                            value: isChecked,
                                            onChanged: (bool? value) {
                                              setState(() {
                                                isChecked = value!;
                                              });
                                            },
                                          ),
                                        ],
                                      ),
                                      SizedBox(
                                        height: 2,
                                      ),
                                      Row(
                                        children: [
                                          Text(
                                            snapshot.data['user']['phone'],
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
                                          ItemOrder(
                                            storeName: widget.storeName,
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
                        padding:
                            EdgeInsets.symmetric(horizontal: 20, vertical: 10),
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
                                  'Rp ${widget.storeTotal.toStringAsFixed(0)}',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 19,
                                      color: Colors.white),
                                ),
                              ],
                            ),
                            Spacer(),
                            GestureDetector(
                              onTap: () {
                                Map<String, dynamic> transactionData = {
                                  'code': randomCode,
                                  'id_cart': '253',
                                  'id_client': '6',
                                  'id_user': snapshot.data['user']['id'],
                                  'status': 'pending',
                                  'date': DateTime.now().toString(),
                                };
                                postTransaction(transactionData);
                              },
                              //   Navigator.push(
                              //     context,
                              //     MaterialPageRoute(
                              //         builder: (context) => PaymentPage()),
                              //   );
                              // },
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
          }),
    );
  }
}
