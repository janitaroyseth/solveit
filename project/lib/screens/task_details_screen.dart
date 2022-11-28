import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jiffy/jiffy.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:project/data/example_data.dart';
import 'package:project/models/comment.dart';
import 'package:project/models/project.dart';
import 'package:project/models/task.dart';
import 'package:project/providers/project_provider.dart';
import 'package:project/providers/task_provider.dart';
import 'package:project/screens/profile_screen.dart';
import 'package:project/styles/theme.dart';
import 'package:project/widgets/appbar_button.dart';
import 'package:project/widgets/comment_list.dart';
import 'package:project/widgets/message_input_field.dart';
import 'package:project/widgets/tag_widget.dart';
import 'package:project/widgets/tags_list.dart';
import 'package:project/widgets/toggle_task_status_button.dart';
import 'package:project/widgets/user_list_item.dart';

import 'configure_task_screen.dart';

/// Screen/Scaffold for the details of a task in a project
class TaskDetailsScreen extends ConsumerWidget {
  /// Named route for this screen.
  static const routeName = "/task";

  /// Creates an instance of [TaskDetailsScreen].
  const TaskDetailsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    FocusNode focusNode = FocusNode();

    return StreamBuilder<Task?>(
        stream: ref.watch(currentTaskProvider),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            Task? task = snapshot.data ?? Task();
            return DefaultTabController(
              length: 2,
              child: Scaffold(
                appBar: AppBar(
                  centerTitle: true,
                  elevation: 0,
                  title: ToggleTaskStatusButton(task: task),
                  leading: AppBarButton(
                    handler: () {
                      focusNode.dispose();
                      Navigator.pop(context);
                    },
                    tooltip: "Go back",
                    icon: PhosphorIcons.caretLeftLight,
                  ),
                  actions: <Widget>[
                    _TaskPopUpMenu(task: task),
                  ],
                  bottom: const TabBar(
                    //labelColor: Colors.black,
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
                      _OverviewTabView(task: task),
                      _CommentTabView(task: task, focusNode: focusNode),
                    ],
                  ),
                ),
              ),
            );
          }
          return const Center(child: CircularProgressIndicator());
        });
  }
}

/// Body content for overview tab.
class _OverviewTabView extends StatelessWidget {
  /// The task to display overview for.
  final Task task;

  /// Creates an instance [OverviewTabView].
  const _OverviewTabView({required this.task});

  Widget assignedList(BuildContext context) {
    return Column(
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
                userId: e,
                size: UserListItemSize.small,
              ),
            )
            .toList(),
      ],
    );
  }

  String deadlineFormatted() {
    return task.deadline != null
        ? Jiffy(task.deadline!).format("dd/MM/yyyy")
        : "-";
  }

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
                  Text(
                    "tags",
                    style: Theme.of(context).textTheme.labelMedium,
                  ),
                  const SizedBox(height: 8),
                  TagsList(
                    tags: task.tags,
                    size: TagSize.large,
                  ),
                  const SizedBox(height: 24),
                  Text(
                    "deadline",
                    style: Theme.of(context).textTheme.labelMedium,
                  ),
                  const SizedBox(height: 8),
                  Text(deadlineFormatted()),
                  const SizedBox(height: 24.0),
                  Text(
                    "assigned",
                    style: Theme.of(context).textTheme.labelMedium,
                  ),
                  const SizedBox(height: 8),
                  assignedList(context),
                  const SizedBox(height: 24),
                  Text(
                    "description",
                    style: Theme.of(context).textTheme.labelMedium,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    task.description,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
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
class _CommentTabView extends StatefulWidget {
  /// The task to display it's comments for.
  final Task task;

  /// FocusNode to use for the comment text field.
  final FocusNode focusNode;

  /// Creates an instance of [_CommentTabView],
  const _CommentTabView({
    required this.task,
    required this.focusNode,
  });

  @override
  State<_CommentTabView> createState() => _CommentTabViewState();
}

class _CommentTabViewState extends State<_CommentTabView> {
  /// [ScrollController] for the [CommentList].
  final ScrollController controller = ScrollController();

  @override
  void initState() {
    super.initState();
    if (widget.task.comments.isNotEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
        controller.jumpTo(controller.position.maxScrollExtent);
      });
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (widget.task.comments.isNotEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
        controller.jumpTo(controller.position.maxScrollExtent);
      });
    }
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  /// Waits the given `wait` milliseconds and then scroll to the bottom of the comment
  /// list.
  void scrollToBottom(wait) {
    Timer(Duration(milliseconds: wait), () {
      controller.animateTo(
        controller.position.maxScrollExtent,
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeInOut,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(
        8.0,
        16.0,
        8.0,
        Platform.isIOS ? 30.0 : 20.0,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                taskTitle(),
                const SizedBox(height: 16.0),
                commentListView(),
              ],
            ),
          ),
          MessageInputField(
            handler: (content, MessageType type) async {
              // switch (type) {
              //   case MessageType.text:
              //     widget.task.comments.add(TextComment(
              //       author: ExampleData.user1,
              //       text: content,
              //     ));
              //     break;
              //   case MessageType.image:
              //     widget.task.comments.add(ImageComment(
              //       author: ExampleData.user2,
              //       image: content,
              //     ));
              //     break;
              //   case MessageType.gif:
              //     widget.task.comments.add(GifComment(
              //       author: ExampleData.user2,
              //       url: content,
              //     ));
              //     break;
              //   default:
              // }

              // setState(() {});
              // scrollToBottom(300);
            },
            focusNode: widget.focusNode,
            camera: true,
            gallery: true,
            gif: true,
          ),
        ],
      ),
    );
  }

  Text taskTitle() {
    return Text(
      widget.task.title.toLowerCase(),
      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
    );
  }

  Expanded commentListView() {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              "comments",
              style: Theme.of(context).textTheme.labelMedium,
            ),
            const SizedBox(height: 8),
            if (widget.task.comments.isEmpty) const Text("No comments..."),
            Expanded(
              child: CommentList(
                comments: widget.task.comments,
                controller: controller,
              ),
            )
          ],
        ),
      ),
    );
  }
}

/// Pop up menu for tasks.
class _TaskPopUpMenu extends ConsumerWidget {
  /// Creates an instance of [_TaskPopUpMenu].
  const _TaskPopUpMenu({required this.task});

  /// The task to show the pop up menu for.
  final Task task;

  void editTask(WidgetRef ref, BuildContext context) {
    ref.read(currentProjectProvider.notifier).setProject(
          ref.watch(projectProvider).getProject(
                task.projectId,
              ),
        );
    Navigator.of(context).pushNamed(
      ConfigureTaskScreen.routeName,
      arguments: task,
    );
  }

  void deleteTask(WidgetRef ref, BuildContext context) {
    Future.delayed(
      const Duration(seconds: 0),
      () => showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text(
            "deleting task",
          ),
          content: Text(
            "Are you sure you want to delete the task \"${task.title.toLowerCase()}\"",
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
                Navigator.of(context).pop();
                Navigator.of(context).pop();
                ref.read(currentProjectProvider.notifier).setProject(
                    ref.read(projectProvider).getProject(task.projectId));

                ref.read(taskProvider).deleteTask(task.taskId);
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
  Widget build(BuildContext context, WidgetRef ref) {
    return PopupMenuButton(
      icon: const Icon(
        PhosphorIcons.dotsThreeVertical,
        size: 34,
      ),
      onSelected: (value) {
        switch (value) {
          case 1:
            editTask(ref, context);
            break;
          case 2:
            deleteTask(ref, context);
            break;
          default:
        }
      },
      itemBuilder: (context) => [
        const PopupMenuItem(
          value: 1,
          height: 40,
          child: Text("edit task"),
        ),
        PopupMenuItem(
          value: 2,
          height: 40,
          child: Text(
            "delete task",
            style: TextStyle(color: Theme.of(context).errorColor),
          ),
        ),
      ],
    );
  }
}
