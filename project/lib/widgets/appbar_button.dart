import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:project/providers/settings_provider.dart';

/// Respresents a widget to be used for appbar.
class AppBarButton extends ConsumerWidget {
  final VoidCallback handler;
  final String tooltip;
  final IconData icon;
  final Color color;

  /// Creates an instance of appbar button with the given function [handler], the given [tooltip] and the given [icon].
  const AppBarButton({
    super.key,
    required this.handler,
    required this.tooltip,
    required this.icon,
    this.color = Colors.black,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    bool darkMode = ref.watch(darkModeProvider.notifier).state;

    return IconButton(
      onPressed: handler,
      visualDensity: const VisualDensity(
        horizontal: 0.0,
        vertical: -2.0,
      ),
      tooltip: tooltip,
      icon: Icon(
        icon,
        size: 30,
        color: color == Colors.black && darkMode ? Colors.white : color,
      ),
    );
  }
}
