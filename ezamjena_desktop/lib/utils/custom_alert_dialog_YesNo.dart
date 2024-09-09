import 'package:flutter/material.dart';

class CustomAlertDialog2 extends StatelessWidget {
  final String title;
  final String message;
  final VoidCallback onConfirmPressed;
  final VoidCallback onCancelPressed;

  const CustomAlertDialog2({
    required this.title,
    required this.message,
    required this.onConfirmPressed,
    required this.onCancelPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Container(
        padding: EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              title,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text(
              message,
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: onConfirmPressed,
                  child: Text("Da"),
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.blue,
                    textStyle: TextStyle(fontSize: 16),
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  ),
                ),
                ElevatedButton(
                  onPressed: onCancelPressed,
                  child: Text("Ne"),
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.red,
                    textStyle: TextStyle(fontSize: 16),
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
