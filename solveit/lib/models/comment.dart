/// The data content of a comment in a task.
class Comment {
  // The text content (body) of the comment.
  String text;
  // The author of the comment.
  String author;
  // The date on which the comment was made.
  String date;

  Comment(
      {this.text = "comment text",
      this.author = "author",
      this.date = "01.01.2001"});
}
