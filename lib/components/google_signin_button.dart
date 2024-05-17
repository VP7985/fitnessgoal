import 'package:flutter/material.dart';

class MyGoogleButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String text;

  const MyGoogleButton({
    Key? key,
    required this.onPressed,
    required this.text,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(40),
        ),
        width: 250,
        height: 50,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/google.png',
              height: 30,
              width: 30,
            ),
            SizedBox(width: 20),
            Text(text),
          ],
        ),
      ),
    );
  }
}
