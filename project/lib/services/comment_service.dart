import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:project/models/message.dart';
import 'package:project/services/user_service.dart';

/// Business logic for comments.
abstract class CommentService {
  /// Saves a new- or updates an existing comment.
  Future<Message> saveComment(String projectId, String taskId, Message comment);

  /// Returns future of a comment with given comment id.
  Future<Message?> getComment(
      String projectId, String taskId, String commentId);

  /// Returns a future list with all comments.
  Stream<List<Message?>> getComments(String projectId, String taskId);

  /// Deletes a comment by comment id.
  Future<void> deleteComment(String projectId, String taskId, String commentId);
}

/// Firebase implementation of commentservice.
class FirebaseCommentService extends CommentService {
  CollectionReference<Map<String, dynamic>> commentCollection(
          String projectId, String taskId) =>
      FirebaseFirestore.instance
          .collection("projects")
          .doc(projectId)
          .collection("tasks")
          .doc(taskId)
          .collection("comments");
  final userService = FirebaseUserService();

  @override
  Future<Message> saveComment(
      String projectId, String taskId, Message comment) async {
    if (comment.messageId == "") {
      comment.messageId = (await commentCollection(projectId, taskId)
              .add(Message.toMap(comment)))
          .id;
    }
    await commentCollection(projectId, taskId)
        .doc(comment.messageId)
        .set(Message.toMap(comment));
    return comment;
  }

  @override
  Future<Message?> getComment(
      String projectId, String taskId, String commentId) async {
    Message? comment;
    Map<String, dynamic>? commentMap =
        (await commentCollection(projectId, taskId).doc(commentId).get())
            .data();
    if (null != commentMap) {
      comment = Message.fromMap(commentMap);
    }
    return comment;
  }

  @override
  Stream<List<Message?>> getComments(String projectId, String taskId) {
    return commentCollection(projectId, taskId)
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
  Future<void> deleteComment(
      String projectId, String taskId, String commentId) async {
    commentCollection(projectId, taskId).doc(commentId).delete();
  }
}
