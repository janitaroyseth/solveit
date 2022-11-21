import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:project/models/project.dart';
import 'package:project/screens/create_profile_screen.dart';
import 'package:project/screens/edit_project_screen.dart';
import 'package:project/screens/home_screen.dart';
import 'package:project/screens/project_preview_screen.dart';
import 'package:project/screens/task_overview_screen.dart';

/// Pop up menu for project.
class ProjectPopUpMenu extends StatefulWidget {
  /// The current project.
  final Project project;

  /// The route name of the current screen displayed.
  final String currentRouteName;

  /// Creates an instance of [ProjectPopUpMenu].
  const ProjectPopUpMenu({
    super.key,
    required this.project,
    required this.currentRouteName,
  });

  @override
  State<ProjectPopUpMenu> createState() => __ProjectPopUpMenuState();
}

class __ProjectPopUpMenuState extends State<ProjectPopUpMenu> {
  @override
  Widget build(BuildContext context) {
    return PopupMenuButton(
      icon: const Icon(
        PhosphorIcons.dotsThreeVertical,
        color: Colors.white,
        size: 34,
      ),
      tooltip: "Menu for project",
      itemBuilder: (context) => [
        PopupMenuItem(
          onTap: () {
            Future.delayed(
              const Duration(seconds: 0),
              () => Navigator.of(context).pushNamed(
                EditProjectScreen.routeName,
                arguments: widget.project,
              ),
            );
          },
          value: 0,
          height: 40,
          child: const Text("edit project"),
        ),
        PopupMenuItem(
          value: 1,
          height: 40,
          onTap: () {
            Future.delayed(
              const Duration(seconds: 0),
              widget.currentRouteName != ProjectPreviewScreen.routeName
                  ? () => Navigator.of(context).pushNamed(
                        ProjectPreviewScreen.routeName,
                        arguments: widget.project,
                      )
                  : () {
                      Navigator.of(context).pushNamedAndRemoveUntil(
                        TaskOverviewScreen.routeName,
                        ModalRoute.withName(HomeScreen.routeName),
                        arguments: widget.project,
                      );
                    },
            );
          },
          child: Text(
            widget.currentRouteName == ProjectPreviewScreen.routeName
                ? "go to tasks"
                : "go to preview",
          ),
        ),
        PopupMenuItem(
          value: 2,
          height: 40,
          onTap: () {
            Future.delayed(
              const Duration(seconds: 0),
              () => showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text(
                    "deleting project",
                  ),
                  content: Text(
                    "Are you sure you want to delete the project \"${widget.project.title.toLowerCase()}\"",
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: const Text("no"),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop(); // pop the dialog
                        Navigator.of(context).pop(); // pop the screen
                      },
                      child: Text(
                        "yes",
                        style: TextStyle(
                          color: Colors.red.shade900,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
          child: Text(
            "delete projext",
            style: TextStyle(
              color: Theme.of(context).errorColor,
            ),
          ),
        ),
      ],
    );
  }
}
