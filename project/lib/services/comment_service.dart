import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:project/models/comment.dart';
import 'package:project/services/user_service.dart';

abstract class CommentService {
  /// Saves a new- or updates an existing comment.
  Future<Comment> saveComment(Comment comment);

  /// Returns future of a comment with given comment id.
  Future<Comment?> getComment(String commentId);

  /// Returns a future list with all comments.
  Future<List<Comment>> getComments();

  /// Deletes a comment by comment id.
  void deleteComment(String commentId);
}

class FirebaseCommentService extends CommentService {
  final commentCollection = FirebaseFirestore.instance.collection("comments");
  final userService = FirebaseUserService();

  @override
  Future<Comment> saveComment(Comment comment) async {
    if (comment.commentId == "") {
      comment.commentId =
          (await commentCollection.add(Comment.toMap(comment))).id;
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
      if (null != comment) {
        comment.author = await userService.getUser(commentMap["author"]);
      }
    }
    return comment;
  }

  @override
  Future<List<Comment>> getComments() async {
    List<Comment> comments = [];
    await commentCollection.get().then((value) async {
      for (var element in value.docs) {
        Comment? comment = Comment.fromMap(element.data());
        if (comment != null) {
          comment.author = await userService.getUser(element.data()["author"]);
          comments.add(comment);
        }
      }
    });
    return comments;
  }

  @override
  void deleteComment(String commentId) {
    commentCollection.doc(commentId).delete();
  }
}
