import 'package:flutter/material.dart';

class MyTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final bool obscureText;
  final Widget? suffixIcon;
  final TextInputType keyboardType;
  final FocusNode focusNode;
  final FocusNode currentFocusNode;
  final FocusNode nextFocusNode;

  MyTextField({
    required this.controller,
    required this.hintText,
    required this.obscureText,
    required this.keyboardType,
    required this.focusNode,
    required this.currentFocusNode,
    required this.nextFocusNode,
    this.suffixIcon,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      obscureText: obscureText, // This will control the visibility
      keyboardType: keyboardType,
      focusNode: focusNode,
      decoration: InputDecoration(
        hintText: hintText,
        suffixIcon: suffixIcon, // Add suffix icon for visibility toggle
        border: OutlineInputBorder(),
      ),
    );
  }
}
