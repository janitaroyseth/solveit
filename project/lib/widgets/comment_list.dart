import 'package:flutter/material.dart';
import 'package:project/models/comment.dart';
import 'package:project/widgets/comment_list_item.dart';

/// Presents a list of comments in a [ListView].
class CommentList extends StatelessWidget {
  /// Creates an instance of [CommentList].
  const CommentList({
    super.key,
    required this.comments,
    required this.controller,
  });

  /// The `comments` to display in the [CommentList].
  final List<Comment> comments;

  /// [ScrollController] for the [ListView].
  final ScrollController controller;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      controller: controller,
      itemCount: comments.length,
      itemBuilder: (context, index) => CommentListItem(
        comment: comments[index],
      ),
    );
  }
}
