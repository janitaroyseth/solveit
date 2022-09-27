import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'custom_elevated_button.dart';

///Represents a widget for a login-button with an icon and text.
class SignInButton extends CustomElevatedButton {
  SignInButton({
    super.key,
    required PhosphorIconData icon,
    required String text,
    required VoidCallback onPressed,
  }) : super(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Icon(
                icon,
                color: Colors.black,
                size: 32,
              ),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Text(
                  text,
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 18.0,
                    fontFamily: "Comfortaa",
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          color: Colors.white,
          onPressed: onPressed,
          height: 45.0,
          padding: 20.0,
        );
}
