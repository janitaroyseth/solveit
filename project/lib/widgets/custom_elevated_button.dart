import 'package:flutter/material.dart';

class CustomElevatedButton extends StatelessWidget {
  const CustomElevatedButton({
    super.key,
    this.child,
    this.color,
    this.borderRadius = 7.0,
    this.height,
    this.padding = 5.0,
    required this.onPressed,
  });

  final Widget? child;
  final Color? color;
  final double borderRadius;
  final double? height;
  final double padding;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(padding, 0, padding, 0),
      child: SizedBox(
        height: height,

        child: ElevatedButton(
            onPressed: onPressed,
            style: ElevatedButton.styleFrom(
              backgroundColor: color,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(borderRadius),
                ),
              ),
            ),
            child: child),
      ),
    );
  }
}