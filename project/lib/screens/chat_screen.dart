import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:project/models/chat.dart';
import 'package:project/models/group.dart';
import 'package:project/providers/auth_provider.dart';
import 'package:project/providers/chat_provder.dart';
import 'package:project/providers/user_provider.dart';
import 'package:project/styles/theme.dart';
import 'package:project/widgets/appbar_button.dart';
import 'package:project/widgets/loading_spinner.dart';
import 'package:project/widgets/message_input_field.dart';

class ChatScreen extends ConsumerStatefulWidget {
  static const routeName = "/chat";

  const ChatScreen({super.key});

  @override
  ConsumerState<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends ConsumerState<ChatScreen> {
  String groupName = "";
  String imageUrl =
      "https://firebasestorage.googleapis.com/v0/b/solveit-1337.appspot.com/o/user_images%2Fprofile_placeholder.png?alt=media&token=d1167324-93a9-4515-8341-21d27abd3d24";

  @override
  Widget build(BuildContext context) {
    String currentUser = ref.watch(authProvider).currentUser!.uid;
    String groupId = ModalRoute.of(context)!.settings.arguments as String;
    Group? group;

    return FutureBuilder<Group?>(
      future: ref.watch(chatProvider).getGroup(groupId).first,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          group = snapshot.data;
          _initializeChatInfo(snapshot.data!.members, currentUser, ref);
          return Scaffold(
            appBar: AppBar(
              leading: _backButton(context),
              titleSpacing: -4,
              title: Row(
                children: [
                  CircleAvatar(
                    radius: 20,
                    backgroundImage: NetworkImage(imageUrl),
                  ),
                  const SizedBox(width: 8.0),
                  Text(
                    groupName,
                    style: TextStyle(fontSize: 16),
                  ),
                ],
              ),
            ),
            body: Column(
              children: [
                Expanded(
                  child: StreamBuilder<List<Chat?>>(
                      stream: ref.watch(chatProvider).getChats(groupId),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          List<Chat?> chats = snapshot.data!;

                          return ListView.builder(
                            reverse: true,
                            shrinkWrap: true,
                            itemCount: snapshot.data!.length,
                            itemBuilder: (context, index) => Padding(
                              padding: const EdgeInsets.all(6.0),
                              child: Row(
                                mainAxisAlignment:
                                    chats[index]!.author == currentUser
                                        ? MainAxisAlignment.end
                                        : MainAxisAlignment.start,
                                children: [
                                  Container(
                                    constraints: BoxConstraints(
                                      maxWidth:
                                          MediaQuery.of(context).size.width /
                                              1.5,
                                    ),
                                    decoration: chats[index]!.author ==
                                            currentUser
                                        ? const BoxDecoration(
                                            color: Themes.primaryColor,
                                            borderRadius: BorderRadius.only(
                                              topLeft: Radius.circular(20.0),
                                              topRight: Radius.circular(20.0),
                                              bottomLeft: Radius.circular(20.0),
                                            ),
                                          )
                                        : BoxDecoration(
                                            color: Colors.grey.shade600
                                                .withOpacity(0.2),
                                            borderRadius:
                                                const BorderRadius.only(
                                              topLeft: Radius.circular(20.0),
                                              topRight: Radius.circular(20.0),
                                              bottomRight:
                                                  Radius.circular(20.0),
                                            ),
                                          ),
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 16.0,
                                        vertical: 12.0,
                                      ),
                                      child: Text(
                                        snapshot.data![index]!.content,
                                        style: TextStyle(
                                          height: 1.4,
                                          color: chats[index]!.author ==
                                                  currentUser
                                              ? Colors.white
                                              : Themes.textColor(ref),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        }
                        if (snapshot.hasError) print(snapshot.error);
                        return Padding(
                          padding: const EdgeInsets.all(30.0),
                          child: Center(
                              child: Text(
                            "Say hi to $groupName 👋",
                            textAlign: TextAlign.center,
                            style: Theme.of(context).textTheme.displayMedium,
                          )),
                        );
                      }),
                ),
                MessageInputField(
                    gif: true,
                    gallery: true,
                    camera: true,
                    handler: (content, MessageType type) async {
                      String currentUserId =
                          ref.watch(authProvider).currentUser!.uid;
                      switch (type) {
                        case MessageType.text:
                          ref
                              .read(chatProvider)
                              .addChat(
                                groupId,
                                Chat(
                                  createdAt: DateTime.now(),
                                  content: content,
                                  author: currentUserId,
                                ),
                              )
                              .then((value) {
                            group!.lastUpdated = DateTime.now();
                            group!.recentMessage = value.content;
                            return ref.read(chatProvider).saveGroup(group!);
                          });

                          break;
                        // case MessageType.image:
                        //   ref
                        //       .read(commentImageProvider)
                        //       .addCommentImage(widget.task.taskId, content)
                        //       .then((value) => ref.read(commentProvider).saveComment(
                        //             ImageComment(
                        //               taskId: widget.task.taskId,
                        //               author: currentUserId,
                        //               imageUrl: value!,
                        //             ),
                        //           ))
                        //       .then((value) => scrollToBottom(600));
                        //   break;
                        // case MessageType.gif:
                        //   ref
                        //       .read(commentProvider)
                        //       .saveComment(
                        //         ImageComment(
                        //           taskId: widget.task.taskId,
                        //           author: currentUserId,
                        //           imageUrl: content,
                        //         ),
                        //       )
                        //       .then((value) => scrollToBottom(600));
                        //   break;
                        default:
                      }
                    },
                    focusNode: FocusNode()),
                SizedBox(
                  height: Platform.isIOS ? 30.0 : 20.0,
                ),
              ],
            ),
          );
        }
        if (snapshot.hasError) print(snapshot.error);
        return const LoadingSpinner();
      },
    );
  }

  /// Goes back to previous screen.
  AppBarButton _backButton(BuildContext context) {
    return AppBarButton(
      handler: () => Navigator.of(context).pop(),
      tooltip: "Go back",
      icon: PhosphorIcons.caretLeftLight,
      color: Colors.white,
    );
  }

  void _initializeChatInfo(
    List<String> userIds,
    String currentUser,
    WidgetRef ref,
  ) async {
    for (var id in userIds) {
      if (id != currentUser) {
        groupName =
            "${(await ref.watch(userProvider).getUser(id).first)!.username} ";
        imageUrl = (await ref.watch(userProvider).getUser(id).first)!.imageUrl!;
      }
    }
    setState(() {});
  }
}
