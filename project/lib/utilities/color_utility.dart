import 'dart:math';

import 'package:flutter/material.dart';

/// Contains static utility functions for colors.
class ColorUtility {
  /// Converts the given [color] to a [String].
  static String stringFromColor(Color color) {
    return "#${color.toString().split('(0x')[1].split(')')[0]}";
  }

  /// Converts the given [String color] to a [Color].
  static Color colorFromString(String color) {
    return color.length > 7
        ? Color(int.parse(color.substring(1), radix: 16))
        : Color(
            int.parse(color.substring(1), radix: 16) + 0xFF000000,
          );
  }

  /// Returns a [Color] either `black` or `white`, depending on the contrast with the given
  /// color.
  static Color getContrastColor(Color color) {
    return color.computeLuminance() * color.alpha.clamp(0, 1) < 0.45
        ? Colors.white
        : Colors.black;
  }

  /// Returns a random [Color].
  static Color getRandomColor() {
    return Color((Random().nextDouble() * 0xFFFFFF).toInt()).withOpacity(1.0);
  }
}
