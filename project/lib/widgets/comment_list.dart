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
    return Expanded(
      child: ListView.builder(
        itemBuilder: ((context, index) => CommentListItem(
              comment: widget.comments[index],
            )),
        itemCount: widget.comments.length,
      ),
    );
  }
}
