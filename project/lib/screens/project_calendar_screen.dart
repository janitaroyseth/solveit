import 'dart:io';

import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:project/models/project.dart';
import 'package:project/screens/task_overview_screen.dart';
import 'package:project/styles/curve_clipper.dart';
import 'package:project/styles/theme.dart';
import 'package:project/widgets/appbar_button.dart';
import 'package:project/widgets/calendar.dart';
import 'package:project/widgets/project_pop_up_menu.dart';

/// Represents a calnder view of a projects tasks.
class ProjectCalendarScreen extends StatelessWidget {
  static const routeName = "/project/calendar";

  const ProjectCalendarScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final Project project =
        ModalRoute.of(context)!.settings.arguments as Project;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        toolbarHeight: 95,
        title: Row(
          children: [
            Image.asset(
              project.imageUrl,
              height: 90,
            ),
            Text(
              project.title.toLowerCase(),
              style: Theme.of(context).appBarTheme.titleTextStyle!.copyWith(
                    color: Colors.white,
                  ),
            ),
          ],
        ),
        centerTitle: false,
        titleSpacing: -4,
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: Colors.white,
        leading: AppBarButton(
          handler: () {
            Navigator.of(context).pop();
          },
          tooltip: "Add new task",
          icon: PhosphorIcons.caretLeftLight,
          color: Colors.white,
        ),
        actions: <Widget>[
          AppBarButton(
            handler: () => Navigator.of(context).popAndPushNamed(
                TaskOverviewScreen.routeName,
                arguments: project),
            tooltip: "Open calendar for this project",
            icon: PhosphorIcons.listChecksLight,
            color: Colors.white,
          ),
          ProjectPopUpMenu(
            project: project,
            currentRouteName: ProjectCalendarScreen.routeName,
          ),
        ],
      ),
      body: Column(
        children: <Widget>[
          ClipPath(
            clipper: CurveClipper(),
            child: Container(
              color: Themes.primaryColor,
              height: Platform.isIOS ? 150 : 130,
            ),
          ),
          Expanded(child: Calendar(project: project)),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.of(context).pop(),
        child: const Icon(
          PhosphorIcons.plus,
          color: Colors.white,
        ),
      ),
    );
  }
}
