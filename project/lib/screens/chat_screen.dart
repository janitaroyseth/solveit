import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:project/models/message.dart';
import 'package:project/models/group.dart';
import 'package:project/models/user.dart';
import 'package:project/providers/auth_provider.dart';
import 'package:project/providers/chat_image_provider.dart';
import 'package:project/providers/chat_provder.dart';
import 'package:project/providers/user_provider.dart';
import 'package:project/widgets/buttons/app_bar_button.dart';
import 'package:project/widgets/list/chat_list.dart';
import 'package:project/widgets/general/loading_spinner.dart';
import 'package:project/widgets/inputs/message_input_field.dart';

/// Screen/Scaffold displaying a chat.
class ChatScreen extends ConsumerWidget {
  /// Named route for this screen.
  static const routeName = "/chat";

  /// Creates an instance of [ChatScreen].
  const ChatScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    /// Focusnode for the message field.
    FocusNode focusNode = FocusNode();

    /// Url of the user participating in this chat.
    String currentUser = ref.watch(authProvider).currentUser!.uid;

    /// The group id for the chats that are being displayed.
    String groupId = ModalRoute.of(context)!.settings.arguments as String;

    return FutureBuilder<Group?>(
      future: ref.watch(chatProvider).getGroup(groupId).first,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          Group group = snapshot.data!;

          return Scaffold(
            appBar: AppBar(
              leading: _backButton(context, ref, groupId),
              titleSpacing: -4,
              title: FutureBuilder<User?>(
                future: ref
                    .watch(userProvider)
                    .getUser(getUserID(group.members, currentUser))
                    .first,
                builder: (context, snpsht) {
                  if (snpsht.hasData) {
                    User user = snpsht.data!;

                    return _appBarTitle(user.imageUrl!, user.username);
                  }
                  return const LoadingSpinner();
                },
              ),
            ),
            body: GestureDetector(
              onTap: () => focusNode.unfocus(),
              child: Column(
                children: [
                  ChatList(groupId: groupId),
                  _messageField(ref, groupId, group, focusNode),
                  _bottomPadding(),
                ],
              ),
            ),
          );
        }
        if (snapshot.hasError) if (kDebugMode) print(snapshot.error);
        return const LoadingSpinner();
      },
    );
  }

  /// The app bar title displaying the image and name of the other user
  /// participating in this chat.
  Row _appBarTitle(String imageUrl, String groupName) {
    return Row(
      children: [
        CircleAvatar(
          radius: 20,
          backgroundImage: NetworkImage(imageUrl),
        ),
        const SizedBox(width: 8.0),
        Text(
          groupName,
          style: const TextStyle(fontSize: 16),
        ),
      ],
    );
  }

  /// Bottom padding depending on the user's platform.
  SizedBox _bottomPadding() {
    return SizedBox(
      height: Platform.isIOS ? 30.0 : 20.0,
    );
  }

  /// [MessageInputField] customized for chat screen.
  MessageInputField _messageField(
      WidgetRef ref, String groupId, Group? group, FocusNode focusNode) {
    return MessageInputField(
      gif: true,
      gallery: true,
      camera: true,
      handler: (content, MessageType type) async {
        String currentUserId = ref.watch(authProvider).currentUser!.uid;
        switch (type) {
          case MessageType.text:
            ref
                .read(chatProvider)
                .addChat(
                  groupId,
                  TextMessage(
                    otherId: groupId,
                    date: DateTime.now(),
                    text: content,
                    author: currentUserId,
                  ),
                )
                .then((value) {
              group!.lastUpdated = DateTime.now();
              group.recentMessage = (value as TextMessage).text;
              return ref.read(chatProvider).saveGroup(group);
            });

            break;
          case MessageType.image:
            ref
                .read(chatImageProvider)
                .addChatImage(groupId, content)
                .then((value) => ref.read(chatProvider).addChat(
                      groupId,
                      ImageMessage(
                        otherId: groupId,
                        author: currentUserId,
                        imageUrl: value!,
                      ),
                    ))
                .then((value) {
              group!.lastUpdated = DateTime.now();
              group.recentMessage = "image";
              return ref.read(chatProvider).saveGroup(group);
            });
            break;
          case MessageType.gif:
            ref
                .read(chatProvider)
                .addChat(
                  groupId,
                  ImageMessage(
                    otherId: groupId,
                    author: currentUserId,
                    imageUrl: content,
                  ),
                )
                .then((value) {
              group!.lastUpdated = DateTime.now();
              group.recentMessage = "gif from Tenor";
              return ref.read(chatProvider).saveGroup(group);
            });
            ;
            break;
          default:
        }
      },
      focusNode: focusNode,
    );
  }

  /// Goes back to previous screen.
  AppBarButton _backButton(
      BuildContext context, WidgetRef ref, String groupId) {
    return AppBarButton(
      handler: () {
        ref.watch(chatProvider).getChats(groupId).first.then((value) {
          if (value.isEmpty) {
            ref.read(chatProvider).deleteGroup(groupId);
          }
        }).whenComplete(() => Navigator.of(context).pop());
      },
      tooltip: "Go back",
      icon: PhosphorIcons.caretLeftLight,
    );
  }

  /// Gets name and image of the user who is participating in this chat and sets
  /// the respective information to the variables [groupName] and [imageUrl].
  String getUserID(List<String> userIds, String currentUser) {
    for (var id in userIds) {
      if (id != currentUser) {
        return id;
      }
    }
    return "";
  }
}
