import 'package:flutter/material.dart';
import 'package:jiffy/jiffy.dart';

import '../models/comment.dart';

/// Converts a Comment object to a list item used in a comment list.
class CommentListItem extends StatelessWidget {
  /// The [comment] to be converted.
  final Comment comment;

  const CommentListItem({
    super.key,
    required this.comment,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          CircleAvatar(
            backgroundImage: AssetImage(comment.author.imageUrl),
          ),
          const SizedBox(width: 8.0),
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  "${comment.author.firstname} ${comment.author.lastname}",
                  textAlign: TextAlign.start,
                  style: Theme.of(context).textTheme.caption,
                ),
                const SizedBox(height: 4.0),
                Text(
                  comment.text,
                  overflow: TextOverflow.clip,
                  textAlign: TextAlign.start,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                const SizedBox(height: 4.0),
                Text(
                  Jiffy(comment.date).fromNow(),
                  style: Theme.of(context).textTheme.caption,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
