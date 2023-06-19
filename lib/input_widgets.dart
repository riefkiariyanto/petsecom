import 'package:flutter/material.dart';

class InputWidget extends StatelessWidget {
  TextEditingController controller;
  bool isObscureText;
  TextInputType inputType;
  String labelText;
  bool isEnable;

  InputWidget(
      {required this.controller,
      required this.isObscureText,
      required this.labelText,
      this.inputType = TextInputType.text,
      this.isEnable = true});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      child: TextFormField(
        obscureText: isObscureText,
        controller: controller,
        enabled: isEnable,
        keyboardType: inputType,
        decoration: InputDecoration(
          labelText: labelText,
        ),
      ),
    );
  }
}
