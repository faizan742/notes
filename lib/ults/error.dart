import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
class errorMessage{
  void  loadError(String error1)
  {
    Fluttertoast.showToast(
        msg: error1,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0
    );
  }

}