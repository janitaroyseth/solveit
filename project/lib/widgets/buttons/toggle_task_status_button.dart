import 'package:animated_toggle_switch/animated_toggle_switch.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:project/models/task.dart';
import 'package:project/providers/task_provider.dart';
import 'package:project/styles/theme.dart';

/// Toggle button to toggle a task between solved and open.
class ToggleTaskStatusButton extends StatefulWidget {
  /// Whether the task is finished or not.
  final Task task;

  /// Creates an instance of [ToggleTaskStatusButton].
  const ToggleTaskStatusButton({super.key, required this.task});

  @override
  State<ToggleTaskStatusButton> createState() => _ToggleTaskStatusButtonState();
}

class _ToggleTaskStatusButtonState extends State<ToggleTaskStatusButton> {
  late bool value;

  @override
  void initState() {
    value = widget.task.done;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, child) => AnimatedToggleSwitch.dual(
        current: value,
        first: true,
        second: false,
        height: 32,
        onChanged: (bool newValue) {
          setState(() {
            widget.task.done = newValue;
            ref.read(taskProvider).saveTask(widget.task);
            value = newValue;
          });
        },
        borderWidth: 1.5,
        iconBuilder: (value) {
          if (value == true) {
            return const Icon(
              PhosphorIcons.check,
              color: Colors.white,
            );
          }
          return Icon(
            PhosphorIcons.check,
            color: Themes.primaryColor.shade100,
          );
        },
        innerColor: Colors.white.withOpacity(0.1),
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
          return Themes.primaryColor.shade100.withOpacity(0.3);
        },
      ),
    );
  }
}
