import 'package:flutter/material.dart';

class Utils {
 static ScaffoldFeatureController<SnackBar, SnackBarClosedReason> showSnackBar(
      String message, BuildContext context) {
    return ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(message),
    ));
  }
}

