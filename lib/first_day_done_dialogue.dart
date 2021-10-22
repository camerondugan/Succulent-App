import 'package:flutter/material.dart';

void dialogue(context) {
  showDialog<String>(
    context: context,
    builder: (BuildContext context) => AlertDialog(
      title: const Text('Congratulations!'),
      content: const Text(
          'The first day is done, come back tommorrow to see your plant grow!'),
      actions: <Widget>[
        TextButton(
          onPressed: () => Navigator.pop(context, 'OK'),
          child: const Text('OK'),
        ),
      ],
    ),
  );
}
