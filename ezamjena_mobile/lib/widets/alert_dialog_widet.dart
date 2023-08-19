import 'package:ezamjena_mobile/widets/custom_alert_dialog.dart';
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
void _showMissingFieldsDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) => CustomAlertDialog(
        title: "Nedostajući podaci",
        message: "Molimo popunite sva obavezna polja.",
        onOkPressed: () {
          Navigator.pop(context); // Zatvaranje dijaloga
        },
      ),
    );
  }
