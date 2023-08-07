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

class inputNumber extends StatelessWidget {
  TextEditingController controller;
  bool isObscureText;
  TextInputType inputType;
  String labelText;
  bool isEnable;

  inputNumber(
      {required this.controller,
      required this.isObscureText,
      required this.labelText,
      this.inputType = TextInputType.number,
      this.isEnable = true});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      child: TextFormField(
        obscureText: isObscureText,
        controller: controller,
        enabled: isEnable,
        keyboardType: TextInputType.number,
        validator: (value) {
          if (value!.isEmpty ||
              !RegExp(r'(^[\+]?[(]?[0-9]{3}[)]?[-\s\.]?[0-9]{3}[-\s\.]?[0-9]{4,6}$)')
                  .hasMatch(value)) {
            return "Enter Correct Number";
          } else {
            return null;
          }
        },
        decoration: InputDecoration(
          labelText: labelText,
        ),
      ),
    );
  }
}
