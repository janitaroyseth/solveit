import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:project/models/project.dart';
import 'package:project/models/task.dart';
import 'package:project/providers/auth_provider.dart';
import 'package:project/providers/project_provider.dart';
import 'package:project/providers/task_provider.dart';
import 'package:project/screens/edit_task_screen.dart';
import 'package:project/screens/task_overview_screen.dart';
import 'package:project/styles/curve_clipper.dart';
import 'package:project/styles/theme.dart';
import 'package:project/widgets/buttons/app_bar_button.dart';
import 'package:project/widgets/general/calendar.dart';
import 'package:project/widgets/buttons/project_pop_up_menu.dart';

/// Represents a calnder view of a projects tasks.
class ProjectCalendarScreen extends ConsumerStatefulWidget {
  /// Named route for this screen.
  static const routeName = "/project/calendar";

  /// Creates an instance of [ProjectCalendarScreen].
  const ProjectCalendarScreen({super.key});

  @override
  ConsumerState<ProjectCalendarScreen> createState() =>
      _ProjectCalendarScreenState();
}

class _ProjectCalendarScreenState extends ConsumerState<ProjectCalendarScreen> {
  DateTime selectedDay = DateTime.now();

  bool isCollaborator(WidgetRef ref, Project project) =>
      project.collaborators.contains(ref.watch(authProvider).currentUser!.uid);

  @override
  Widget build(BuildContext context) {
    final Project project =
        ModalRoute.of(context)!.settings.arguments as Project;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        toolbarHeight: 95,
        title: _appBarTitle(project, context),
        titleSpacing: -4,
        foregroundColor: Colors.white,
        leading: _backButton(context),
        actions: <Widget>[
          _taskListButton(context, project),
          ProjectPopUpMenu(
            project: project,
            currentRouteName: ProjectCalendarScreen.routeName,
          ),
        ],
      ),
      body: Column(
        children: <Widget>[
          _headerBackground(),
          _calendar(project),
        ],
      ),
      floatingActionButton: Visibility(
        visible: isCollaborator(ref, project),
        child: _addNewTaskButton(
          project,
          context,
          selectedDay,
        ),
      ),
    );
  }

  Row _appBarTitle(Project project, BuildContext context) {
    return Row(
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
    );
  }

  AppBarButton _backButton(BuildContext context) {
    return AppBarButton(
      handler: () {
        Navigator.of(context).pop();
      },
      tooltip: "Go back",
      icon: PhosphorIcons.caretLeftLight,
      color: Colors.white,
    );
  }

  AppBarButton _taskListButton(BuildContext context, Project project) {
    return AppBarButton(
      handler: () => Navigator.of(context).popAndPushNamed(
        TaskOverviewScreen.routeName,
        arguments: project,
      ),
      tooltip: "Open list for this project",
      icon: PhosphorIcons.listChecksLight,
      color: Colors.white,
    );
  }

  Expanded _calendar(Project project) {
    return Expanded(
      child: Calendar(
        project: project,
        selectDay: (DateTime newDate) {
          selectedDay = newDate;
          setState(() {});
        },
      ),
    );
  }

  ClipPath _headerBackground() {
    return ClipPath(
      clipper: CurveClipper(),
      child: Container(
        color: Themes.primaryColor,
        height: Platform.isIOS ? 150 : 130,
      ),
    );
  }

  /// Button for adding a new task.
  FloatingActionButton _addNewTaskButton(
      Project project, BuildContext context, DateTime newDate) {
    return FloatingActionButton(
      onPressed: () async {
        ref.read(editTaskProvider.notifier).setTask(null);
        ref.read(currentProjectProvider.notifier).setProject(
            ref.watch(projectProvider).getProject(project.projectId));
        Navigator.of(context)
            .pushNamed(EditTaskScreen.routeName,
                arguments: Task(deadline: newDate))
            .whenComplete(() => setState(() {}));
      },
      child: const Icon(
        PhosphorIcons.plus,
        color: Colors.white,
      ),
    );
  }
}
