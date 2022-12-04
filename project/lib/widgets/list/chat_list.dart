import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:project/models/message.dart';
import 'package:project/providers/chat_provder.dart';
import 'package:project/widgets/items/chat_list_item.dart';
import 'package:project/widgets/general/loading_spinner.dart';

/// List view of chats.
class ChatList extends ConsumerWidget {
  /// Creates an instance of [ChatList] displaying the chats of the given
  /// group id.
  const ChatList({
    super.key,
    required this.groupId,
  });

  /// The group id to display chats for.
  final String groupId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Expanded(
      child: StreamBuilder<List<Message?>>(
        stream: ref.watch(chatProvider).getChats(groupId),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List<Message?> chats = snapshot.data!;

            if (chats.isEmpty) {
              return _noChatsText(context);
            }

            return _chatList(chats);
          }

          if (snapshot.hasError) if (kDebugMode) print(snapshot.error);

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const LoadingSpinner();
          }

          return _noChatsText(context);
        },
      ),
    );
  }

  /// Returns a text prompting user to start chatting.
  Padding _noChatsText(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(30.0),
      child: Center(
        child: Text(
          "Say hi 👋",
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.displayMedium,
        ),
      ),
    );
  }

  /// Returns a [ListView] of the given chats.
  ListView _chatList(List<Message?> chats) {
    return ListView.builder(
      reverse: true,
      shrinkWrap: true,
      itemCount: chats.length,
      itemBuilder: (context, index) => ChatListItem(
        chat: chats[index]!,
      ),
    );
  }
}
