import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:project/providers/settings_provider.dart';

/// Respresents a widget to be used for appbar.
class AppBarButton extends ConsumerWidget {
  /// Function to call when button is tapped.
  final VoidCallback handler;

  /// Tool tip to display when button is long pressed.
  final String tooltip;

  /// The icon to display in the button.
  final IconData icon;

  /// The color of the button, defaults to black.
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
    bool darkMode = ref.watch(darkModeProvider);

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
