/// The data content of a tag on a task.
class Tag {
  String tagId;
  // The text content of the tag.
  final String text;
  // The numeric color value of the tag.
  final String color;

  // Set color to default value if no color parameter is given,
  // or to red if color parameter is of invalid format,
  // or to color parameter if its format is valid.
  Tag({this.tagId = "", String text = "tag", String color = "#FFFFFF"})
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
    final String tagId = data['tagId'];
    final String text = data['text'];
    final String color = data['color'];
    return Tag(tagId: tagId, text: text, color: color);
  }

  static List<Tag> fromMaps(var data) {
    List<Tag> tags = [];
    for (var value in data) {
      Tag? tag = fromMap(value);
      if (null != tag) {
        tags.add(tag);
      }
    }
    return tags;
  }

  /// Converts a [Tag] object to a [Map] object.
  Map<String, dynamic> toMap() {
    return {"tagId": tagId, "text": text, "color": color};
  }

  @override
  int get hashCode => text.hashCode + color.hashCode;

  @override
  bool operator ==(Object other) {
    if (text == (other as Tag).text && color == (other).color) {
      return true;
    }
    return false;
  }
}
