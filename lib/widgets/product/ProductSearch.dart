import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../../Constants/constants.dart';
import '../../Views/DrawerWidget.dart';
import '../Cart/CartPage.dart';
import 'ProductDetail.dart';

class ProductSearch extends StatefulWidget {
  final String searchQuery;
  const ProductSearch({Key? key, required this.searchQuery}) : super(key: key);

  @override
  State<ProductSearch> createState() => _ProductSearchState();
}

class _ProductSearchState extends State<ProductSearch> {
  TextEditingController _searchController = TextEditingController();
  List<dynamic> _products = [];
  List<dynamic> _filteredProducts = [];

  Future getProduct() async {
    final UrlData = '${url}list-product/';

    try {
      http.Response response = await http.get(Uri.parse(UrlData));
      if (response.statusCode == 200) {
        print(json.decode(response.body)['data'][0]['name']);
        setState(() {
          _products = jsonDecode(response.body)['data'];
          _filteredProducts = _products;
        });
      } else {
        print("Error - Status Code: ${response.statusCode}");
        print("Error - Message: ${response.body}");
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  void filterProducts(String query) {
    setState(() {
      if (query.isEmpty) {
        _filteredProducts = _products;
      } else {
        _filteredProducts = _products
            .where((product) =>
                product['name'].toLowerCase().contains(query.toLowerCase()))
            .toList();
      }
    });
  }

  @override
  void initState() {
    super.initState();
    _searchController.text = widget.searchQuery;
    getProduct();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 50,
        backgroundColor: Colors.brown[300],
        bottomOpacity: 0.0,
        elevation: 0.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(5),
            bottomRight: Radius.circular(5),
          ),
        ),
        title: InkWell(
          child: Container(
            alignment: Alignment.centerLeft,
            padding: EdgeInsets.symmetric(vertical: 3),
            height: 40,
            child: TextField(
              controller: _searchController,
              style: TextStyle(
                fontSize: 14,
              ),
              onChanged: filterProducts,
              decoration: InputDecoration(
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 8,
                ),
                filled: true,
                fillColor: Colors.brown[100],
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                  borderSide:
                      BorderSide(color: Colors.brown.shade400, width: 1),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                  borderSide:
                      BorderSide(color: Colors.brown.shade100, width: 1),
                ),
                hintText: "Search...",
                prefixIcon:
                    Icon(Icons.search, size: 20, color: Colors.deepOrange[300]),
              ),
            ),
          ),
        ),
        centerTitle: true,
        actions: <Widget>[
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (BuildContext context) {
                  return const CartPage();
                }),
              );
            },
            icon: Icon(Icons.shopping_bag_outlined, color: Colors.grey[200]),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
          child: StaggeredGrid.count(
            crossAxisCount: 2,
            crossAxisSpacing: 15.0,
            mainAxisSpacing: 15.0,
            children: _filteredProducts.map((product) {
              return Container(
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.3),
                      blurRadius: 1,
                      offset: Offset(0.0, 0.75),
                    ),
                  ],
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (BuildContext context) =>
                                ProductDetail(productId: product['id']),
                          ),
                        );
                      },
                      child: Container(
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Image.network(
                            "${urlImage}storage/${product['image']}",
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 8),
                    Row(
                      children: [
                        Container(
                          width: 150,
                          padding: EdgeInsets.only(left: 10, bottom: 10),
                          child: Text(
                            product['name'].toString(),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 2,
                            style: TextStyle(
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ],
                    ),
                    Container(
                      margin: EdgeInsets.only(left: 10, right: 10, bottom: 8),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Rp${product['price']}',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          GestureDetector(
                            onTap: () async {
                              final prefs =
                                  await SharedPreferences.getInstance();
                              String _data;
                              _data = prefs.getString('_data') ?? '';
                              Map<String, dynamic> decodedData =
                                  json.decode(_data);

                              var response = await http.post(
                                Uri.parse("${url}add-cart-id"),
                                body: {
                                  "id_products": product['id'].toString(),
                                  "id_user":
                                      decodedData['user']['id'].toString(),
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
                                  'Error',
                                  'Already in Cart',
                                  backgroundColor: Colors.red,
                                  colorText: Colors.white,
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
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
        ),
      ),
    );
  }
}
