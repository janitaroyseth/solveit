import 'package:flutter/material.dart';

/// Used for a list item in a modal which display various options.
class ModalListItem extends StatelessWidget {
  /// The [IconData] the modal list item should display.
  final IconData icon;

  /// The [String] the modal list item should display.
  final String label;

  /// The [VoidCallback] to call when the list item is tapped.
  final VoidCallback handler;

  /// Creates an instance of [ModalListItem], with the given `icon` of type
  /// [IconData]. `label` of type [String] and `handler` a [VoidCallback] to
  /// call on tap.
  const ModalListItem({
    super.key,
    required this.icon,
    required this.label,
    required this.handler,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        const SizedBox(height: 12.0),
        InkWell(
          onTap: handler,
          child: Row(
            children: <Widget>[
              Icon(
                icon,
                size: 34,
              ),
              const SizedBox(width: 8),
              Text(label)
            ],
          ),
        ),
      ],
    );
  }
}
