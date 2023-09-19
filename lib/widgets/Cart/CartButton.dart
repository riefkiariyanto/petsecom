import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../../Constants/constants.dart';

class CartButton extends StatefulWidget {
  final int cartId;
  final Function(int) onQuantityChanged;
  CartButton({required this.cartId, required this.onQuantityChanged});

  @override
  _CartButtonState createState() => _CartButtonState();
}

class _CartButtonState extends State<CartButton> {
  int qty = 0;

  @override
  void initState() {
    super.initState();
    fetchQtyFromApi();
  }

  void fetchQtyFromApi() async {
    final response =
        await http.get(Uri.parse('${url}get-cart-quantity/${widget.cartId}'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      setState(() {
        qty = data['qty'];
      });
    } else {}
  }

  void incrementQty() async {
    final response = await http.put(
        Uri.parse('${url}get-cart-quantity/${widget.cartId}'),
        body: json.encode({"qty": qty + 1}),
        headers: {"Content-Type": "application/json"});

    if (response.statusCode == 200) {
      setState(() {
        qty++;
      });
      widget
          .onQuantityChanged(qty); // Notify the parent widget about the change
    } else {
      // Handle error, e.g., update failed
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Increment qty when the button is tapped
        incrementQty();
      },
      child: Container(
        width: 20,
        height: 20,
        decoration: BoxDecoration(
          color: Colors.blueAccent,
          borderRadius: BorderRadius.circular(4),
        ),
        child: Icon(
          Icons.add,
          color: Colors.white,
          size: 15,
        ),
      ),
    );
  }
}
