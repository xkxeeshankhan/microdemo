import 'package:flutter/material.dart';

class ErrorMessage extends StatelessWidget {
  final String errorMessage;

  const ErrorMessage({Key key, this.errorMessage}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return errorMessage == null || errorMessage == ""
        ? SizedBox()
        : Text(
            errorMessage,
            style: TextStyle(color: Colors.red),
          );
  }
}
