import 'package:flutter/material.dart';

class UserListItem extends StatelessWidget {
  final VoidCallback handler;
  final String name;
  final String imageUrl;
  final bool isOwner;
  const UserListItem({
    super.key,
    required this.handler,
    required this.name,
    required this.imageUrl,
    this.isOwner = false,
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
              radius: 20,
              backgroundImage: AssetImage(imageUrl),
            ),
            const SizedBox(width: 8.0),
            Text(name),
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
