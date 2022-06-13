import 'package:flutter/material.dart';

class CustomAlertDialog extends StatelessWidget {
  @override
  Text title;
  Widget content;
  TextButton cancel;
  TextButton ok;

  CustomAlertDialog(this.title, this.content, this.cancel, this.ok);

  Widget build(BuildContext context) {
    return AlertDialog(
      title: title,
      content: content,
      actions: [
        cancel,
        ok,
      ],
    );
  }
}
