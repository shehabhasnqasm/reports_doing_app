import 'package:flutter/material.dart';
import 'package:reports_doing_app/core/services/constants/color_constant.dart';

class GlobalDialogs {
  static void showErrorDialog(
      {required String error, required BuildContext context}) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Row(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  /*
                  child: Image.network(
                    'https://t3.ftcdn.net/jpg/02/69/66/02/240_F_269660263_wICqesonYg9VCcNiVnFzEhmuTWCyeu4Q.jpg',
                    height: 30,
                    width: 30,
                  ),
                  */
                  child: Image.asset(
                    'assets/images/other/alert_watch.png',
                    height: 30,
                    width: 30,
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.all(0.0),
                  child: Text('Error Occured'),
                )
              ],
            ),
            content: Text(
              error,
              style: TextStyle(
                  fontSize: 20,
                  color: Constants.dartBlue,
                  fontStyle: FontStyle.italic),
            ),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.canPop(context) ? Navigator.pop(context) : null;
                  },
                  child: const Text(
                    'OK',
                    style: TextStyle(color: Colors.red),
                  ))
            ],
          );
        });
  }
}
