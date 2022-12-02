import 'package:flutter/material.dart';
import 'package:project/models/message.dart';
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
  final List<Message?> comments;

  /// [ScrollController] for the [ListView].
  final ScrollController controller;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      controller: controller,
      reverse: true,
      itemCount: comments.length,
      itemBuilder: (context, index) => CommentListItem(
        comment: comments[index]!,
      ),
    );
  }
}
