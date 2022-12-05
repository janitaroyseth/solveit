import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class NotificationMark extends ConsumerWidget {
  final bool visible;
  const NotificationMark({super.key, this.visible = false});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Visibility(
      visible: visible,
      child: Positioned(
        right: 2,
        top: 4,
        child: CircleAvatar(
          backgroundColor: Colors.red.shade800,
          radius: 5,
        ),
      ),
    );
  }
}
