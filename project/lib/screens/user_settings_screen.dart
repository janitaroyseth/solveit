import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

import '../styles/theme.dart';
import '../widgets/appbar_button.dart';

/// Scaffold/Screen for viewing and editing user settings.
class UserSettingsScreen extends StatelessWidget {
  static const routeName = "/settings";
  const UserSettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        foregroundColor: Colors.white,
        elevation: 0,
        title: const Text("Settings"),
        titleSpacing: -4,
        backgroundColor: Themes.primaryColor,
        leading: AppBarButton(
          handler: () {
            Navigator.pop(context);
          },
          tooltip: "Go back",
          icon: PhosphorIcons.caretLeftLight,
          color: Colors.white,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(30),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Icon(
              PhosphorIcons.gearSixLight,
              size: 60,
            ),
            const SizedBox(height: 20),
            // const Text(
            //   "User Settings",
            //   textAlign: TextAlign.center,
            //   style: TextStyle(fontSize: 20),
            // ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {},
              child: const Text("Behold"),
            ),
            ElevatedButton(
              onPressed: () {},
              child: const Text("my"),
            ),
            ElevatedButton(
              onPressed: () {},
              child: const Text("glorious"),
            ),
            ElevatedButton(
              onPressed: () {},
              child: const Text("creation"),
            ),
          ],
        ),
      ),
    );
  }
}
