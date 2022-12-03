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
    await preferences.setString("dateFormat", settings.dateFormat);
  }

  Settings getSettings() {
    bool? darkThemeEnabled = preferences.getBool("darkThemeEnabled");
    String? dateFormat = preferences.getString("dateFormat");
    if (darkThemeEnabled != null) {
      return Settings(
          darkThemeEnabled: darkThemeEnabled, dateFormat: dateFormat);
    } else {
      return Settings();
    }
  }
}
