import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:project/models/user.dart';

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

  /// Whether the user is the owner of the project to display the user list item
  /// in.
  final bool isOwner;

  /// The size to use for the user list item.
  final UserListItemSize size;

  /// Optional widget to place on the far right side of the user list item.
  final Widget? widget;

  /// Creates an instance of [UserListItem].
  const UserListItem({
    super.key,
    required this.user,
    this.isOwner = false,
    this.size = UserListItemSize.large,
    this.widget,
    required this.handler,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return GestureDetector(
      onTap: handler,
      child: Padding(
        padding: EdgeInsets.symmetric(
          vertical: widget != null ? 0.0 : 4.0,
          horizontal: 0.0,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: <Widget>[
                _userImageAvatar(),
                const SizedBox(width: 8.0),
                _usernameText(),
                _isOwnerText()
              ],
            ),
            if (widget != null) widget!,
          ],
        ),
      ),
    );
  }

  /// Returns a text widget displaying the user's username.
  Text _usernameText() {
    return Text(
      user.username,
      style: size == UserListItemSize.large
          ? const TextStyle(fontSize: 13)
          : const TextStyle(fontSize: 12),
    );
  }

  /// Returns a cicrle avatar of the users profile image.
  CircleAvatar _userImageAvatar() {
    return CircleAvatar(
      radius: size == UserListItemSize.large ? 20 : 15,
      backgroundImage: NetworkImage(user.imageUrl!),
    );
  }

  /// Returns a text which is only visible if the user is the owner of the project.
  Visibility _isOwnerText() {
    return Visibility(
      visible: isOwner,
      child: const Text(
        " - owner",
        style: TextStyle(
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
