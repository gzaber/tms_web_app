//@dart=2.9
import 'package:flutter/material.dart';

class CustomSnackBar {
  static Widget show(String message, bool success, BuildContext context) {
    return SnackBar(
      content: Text(
        message,
        style:
            Theme.of(context).textTheme.bodyText2.copyWith(color: Colors.white),
      ),
      backgroundColor: success ? Theme.of(context).primaryColor : Colors.black,
      padding: const EdgeInsets.all(16.0),
      margin: const EdgeInsets.all(16.0),
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(),
    );
  }
}
