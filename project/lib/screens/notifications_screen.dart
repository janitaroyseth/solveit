import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jiffy/jiffy.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:project/models/group.dart';
import 'package:project/models/user.dart';
import 'package:project/providers/auth_provider.dart';
import 'package:project/providers/chat_provder.dart';
import 'package:project/providers/user_provider.dart';
import 'package:project/screens/chat_screen.dart';
import 'package:project/screens/collaborators_screen.dart';
import 'package:project/screens/profile_screen.dart';
import 'package:project/styles/theme.dart';
import 'package:project/widgets/appbar_button.dart';
import 'package:project/widgets/loading_spinner.dart';

class NotificationsScreen extends ConsumerWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    String currentUser = ref.watch(authProvider).currentUser!.uid;
    return Scaffold(
      appBar: AppBar(
        title: _appBarTitle(),
        actions: [
          AppBarButton(
            handler: () {
              List<String> members = [];
              Navigator.of(context)
                  .pushNamed(CollaboratorsScreen.routeName, arguments: [
                members,
                CollaboratorsSearchType.collaborators,
                "",
              ]).then((value) {
                if (members.isNotEmpty) {
                  // Does group exist
                  ref.watch(chatProvider).getGroups().first.then((groups) {
                    for (Group group in groups) {
                      for (String member in members) {
                        print(
                            member + group.members.contains(member).toString());
                        if (group.members.contains(member)) {
                          Navigator.of(context).pushNamed(
                            ChatScreen.routeName,
                            arguments: group.groupId,
                          );
                          return;
                        }
                      }
                    }
                    members.add(ref.watch(authProvider).currentUser!.uid);
                    ref
                        .read(chatProvider)
                        .saveGroup(Group(members: members))
                        .then(
                          (value) => Navigator.of(context).pushNamed(
                            ChatScreen.routeName,
                            arguments: value.groupId,
                          ),
                        );
                    return;
                  });
                }
              });
            },
            tooltip: "write new message",
            icon: PhosphorIcons.pencilSimpleLineLight,
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Text(
                "notifications",
                style: Theme.of(context).textTheme.labelLarge,
              ),
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: 2,
                itemBuilder: (context, index) => Padding(
                  padding: const EdgeInsets.only(top: 16.0),
                  child: Text(
                    "notification message",
                    style: Theme.of(context).textTheme.labelMedium,
                  ),
                ),
              ),
              const SizedBox(height: 32.0),
              Text(
                "messages",
                style: Theme.of(context).textTheme.labelLarge,
              ),
              Flexible(
                fit: FlexFit.loose,
                child: StreamBuilder<List<Group?>>(
                    stream: ref.watch(chatProvider).getGroups(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        List<Group?> groups = snapshot.data!;
                        return ListView.builder(
                          shrinkWrap: true,
                          itemCount: groups.length,
                          itemBuilder: (context, index) => _messageListItem(
                              ref, groups[index]!, currentUser),
                        );
                      }
                      return const LoadingSpinner();
                    }),
              )
            ],
          ),
        ),
      ),
    );
  }

  StreamBuilder<User?> _messageListItem(
      WidgetRef ref, Group group, String currentUser) {
    return StreamBuilder<User?>(
        stream: ref.watch(userProvider).getUser(
            group.members.firstWhere((element) => element != currentUser)),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            User user = snapshot.data!;
            return GestureDetector(
              onTap: () {
                Navigator.of(context).pushNamed(
                  ChatScreen.routeName,
                  arguments: group.groupId,
                );
              },
              child: Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    CircleAvatar(
                      radius: 30,
                      backgroundImage: NetworkImage(user.imageUrl!),
                      backgroundColor: Colors.black,
                    ),
                    const SizedBox(width: 8.0),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: <Widget>[
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Expanded(
                                child: Text(
                                  user.username,
                                  overflow: TextOverflow.ellipsis,
                                  style: Theme.of(context).textTheme.titleSmall,
                                ),
                              ),
                              Text(
                                Jiffy(group.lastUpdated).fromNow(),
                                style: Theme.of(context).textTheme.caption,
                              )
                            ],
                          ),
                          const SizedBox(
                            height: 6.0,
                          ),
                          Text(
                            group.recentMessage.isEmpty
                                ? "no messages"
                                : group.recentMessage,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),
            );
          }
          return const LoadingSpinner();
        });
  }

  Row _appBarTitle() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        const Text(
          "solve",
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w300,
          ),
        ),
        Text(
          "it",
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 18,
            color: Themes.primaryColor.shade50,
          ),
        )
      ],
    );
  }
}
