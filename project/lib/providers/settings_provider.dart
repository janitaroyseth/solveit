import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:project/services/preferences_service.dart';

/// The Settings Provider
final settingsProvider = Provider<PreferencesService>((ref) {
  final PreferencesService prefs = PreferencesService();
  return prefs;
});
