import 'package:flutter/material.dart';

class TextWidgetSignUp extends StatelessWidget {
  const TextWidgetSignUp({super.key});

  @override
  Widget build(BuildContext context) {
    return const Text(
      "Register ",
      style: TextStyle(
          fontSize: 30, color: Colors.white, fontWeight: FontWeight.bold),
    );
  }
}
