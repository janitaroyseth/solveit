import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:project/models/alert.dart';
import 'package:project/models/group.dart';
import 'package:project/models/notification.dart' as model;
import 'package:project/models/user.dart';
import 'package:project/providers/alert_provider.dart';
import 'package:project/providers/auth_provider.dart';
import 'package:project/providers/chat_provder.dart';
import 'package:project/providers/notification_provider.dart';
import 'package:project/providers/user_provider.dart';
import 'package:project/screens/chat_screen.dart';
import 'package:project/screens/collaborators_screen.dart';
import 'package:project/styles/theme.dart';
import 'package:project/utilities/date_formatting.dart';
import 'package:project/widgets/buttons/app_bar_button.dart';
import 'package:project/widgets/general/loading_spinner.dart';
import 'package:project/widgets/general/notification_mark.dart';

/// Screen/Scaffold for displaying notifications and messages for the current
/// user.
class NotificationsScreen extends ConsumerWidget {
  /// Creates an instance of [NotificationsScreen].
  const NotificationsScreen({super.key});

  void _setNotificationsAsSeen(WidgetRef ref, String currentUser) async {
    Alert alert = await ref.watch(alertProvider.notifier).getAlert().first ??
        Alert(unseenNotification: false, groupIds: {});
    alert.unseenNotification = false;
    ref.read(alertProvider.notifier).saveAlert(alert, currentUser);
  }

  void _setMessageAsRead(WidgetRef ref, String groupId) async {
    ref.watch(alertProvider.notifier).getAlert().first.then((alert) {
      alert ??= Alert(unseenNotification: false, groupIds: {});
      alert.groupIds.remove(groupId);

      String userId = ref.watch(authProvider).currentUser!.uid;
      ref.read(alertProvider.notifier).saveAlert(alert, userId);
    });
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    String currentUser = ref.watch(authProvider).currentUser!.uid;
    _setNotificationsAsSeen(ref, currentUser);
    return Scaffold(
      appBar: AppBar(
        title: _appBarTitle(),
        actions: [_newMessageButton(ref, context, currentUser)],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              _notificationsSection(context, ref, currentUser),
              const SizedBox(height: 32.0),
              _messagesSection(ref, context, currentUser),
            ],
          ),
        ),
      ),
    );
  }

  /// [AppBarButton] for creating a new message.
  AppBarButton _newMessageButton(
      WidgetRef ref, BuildContext context, String currentUser) {
    return AppBarButton(
      handler: () => _newMessage(ref, context, currentUser),
      tooltip: "create new message",
      icon: PhosphorIcons.pencilSimpleLineLight,
    );
  }

  /// Returns the notification section, displaying a title and a list of recent
  /// notifications.
  Flexible _notificationsSection(
      BuildContext context, WidgetRef ref, String currentUser) {
    return Flexible(
      fit: FlexFit.loose,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            "notifications",
            style: Theme.of(context).textTheme.labelLarge,
          ),
          _notificationsList(ref, currentUser),
        ],
      ),
    );
  }

  /// Returns a [ListView] of recent notifications.
  Widget _notificationsList(WidgetRef ref, String currentUser) {
    return StreamBuilder<List<model.Notification>>(
        stream: ref
            .watch(notificationProvider)
            .getNotificationsForUser(currentUser),
        builder: (context, snapshot) {
          const maxLength = 7;
          if (snapshot.hasData) {
            List<model.Notification>? notifications = snapshot.data;
            return ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: notifications!.length < maxLength
                  ? notifications.length % maxLength
                  : maxLength,
              itemBuilder: (context, index) =>
                  _notificationsListItem(context, notifications[index]),
            );
          }
          if (snapshot.hasError) print(snapshot.error);
          return const LoadingSpinner();
        });
  }

  /// Returns a list item for notifications.
  Padding _notificationsListItem(
      BuildContext context, model.Notification notification) {
    return Padding(
      padding: const EdgeInsets.only(top: 16.0),
      child: Row(
        children: [
          Expanded(
            child: Text(
              notification.message,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ),
          const SizedBox(width: 8.0),
          Text(
            DateFormatting.timeSince(notification.sentAt),
            style: Theme.of(context).textTheme.caption,
          )
        ],
      ),
    );
  }

  /// Returns the messages section, displaying a title and list of message groups
  /// the current user is participating in.
  Flexible _messagesSection(
    WidgetRef ref,
    BuildContext context,
    String currentUser,
  ) {
    return Flexible(
      fit: FlexFit.loose,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Text(
            "messages",
            style: Theme.of(context).textTheme.labelLarge,
          ),
          _messagesList(ref, currentUser),
        ],
      ),
    );
  }

  /// Returns a list of message groups the user is participating in.
  Flexible _messagesList(WidgetRef ref, String currentUser) {
    return Flexible(
      fit: FlexFit.loose,
      child: StreamBuilder<List<Group?>>(
        stream: ref.watch(chatProvider).getGroups(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List<Group?> groups = snapshot.data!;
            return ListView.builder(
              shrinkWrap: true,
              itemCount: groups.length,
              itemBuilder: (context, index) =>
                  _messageListItem(ref, groups[index]!, currentUser),
            );
          }
          return const LoadingSpinner();
        },
      ),
    );
  }

  /// Returns a list item for message groups.
  Widget _messageListItem(
    WidgetRef ref,
    Group group,
    String currentUser,
  ) {
    final otherUsers = group.members.where((element) {
      return element != currentUser;
    });
    if (otherUsers.isEmpty) return const SizedBox();

    final userStream = ref.watch(userProvider).getUser(otherUsers.first);

    return StreamBuilder<User?>(
      stream: userStream,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          User user = snapshot.data!;
          return GestureDetector(
            onTap: () => _openChat(context, ref, group.groupId),
            child: Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Stack(
                    children: [
                      _messageImage(user),
                      StreamBuilder<Alert?>(
                          stream: ref.watch(alertProvider),
                          builder: (context, snapshot) {
                            if (snapshot.hasData && snapshot.data != null) {
                              Alert alert = snapshot.data!;

                              return NotificationMark(
                                  visible:
                                      alert.groupIds.contains(group.groupId));
                            }
                            return const SizedBox();
                          }),
                    ],
                  ),
                  const SizedBox(width: 8.0),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            _messageName(user, context),
                            _lastMessageSentAt(group, context)
                          ],
                        ),
                        const SizedBox(
                          height: 6.0,
                        ),
                        _recentMessage(group)
                      ],
                    ),
                  )
                ],
              ),
            ),
          );
        }
        return const LoadingSpinner();
      },
    );
  }

  /// The most recent message sent in the given group.
  Text _recentMessage(Group group) {
    return Text(
      group.recentMessage.isEmpty ? "no messages" : group.recentMessage,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
    );
  }

  /// The date the last message was sent.
  Text _lastMessageSentAt(Group group, BuildContext context) {
    return Text(
      DateFormatting.timeSince(group.lastUpdated),
      style: Theme.of(context).textTheme.caption,
    );
  }

  /// The name of the user messaging with.
  Expanded _messageName(User user, BuildContext context) {
    return Expanded(
      child: Text(
        user.username,
        overflow: TextOverflow.ellipsis,
        style: Theme.of(context).textTheme.titleSmall,
      ),
    );
  }

  /// The image of the user messaging with.
  CircleAvatar _messageImage(User user) {
    return CircleAvatar(
      radius: 30,
      backgroundImage: NetworkImage(user.imageUrl!),
      backgroundColor: Colors.black,
    );
  }

  /// Returns styled solve it for title.
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

  /// Creates a new group if group does not already exists, or opens the existing
  /// group for chatting.
  void _newMessage(WidgetRef ref, BuildContext context, String currentUser) {
    List<String> members = [];
    members.add(ref.watch(authProvider).currentUser!.uid);
    Navigator.of(context).pushNamed(CollaboratorsScreen.routeName, arguments: [
      members,
      CollaboratorsSearchType.collaborators,
      "",
    ]).then((value) {
      if (members.isNotEmpty) {
        // Does group exist
        ref.watch(chatProvider).getGroups().first.then((groups) {
          for (Group group in groups) {
            for (String member in members) {
              if (group.members.contains(member) && member != currentUser) {
                _openChat(context, ref, group.groupId);
                return;
              }
            }
          }
          ref.read(chatProvider).saveGroup(Group(members: members)).then(
                (value) => _openChat(context, ref, value.groupId),
              );
          return;
        });
      }
    });
  }

  /// Opens the [ChatScreen] for the chat's of the given [groupId].
  Future _openChat(BuildContext context, WidgetRef ref, String groupId) {
    _setMessageAsRead(ref, groupId);

    return Navigator.of(context).pushNamed(
      ChatScreen.routeName,
      arguments: groupId,
    );
  }
}
