import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:project/models/message.dart';
import 'package:project/providers/auth_provider.dart';
import 'package:project/providers/chat_image_provider.dart';
import 'package:project/providers/chat_provder.dart';
import 'package:project/styles/theme.dart';

/// Converts a [Message] object to a list item used in a chat list.
class ChatListItem extends StatelessWidget {
  /// The [Chat] to be present as a list item.
  final Message chat;

  /// Creates an instance of [ChatListItem].
  const ChatListItem({
    super.key,
    required this.chat,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, child) => GestureDetector(
        onLongPress: () => _deleteChat(ref, context),
        child: _chatContent(),
      ),
    );
  }

  /// If the current user is the author of the chat then a dialog will open
  /// letting the user delete their chat.
  void _deleteChat(WidgetRef ref, BuildContext context) {
    String currentUserId = ref.watch(authProvider).currentUser!.uid;
    if (chat.author == currentUserId) {
      showDialog(
          context: context, builder: (context) => _deleteDialog(context, ref));
    }
  }

  /// Returns a [AlertDialog] giving the user the option to delete their chat.
  AlertDialog _deleteDialog(BuildContext context, WidgetRef ref) {
    return AlertDialog(
      title: const Text("deleting chat"),
      content: const Text("Are you sure you want to delete your chat"),
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
            if (chat is ImageMessage) {
              ref
                  .read(chatImageProvider)
                  .deleteChatImage(
                      chat.otherId, (chat as ImageMessage).imageUrl)
                  .then((value) => ref
                      .read(chatProvider)
                      .deleteChat(chat.otherId, chat.messageId))
                  .then((value) => Navigator.of(context).pop());
            } else {
              ref
                  .read(chatProvider)
                  .deleteChat(chat.otherId, chat.messageId)
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

  /// Returns a [Column] containing the chat content.
  Column _chatContent() {
    return Column(
      children: [
        if (chat is TextMessage) _TextChat(chat: chat),
        if (chat is ImageMessage) _ImageChat(chat: chat),
      ],
    );
  }
}

/// Presents a image chat.
class _ImageChat extends ConsumerWidget {
  /// Creates an instance of [_ImageChat] of type [Widget].
  const _ImageChat({required this.chat});

  /// The [Chat] model to display in a [_ImageChat] [Widget].
  final Message chat;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    String currentUser = ref.watch(authProvider).currentUser!.uid;

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: _getChatItemAlignment(currentUser),
        children: [
          ClipRRect(
            borderRadius: _getCharItemBorderRadius(currentUser),
            child: Image.network(
              (chat as ImageMessage).imageUrl,
              width: MediaQuery.of(context).size.width / 2.2,
              fit: BoxFit.contain,
            ),
          ),
        ],
      ),
    );
  }

  /// Returns the correct alignment depending if the chat author is the
  /// current user.
  MainAxisAlignment _getChatItemAlignment(String currentUser) {
    return chat.author == currentUser
        ? MainAxisAlignment.end
        : MainAxisAlignment.start;
  }

  /// Returns the correct shape of border radius depending if the chat author
  /// is the current user.
  BorderRadius _getCharItemBorderRadius(String currentUser) {
    return chat.author == currentUser
        ? const BorderRadius.only(
            topLeft: Radius.circular(20.0),
            topRight: Radius.circular(20.0),
            bottomLeft: Radius.circular(20.0),
          )
        : const BorderRadius.only(
            topLeft: Radius.circular(20.0),
            topRight: Radius.circular(20.0),
            bottomRight: Radius.circular(20.0),
          );
  }
}

/// Presents a text chat.
class _TextChat extends ConsumerWidget {
  /// Creates an instance of [_TextChat], using the contents of the given
  /// chat.
  const _TextChat({required this.chat});

  /// [Message] chat to display contents for.
  final Message chat;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    String currentUser = ref.watch(authProvider).currentUser!.uid;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 4.0),
      child: Row(
        mainAxisAlignment: _getChatItemAlignment(currentUser),
        children: <Widget>[
          Container(
            constraints: BoxConstraints(
              maxWidth: MediaQuery.of(context).size.width / 1.5,
            ),
            decoration: _getCharItemBoxDecoration(currentUser),
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 16.0,
                vertical: 12.0,
              ),
              child: Text(
                (chat as TextMessage).text.trim(),
                style: TextStyle(
                  height: 1.4,
                  color: chat.author == currentUser
                      ? Colors.white
                      : Themes.textColor(ref),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Returns the correct alignment depending if the chat author is the
  /// current user.
  MainAxisAlignment _getChatItemAlignment(String currentUser) {
    return chat.author == currentUser
        ? MainAxisAlignment.end
        : MainAxisAlignment.start;
  }

  /// Returns the correct box decoration depending if the chat author
  /// is the current user.
  BoxDecoration _getCharItemBoxDecoration(String currentUser) {
    return chat.author == currentUser
        ? const BoxDecoration(
            color: Themes.primaryColor,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20.0),
              topRight: Radius.circular(20.0),
              bottomLeft: Radius.circular(20.0),
            ),
          )
        : BoxDecoration(
            color: Colors.grey.shade600.withOpacity(0.2),
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(20.0),
              topRight: Radius.circular(20.0),
              bottomRight: Radius.circular(20.0),
            ),
          );
  }
}
