import 'package:flutter/material.dart';

/// Respresents a widget to be used for appbar.
class AppBarButton extends StatelessWidget {
  final VoidCallback handler;
  final String tooltip;
  final IconData icon;

  /// Creates an instance of appbar button with the given function [handler], the given [tooltip] and the given [icon].
  const AppBarButton({
    super.key,
    required this.handler,
    required this.tooltip,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: handler,
      visualDensity: const VisualDensity(
        horizontal: -2.0,
        vertical: -2.0,
      ),
      tooltip: tooltip,
      icon: Icon(
        icon,
        size: 28,
      ),
    );
  }
}
