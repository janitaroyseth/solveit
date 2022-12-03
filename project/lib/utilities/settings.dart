/// Represents settings in the app.
class Settings {
  /// Whether dark theme is enabled.
  bool darkThemeEnabled;

  /// What date format is chosen.
  String dateFormat;

  /// Creates an instance of settings.
  Settings({this.darkThemeEnabled = false, String? dateFormat})
      : dateFormat = dateFormat ?? "dd/MM/yyyy";
}
