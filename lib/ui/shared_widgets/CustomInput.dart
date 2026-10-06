import 'package:flutter/material.dart';

class CustomInput extends StatelessWidget {
  final String labelText;
  final String hintText;
  final bool obscureText;

  const CustomInput({
    super.key,
    required this.labelText,
    required this.hintText,
    required this.obscureText,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      decoration: InputDecoration(
        labelText: labelText,
        hintText: hintText,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
        filled: true,
        fillColor: Colors.white,
      ),
    );
  }
}
