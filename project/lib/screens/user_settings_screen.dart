import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

import '../styles/theme.dart';
import '../widgets/appbar_button.dart';

/// Scaffold/Screen for viewing and editing user settings.
class UserSettingsScreen extends StatelessWidget {
  static const routeName = "/settings";
  const UserSettingsScreen({super.key});
  static final List<String> settingsList = ["Theme", "Text", "Time", "Account"];
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
      body: Padding(
        padding: const EdgeInsets.all(30),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _getSettingsList(),
          ],
        ),
      ),
    );
  }

  Widget _getSettingsList() {
    return Expanded(
      child: ListView.separated(
        separatorBuilder: (context, index) => const Divider(
          color: Color.fromARGB(62, 0, 0, 0),
          height: 30,
          thickness: 0.5,
        ),
        itemBuilder: ((context, index) => _getSettingsListItem(index)),
        itemCount: settingsList.length,
      ),
    );
  }

  Widget _getSettingsListItem(int index) {
    List<Icon> icons = [
      const Icon(PhosphorIcons.paletteLight),
      const Icon(PhosphorIcons.textTLight),
      const Icon(PhosphorIcons.clockLight),
      const Icon(PhosphorIcons.keyLight)
    ];
    return InkWell(
      onTap: () {},
      child: Row(
        children: [
          icons[index],
          const Spacer(flex: 1),
          Text(
            settingsList[index],
            style: Themes.textTheme.bodyMedium,
          ),
          const Spacer(flex: 9),
          const Icon(PhosphorIcons.caretRightLight)
        ],
      ),
    );
  }
}
