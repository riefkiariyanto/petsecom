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
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: Colors.grey[100],
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
      body: SingleChildScrollView(
        child: Column(
          children: [
            CartItem(),
            SizedBox(
              height: 10,
            ),
            CheckoutState(),
            SizedBox(
              height: 20,
            ),
            CheckOutButton()
          ],
        ),
      ),
    );
  }

  CheckoutState() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Divider(
            height: 2,
            color: Colors.grey[400],
            thickness: 2,
          ),
          Padding(
            padding: EdgeInsets.only(top: 20),
            child: Row(
              children: [
                Text(
                  'Total ',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Spacer(),
                Text(
                  "\$ Price",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  CheckOutButton() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30.0),
      child: Container(
        padding: EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.deepOrange,
          borderRadius: BorderRadius.circular(14),
        ),
        child: Center(
          child: Text(
            'CheckOut',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }
}
