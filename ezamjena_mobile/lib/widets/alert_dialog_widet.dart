import 'package:flutter/material.dart';

Widget AlertDialogWidget(
    {required String title,
    required String message,
    required BuildContext context}) {
  return AlertDialog(
    title: Text(title),
    content: Text(message),
    actions: [
      TextButton(
          onPressed: () => Navigator.pop(context), child: const Text("Ok"))
    ],
  );
}