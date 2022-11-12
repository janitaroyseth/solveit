import 'dart:io';

import 'package:project/models/user.dart';

/// The data content of a comment in a task.
abstract class Comment {
  // The author of the comment.
  User author;
  // The date on which the comment was made.
  String date;

  /// Converts a [Map] object to a [Comment] object.
  static Comment? fromMap(Map<String, dynamic>? data) {
    if (data == null) {
      return null;
    }

    final String author = data['author'];
    final String date = data['date'];
    // TODO: fix this
    //return Comment(text: text, author: author, date: date);
  }

  Comment({
    required this.author,
    String? date,
  }) : date = date ?? DateTime.now().toIso8601String();
}

/// Comment where the content is a [Image].
class ImageComment extends Comment {
  /// The image content of the comment.
  File image;

  /// Creates an instance of [ImageComment], a comment where the content
  /// is a [Image].
  ImageComment({
    required super.author,
    super.date,
    required this.image,
  });
}

/// Comment where the content is a [String].
class TextComment extends Comment {
  /// The text content (body) of the comment.
  String text;

  /// Creates an instant of [TextComment], a comment where the content
  /// is a [String].
  TextComment({
    required super.author,
    super.date,
    required this.text,
  });
}

class GiphyComment extends Comment {
  String url;

  GiphyComment({
    required super.author,
    super.date,
    required this.url,
  });
}
