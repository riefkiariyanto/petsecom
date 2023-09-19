import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../../Constants/constants.dart';
import '../Cart/CartPage.dart';
import '../product/ProductDetail.dart';

class DetailStore extends StatefulWidget {
  final int idClient;
  DetailStore({required this.idClient});

  @override
  State<DetailStore> createState() => _DetailStoreState();
}

class _DetailStoreState extends State<DetailStore> {
  Future getStoreProduct() async {
    final UrlData = '${url}all-shops-and-products';

    try {
      final response = await http.get(Uri.parse(UrlData));
      if (response.statusCode == 200) {
        final data = json.decode(response.body)['data'];
        final storeData = data.firstWhere(
          (store) => store['id_clients'] == widget.idClient,
          orElse: () => null,
        );
        return storeData; // Return the filtered store data
      } else {
        print("Error - Status Code: ${response.statusCode}");
        print("Error - Message: ${response.body}");
        return null;
      }
    } catch (e) {
      print('Error: $e');
      return null;
    }
  }

  Future<void> addToCart(int productId) async {
    final prefs = await SharedPreferences.getInstance();
    String _data = prefs.getString('_data') ?? '';
    Map<String, dynamic> decodedData = json.decode(_data); // Decode the data

    final Map<String, String> postData = {
      "id_products": productId.toString(),
      "id_user": decodedData['user']['id'].toString(),
      "qty": '1',
      "date": DateTime.now().toString(),
      "status": "pending"
    };

    final response = await http.post(
      Uri.parse("${url}add-cart-id"),
      body: postData,
    );

    if (response.statusCode == 200) {
      Get.snackbar(
        'Success',
        'Added to cart',
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    } else {
      Get.snackbar(
        'Error',
        'Already in Cart',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }

    print(response.body);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      child: Stack(children: [
        Stack(
          children: [
            Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height / 3,
              decoration: BoxDecoration(
                  color: Colors.brown[300],
                  borderRadius: BorderRadius.only(
                      // bottomLeft: Radius.circular(100),
                      bottomRight: Radius.circular(100))),
            )
          ],
        ),
        Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            bottomOpacity: 0.0,
            elevation: 0.0,
            title: Text(
              "Store",
              style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.white),
            ),
            centerTitle: true,
            actions: <Widget>[
              IconButton(
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (BuildContext context) {
                    return const CartPage();
                  }));
                },
                icon: Icon(Icons.shopping_bag_outlined, color: Colors.white),
              ),
            ],
            leading: IconButton(
              onPressed: () => Navigator.of(context).pop(),
              icon: Icon(Icons.arrow_back, color: Colors.white),
            ),
          ),
          body: Stack(
            children: [
              FutureBuilder(
                  future: getStoreProduct(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError || snapshot.data == null) {
                      return Text('Error: Data not found');
                    } else {
                      final storeData = snapshot.data;
                      return Container(
                        color: Colors.transparent,
                        padding:
                            EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                        child: SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  CircleAvatar(
                                    radius: 25,
                                    backgroundColor: Colors.transparent,
                                    backgroundImage: NetworkImage(
                                        "${urlImage}storage/${storeData['logo']}"),
                                  ),
                                  SizedBox(
                                    width: 5,
                                  ),
                                  Column(
                                    children: [
                                      Row(
                                        children: [
                                          Text(
                                            storeData?['store_name'],
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ],
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          Container(
                                            width: 200,
                                            child: Text(
                                              storeData?['address'],
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 12,
                                              ),
                                            ),
                                          ),
                                        ],
                                      )
                                    ],
                                  ),
                                  Spacer(),
                                  CircleAvatar(
                                    radius: 25,
                                    backgroundColor: Colors.grey[100],
                                    child: Icon(
                                      CupertinoIcons.chat_bubble,
                                      size: 20,
                                    ),
                                  ),
                                ],
                              ),
                              const Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 8),
                                child: Divider(
                                  height: 4,
                                ),
                              ),
                              FutureBuilder(
                                future: getStoreProduct(),
                                builder: (context, snapshot) {
                                  if (snapshot.connectionState ==
                                      ConnectionState.waiting) {
                                    return Center(
                                      child: CircularProgressIndicator(),
                                    );
                                  }
                                  if (!snapshot.hasData) {
                                    return Center(
                                      child: Text('No data available.'),
                                    );
                                  }
                                  List<dynamic> products =
                                      snapshot.data['products'];
                                  return StaggeredGrid.count(
                                    crossAxisCount: 2,
                                    children: [
                                      for (int i = 0; i < products.length; i++)
                                        Container(
                                          padding: EdgeInsets.all(10),
                                          margin: EdgeInsets.all(8),
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius:
                                                BorderRadius.circular(20),
                                            boxShadow: [
                                              BoxShadow(
                                                color: Colors.black
                                                    .withOpacity(0.3),
                                                blurRadius: 1,
                                                offset: Offset(0.0, 0.75),
                                              ),
                                            ],
                                          ),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              GestureDetector(
                                                onTap: () {
                                                  Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                      builder: (BuildContext
                                                              context) =>
                                                          ProductDetail(
                                                        productId: products[i][
                                                            'id'], // Pass the product's ID
                                                      ),
                                                    ),
                                                  );
                                                },
                                                child: Container(
                                                  height: 110,
                                                  width: 120,
                                                  decoration: BoxDecoration(
                                                    boxShadow: [
                                                      BoxShadow(
                                                        color: Colors.black
                                                            .withOpacity(0.1),
                                                        blurRadius: 1,
                                                        offset:
                                                            Offset(0.0, 0.75),
                                                      ),
                                                    ],
                                                    color: Colors.white,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            20),
                                                  ),
                                                  child: ClipRRect(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            20),
                                                    child: Image.network(
                                                      "${urlImage}storage/${products[i]['image']}",
                                                      fit: BoxFit.cover,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              SizedBox(height: 10),
                                              Text(
                                                products[i]['name'],
                                                style: TextStyle(
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.normal,
                                                ),
                                              ),
                                              SizedBox(
                                                height: 2,
                                              ),
                                              Text(
                                                'Rp${products[i]['price']}',
                                                style: TextStyle(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              SizedBox(height: 5),
                                              Padding(
                                                padding:
                                                    const EdgeInsets.all(2.0),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    GestureDetector(
                                                      onTap: () async {
                                                        addToCart(
                                                            products[i]['id']);
                                                      },
                                                      child: Container(
                                                        height: 30,
                                                        width: 135,
                                                        decoration:
                                                            BoxDecoration(
                                                          color: Colors.white,
                                                          border: Border.all(
                                                            color: Colors
                                                                .deepOrange,
                                                            width: 1,
                                                          ),
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(8),
                                                          boxShadow: const [
                                                            BoxShadow()
                                                          ],
                                                        ),
                                                        child: Center(
                                                          child: Text(
                                                            '+   Cart',
                                                            style: TextStyle(
                                                              fontSize: 12,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              color: Colors
                                                                  .deepOrange,
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                    ],
                                  );
                                },
                              )
                            ],
                          ),
                        ),
                      );
                    }
                  }),
            ],
          ),
        ),
      ]),
    );
  }
}
