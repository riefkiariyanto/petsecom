import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:get/get.dart';
import 'package:petsecom/widgets/product/ProductDetail.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';

import '../../Constants/constants.dart';

class ItemsWidget extends StatefulWidget {
  const ItemsWidget({super.key});

  @override
  State<ItemsWidget> createState() => _ItemsWidgetState();
}

class _ItemsWidgetState extends State<ItemsWidget> {
  Future getProduct() async {
    final UrlData = '${url}list-product/';

    try {
      http.Response response = await http.get(Uri.parse(UrlData));
      if (response.statusCode == 200) {
        print(json.decode(response.body)['data'][0]['name']);
        return jsonDecode(response.body);
      } else {
        print("Error - Status Code: ${response.statusCode}");
        print("Error - Messaga: ${response.body}");
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: getProduct(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          List<dynamic> products = snapshot.data['data'];
          return StaggeredGrid.count(
            crossAxisCount: 2,
            children: [
              for (int i = 0; i < products.length; i++)
                FutureBuilder(
                    future: getProduct(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        return Container(
                          padding:
                              EdgeInsets.only(left: 15, right: 15, top: 10),
                          margin:
                              EdgeInsets.symmetric(vertical: 8, horizontal: 10),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                  color: Colors.black.withOpacity(0.3),
                                  blurRadius: 1,
                                  offset: Offset(0.0, 0.75)),
                            ],
                          ),
                          child: Column(
                            children: [
                              GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (BuildContext context) =>
                                          ProductDetail(
                                              productId: snapshot.data['data']
                                                  [i]['id']),
                                    ),
                                  );
                                },
                                child: Container(
                                  height: 110,
                                  width: 120,
                                  decoration: BoxDecoration(
                                    boxShadow: [
                                      BoxShadow(
                                          color: Colors.black.withOpacity(0.1),
                                          blurRadius: 1,
                                          offset: Offset(0.0, 0.75)),
                                    ],
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(20),
                                    child: Image.network(
                                      "${urlImage}storage/${snapshot.data['data'][i]['image']}",
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              Container(
                                padding: EdgeInsets.only(bottom: 8),
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  snapshot.data['data'][i]['name'],
                                  style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                              Container(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  snapshot.data['data'][i]['description'],
                                  style: TextStyle(
                                    fontSize: 10,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 10,
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.symmetric(vertical: 10),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'Rp${NumberFormat.decimalPattern().format(int.parse(snapshot.data['data'][i]['price']))}'
                                          .replaceAll(',', '.'),
                                      style: TextStyle(
                                          fontSize: 16,
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    GestureDetector(
                                      onTap: () async {
                                        final prefs = await SharedPreferences
                                            .getInstance();
                                        String _data;
                                        _data = prefs.getString('_data') ?? '';
                                        Map<String, dynamic> decodedData = json
                                            .decode(_data); // Decode the data

                                        var response = await http.post(
                                          Uri.parse("${url}add-cart-id"),
                                          body: {
                                            "id_products": snapshot.data['data']
                                                    [i]['id']
                                                .toString(),
                                            "id_user": decodedData['user']['id']
                                                .toString(),
                                            "qty": 1.toString(),
                                            "date": DateTime.now().toString(),
                                            "status": "pending"
                                          },
                                        );

                                        if (response.statusCode == 200) {
                                          Get.snackbar(
                                            'success',
                                            'in Cart',
                                            backgroundColor: Colors.green,
                                            colorText: Colors.white,
                                          );
                                        } else {
                                          Get.snackbar(
                                            'Already',
                                            'in Cart',
                                            backgroundColor: Colors.blue,
                                            colorText: Colors.white,
                                            snackPosition: SnackPosition.BOTTOM,
                                          );
                                        }
                                        print(response.body);
                                      },
                                      child: Icon(
                                        Icons.shopping_cart_checkout,
                                        color: Colors.deepOrange,
                                      ),
                                    )
                                  ],
                                ),
                              )
                            ],
                          ),
                        );
                      } else {
                        return Container();
                      }
                    }),
            ],
          );
        });
  }
}
