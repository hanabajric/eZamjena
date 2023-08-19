import 'package:flutter/material.dart';

class TextFieldWithTitle extends StatefulWidget {
  final String title;
  final TextEditingController controller;
  final ValueChanged<String>? onChanged;
  final bool passwordField;
  final FormFieldValidator<String>? validator;
  final TextInputType? keyboardType;
  final String? errorText;
  final String? emailErrorText;
  final String? passwordErrorText;
  final String? passwordConfirmationErrorText;

  const TextFieldWithTitle({
    required this.title,
    required this.controller,
    this.onChanged,
    this.passwordField = false,
    this.validator,
    this.keyboardType,
    this.errorText,
    this.emailErrorText,
    this.passwordErrorText,
    this.passwordConfirmationErrorText,
  });

  @override
  _TextFieldWithTitleState createState() => _TextFieldWithTitleState();
}

class _TextFieldWithTitleState extends State<TextFieldWithTitle> {
  bool _passwordVisible = false;
  bool _passwordConfirmationVisible = false;

  @override
  Widget build(BuildContext context) {
    bool isPasswordField = widget.title.toLowerCase().contains('lozinka');
    bool isConfirmationField =
        widget.title.toLowerCase().contains('potvrda lozinke');

    return Container(
      margin: EdgeInsets.symmetric(vertical: 5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              SizedBox(
                width: 120,
                child: Text(widget.title,
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
              ),
              SizedBox(width: 10),
              Expanded(
                child: Align(
                  alignment: Alignment.topCenter,
                  child: TextFormField(
                    controller: widget.controller,
                    onChanged: widget.onChanged,
                    obscureText: isPasswordField || isConfirmationField
                        ? (widget.passwordField ? !_passwordVisible : true)
                        : false,
                    validator: widget.validator,
                    keyboardType: widget.keyboardType,
                    decoration: InputDecoration(
                      errorText: widget.errorText ??
                          widget.emailErrorText ??
                          widget.passwordErrorText ??
                          widget.passwordConfirmationErrorText,
                      
                    ),
                    // Add more text field properties here
                  ),
                ),
              ),
              if (isPasswordField || isConfirmationField && widget.passwordField)
                IconButton(
                  onPressed: () {
                    setState(() {
                      _passwordVisible = !_passwordVisible;
                    });
                  },
                  icon: Icon(
                    _passwordVisible ? Icons.visibility : Icons.visibility_off,
                  ),
                ),
              // if (isConfirmationField && widget.passwordField)
              //   IconButton(
              //     onPressed: () {
              //       setState(() {
              //         _passwordConfirmationVisible =
              //             !_passwordConfirmationVisible;
              //       });
              //     },
              //     icon: Icon(
              //       _passwordConfirmationVisible
              //           ? Icons.visibility
              //           : Icons.visibility_off,
              //     ),
              //   ),
            ],
          ),
        ],
      ),
    );
  }
}