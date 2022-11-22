import 'dart:io';

import 'package:project/models/user.dart';

/// The data content of a comment in a task.
abstract class Comment {
  // The id of the comment.
  String commentId;
  // The author of the comment.
  User? author;
  // The date on which the comment was made.
  String date;

  /// Converts a [Map] object to a [Comment] object.
  static Comment? fromMap(Map<String, dynamic>? data) {
    if (data == null) {
      return null;
    }

    final String commentId = data["commentId"];
    final String date = data['date'];
    final String? image = data['image'];
    final String? text = data['text'];
    final String? url = data['url'];

    if (null != image) {
      return ImageComment(commentId: commentId, date: date, image: File(image));
    } else if (null != text) {
      return TextComment(commentId: commentId, date: date, text: text);
    } else if (null != url) {
      return GifComment(commentId: commentId, date: date, url: url);
    } else {
      return null;
    }
  }

  static Map<String, dynamic> toMap(Comment comment) {
    Map<String, dynamic> map = {
      "commentId": comment.commentId,
      "author": comment.author!.userId,
      "date": comment.date,
    };
    if (comment is TextComment) {
      map["text"] = comment.text;
    } else if (comment is GifComment) {
      map["url"] = comment.url;
    } else if (comment is ImageComment) {
      map["image"] = comment.image;
    }
    return map;
  }

  Comment({
    this.commentId = "",
    this.author,
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
    super.commentId = "",
    super.author,
    super.date,
    required this.image,
  });

  /// Creates an instance of [ImageComment] from the given [Map].
  static ImageComment? fromMap(Map<String, dynamic>? data) {
    if (data == null) {
      return null;
    }
    final String commentId = data["commentId"];
    final String date = data["date"];
    final File image = data["image"];

    return ImageComment(
      commentId: commentId,
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
    super.commentId = "",
    super.author,
    super.date,
    required this.text,
  });

  /// Creates an instance of [TextComment] from the given [Map].
  static TextComment? fromMap(Map<String, dynamic>? data) {
    if (data == null) {
      return null;
    }

    final String commentId = data["commentId"];
    final String date = data["date"];
    final String text = data["text"];

    return TextComment(
      commentId: commentId,
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
    super.commentId,
    super.author,
    super.date,
    required this.url,
  });

  /// Creates an instance of [GifComment] from the given [Map].
  static GifComment? fromMap(Map<String, dynamic>? data) {
    if (data == null) {
      return null;
    }

    final String commentId = data["commentId"];
    final String date = data["date"];
    final String url = data["url"];

    return GifComment(
      commentId: commentId,
      date: date,
      url: url,
    );
  }
}
