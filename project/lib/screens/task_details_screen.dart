import 'dart:io';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:project/models/project.dart';
import 'package:project/models/task.dart';
import 'package:project/screens/profile_screen.dart';
import 'package:project/styles/theme.dart';
import 'package:project/widgets/appbar_button.dart';
import 'package:project/widgets/comment_list.dart';
import 'package:project/widgets/message_input_field.dart';
import 'package:project/widgets/tag_widget.dart';
import 'package:project/widgets/toggle_task_status_button.dart';
import 'package:project/widgets/user_list_item.dart';

/// Screen/Scaffold for the details of a task in a project
class TaskDetailsScreen extends StatelessWidget {
  /// Named route for this screen.
  static const routeName = "/task";

  /// Creates an instance of [TaskDetailsScreen].
  const TaskDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    FocusNode focusNode = FocusNode();

    Task task = ModalRoute.of(context)!.settings.arguments as Task;

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          elevation: 0,
          title: ToggleTaskStatusButton(isTaskDone: task.done),
          leading: AppBarButton(
            handler: () {
              focusNode.dispose();
              Navigator.pop(context);
            },
            tooltip: "Go back",
            icon: PhosphorIcons.caretLeftLight,
          ),
          actions: <Widget>[
            PopupMenuButton(
              icon: const Icon(
                PhosphorIcons.dotsThreeVertical,
                size: 34,
              ),
              itemBuilder: (context) => [
                PopupMenuItem(
                  value: 1,
                  height: 48,
                  onTap: () {},
                  child: const Text("edit task"),
                ),
                PopupMenuItem(
                  value: 2,
                  height: 48,
                  onTap: () {
                    Future.delayed(
                      const Duration(seconds: 0),
                      () => showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: const Text(
                            "deleting task",
                          ),
                          content: Text(
                            "Are you sure you want to delete this task \"${task.title.toLowerCase()}\"",
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
                    "delete task",
                    style: TextStyle(color: Colors.red.shade900),
                  ),
                ),
              ],
            ),
          ],
          bottom: const TabBar(
            labelColor: Colors.black,
            indicatorColor: Themes.primaryColor,
            tabs: <Tab>[
              Tab(text: "overview"),
              Tab(text: "comments"),
            ],
          ),
        ),
        body: GestureDetector(
          onTap: () => focusNode.unfocus(),
          child: TabBarView(
            children: [
              OverviewTabView(task: task),
              CommentTabView(task: task, focusNode: focusNode),
            ],
          ),
        ),
      ),
    );
  }
}

/// Body content for overview tab.
class OverviewTabView extends StatelessWidget {
  /// The task to display overview for.
  final Task task;

  /// Creates an instance [OverviewTabView].
  const OverviewTabView({
    super.key,
    required this.task,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(8.0, 16.0, 8.0, 0.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              task.title.toLowerCase(),
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 16.0),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text("tags", style: Themes.textTheme.labelMedium),
                  const SizedBox(height: 8),
                  Row(
                    children:
                        task.tags.map((e) => TagWidget.fromTag(e)).toList(),
                  ),
                  const SizedBox(height: 24),
                  Text("deadline", style: Themes.textTheme.labelMedium),
                  const SizedBox(height: 8),
                  Text(DateFormat("dd/MM/yyyy")
                      .format(DateTime.parse(task.deadline!))),
                  const SizedBox(height: 24.0),
                  Text("assigned", style: Themes.textTheme.labelMedium),
                  const SizedBox(height: 8),
                  Column(
                    children: [
                      ...task.assigned
                          .map(
                            (e) => UserListItem(
                              handler: () => Navigator.of(context).pushNamed(
                                ProfileScreen.routeName,
                                arguments: {
                                  "user": e,
                                  "projects": <Project>[],
                                },
                              ),
                              user: e,
                              size: UserListItemSize.small,
                            ),
                          )
                          .toList(),
                    ],
                  ),
                  const SizedBox(height: 24),
                  Text("description", style: Themes.textTheme.labelMedium),
                  const SizedBox(height: 8),
                  Text(task.description, style: Themes.textTheme.bodyMedium),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

/// Body content for the comment tab.
class CommentTabView extends StatelessWidget {
  /// The task to display it's comments for.
  final Task task;

  /// FocusNode to use for the comment text field.
  final FocusNode focusNode;

  /// Creates an instance of [CommentTabView],
  const CommentTabView({
    super.key,
    required this.task,
    required this.focusNode,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:
          EdgeInsets.fromLTRB(8.0, 16.0, 8.0, Platform.isIOS ? 30.0 : 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  task.title.toLowerCase(),
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.w500),
                ),
                const SizedBox(height: 16.0),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text("comments", style: Themes.textTheme.labelMedium),
                      const SizedBox(height: 8),
                      task.comments.isEmpty
                          ? const Text("No comments...")
                          : CommentList(
                              comments: task.comments,
                            )
                    ],
                  ),
                ),
              ],
            ),
          ),
          MessageInputField(
            focusNode: focusNode,
            camera: true,
            gallery: true,
            gif: true,
          ),
        ],
      ),
    );
  }
}
