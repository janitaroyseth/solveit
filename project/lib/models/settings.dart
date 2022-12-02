class Settings {
  bool darkThemeEnabled;

  String dateFormat;

  Settings({this.darkThemeEnabled = false, String? dateFormat})
      : dateFormat = dateFormat ?? "dd/MM/yyyy";
}
