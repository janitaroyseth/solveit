import 'package:animated_toggle_switch/animated_toggle_switch.dart';
import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:project/styles/theme.dart';

/// Toggle button to toggle a task between solved and open.
class ToggleTaskStatusButton extends StatefulWidget {
  /// Whether the task is finished or not.
  final bool isTaskDone;

  /// Creates an instance of [ToggleTaskStatusButton].
  const ToggleTaskStatusButton({super.key, required this.isTaskDone});

  @override
  State<ToggleTaskStatusButton> createState() => _ToggleTaskStatusButtonState();
}

class _ToggleTaskStatusButtonState extends State<ToggleTaskStatusButton> {
  late bool value;

  @override
  void initState() {
    value = widget.isTaskDone;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedToggleSwitch.dual(
      current: value,
      first: true,
      second: false,
      height: 32,
      onChanged: (bool i) => setState(() => value = i),
      borderWidth: 1.5,
      iconBuilder: (value) {
        if (value == true) {
          return const Icon(
            PhosphorIcons.check,
            color: Colors.white,
          );
        }
        return const Icon(
          PhosphorIcons.check,
          color: Themes.primaryColor,
        );
      },
      textBuilder: (value) {
        if (value == true) {
          return const Text(
            "solved",
            style: TextStyle(fontSize: 16),
          );
        }
        return const Text(
          "open",
          style: TextStyle(fontSize: 16),
        );
      },
      colorBuilder: (value) {
        if (value == true) {
          return Themes.primaryColor;
        }
        return Themes.primaryColor.withOpacity(0.1);
      },
    );
  }
}
