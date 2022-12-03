import 'package:animated_toggle_switch/animated_toggle_switch.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:project/utilities/filter.dart';
import 'package:project/utilities/filter_option.dart';
import 'package:project/utilities/settings.dart';
import 'package:project/widgets/app_bar_button.dart';
import 'package:project/widgets/radio_button_group.dart';
import 'package:settings_ui/settings_ui.dart';
import 'package:project/styles/theme.dart';
import 'package:project/providers/settings_provider.dart';

/// Scaffold/Screen for viewing and editing user settings.
class UserSettingsScreen extends ConsumerStatefulWidget {
  /// Named route for this screen.
  static const routeName = "/settings";

  /// Creates an instance of [UserSettingsScreen].
  const UserSettingsScreen({super.key});

  @override
  ConsumerState<UserSettingsScreen> createState() => _UserSettingsScreenState();
}

class _UserSettingsScreenState extends ConsumerState<UserSettingsScreen> {
  /// Settings displayed.
  late Settings _settings;

  @override
  void initState() {
    _settings = ref.read(settingsProvider).getSettings();
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

  /// Returns a settings list over settings.
  Widget _getSettingsList(WidgetRef ref) {
    return SettingsList(
      lightTheme: SettingsThemeData(
        settingsListBackground: Theme.of(context).scaffoldBackgroundColor,
        settingsSectionBackground: Theme.of(context).scaffoldBackgroundColor,
        dividerColor: Colors.transparent,
      ),
      sections: [
        _appearanceSection(ref),
        _dateAndTimeSection(ref),
      ],
    );
  }

  /// Settings section for changing the apperance of the app.
  SettingsSection _appearanceSection(WidgetRef ref) {
    return SettingsSection(
      title: Text(
        "appearance",
        style: TextStyle(
          color: Themes.textColor(ref).withOpacity(0.7),
          fontFamily: Themes.fontFamily,
        ),
      ),
      tiles: <SettingsTile>[
        _darkThemeTile(ref),
      ],
    );
  }

  /// Settings tile for toggling the dark theme.
  SettingsTile _darkThemeTile(WidgetRef ref) {
    return SettingsTile.switchTile(
      trailing: AnimatedToggleSwitch.rolling(
        current: _settings.darkThemeEnabled,
        values: const [false, true],
        onChanged: (bool value) {
          _settings.darkThemeEnabled = value;
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
        _settings.darkThemeEnabled = value;
        ref.read(darkModeProvider.notifier).change(value);
        _saveSettings();

        setState(() {});
      },
      initialValue: _settings.darkThemeEnabled,
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
    );
  }

  /// Settings section for editing settings of type date and time.
  SettingsSection _dateAndTimeSection(WidgetRef ref) {
    return SettingsSection(
      title: Text(
        "date and time",
        style: TextStyle(
          color: Themes.textColor(ref).withOpacity(0.7),
          fontFamily: Themes.fontFamily,
        ),
      ),
      tiles: <SettingsTile>[_dateFormatTile(ref)],
    );
  }

  /// A settings tile displaying option to edit the date format
  /// the app uses.
  SettingsTile _dateFormatTile(WidgetRef ref) {
    return SettingsTile.navigation(
      onPressed: (context) {
        return showDialog(
                context: context,
                builder: (context) => const _DateFormatDialog())
            .then((value) => setState(() {}));
      },
      leading: Icon(
        PhosphorIcons.calendarBlankBold,
        color: Themes.textColor(ref).withOpacity(0.7),
      ),
      value: Text(
        ref.watch(dateFormatProvider).toLowerCase(),
        style: const TextStyle(
          fontSize: 14,
          fontFamily: Themes.fontFamily,
        ),
      ),
      title: Text(
        "date format",
        style: TextStyle(
          fontFamily: Themes.fontFamily,
          color: Themes.textColor(ref),
          fontSize: 14,
        ),
      ),
    );
  }

  void _saveSettings() {
    ref.read(settingsProvider).saveSettings(_settings);
  }
}

/// Dialog for choosing a date format.
class _DateFormatDialog extends StatefulWidget {
  /// Creates an instance of [_DateFormatDialog].
  const _DateFormatDialog();

  @override
  State<_DateFormatDialog> createState() => _DateFormatDialogState();
}

class _DateFormatDialogState extends State<_DateFormatDialog> {
  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Consumer(
        builder: (context, ref, child) => SizedBox(
          height: 400,
          width: MediaQuery.of(context).size.width / 1,
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              children: [
                Text(
                  "date format",
                  style: Theme.of(context).textTheme.displaySmall,
                ),
                const SizedBox(height: 16.0),
                RadioButtonGroup(
                  initalValue: FilterOption(
                      description: ref.watch(dateFormatProvider),
                      filterBy: false),
                  filter: Filter(
                    title: "date format",
                    filterHandler: (FilterOption filterOption) {
                      Settings settings =
                          ref.read(settingsProvider).getSettings();
                      settings.dateFormat = filterOption.description;
                      ref.read(settingsProvider).saveSettings(settings);
                      ref
                          .read(dateFormatProvider.notifier)
                          .change(filterOption.description);
                    },
                    filterType: FilterType.radio,
                    filterOptions: [
                      FilterOption(
                        description: "dd/MM/yyyy",
                        filterBy: false,
                      ),
                      FilterOption(
                        description: "dd-MM-yyyy",
                        filterBy: false,
                      ),
                      FilterOption(
                        description: "dd.MM.yyyy",
                        filterBy: false,
                      ),
                      FilterOption(
                        description: "MM/dd/yyyy",
                        filterBy: false,
                      ),
                      FilterOption(
                        description: "MM-dd-yyyy",
                        filterBy: false,
                      ),
                      FilterOption(
                        description: "MM.dd.yyyy",
                        filterBy: false,
                      ),
                      FilterOption(
                        description: "yyyy-MM-dd",
                        filterBy: false,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
