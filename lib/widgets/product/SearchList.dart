import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../../Constants/constants.dart';
import '../../Views/DrawerWidget.dart';
import '../Cart/CartPage.dart';
import 'ProductDetail.dart';

class SearchList extends StatefulWidget {
  final String searchQuery;

  const SearchList({Key? key, required this.searchQuery}) : super(key: key);

  @override
  State<SearchList> createState() => _SearchListState();
}

class _SearchListState extends State<SearchList> {
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
          _filteredProducts = _products; // Initialize filtered list
        });
      } else {
        print("Error - Status Code: ${response.statusCode}");
        print("Error - Messaga: ${response.body}");
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
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (BuildContext context) {
                  return DrawerWidget();
                }),
              );
            },
            icon: Icon(Icons.menu_rounded, color: Colors.grey[200]),
          )
        ],
      ),
      body: ListView.builder(
        itemCount: _filteredProducts.length,
        itemBuilder: ((context, index) {
          return Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (BuildContext context) => ProductDetail(
                        productId: _filteredProducts[index]['id']),
                  ),
                );
              },
              child: ListTile(
                title: Row(children: [
                  Container(
                    height: 50,
                    width: 40,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.white),
                    child: Center(
                      child: Image.network(
                        "${urlImage}storage/${_filteredProducts[index]['image']}",
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Column(
                    children: [
                      Container(
                        width: 270,
                        child: Text(
                          _filteredProducts[index]['name'],
                          style: TextStyle(
                              fontSize: 12, fontWeight: FontWeight.bold),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                        ),
                      ),
                      Container(
                        width: 270,
                        child: Text(
                          _filteredProducts[index]['category'],
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey,
                          ),
                        ),
                      ),
                    ],
                  )
                ]),
              ),
            ),
          );
        }),
      ),
    );
  }
}
