import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class EditShipping extends StatefulWidget {
  @override
  _EditShippingState createState() => _EditShippingState();
}

class _EditShippingState extends State<EditShipping> {
  TextEditingController nameController = TextEditingController();
  TextEditingController addressController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('New Shipping Address'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Name:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            TextField(
              controller: nameController,
              decoration: InputDecoration(
                hintText: 'Enter your name',
              ),
            ),
            Text(
              'Address:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            TextField(
              controller: addressController,
              decoration: InputDecoration(
                hintText: 'Enter your address',
              ),
            ),
            ElevatedButton(
              onPressed: () {
                // Save the updated username and address
                final newName = nameController.text;
                final newAddress = addressController.text;

                Navigator.pop(context);
              },
              child: Text('Save'),
            ),
          ],
        ),
      ),
    );
  }
}
