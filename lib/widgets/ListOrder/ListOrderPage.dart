import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../Views/HomePage.dart';
import '../Cart/CartPage.dart';
import 'StoreOrder.dart';

class ListOrder extends StatefulWidget {
  const ListOrder({super.key});

  @override
  State<ListOrder> createState() => _ListOrderState();
}

class _ListOrderState extends State<ListOrder> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        bottomOpacity: 0.0,
        elevation: 0.0,
        title: Text(
          "ListOrder",
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
      body: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            StoreOrder(),
          ],
        ),
      ),
    );
  }
}
