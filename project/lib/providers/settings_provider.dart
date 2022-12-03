import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:project/services/preferences_service.dart';

/// The Settings Provider
final settingsProvider = Provider<PreferencesService>((ref) {
  final PreferencesService prefs = PreferencesService();
  return prefs;
});

/// Notifier for toggling darkmode.
class DarkModeNotifier extends StateNotifier<bool> {
  DarkModeNotifier(super.state);

  void change(value) {
    state = value;
  }
}

/// State notifier provider for listening to changes in darkmode setting.
final darkModeProvider = StateNotifierProvider<DarkModeNotifier, bool>(
  (ref) => DarkModeNotifier(
      ref.watch(settingsProvider).getSettings().darkThemeEnabled),
);

/// Notifier for toggling darkmode.
class DateFormatNotifier extends StateNotifier<String> {
  DateFormatNotifier(super.state);

  void change(value) {
    state = value;
  }
}

/// State notifier provider for listening to changes in darkmode setting.
final dateFormatProvider = StateNotifierProvider<DateFormatNotifier, String>(
  (ref) =>
      DateFormatNotifier(ref.watch(settingsProvider).getSettings().dateFormat),
);
