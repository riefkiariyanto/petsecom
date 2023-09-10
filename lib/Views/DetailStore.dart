import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../Constants/constants.dart';
import '../Controllers/MapsController.dart';
import '../widgets/Cart/CartPage.dart';
import '../widgets/product/ItemsWidget.dart';

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
      backgroundColor: Colors.grey[300],
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
                  return CircularProgressIndicator();
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
                            padding: const EdgeInsets.symmetric(vertical: 15),
                            child: Divider(
                              height: 4,
                            ),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          // ItemsWidget(),
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
}
