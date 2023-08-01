import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:reports_doing_app/features/employees/presentation_layer/pages/auth/login_page.dart';

class RichTextWidgetSignUp extends StatelessWidget {
  const RichTextWidgetSignUp({super.key});

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
          text: 'Login',
          recognizer: TapGestureRecognizer()
            ..onTap = () => Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (context) => const LoginPage())),
          style: const TextStyle(
              color: Color.fromARGB(200, 33, 149, 243),
              decoration: TextDecoration.underline,
              fontSize: 16,
              fontWeight: FontWeight.bold))
    ]));
  }
}
