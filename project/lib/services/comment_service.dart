import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:project/models/message.dart';
import 'package:project/services/user_service.dart';

/// Business logic for comments.
abstract class CommentService {
  /// Saves a new- or updates an existing comment.
  Future<Message> saveComment(Message comment);

  /// Returns future of a comment with given comment id.
  Future<Message?> getComment(String commentId);

  /// Returns a future list with all comments.
  Stream<List<Message?>> getComments(String taskId);

  /// Deletes a comment by comment id.
  Future<void> deleteComment(String commentId);
}

/// Firebase implementation of commentservice.
class FirebaseCommentService extends CommentService {
  final commentCollection = FirebaseFirestore.instance.collection("comments");
  final userService = FirebaseUserService();

  @override
  Future<Message> saveComment(Message comment) async {
    if (comment.messageId == "") {
      comment.messageId =
          (await commentCollection.add(Message.toMap(comment))).id;
      await commentCollection
          .doc(comment.messageId)
          .set(Message.toMap(comment));
    } else {
      await commentCollection
          .doc(comment.messageId)
          .set(Message.toMap(comment));
    }
    return comment;
  }

  @override
  Future<Message?> getComment(String commentId) async {
    Message? comment;
    Map<String, dynamic>? commentMap =
        (await commentCollection.doc(commentId).get()).data();
    if (null != commentMap) {
      comment = Message.fromMap(commentMap);
    }
    return comment;
  }

  @override
  Stream<List<Message?>> getComments(String taskId) {
    return commentCollection
        .where("otherId", isEqualTo: taskId)
        .snapshots()
        .map((event) => event.docs)
        .map((event) {
      List<Message?> comments = Message.fromMaps(event);

      comments.sort((b, a) {
        if (a == null) {
          return -1;
        }
        if (b == null) {
          return 1;
        }
        return (Message.toMap(a)["date"]).compareTo(
          Message.toMap(b)["date"],
        );
      });

      return comments;
    });
  }

  @override
  Future<void> deleteComment(String commentId) async {
    commentCollection.doc(commentId).delete();
  }
}
