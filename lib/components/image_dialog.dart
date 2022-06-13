import 'package:flutter/material.dart';

class ImageDialog extends StatelessWidget {
  @override
  Text title;
  Widget content;
  Row buttons;


  ImageDialog(this.title, this.content, this.buttons);

  Widget build(BuildContext context) {
    return AlertDialog(
      title: title,
      content: content,
      actions: [
        buttons
      ],
    );
  }
}
