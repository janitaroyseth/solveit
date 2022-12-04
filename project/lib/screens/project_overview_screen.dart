import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:project/models/project.dart';
import 'package:project/providers/calendar_provider.dart';
import 'package:project/providers/project_provider.dart';
import 'package:project/providers/auth_provider.dart';
import 'package:project/providers/task_provider.dart';
import 'package:project/providers/user_provider.dart';
import 'package:project/screens/edit_project_screen.dart';
import 'package:project/screens/task_overview_screen.dart';
import 'package:project/styles/theme.dart';
import 'package:project/widgets/buttons/app_bar_button.dart';
import 'package:project/widgets/items/project_card.dart';

import '../models/task.dart';

/// Screen/Scaffold for the overview of projects the user have access to.
class ProjectOverviewScreen extends ConsumerStatefulWidget {
  /// Named route for this screen.
  static const routeName = "/project-overview";

  /// Creates an instance of [ProjectOverviewScreen].
  const ProjectOverviewScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      ProjectOverviewScreenState();
}

class ProjectOverviewScreenState extends ConsumerState<ProjectOverviewScreen> {
  /// Opens the given project's [TaskOverviewScreen].
  void _openProject(Project project) async {
    ref.read(calendarProvider).addTasksToCalendar(
        tasks: await ref.read(taskProvider).getTasks(project.projectId).first
            as List<Task>,
        email: ref.read(authProvider).currentUser!.email!);
    ref
        .read(currentProjectProvider.notifier)
        .setProject(ref.watch(projectProvider).getProject(project.projectId));
    ref.read(editProjectProvider.notifier).setProject(project);
    Navigator.of(context)
        .pushNamed(TaskOverviewScreen.routeName, arguments: project.projectId);
  }

  _saveDeviceToken() async {
    String uid = ref.watch(authProvider).currentUser!.uid;
    String? fcmToken = await FirebaseMessaging.instance.getToken();
    print(fcmToken);
    if (fcmToken != null) {
      final tokenRef = FirebaseFirestore.instance
          .collection("users")
          .doc(uid)
          .collection("tokens")
          .doc(fcmToken);

      await tokenRef.set({
        "token": fcmToken,
        "createdAt": DateTime.now(),
        "platform": Platform.operatingSystem,
      });
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (Platform.isIOS) {
      FirebaseMessaging.instance.requestPermission(
        alert: true,
        sound: true,
        badge: true,
      );
    }
    _saveDeviceToken();
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: _appBarTitle(),
        actions: [_newProjectButton()],
      ),
      body: StreamBuilder(
        stream: ref.watch(projectProvider).getProjectsByUserIdAsCollaborator(
              ref.watch(authProvider).currentUser!.uid,
            ),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            var data = snapshot.data;
            List<Project> projects = data as List<Project>;
            return _projectGridView(projects);
          }
          if (snapshot.hasError) print(snapshot.error);

          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }

  /// Returns a grid view displaying the given list of projects.
  Padding _projectGridView(List<Project> projects) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisExtent: 120,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
        ),
        itemCount: projects.length,
        itemBuilder: (context, index) => ProjectCard(
          project: projects[index],
          handler: () => _openProject(projects[index]),
        ),
      ),
    );
  }

  /// Returns texts displaying the app's logo.
  Row _appBarTitle() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        const Text(
          "solve",
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w300,
          ),
        ),
        Text(
          "it",
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 18,
            color: Themes.primaryColor.shade50,
          ),
        )
      ],
    );
  }

  /// Button which navigates to [EditProjectScreen] for assing a new project.
  AppBarButton _newProjectButton() {
    return AppBarButton(
      handler: () {
        ref.read(editProjectProvider.notifier).setProject(null);
        Navigator.of(context).pushNamed(EditProjectScreen.routeName);
        setState(() {});
      },
      tooltip: "Add new project",
      icon: PhosphorIcons.plus,
    );
  }
}
