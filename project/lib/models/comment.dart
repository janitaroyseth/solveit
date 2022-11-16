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

    final User author = data['author'];
    final String date = data['date'];
    // TODO: fix this
    //return Comment(author: author, date: date);
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

  /// Creates an instance of [ImageComment] from the given [Map].
  static ImageComment? fromMap(Map<String, dynamic>? data) {
    if (data == null) {
      return null;
    }

    final User author = data["author"];
    final String date = data["date"];
    final File image = data["image"];

    return ImageComment(
      author: author,
      date: date,
      image: image,
    );
  }
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

  /// Creates an instance of [TextComment] from the given [Map].
  static TextComment? fromMap(Map<String, dynamic>? data) {
    if (data == null) {
      return null;
    }

    final User author = data["author"];
    final String date = data["date"];
    final String text = data["text"];

    return TextComment(
      author: author,
      date: date,
      text: text,
    );
  }
}

/// Comment where the content is a string url.
class GifComment extends Comment {
  /// The url of the giphy in the comment.
  String url;

  /// Creates an instance of [GifComment].
  GifComment({
    required super.author,
    super.date,
    required this.url,
  });

  /// Creates an instance of [GifComment] from the given [Map].
  static GifComment? fromMap(Map<String, dynamic>? data) {
    if (data == null) {
      return null;
    }

    final User author = data["author"];
    final String date = data["date"];
    final String url = data["url"];

    return GifComment(
      author: author,
      date: date,
      url: url,
    );
  }
}
