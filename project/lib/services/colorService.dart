import 'dart:ui';

class ColorService {
  static Color getContrastColorFromList(
      List<dynamic> hexcolors, dynamic backgroundColor) {
    Color returnColor = Color(0xff000000);
    if (hexcolors.isNotEmpty) {
      List<Color> colors = [];
      for (var element in hexcolors) {
        if (element is String) {
          colors.add(_stringToColor(element));
        } else if (element is num) {
          colors.add(_numToColor(element));
        } else if (element is Color) {
          colors.add(element);
        }
      }
      Color? background;
      if (backgroundColor is Color) {
        background = backgroundColor;
      } else if (backgroundColor is String) {
        background = _stringToColor(backgroundColor);
      } else if (backgroundColor is num) {
        background = _numToColor(backgroundColor);
      }
      if (null != background) {}
    }

    return returnColor;
  }

  static Color _contrastFromList(List<Color> colors) {
    return Color(0xff000000);
  }

  static Color _stringToColor(String color) {
    return Color(0xff000000);
  }

  static Color _numToColor(num color) {
    return Color(0xff00000);
  }

  static num _contrastBetween(Color c1, Color c2) {
    return 1;
  }

  static num _getLuminance(Color color) {
    num luminance = color.alpha.clamp(0, 1) *
        (color.red * 0.2126 + color.green * 0.7152 + color.blue * 0.0722);

    return luminance;
  }
}
