import 'package:flutter/material.dart';

import '../entities/comment.dart';

/// Converts a Comment object to a list item used in a comment list.
class CommentListItem extends StatelessWidget {

  /// The [comment] to be converted.
  final Comment comment;

  const CommentListItem({super.key, required this.comment});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 8.0,
        vertical: 10.0,
      ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12.0),
          boxShadow: const [
            BoxShadow(
                blurRadius: 2.0,
                color: Colors.black38,
                blurStyle: BlurStyle.outer,
                offset: Offset(0.0, 0.0),
                spreadRadius: 0.5),
          ],
        ),
        child: InkWell(
          onTap: () {},
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: <Widget>[
                Container(
                  alignment: Alignment.topLeft,
                  child: Row(
                    children: <Widget>[
                      Text(
                        comment.text,
                        textAlign: TextAlign.start,
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.only(top: 4.0),
                  alignment: Alignment.topLeft,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                      comment.author.toLowerCase(),
                      textAlign: TextAlign.start,
                      style: Theme.of(context).textTheme.caption,
                      ),
                      Text(
                        comment.date,
                        style: Theme.of(context).textTheme.caption,
                      ),
                    ]
                  ),
                ),
                const SizedBox(
                  height: 10.0,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}