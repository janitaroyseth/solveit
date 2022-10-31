import 'package:flutter/material.dart';

import '../models/comment.dart';
import 'comment_list_item.dart';

/// The list of comments in the task.
class CommentList extends StatefulWidget {
  final List<Comment> comments;
  const CommentList({Key? key, required this.comments}) : super(key: key);

  @override
  State<CommentList> createState() => _CommentListState();
}

class _CommentListState extends State<CommentList> {
  @override
  Widget build(BuildContext context) {
    List<Widget> commentWidgets = [];
    for (Comment comment in widget.comments) {
      commentWidgets.add(CommentListItem(comment: comment));
    }
    return Column(
      children: commentWidgets,
    );
  }
}
