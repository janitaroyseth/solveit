import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:project/services/preferences_service.dart';
import 'package:settings_ui/settings_ui.dart';

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
        backgroundColor: Colors.white,
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
      lightTheme: const SettingsThemeData(
        settingsListBackground: Colors.white,
        settingsSectionBackground: Colors.white,
        dividerColor: Colors.black,
      ),
      sections: [
        SettingsSection(
          title: const Text('Theme'),
          tiles: <SettingsTile>[
            SettingsTile.switchTile(
              onToggle: (value) {
                settings.darkThemeEnabled = value;
                _saveSettings();
                setState(() {});
              },
              initialValue: settings.darkThemeEnabled,
              leading: const Icon(Icons.format_paint),
              title: const Text('Enable dark theme'),
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
