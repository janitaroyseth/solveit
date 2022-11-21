import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/settings.dart';

class PreferencesService {
  static final PreferencesService _preferencesService =
      PreferencesService._internal();
  late SharedPreferences preferences;

  factory PreferencesService() {
    return _preferencesService;
  }

  PreferencesService._internal() {
    initService();
  }

  void initService() async {
    preferences = await SharedPreferences.getInstance();
  }

  void saveSettings(Settings settings) async {
    await preferences.setBool("darkThemeEnabled", settings.darkThemeEnabled);
    print("Settings saved.");
  }

  Settings getSettings() {
    bool? darkThemeEnabled = preferences.getBool("darkThemeEnabled");
    if (darkThemeEnabled != null) {
      return Settings(darkThemeEnabled: darkThemeEnabled);
    } else {
      return Settings();
    }
  }
}
