import 'package:flutter/material.dart';
import 'package:reports_doing_app/core/constants/constants.dart';

class TextWidget extends StatelessWidget {
  final String? lableText;
  const TextWidget({super.key, this.lableText});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Text(
        lableText ?? '',
        style: TextStyle(
            fontSize: 18.0, fontWeight: FontWeight.bold, color: dartBlue),
        overflow: TextOverflow.ellipsis,
      ),
    );
  }
}
