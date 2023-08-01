import 'package:flutter/material.dart';

class ForgetPasswordBtnWidget extends StatelessWidget {
  const ForgetPasswordBtnWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomRight,
      child: TextButton(
          onPressed: () {
            // Navigator.push(
            //     context,
            //     MaterialPageRoute(
            //         builder: (context) =>
            //             const ForgetPasswordScreen()));
          },
          child: const Text(
            "forget password ?",
            style: TextStyle(
                decoration: TextDecoration.underline,
                fontSize: 16,
                color: Colors.white,
                fontStyle: FontStyle.italic),
          )),
    );
  }
}
