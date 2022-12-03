import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

/// Represents settings in the app.
class Settings {
  /// Whether dark theme is enabled.
  bool darkThemeEnabled;

  /// What date format is chosen.
  String dateFormat;

  /// Creates an instance of settings.
  Settings({bool? darkThemeEnabled, String? dateFormat})
      : dateFormat = dateFormat ?? "dd/MM/yyyy",
        darkThemeEnabled = darkThemeEnabled ??
            SchedulerBinding.instance.window.platformBrightness ==
                Brightness.dark;
}
