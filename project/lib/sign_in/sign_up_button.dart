import 'package:project/widgets/custom_elevated_button.dart';
import 'package:flutter/material.dart';


class SignUpButton extends CustomElevatedButton{
  SignUpButton({super.key,

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

  })  : super(
    child: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
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
    height: 40.0,
    padding: 55,

  );
}