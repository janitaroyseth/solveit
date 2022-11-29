import 'dart:math';

import 'package:flutter/material.dart';

String stringFromColor(Color color) {
  return "#${color.toString().split('(0x')[1].split(')')[0]}";
}

Color colorFromString(String color) {
  return color.length > 7
      ? Color(int.parse(color.substring(1), radix: 16))
      : Color(
          int.parse(color.substring(1), radix: 16) + 0xFF000000,
        );
}

Color getContrastColor(Color color) {
  return color.computeLuminance() * color.alpha.clamp(0, 1) < 0.45
      ? Colors.white
      : Colors.black;
}

Color getRandomColor() {
  return Color((Random().nextDouble() * 0xFFFFFF).toInt()).withOpacity(1.0);
}
