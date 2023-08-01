import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:reports_doing_app/features/employees/presentation_layer/pages/auth/signup_page.dart';

class RichTextWidget extends StatelessWidget {
  const RichTextWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return RichText(
        text: TextSpan(children: [
      const TextSpan(
          text: 'Dont\'t have an acount ?',
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          )),
      const TextSpan(text: '   '),
      TextSpan(
          text: 'Register',
          recognizer: TapGestureRecognizer()
            ..onTap = () => Navigator.push(context,
                MaterialPageRoute(builder: (context) => const SignUpPage())),
          style: const TextStyle(
              color: Color.fromARGB(200, 33, 149, 243),
              decoration: TextDecoration.underline,
              fontSize: 16,
              fontWeight: FontWeight.bold))
    ]));
  }
}
