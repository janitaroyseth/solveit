import 'package:flutter/material.dart';

/// Represents a custom ElevatedButton.
/// This is used as a template for different buttons in the sign-in page
class CustomElevatedButton extends StatelessWidget {
  const CustomElevatedButton({
    super.key,
    this.child,
    this.color,
    this.height,
    this.borderRadius = 7.0,
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
              primary: color,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(borderRadius),
                ),
              ),
            ),
            child: child),
      ),
    );
  }
}
