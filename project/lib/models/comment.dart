import 'package:project/models/user.dart';

/// The data content of a comment in a task.
class Comment {
  // The text content (body) of the comment.
  String text;
  // The author of the comment.
  User author;
  // The date on which the comment was made.
  String date;

  /// Converts a [Map] object to a [Comment] object.
  static Comment? fromMap(Map<String, dynamic>? data) {
    if (data == null) {
      return null;
    }
    final String text = data['text'];
    final String author = data['author'];
    final String date = data['date'];
    // TODO: fix this
    //return Comment(text: text, author: author, date: date);
  }

  Comment(
      {this.text = "comment text",
      required this.author,
      this.date = "01.01.2001"});
}
