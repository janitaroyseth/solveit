import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:project/widgets/appbar_button.dart';
import 'package:project/widgets/bottom_bar.dart';

class ProjectOverviewScreen extends StatelessWidget {
  const ProjectOverviewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("solveit", textAlign: TextAlign.center),
        actions: [
          AppBarButton(
              handler: () {}, tooltip: "YOLO", icon: PhosphorIcons.plus)
        ],
      ),
      bottomNavigationBar: const BottomBar(),
    );
  }
}
