import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:project/services/preferences_service.dart';
import 'package:settings_ui/settings_ui.dart';
import 'package:project/styles/theme.dart';

import '../models/settings.dart';
import '../widgets/appbar_button.dart';

/// Scaffold/Screen for viewing and editing user settings.
class UserSettingsScreen extends StatefulWidget {
  static const routeName = "/settings";
  const UserSettingsScreen({super.key});

  @override
  State<UserSettingsScreen> createState() => _UserSettingsScreenState();
}

class _UserSettingsScreenState extends State<UserSettingsScreen> {
  final PreferencesService _preferencesService = PreferencesService();
  late Settings settings;

  @override
  void initState() {
    settings = _preferencesService.getSettings();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        foregroundColor: Colors.black,
        elevation: 0,
        title: const Text("settings"),
        titleSpacing: -4,
        backgroundColor: Themes.themeData.appBarTheme.backgroundColor,
        leading: AppBarButton(
          handler: () {
            Navigator.pop(context);
          },
          tooltip: "Go back",
          icon: PhosphorIcons.caretLeftLight,
          color: Colors.black,
        ),
      ),
      body: _getSettingsList(),
    );
  }

  Widget _getSettingsList() {
    return SettingsList(
      lightTheme: SettingsThemeData(
        settingsListBackground: Themes.themeData.scaffoldBackgroundColor,
        settingsSectionBackground: Themes.themeData.scaffoldBackgroundColor,
        dividerColor: Colors.black,
      ),
      sections: [
        SettingsSection(
          title: const Text(
            'theme',
            style: TextStyle(color: Themes.primaryColor),
          ),
          tiles: <SettingsTile>[
            SettingsTile.switchTile(
              onToggle: (value) {
                settings.darkThemeEnabled = value;
                _saveSettings();
                setState(() {});
              },
              initialValue: settings.darkThemeEnabled,
              leading: Icon(
                PhosphorIcons.paletteFill,
                color: Themes.textColor.withOpacity(0.5),
              ),
              title: const Text('enable dark theme'),
            ),
          ],
        ),
      ],
    );
  }

  void _saveSettings() {
    _preferencesService.saveSettings(settings);
  }
}
