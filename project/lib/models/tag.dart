/// The data content of a tag on a task.
class Tag {
  // The text content of the tag.
  final String text;
  // The numeric color value of the tag.
  final int color;

  const Tag({this.text = "tag", this.color = 0xFFFFFF});
}
