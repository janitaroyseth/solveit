/// The data content of a tag on a task.
class Tag {
  // The text content of the tag.
  final String text;
  // The numeric color value of the tag.
  final String color;

  // Set color to default value if no color parameter is given,
  // or to red if color parameter is of invalid format,
  // or to color parameter if its format is valid.
  Tag({String text = "tag", String color = "#FFFFFF"})
      : text = text.isNotEmpty ? text : "Invalid Text",
        color = _isColor(color) ? color : "#FF0000";

  static bool _isColor(String color) {
    return RegExp(r'^#([0-9a-fA-F]{6}||[0-9a-fA-F]{8})$').hasMatch(color);
  }
}
