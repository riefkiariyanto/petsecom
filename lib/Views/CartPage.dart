import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:petsecom/widgets/CartItem.dart';

class CartPage extends StatefulWidget {
  const CartPage({super.key});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        backgroundColor: Colors.grey[200],
        bottomOpacity: 0.0,
        elevation: 0.0,
        title: Text(
          "Cart",
          style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Colors.grey[700]),
        ),
        centerTitle: true,
        leading: IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: Icon(Icons.arrow_back, color: Colors.grey[700]),
        ),
      ),
      body: ListView(
        children: [
          CartItem(),
        ],
      ),
    );
  }
}
