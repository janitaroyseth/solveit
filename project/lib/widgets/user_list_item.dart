import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:project/models/user.dart';
import 'package:project/providers/user_provider.dart';

/// Enums for deciding the size of the userlist item.
enum UserListItemSize {
  large,
  small,
}

/// User list item displaying a user and their name.
class UserListItem extends ConsumerWidget {
  /// Handler for what to do when the list item is tapped.
  final VoidCallback handler;

  /// The name of the user.
  final User user;
  final bool isOwner;
  final UserListItemSize size;

  const UserListItem({
    super.key,
    required this.user,
    this.isOwner = false,
    this.size = UserListItemSize.large,
    required this.handler,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // return StreamBuilder<User?>(
    //   stream: ref.watch(userProvider).getUser(userId),
    //   builder: (context, snapshot) {
    //     if (snapshot.hasData) {
    //       User user = snapshot.data!;
    return GestureDetector(
      onTap: handler,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: 4.0,
          horizontal: 0.0,
        ),
        child: Row(
          children: <Widget>[
            CircleAvatar(
              radius: size == UserListItemSize.large ? 20 : 15,
              backgroundImage: NetworkImage(user.imageUrl!),
            ),
            const SizedBox(width: 8.0),
            Text(
              user.username,
              style: size == UserListItemSize.large
                  ? const TextStyle(fontSize: 13)
                  : const TextStyle(fontSize: 12),
            ),
            isOwner
                ? const Text(
                    " - owner",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  )
                : const Text(""),
          ],
        ),
      ),
    );
    // }
    //   return const Center(
    //     child: CircularProgressIndicator(),
    //   );
    // },
    // );
  }
}
