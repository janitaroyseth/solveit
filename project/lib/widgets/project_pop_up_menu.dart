import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:project/models/project.dart';
import 'package:project/providers/project_provider.dart';
import 'package:project/screens/edit_project_screen.dart';
import 'package:project/screens/home_screen.dart';
import 'package:project/screens/project_preview_screen.dart';
import 'package:project/screens/task_overview_screen.dart';
import 'package:project/styles/theme.dart';

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
  void editProject() {
    Future.delayed(
      const Duration(seconds: 0),
      () => Navigator.of(context).pushNamed(
        EditProjectScreen.routeName,
        arguments: widget.project,
      ),
    );
  }

  void togglePreviewOverview(WidgetRef ref) {
    Future.delayed(
      const Duration(seconds: 0),
      widget.currentRouteName != ProjectPreviewScreen.routeName
          ? () {
              ref.read(currentProjectProvider.notifier).setProject(ref
                  .read(projectProvider)
                  .getProject(widget.project.projectId));
              print(widget.project.collaborators);
              Navigator.of(context).pushNamed(ProjectPreviewScreen.routeName);
            }
          : () {
              ref.read(currentProjectProvider.notifier).setProject(ref
                  .read(projectProvider)
                  .getProject(widget.project.projectId));
              Navigator.of(context).pushNamedAndRemoveUntil(
                TaskOverviewScreen.routeName,
                ModalRoute.withName(HomeScreen.routeName),
              );
            },
    );
  }

  void deleteProject(WidgetRef ref) {
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
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(
                "no",
                style: TextStyle(
                  color: Themes.textColor(ref),
                ),
              ),
            ),
            TextButton(
              onPressed: () {
                String projectId = widget.project.projectId;

                Navigator.of(context).pop();
                Navigator.of(context).pop();

                ref.read(projectProvider).deleteProject(projectId);
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
  }

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, child) => PopupMenuButton(
        icon: const Icon(
          PhosphorIcons.dotsThreeVertical,
          color: Colors.white,
          size: 34,
        ),
        onSelected: (value) {
          switch (value) {
            case 0:
              editProject();
              break;
            case 1:
              togglePreviewOverview(ref);
              break;
            case 2:
              deleteProject(ref);
              break;
            default:
          }
        },
        tooltip: "Menu for project",
        itemBuilder: (context) => [
          const PopupMenuItem(
            value: 0,
            height: 40,
            child: Text("edit project"),
          ),
          PopupMenuItem(
            value: 1,
            height: 40,
            child: Text(
              widget.currentRouteName == ProjectPreviewScreen.routeName
                  ? "go to tasks"
                  : "go to preview",
            ),
          ),
          PopupMenuItem(
            value: 2,
            height: 40,
            child: Text(
              "delete projext",
              style: TextStyle(
                color: Theme.of(context).errorColor,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
