import 'package:animated_toggle_switch/animated_toggle_switch.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:settings_ui/settings_ui.dart';
import 'package:project/styles/theme.dart';
import 'package:project/providers/settings_provider.dart';

import '../models/settings.dart';
import '../widgets/appbar_button.dart';

/// Scaffold/Screen for viewing and editing user settings.
class UserSettingsScreen extends ConsumerStatefulWidget {
  static const routeName = "/settings";
  const UserSettingsScreen({super.key});

  @override
  ConsumerState<UserSettingsScreen> createState() => _UserSettingsScreenState();
}

class _UserSettingsScreenState extends ConsumerState<UserSettingsScreen> {
  late Settings settings;

  @override
  void initState() {
    settings = ref.read(settingsProvider).getSettings();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("settings"),
        backgroundColor: Colors.transparent,
        leading: AppBarButton(
          handler: () {
            Navigator.pop(context);
          },
          tooltip: "Go back",
          icon: PhosphorIcons.caretLeftLight,
          color: Colors.black,
        ),
      ),
      body: _getSettingsList(ref),
    );
  }

  Widget _getSettingsList(WidgetRef ref) {
    return SettingsList(
      lightTheme: SettingsThemeData(
        settingsListBackground: Theme.of(context).scaffoldBackgroundColor,
        settingsSectionBackground: Theme.of(context).scaffoldBackgroundColor,
        dividerColor: Colors.black,
      ),
      sections: [
        SettingsSection(
          title: Text(
            'theme',
            style: TextStyle(
              color: Themes.primaryColor.shade50,
              fontFamily: Themes.fontFamily,
            ),
          ),
          tiles: <SettingsTile>[
            SettingsTile.switchTile(
              trailing: AnimatedToggleSwitch.rolling(
                current: settings.darkThemeEnabled,
                values: const [false, true],
                onChanged: (bool value) {
                  settings.darkThemeEnabled = value;
                  ref.read(darkModeProvider.notifier).change(value);
                  _saveSettings();
                  setState(() {});
                },
                height: 32,
                iconBuilder: (value, size, foreground) {
                  if (value == true) {
                    return Icon(
                      PhosphorIcons.moonStarsBold,
                      color: foreground == false ? Colors.black : Colors.white,
                    );
                  }
                  return const Icon(
                    PhosphorIcons.sunHorizonBold,
                    color: Colors.white,
                  );
                },
              ),
              onToggle: (value) {
                settings.darkThemeEnabled = value;
                ref.read(darkModeProvider.notifier).change(value);
                _saveSettings();

                setState(() {});
              },
              initialValue: settings.darkThemeEnabled,
              leading: Icon(
                PhosphorIcons.moonBold,
                color: Themes.textColor(ref).withOpacity(0.7),
              ),
              activeSwitchColor: Themes.primaryColor.shade100,
              title: Text(
                'dark theme',
                style: TextStyle(
                  fontFamily: Themes.fontFamily,
                  color: Themes.textColor(ref),
                  fontSize: 14,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  void _saveSettings() {
    ref.read(settingsProvider).saveSettings(settings);
  }
}
