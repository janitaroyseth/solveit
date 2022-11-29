import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jiffy/jiffy.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:project/models/comment.dart';
import 'package:project/models/project.dart';
import 'package:project/models/task.dart';
import 'package:project/models/user.dart';
import 'package:project/providers/auth_provider.dart';
import 'package:project/providers/comment_image_provider.dart';
import 'package:project/providers/comment_provider.dart';
import 'package:project/providers/project_provider.dart';
import 'package:project/providers/task_provider.dart';
import 'package:project/providers/user_provider.dart';
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

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(8.0, 16.0, 8.0, 0.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            _taskTitle(),
            const SizedBox(height: 16.0),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  _tags(context),
                  _vericalPaddingLarge(),
                  _deadline(context),
                  _vericalPaddingLarge(),
                  _assigned(context),
                  _vericalPaddingLarge(),
                  _description(context),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  /// Returns the task title in a Text widget.
  Text _taskTitle() {
    return Text(
      task.title.toLowerCase(),
      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
    );
  }

  SizedBox _verticalPaddingSmall() => const SizedBox(height: 8);

  SizedBox _vericalPaddingLarge() => const SizedBox(height: 24.0);

  /// Returns the task tags section.
  Column _tags(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          "tags",
          textAlign: TextAlign.left,
          style: Theme.of(context).textTheme.labelMedium,
        ),
        _verticalPaddingSmall(),
        TagsList(
          tags: task.tags,
          size: TagSize.large,
        ),
      ],
    );
  }

  /// Returns the section for task deadline.
  Column _deadline(BuildContext context) {
    return Column(
      children: [
        Text(
          "deadline",
          style: Theme.of(context).textTheme.labelMedium,
        ),
        _verticalPaddingSmall(),
        Text(task.deadline != null
            ? Jiffy(task.deadline!).format("dd/MM/yyyy")
            : "-"),
      ],
    );
  }

  /// Returns the section for displaying assignees,
  Widget _assigned(BuildContext context) {
    return Consumer(
      builder: (context, ref, child) => Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            "assigned",
            style: Theme.of(context).textTheme.labelMedium,
          ),
          _verticalPaddingSmall(),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ...task.assigned.map(
                (e) => UserListItem(
                  user: e,
                  handler: () => Navigator.of(context).pushNamed(
                    ProfileScreen.routeName,
                    arguments: {
                      "user": e.userId,
                      "projects": <Project>[],
                    },
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  ///Returns the section for task description.
  Column _description(BuildContext context) {
    return Column(
      children: [
        Text(
          "description",
          style: Theme.of(context).textTheme.labelMedium,
        ),
        _verticalPaddingSmall(),
        Text(
          task.description,
          style: Theme.of(context).textTheme.bodyMedium,
        ),
      ],
    );
  }
}

/// Body content for the comment tab.
class _CommentTabView extends ConsumerStatefulWidget {
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
  ConsumerState<_CommentTabView> createState() => _CommentTabViewState();
}

class _CommentTabViewState extends ConsumerState<_CommentTabView> {
  /// [ScrollController] for the [CommentList].
  final ScrollController controller = ScrollController();

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
        controller.position.minScrollExtent,
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
      child: Consumer(
        builder: (context, ref, child) => StreamBuilder<List<Comment>>(
            stream: ref.watch(commentProvider).getComments(widget.task.taskId),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                List<Comment> comments = snapshot.data!;

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          taskTitle(),
                          const SizedBox(height: 16.0),
                          commentListView(comments),
                        ],
                      ),
                    ),
                    _commentInputField(ref),
                  ],
                );
              }
              return const Center(child: CircularProgressIndicator());
            }),
      ),
    );
  }

  /// Returns the message input field customized for comments.
  MessageInputField _commentInputField(WidgetRef ref) {
    return MessageInputField(
      handler: (content, MessageType type) async {
        String currentUserId = ref.watch(authProvider).currentUser!.uid;
        switch (type) {
          case MessageType.text:
            ref
                .read(commentProvider)
                .saveComment(
                  TextComment(
                    taskId: widget.task.taskId,
                    author: currentUserId,
                    text: content,
                  ),
                )
                .then((value) => scrollToBottom(300));
            break;
          case MessageType.image:
            ref
                .read(commentImageProvider)
                .addCommentImage(widget.task.taskId, content)
                .then((value) => ref.read(commentProvider).saveComment(
                      ImageComment(
                        taskId: widget.task.taskId,
                        author: currentUserId,
                        imageUrl: value!,
                      ),
                    ))
                .then((value) => scrollToBottom(600));
            break;
          case MessageType.gif:
            ref
                .read(commentProvider)
                .saveComment(
                  ImageComment(
                    taskId: widget.task.taskId,
                    author: currentUserId,
                    imageUrl: content,
                  ),
                )
                .then((value) => scrollToBottom(600));
            break;
          default:
        }
      },
      focusNode: widget.focusNode,
      camera: true,
      gallery: true,
      gif: true,
    );
  }

  /// Returns the task title in a text widget.
  Text taskTitle() {
    return Text(
      widget.task.title.toLowerCase(),
      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
    );
  }

  /// Returns the list of comments.
  Expanded commentListView(List<Comment> comments) {
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
            if (comments.isEmpty) const Text("No comments..."),
            Expanded(
              child: CommentList(
                comments: comments,
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

  /// Navigates to screen for editing tasks.
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

  /// Displays a dialog asking if the user wishes to delete the task.
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
