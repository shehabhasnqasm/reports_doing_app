import 'package:flutter/material.dart';

class LoginBtnWidget extends StatelessWidget {
  final Function fct;
  const LoginBtnWidget({super.key, required this.fct});

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      onPressed: null, //fct(),
      color: const Color.fromARGB(255, 211, 20, 84),
      elevation: 10,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10), side: BorderSide.none),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const [
          Padding(
            padding: EdgeInsets.symmetric(vertical: 14),
            child: Text(
              "login",
              style: TextStyle(
                  fontSize: 20,
                  color: Colors.white,
                  fontWeight: FontWeight.bold),
            ),
          ),
          SizedBox(
            width: 7,
          ),
          Icon(
            Icons.login,
            color: Colors.white,
          )
        ],
      ),
    );
  }
}
