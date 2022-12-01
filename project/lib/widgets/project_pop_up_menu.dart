import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:project/models/project.dart';
import 'package:project/providers/auth_provider.dart';
import 'package:project/providers/project_provider.dart';
import 'package:project/screens/edit_project_screen.dart';
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
  /// Navigates to the [EditProjectScreen].
  void editProject() {
    Future.delayed(
      const Duration(seconds: 0),
      () => Navigator.of(context).pushNamed(
        EditProjectScreen.routeName,
        arguments: widget.project,
      ),
    );
  }

  /// Navigates between [ProjectPreviewScreen] and [TaskOverviewScreen].
  void togglePreviewOverview(WidgetRef ref) {
    Future.delayed(
      const Duration(seconds: 0),
      widget.currentRouteName != ProjectPreviewScreen.routeName
          ? () {
              ref.read(currentProjectProvider.notifier).setProject(ref
                  .read(projectProvider)
                  .getProject(widget.project.projectId));
              Navigator.of(context).pushNamed(ProjectPreviewScreen.routeName);
            }
          : () {
              ref.read(currentProjectProvider.notifier).setProject(ref
                  .read(projectProvider)
                  .getProject(widget.project.projectId));

              while (Navigator.of(context).canPop()) {
                Navigator.of(context).pop();
              }

              Navigator.of(context).pushNamed(TaskOverviewScreen.routeName);
            },
    );
  }

  /// Opens a dialog letting the owner of the project confirm if they do want
  /// to delete the project.
  void deleteProject(WidgetRef ref) {
    Future.delayed(
      const Duration(seconds: 0),
      () => showDialog(
        context: context,
        builder: (context) => _confirmDeleteDialog(context, ref),
      ),
    );
  }

  AlertDialog _confirmDeleteDialog(BuildContext context, WidgetRef ref) {
    return AlertDialog(
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
          if (widget.project.collaborators
              .contains(ref.watch(authProvider).currentUser!.uid))
            _editProjectMenuItem(),
          _togglePreviewAndTasksMenuItem(),
          if (ref.watch(authProvider).currentUser!.uid == widget.project.owner)
            _deleteProjectMenuItem(context),
        ],
      ),
    );
  }

  /// [PopPopupMenuItem] for showing delete option.
  PopupMenuItem<int> _deleteProjectMenuItem(BuildContext context) {
    return PopupMenuItem(
      value: 2,
      height: 40,
      child: Text(
        "delete projext",
        style: TextStyle(
          color: Theme.of(context).errorColor,
        ),
      ),
    );
  }

  /// [PopPopupMenuItem] for toggling between project preview and task list.
  PopupMenuItem<int> _togglePreviewAndTasksMenuItem() {
    return PopupMenuItem(
      value: 1,
      height: 40,
      child: Text(
        widget.currentRouteName == ProjectPreviewScreen.routeName
            ? "go to tasks"
            : "go to preview",
      ),
    );
  }

  /// [PopPopupMenuItem] for showing edit project option.
  PopupMenuItem _editProjectMenuItem() {
    return const PopupMenuItem(
      value: 0,
      height: 40,
      child: Text("edit project"),
    );
  }
}
