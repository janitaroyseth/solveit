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

  /// Converts a [Map] object to a [Tag] object.
  static Tag? fromMap(Map<String, dynamic>? data) {
    if (data == null) {
      return null;
    }
    final String text = data['text'];
    final String color = data['color'];
    return Tag(text: text, color: color);
  }

  /// Converts a [Tag] object to a [Map] object.
  Map toMap() {
    return {"text": text, "color": color};
  }
}
