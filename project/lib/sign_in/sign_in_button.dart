import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import '../widgets/custom_elevated_button.dart';

class SignInButton extends CustomElevatedButton {
  SignInButton({
    super.key,
    required PhosphorIconData icon,
    required String assetName,
    required String text,
    required VoidCallback onPressed,
    double? height,
    double? padding,
    double? fontSize,
    double? logoHeight,
    String? fontFamily,
    FontWeight? fontWeight,
    Color? color,
    Color? textColor,
  }) : super(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Icon(
                icon,
              ),
              // Image.asset(assetName, height: logoHeight),
              Text(
                text,
                style: TextStyle(
                  color: textColor,
                  fontSize: fontSize,
                  fontFamily: fontFamily,
                  fontWeight: fontWeight,
                ),
              ),
            ],
          ),
          color: color,
          onPressed: onPressed,
          height: 45.0,
          padding: 10.0,
        );
}
