import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ToastsMessage {
  void showSuccessToast() {
    Fluttertoast.showToast(
        msg: "Task has been uploaded successfuly",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        //timeInSecForIosWeb: 2,
        backgroundColor: Colors.green,
        textColor: Colors.white,
        fontSize: 16.0);
  }

  void showErrorToast() {
    Fluttertoast.showToast(
        msg: " Sorry ; Failure oe an error appear ",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        //timeInSecForIosWeb: 2,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0);
  }
}
