import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:project/widgets/appbar_button.dart';

/// Screen/Scaffold for the profile of the user.
class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("profile", textAlign: TextAlign.center),
        actions: [
          // TODO: Add action to button.
          AppBarButton(
              handler: () {},
              tooltip: "Settings",
              icon: PhosphorIcons.gearSixLight)
        ],
      ),
      body: Center(
        child: Column(
          children: [
            const Padding(
              padding: EdgeInsets.all(50),
            ),
            Image.asset(
              "assets/images/profile_pictuer_placeholder.png",
              height: 200,
            ),
            const Padding(
              padding: EdgeInsets.all(40),
            ),
            const Text("Testy"),
            const Padding(
              padding: EdgeInsets.all(20),
            ),
            const Text("Testyson"),
            const Padding(
              padding: EdgeInsets.all(20),
            ),
            const Text("About me yo!"),
          ],
        ),
      ),
    );
  }
}
