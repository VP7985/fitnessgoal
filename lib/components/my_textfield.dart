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
      child: TextField(
        controller: controller,
        obscureText: obscureText,
        decoration: InputDecoration(
          labelText: lableText,
          prefixIcon: Icon(prefixIcon),
          suffixIcon: suffixIcon != null ? Icon(suffixIcon) : null,
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.white),
            borderRadius: BorderRadius.circular(15.0),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.grey.shade400),
            borderRadius: BorderRadius.circular(15.0),
          ),
          filled: true,
          fillColor: Colors.grey.shade200,
          hintStyle: TextStyle(color: Colors.grey[500]),
        ),
      ),
    );
  }
}
