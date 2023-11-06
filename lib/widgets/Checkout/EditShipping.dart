import 'package:flutter/material.dart';

class EditShipping extends StatefulWidget {
  final Map<String, dynamic> initialData;
  final Function(Map<String, dynamic>) onAddressSaved;

  EditShipping({required this.initialData, required this.onAddressSaved});

  @override
  _EditShippingState createState() => _EditShippingState();
}

class _EditShippingState extends State<EditShipping> {
  late TextEditingController nameController;
  late TextEditingController addressController;
  late TextEditingController phoneController;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: widget.initialData['name']);
    addressController =
        TextEditingController(text: widget.initialData['address']);
    phoneController = TextEditingController(text: widget.initialData['phone']);
  }

  void onSaveAddress() {
    final newName = nameController.text;
    final newAddress = addressController.text;
    final newPhone = phoneController.text;

    Map<String, dynamic> newAddressData = {
      'name': newName,
      'address': newAddress,
      'phone': newPhone,
    };

    widget.onAddressSaved(newAddressData);

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        child: AlertDialog(
          title: Text('Edit Shipping Address'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
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
              Text(
                'Phone:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              TextField(
                controller: phoneController,
                decoration: InputDecoration(
                  hintText: 'Enter your phone number',
                ),
                keyboardType: TextInputType.phone,
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              onPressed: onSaveAddress,
              child: Text('Save'),
            ),
          ],
        ),
      ),
    );
  }
}
