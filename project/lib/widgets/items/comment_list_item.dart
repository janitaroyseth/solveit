import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:project/models/message.dart';
import 'package:project/providers/auth_provider.dart';
import 'package:project/providers/comment_image_provider.dart';
import 'package:project/providers/comment_provider.dart';
import 'package:project/providers/task_provider.dart';
import 'package:project/providers/user_provider.dart';
import 'package:project/styles/theme.dart';
import 'package:project/utilities/date_formatting.dart';

import '../../models/user.dart';

/// Converts a Comment object to a list item used in a comment list.
class CommentListItem extends StatelessWidget {
  /// The [Comment] to be present as a list item.
  final Message comment;

  /// Creates an instance of [CommentListItem].
  const CommentListItem({
    super.key,
    required this.comment,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, child) => StreamBuilder<User?>(
          stream: ref.watch(userProvider).getUser(comment.author),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              User author = snapshot.data!;

              return GestureDetector(
                onLongPress: () => _deleteComment(ref, context),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: <Widget>[
                      _authorImage(author),
                      const SizedBox(width: 8.0),
                      Expanded(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            _authorName(author, context),
                            _commentContent(),
                            _formattedTimeSincePosted(context),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }
            return const Center(child: CircularProgressIndicator());
          }),
    );
  }

  /// If the current user is the author of the comment then a dialog will open
  /// letting the user delete their comment.
  void _deleteComment(WidgetRef ref, BuildContext context) {
    String currentUserId = ref.watch(authProvider).currentUser!.uid;
    if (comment.author == currentUserId) {
      showDialog(
          context: context, builder: (context) => _deleteDialog(context, ref));
    }
  }

  /// Returns a [AlertDialog] giving the user the option to delete their comment.
  AlertDialog _deleteDialog(BuildContext context, WidgetRef ref) {
    return AlertDialog(
      title: const Text("deleting comment"),
      content: const Text("Are you sure you want to delete your comment"),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text(
            "no",
            style: TextStyle(
              color: Themes.textColor(ref),
            ),
          ),
        ),
        TextButton(
          onPressed: () {
            if (comment is ImageMessage) {
              ref
                  .read(commentImageProvider)
                  .deleteCommentImage(
                      comment.otherId, (comment as ImageMessage).imageUrl)
                  .then((value) => ref.read(commentProvider).deleteComment(
                      ref.read(editTaskProvider)!.projectId,
                      ref.read(editTaskProvider)!.taskId,
                      comment.messageId))
                  .then((value) => Navigator.of(context).pop());
            } else {
              ref
                  .read(commentProvider)
                  .deleteComment(ref.read(editTaskProvider)!.projectId,
                      ref.read(editTaskProvider)!.taskId, comment.messageId)
                  .then((value) => Navigator.of(context).pop());
            }
          },
          child: Text(
            "yes",
            style: TextStyle(
              color: Colors.red.shade900,
            ),
          ),
        ),
      ],
    );
  }

  /// Returns a [Column] containing the comment content.
  Column _commentContent() {
    return Column(
      children: [
        const SizedBox(height: 4.0),
        if (comment is TextMessage) _TextComment(comment: comment),
        if (comment is ImageMessage) _ImageComment(comment: comment),
        const SizedBox(height: 4.0),
      ],
    );
  }

  /// Returns a [Text] widget showing the formatted time since posted.
  Text _formattedTimeSincePosted(BuildContext context) {
    return Text(
      DateFormatting.timeSince(comment.date),
      style: Theme.of(context).textTheme.caption,
    );
  }

  /// Returns a [Text] widget containing the auhors name.
  Text _authorName(User author, BuildContext context) {
    return Text(
      author.username,
      textAlign: TextAlign.start,
      style: Theme.of(context).textTheme.caption,
    );
  }

  /// Returns a [CircleAvatar] of the authors profile picture.
  CircleAvatar _authorImage(User author) {
    return CircleAvatar(
      backgroundImage: NetworkImage(author.imageUrl!),
      radius: 20,
    );
  }
}

/// Presents a text comment in a [Widget].
class _TextComment extends StatelessWidget {
  /// Creates an instance of [_TextComment] of type [Widget].
  const _TextComment({required this.comment});

  /// The [Comment] model to display in a [_TextComment] [Widget].
  final Message comment;

  @override
  Widget build(BuildContext context) {
    return Text(
      (comment as TextMessage).text,
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
  final Message comment;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(15.0),
      child: Image.network(
        (comment as ImageMessage).imageUrl,
        width: MediaQuery.of(context).size.width / 2,
        fit: BoxFit.contain,
      ),
    );
  }
}
