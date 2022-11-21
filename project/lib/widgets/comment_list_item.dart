import 'package:flutter/material.dart';
import 'package:jiffy/jiffy.dart';
import 'package:project/models/comment.dart' as model;

/// Converts a Comment object to a list item used in a comment list.
class CommentListItem extends StatelessWidget {
  /// The [Comment] to be present as a list item.
  final model.Comment comment;

  /// Creates an instance of [CommentListItem].
  const CommentListItem({
    super.key,
    required this.comment,
  });

  /// Returns a [String] of the authors first name and last name.
  String _authorName() {
    return comment.author.username;
  }

  /// Returns a [Widget] of the authors profile picture.
  Widget _authorImage() {
    return CircleAvatar(
      backgroundImage: AssetImage(comment.author.imageUrl!),
      radius: 20,
    );
  }

  /// Returns a formatted [String] of a [date], displaying how
  /// long ago the comment was posted.
  String _formatTimeSincePosted(String date) {
    return Jiffy(date).fromNow();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          _authorImage(),
          const SizedBox(width: 8.0),
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  _authorName(),
                  textAlign: TextAlign.start,
                  style: Theme.of(context).textTheme.caption,
                ),
                const SizedBox(height: 4.0),
                if (comment is model.TextComment)
                  _TextComment(comment: comment),
                if (comment is model.ImageComment)
                  _ImageComment(comment: comment),
                if (comment is model.GifComment)
                  _GiphyComment(comment: comment),
                const SizedBox(height: 4.0),
                Text(
                  _formatTimeSincePosted(comment.date),
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

/// Presents a text comment in a [Widget].
class _TextComment extends StatelessWidget {
  /// Creates an instance of [_TextComment] of type [Widget].
  const _TextComment({required this.comment});

  /// The [Comment] model to display in a [_TextComment] [Widget].
  final model.Comment comment;

  @override
  Widget build(BuildContext context) {
    return Text(
      (comment as model.TextComment).text,
      overflow: TextOverflow.clip,
      textAlign: TextAlign.start,
      style: const TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w400,
      ),
    );
  }
}

/// Presents a image comment in a [Widget].
class _ImageComment extends StatelessWidget {
  /// Creates an instance of [_ImageComment] of type [Widget].
  const _ImageComment({required this.comment});

  /// The [Comment] model to display in a [_ImageComment] [Widget].
  final model.Comment comment;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(15.0),
      child: Image.file(
        (comment as model.ImageComment).image,
        width: MediaQuery.of(context).size.width / 2,
        fit: BoxFit.contain,
      ),
    );
  }
}

/// Presents a giphy comment in a [Widget].
class _GiphyComment extends StatelessWidget {
  /// Creates an instance of [_GiphyComment] of type [Widget].
  const _GiphyComment({required this.comment});

  /// The [Comment] model to display in a [_GiphyComment] [Widget].
  final model.Comment comment;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(15.0),
      child: Image.network(
        (comment as model.GifComment).url,
        width: MediaQuery.of(context).size.width / 2,
        fit: BoxFit.contain,
      ),
    );
  }
}
