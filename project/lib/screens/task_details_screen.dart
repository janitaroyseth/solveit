import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:project/models/message.dart';
import 'package:project/models/project.dart';
import 'package:project/models/task.dart';
import 'package:project/models/user.dart';
import 'package:project/providers/auth_provider.dart';
import 'package:project/providers/comment_image_provider.dart';
import 'package:project/providers/comment_provider.dart';
import 'package:project/providers/project_provider.dart';
import 'package:project/providers/settings_provider.dart';
import 'package:project/providers/task_provider.dart';
import 'package:project/providers/user_provider.dart';
import 'package:project/screens/configure_task_screen.dart';
import 'package:project/screens/profile_screen.dart';
import 'package:project/styles/theme.dart';
import 'package:project/utilities/date_formatting.dart';
import 'package:project/widgets/appbar_button.dart';
import 'package:project/widgets/comment_list.dart';
import 'package:project/widgets/loading_spinner.dart';
import 'package:project/widgets/message_input_field.dart';
import 'package:project/widgets/tag_widget.dart';
import 'package:project/widgets/tags_list.dart';
import 'package:project/widgets/toggle_task_status_button.dart';
import 'package:project/widgets/user_list_item.dart';

/// Screen/Scaffold for the details of a task in a project
class TaskDetailsScreen extends ConsumerWidget {
  /// Named route for this screen.
  static const routeName = "/task";

  /// Creates an instance of [TaskDetailsScreen].
  const TaskDetailsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    bool isCollaborator = ModalRoute.of(context)!.settings.arguments as bool;

    return StreamBuilder<Task?>(
      stream: ref.watch(currentTaskProvider),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          Task? task = snapshot.data ?? Task();
          return DefaultTabController(
            length: 2,
            child: Scaffold(
              appBar: AppBar(
                backgroundColor: _appBarBackground(ref),
                title: isCollaborator
                    ? ToggleTaskStatusButton(task: task)
                    : _taskStatusLabel(task),
                leading: _backButton(context),
                actions: [
                  Visibility(
                    visible: isCollaborator,
                    child: _TaskPopUpMenu(task: task),
                  )
                ],
                bottom: _appBarBottomTab(),
              ),
              body: TabBarView(
                children: [
                  _OverviewTabView(task: task),
                  _CommentTabView(task: task),
                ],
              ),
            ),
          );
        }
        return const LoadingSpinner();
      },
    );
  }

  /// [TabBar] toggling between overview and comments.
  TabBar _appBarBottomTab() {
    return const TabBar(
      indicatorColor: Themes.primaryColor,
      tabs: <Tab>[
        Tab(text: "overview"),
        Tab(text: "comments"),
      ],
    );
  }

  /// Button that navigates to previous screen.
  AppBarButton _backButton(BuildContext context) {
    return AppBarButton(
      handler: () {
        Navigator.pop(context);
      },
      tooltip: "Go back",
      icon: PhosphorIcons.caretLeftLight,
    );
  }

  /// Returns the background color of the appbar depending
  /// on which theme mode is selected.
  Color _appBarBackground(WidgetRef ref) {
    return ref.watch(darkModeProvider)
        ? const Color.fromRGBO(21, 21, 21, 1)
        : Colors.transparent;
  }

  /// Returns a label displaying the status of the task.
  Widget _taskStatusLabel(Task task) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Visibility(
          visible: task.done,
          child: const Icon(PhosphorIcons.check),
        ),
        const SizedBox(width: 8.0),
        Text(task.done ? "solved" : "open"),
        AppBarButton(
          handler: () {},
          tooltip: "",
          icon: PhosphorIcons.cactus,
          color: Colors.transparent,
        ),
      ],
    );
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
    return Consumer(
      builder: (context, ref, child) => SingleChildScrollView(
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
                    _deadline(context, ref),
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
  Column _deadline(BuildContext context, WidgetRef ref) {
    return Column(
      children: [
        Text(
          "deadline",
          style: Theme.of(context).textTheme.labelMedium,
        ),
        _verticalPaddingSmall(),
        Text(task.deadline != null
            ? DateFormatting.shortDate(ref, task.deadline!)
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
          _assignedList(ref),
        ],
      ),
    );
  }

  /// Returns a column containing task assignees mapped to user list items.
  Column _assignedList(WidgetRef ref) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        ...task.assigned.map(
          (e) => StreamBuilder<User?>(
            stream: ref.watch(userProvider).getUser(e),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                User user = snapshot.data!;
                return _assignedUserListItem(user, context, e);
              }
              return const LoadingSpinner();
            },
          ),
        ),
      ],
    );
  }

  /// Returns a user list item custimized for assignees.
  UserListItem _assignedUserListItem(
      User user, BuildContext context, String e) {
    return UserListItem(
      user: user,
      handler: () => Navigator.of(context).pushNamed(
        ProfileScreen.routeName,
        arguments: {
          "user": e,
          "projects": <Project>[],
        },
      ),
    );
  }

  ///Returns the section for task description.
  Column _description(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
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

  /// Creates an instance of [_CommentTabView],
  const _CommentTabView({required this.task});

  @override
  ConsumerState<_CommentTabView> createState() => _CommentTabViewState();
}

class _CommentTabViewState extends ConsumerState<_CommentTabView> {
  /// [ScrollController] for the [CommentList].
  final ScrollController controller = ScrollController();
  late FocusNode focusNode;

  @override
  void initState() {
    focusNode = FocusNode();
    super.initState();
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
        controller.position.minScrollExtent,
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeInOut,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => focusNode.unfocus(),
      child: Padding(
        padding: EdgeInsets.fromLTRB(
          8.0,
          16.0,
          8.0,
          Platform.isIOS ? 30.0 : 20.0,
        ),
        child: Consumer(
          builder: (context, ref, child) => StreamBuilder<List<Message?>>(
              stream: ref
                  .watch(commentProvider)
                  .getComments(widget.task.projectId, widget.task.taskId),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  List<Message?> comments = snapshot.data!;

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
                if (snapshot.hasError) print(snapshot.error);
                return const LoadingSpinner();
              }),
        ),
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
                  widget.task.projectId,
                  widget.task.taskId,
                  TextMessage(
                    otherId: widget.task.taskId,
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
                      widget.task.projectId,
                      widget.task.taskId,
                      ImageMessage(
                        otherId: widget.task.taskId,
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
                  widget.task.projectId,
                  widget.task.taskId,
                  ImageMessage(
                    otherId: widget.task.taskId,
                    author: currentUserId,
                    imageUrl: content,
                  ),
                )
                .then((value) => scrollToBottom(600));
            break;
          default:
        }
      },
      focusNode: focusNode,
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
  Expanded commentListView(List<Message?> comments) {
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
    ref.read(editTaskProvider.notifier).setTask(task);
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
        builder: (context) => _deleteTaskDialog(context, ref),
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

  /// Displays a dialog letting user confirm that they do want to
  /// delete the task.
  AlertDialog _deleteTaskDialog(BuildContext context, WidgetRef ref) {
    return AlertDialog(
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

            ref.read(taskProvider).deleteTask(task.projectId, task.taskId);
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
}
