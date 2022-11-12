import 'package:flutter/material.dart';
import 'package:project/models/comment.dart';
import 'package:project/widgets/comment_list_item.dart';

/// The list of comments in the task.
class CommentList extends StatelessWidget {
  final List<Comment> comments;
  const CommentList({Key? key, required this.comments}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: comments.length,
      itemBuilder: (context, index) => CommentListItem(
        comment: comments[index],
      ),
    );
  }
}
