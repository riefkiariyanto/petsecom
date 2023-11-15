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
        backgroundColor: Colors.brown[300],
        toolbarHeight: 45,
        bottomOpacity: 0.0,
        elevation: 1.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(30),
          ),
        ),
        title: Text(
          "Order List",
          style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Colors.brown[50]),
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
            icon: Icon(Icons.shopping_bag_outlined, color: Colors.brown[50]),
          ),
        ],
        leading: IconButton(
          onPressed: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (BuildContext context) {
              return const HomePage();
            }));
          },
          icon: Icon(Icons.arrow_back, color: Colors.brown[50]),
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
