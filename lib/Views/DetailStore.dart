import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../Constants/constants.dart';
import '../Controllers/MapsController.dart';
import '../widgets/Cart/CartPage.dart';
import '../widgets/product/ItemsWidget.dart';
import '../widgets/product/ProductDetail.dart';

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        bottomOpacity: 0.0,
        elevation: 0.0,
        title: Text(
          "Store",
          style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Colors.grey[700]),
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
            icon: Icon(Icons.shopping_bag_outlined, color: Colors.grey[700]),
          ),
        ],
        leading: IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: Icon(Icons.arrow_back, color: Colors.grey[700]),
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
                    color: Colors.white,
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
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
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Container(
                                        width: 200,
                                        child: Text(
                                          storeData?['address'],
                                          style: TextStyle(
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
                                backgroundColor: Colors.grey[200],
                                child: Icon(
                                  CupertinoIcons.chat_bubble,
                                  size: 20,
                                  color: Colors.blue,
                                ),
                              ),
                            ],
                          ),
                          const Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8),
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
                                        borderRadius: BorderRadius.circular(20),
                                        boxShadow: [
                                          BoxShadow(
                                            color:
                                                Colors.black.withOpacity(0.3),
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
                                                  builder:
                                                      (BuildContext context) =>
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
                                                    offset: Offset(0.0, 0.75),
                                                  ),
                                                ],
                                                color: Colors.white,
                                                borderRadius:
                                                    BorderRadius.circular(20),
                                              ),
                                              child: ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(20),
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
                                            padding: const EdgeInsets.all(2.0),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                GestureDetector(
                                                  onTap: () async {},
                                                  child: Container(
                                                    height: 30,
                                                    width: 135,
                                                    decoration: BoxDecoration(
                                                      color: Colors.white,
                                                      border: Border.all(
                                                        color:
                                                            Colors.deepOrange,
                                                        width: 1,
                                                      ),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              8),
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
                                                              FontWeight.bold,
                                                          color:
                                                              Colors.deepOrange,
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
    );
  }

  itemProductList(BuildContext context) {}
}
