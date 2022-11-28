import 'package:cloud_firestore/cloud_firestore.dart';

/// The data content of a comment in a task.
abstract class Comment {
  // The id of the comment.
  String commentId;

  /// The id of the task this comment belongs to.
  String taskId;

  // The user id of the author of this comment.
  String author;
  // The date on which the comment was made.
  DateTime date;

  /// Converts a [Map] object to a [Comment] object.
  static Comment? fromMap(Map<String, dynamic>? data) {
    if (data == null) {
      return null;
    }

    final String commentId = data["commentId"];
    final String taskId = data["taskId"];
    final String author = data["author"];
    final DateTime date = (data['date'] as Timestamp).toDate();
    final String? imageUrl = data['imageUrl'];
    final String? text = data['text'];

    if (imageUrl != null) {
      return ImageComment(
          commentId: commentId,
          taskId: taskId,
          author: author,
          date: date,
          imageUrl: imageUrl);
    } else if (text != null) {
      return TextComment(
          commentId: commentId,
          taskId: taskId,
          author: author,
          date: date,
          text: text);
    } else {
      return null;
    }
  }

  static List<Comment> fromMaps(var data) {
    List<Comment> comments = [];

    for (var value in data) {
      Comment? comment = fromMap(value.data());
      if (comment != null) {
        comments.add(comment);
      }
    }
    return comments;
  }

  static Map<String, dynamic> toMap(Comment comment) {
    Map<String, dynamic> map = {
      "commentId": comment.commentId,
      "taskId": comment.taskId,
      "author": comment.author,
      "date": comment.date,
    };

    if (comment is TextComment) {
      map["text"] = comment.text;
    } else if (comment is ImageComment) {
      map["imageUrl"] = comment.imageUrl;
    }

    return map;
  }

  Comment({
    this.commentId = "",
    required this.taskId,
    required this.author,
    required DateTime? date,
  }) : date = date ?? DateTime.now();
}

/// Comment where the content is a [Image].
class ImageComment extends Comment {
  /// The image url of the comment.
  String imageUrl;

  /// Creates an instance of [ImageComment], a comment where the content
  /// is a [Image].
  ImageComment({
    super.commentId = "",
    super.date,
    required super.taskId,
    required super.author,
    required this.imageUrl,
  });

  /// Creates an instance of [ImageComment] from the given [Map].
  static ImageComment? fromMap(Map<String, dynamic>? data) {
    if (data == null) {
      return null;
    }
    final String commentId = data["commentId"];
    final String taskId = data["taskId"];
    final String author = data["author"];
    final DateTime date = (data["date"] as Timestamp).toDate();
    final String imageUrl = data["imageUrl"];

    return ImageComment(
      commentId: commentId,
      taskId: taskId,
      author: author,
      date: date,
      imageUrl: imageUrl,
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
    super.date,
    required super.taskId,
    required super.author,
    required this.text,
  });

  /// Creates an instance of [TextComment] from the given [Map].
  static TextComment? fromMap(Map<String, dynamic>? data) {
    if (data == null) {
      return null;
    }

    final String commentId = data["commentId"];
    final String taskId = data["taskId"];
    final String author = data["author"];
    final DateTime date = (data["date"] as Timestamp).toDate();
    final String text = data["text"];

    return TextComment(
      commentId: commentId,
      taskId: taskId,
      author: author,
      date: date,
      text: text,
    );
  }
}
