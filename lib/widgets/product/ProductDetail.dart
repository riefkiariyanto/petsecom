import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:petsecom/Views/HomePage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../Constants/constants.dart';
import '../../Controllers/MapsController.dart';
import '../../Views/DetailStore.dart';
import '../Cart/CartPage.dart';

class ProductDetail extends StatefulWidget {
  final int productId; // Add this parameterr
  const ProductDetail({required this.productId, Key? key}) : super(key: key);

  @override
  State<ProductDetail> createState() => _ProductDetailState();
}

class _ProductDetailState extends State<ProductDetail> {
  Future getProduct() async {
    final UrlData = '${url}list-product/shop';

    try {
      http.Response response = await http.get(Uri.parse(UrlData));
      if (response.statusCode == 200) {
        print(json.decode(response.body)['data'][0]['name']);
        return jsonDecode(response.body);
      } else {
        print("Error - Status Code: ${response.statusCode}");
        print("Error - Message: ${response.body}");
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        bottomOpacity: 0.0,
        elevation: 0.0,
        title: Text(
          "Detail Item",
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
          onPressed: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (BuildContext context) {
              return const HomePage();
            }));
          },
          icon: Icon(Icons.arrow_back, color: Colors.grey[700]),
        ),
      ),
      body: Stack(
        children: [
          Container(
            child: Column(
              children: [
                FutureBuilder(
                    future: getProduct(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(child: CircularProgressIndicator());
                      } else if (snapshot.hasError) {
                        return Text("Error loading data");
                      } else if (!snapshot.hasData ||
                          snapshot.data['data'].isEmpty) {
                        return Text("No data available");
                      } else {
                        var productData = snapshot.data['data'].firstWhere(
                            (item) => item['id'] == widget.productId,
                            orElse: () => null);

                        if (productData == null) {
                          return Center(child: Text("Product not found"));
                        }

                        var shopData = productData['shop'];
                        String imageUrl =
                            "${urlImage}storage/${productData['image']}";

                        return Container(
                          padding:
                              EdgeInsets.symmetric(vertical: 10, horizontal: 5),
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
                          child: Column(children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Center(
                                  child: Container(
                                    padding: EdgeInsets.all(5),
                                    height: 250,
                                    width: 240,
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(20),
                                      child: Image.network(
                                        "${imageUrl}",
                                        fit: BoxFit
                                            .cover, // Set the fit property
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ]),
                        );
                      }
                    }),
              ],
            ),
          ),
          scroll()
        ],
      ),
    );
  }

  scroll() {
    return DraggableScrollableSheet(
        initialChildSize: 0.6,
        maxChildSize: 1.0,
        minChildSize: 0.6,
        builder: (context, scrollController) {
          var controller = Get.put(MapsController());
          return FutureBuilder(
              future: getProduct(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }
                var productData = snapshot.data['data'].firstWhere(
                    (item) => item['id'] == widget.productId,
                    orElse: () => null);

                if (productData == null) {
                  return Center(child: Text("Product not found"));
                }
                var shopData = productData['shop'];

                return Container(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  clipBehavior: Clip.hardEdge,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30),
                    ),
                  ),
                  child: SingleChildScrollView(
                    controller: scrollController,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 10, bottom: 25),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                height: 5,
                                width: 35,
                                color: Colors.black12,
                              )
                            ],
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              productData['category'],
                              style: TextStyle(
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Row(
                          children: [
                            Column(
                              children: [
                                SizedBox(
                                  width: 240,
                                  child: Text(
                                    productData['name'],
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Spacer(),
                            Text(
                              "Rp ${productData['price']}",
                              style: TextStyle(
                                color: Colors.redAccent,
                                fontFamily: 'Gilroy',
                                fontSize: 17,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        Divider(
                          height: 4,
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Row(
                          children: [
                            CircleAvatar(
                              radius: 25,
                              backgroundColor: Colors
                                  .white, // Mengatur warna latar belakang menjadi putih

                              backgroundImage: NetworkImage(
                                  "${urlImage}storage/${shopData['logo']}"),
                            ),
                            SizedBox(
                              width: 5,
                            ),
                            Column(
                              children: [
                                Row(
                                  children: [
                                    GestureDetector(
                                      onTap: () {
                                        int idClient = shopData['id_clients'];
                                        print('id_clients: $idClient');

                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (BuildContext context) =>
                                                DetailStore(idClient: idClient),
                                          ),
                                        );
                                      },
                                      child: Text(
                                        shopData['store_name'],
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    SizedBox(
                                      width: 200,
                                      child: Text(
                                        shopData['address'],
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
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              "Description",
                              style: TextStyle(
                                  fontFamily: 'Gilroy',
                                  fontSize: 20,
                                  color: Colors.grey[700],
                                  fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Flexible(
                              child: Text(
                                productData['description'],
                                style: TextStyle(color: Colors.grey),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              GestureDetector(
                                onTap: () async {
                                  final prefs =
                                      await SharedPreferences.getInstance();
                                  String _data;
                                  _data = prefs.getString('_data') ?? '';
                                  Map<String, dynamic> decodedData =
                                      json.decode(_data); // Decode the data

                                  var response = await http
                                      .post(Uri.parse("${url}add-cart"), body: {
                                    "id_products": productData['id'].toString(),
                                    "id_user": decodedData['user']['id']
                                        .toString(), // Use the decoded user ID

                                    "qty": productData['qty'].toString(),
                                    "date": DateTime.now().toString(),
                                    "status": "pending"
                                  });
                                  if (response.statusCode == 200) {
                                  } else {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                          content: Text(
                                              'Item added to cart successfully')),
                                    );
                                  }
                                  print(response.body);
                                },
                                child: Container(
                                  height: 50,
                                  width: 320,
                                  decoration: BoxDecoration(
                                    color: Colors.blue[600],
                                    borderRadius: BorderRadius.circular(20),
                                    boxShadow: const [BoxShadow()],
                                  ),
                                  child: Center(
                                    child: Text(
                                      'Add To Cart',
                                      style: TextStyle(
                                        color: Colors.white,
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
                );
              });
        });
  }
}
