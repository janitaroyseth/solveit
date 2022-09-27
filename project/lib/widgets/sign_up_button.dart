import 'package:project/widgets/custom_elevated_button.dart';
import 'package:flutter/material.dart';

///Represents a widget for a sign-up button
class SignUpButton extends CustomElevatedButton{
  SignUpButton({super.key,
    required String text,
    required VoidCallback onPressed,
  })  : super(
    child: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text(
          text,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w300,
          ),
        ),
      ],
    ),
    color: const Color.fromRGBO(36, 149, 165, 1.0),
    onPressed: onPressed,
    height: 40.0,
    padding: 55,

  );
}