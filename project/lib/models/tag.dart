/// The data content of a tag on a task.
class Tag {
  // The text content of the tag.
  final String text;
  // The numeric color value of the tag.
  final int color;

  /// Converts a [Map] object to a [Tag] object.
  factory Tag.fromMap(Map<String, dynamic> data) {
    if (data == null) {
      //return null;
    }
    final String text = data['text'];
    final int color = data['color'];
    return Tag(text: text, color: color);
  }

  const Tag({this.text = "tag", this.color = 0xFFFFFF});
}
