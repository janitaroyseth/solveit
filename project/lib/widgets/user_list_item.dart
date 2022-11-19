import 'package:flutter/material.dart';
import 'package:project/models/user.dart';

/// Enums for deciding the size of the userlist item.
enum UserListItemSize {
  large,
  small,
}

/// User list item displaying a user and their name.
class UserListItem extends StatelessWidget {
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
  Widget build(BuildContext context) {
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
              backgroundImage: AssetImage(user.imageUrl),
            ),
            const SizedBox(width: 8.0),
            Text(
              "$user.username",
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
  }
}
