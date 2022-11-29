import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:project/models/comment.dart';
import 'package:project/services/user_service.dart';

/// Business logic for comments.
abstract class CommentService {
  /// Saves a new- or updates an existing comment.
  Future<Comment> saveComment(Comment comment);

  /// Returns future of a comment with given comment id.
  Future<Comment?> getComment(String commentId);

  /// Returns a future list with all comments.
  Stream<List<Comment>> getComments(String taskId);

  /// Deletes a comment by comment id.
  Future<void> deleteComment(String commentId);
}

/// Firebase implementation of commentservice.
class FirebaseCommentService extends CommentService {
  final commentCollection = FirebaseFirestore.instance.collection("comments");
  final userService = FirebaseUserService();

  @override
  Future<Comment> saveComment(Comment comment) async {
    if (comment.commentId == "") {
      comment.commentId =
          (await commentCollection.add(Comment.toMap(comment))).id;
      await commentCollection
          .doc(comment.commentId)
          .set(Comment.toMap(comment));
    } else {
      await commentCollection
          .doc(comment.commentId)
          .set(Comment.toMap(comment));
    }
    return comment;
  }

  @override
  Future<Comment?> getComment(String commentId) async {
    Comment? comment;
    Map<String, dynamic>? commentMap =
        (await commentCollection.doc(commentId).get()).data();
    if (null != commentMap) {
      comment = Comment.fromMap(commentMap);
    }
    return comment;
  }

  @override
  Stream<List<Comment>> getComments(String taskId) {
    return commentCollection
        .where("taskId", isEqualTo: taskId)
        .snapshots()
        .map((event) => event.docs)
        .map((event) {
      List<Comment> comments = Comment.fromMaps(event);

      comments.sort((b, a) {
        if (a == null) {
          return -1;
        }
        if (b == null) {
          return 1;
        }
        return (Comment.toMap(a)["date"]).compareTo(
          Comment.toMap(b)["date"],
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
