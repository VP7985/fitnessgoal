import 'package:flutter/material.dart';
class MyTextField extends StatelessWidget {
  final TextEditingController controller;
  final String lableText;
  final bool obscureText;
  final IconData prefixIcon;
  final IconData? suffixIcon;

  const MyTextField({
    Key? key,
    required this.controller,
    required this.lableText,
    required this.obscureText,
    required this.prefixIcon,
    this.suffixIcon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25.0),
      child: TextFormField(
        controller: controller,
        obscureText: obscureText,
        decoration: InputDecoration(
          labelText: lableText,
          labelStyle: TextStyle(color: Colors.black),
          prefixIcon: Icon(prefixIcon),
          suffixIcon: controller.text.isNotEmpty ? Icon(suffixIcon) : null,
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.white),
            borderRadius: BorderRadius.zero, // Make it square
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.grey.shade400),
            borderRadius: BorderRadius.zero, // Make it square
          ),
          filled: true,
          fillColor: Colors.grey.shade200,
          hintStyle: TextStyle(color: Colors.grey[500]),
        ),
      ),
    );
  }
}
