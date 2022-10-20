import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

import '../models/task.dart';
import '../widgets/appbar_button.dart';
import '../widgets/comment_list.dart';
import '../widgets/tag_widget.dart' as widget_tag;
import '../widgets/tags_list.dart';

/// Screen/Scaffold for the details of a task in a project
class TaskDetailScreen extends StatefulWidget {
  const TaskDetailScreen({super.key});

  @override
  State<StatefulWidget> createState() => _TaskDetailsScreenState();
}

class _TaskDetailsScreenState extends State<TaskDetailScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final task = ModalRoute.of(context)!.settings.arguments as Task;
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(task.title),
            Visibility(
              visible: true,
              child: _textStatus(task),
            ),
          ],
        ),
        titleSpacing: -4,
        leading: AppBarButton(
          handler: () {
            Navigator.pop(context);
          },
          tooltip: "Go back",
          icon: PhosphorIcons.caretLeftLight,
        ),
        actions: <Widget>[
          _openCloseTaskButton(task),
          AppBarButton(
            handler: () {},
            tooltip: "Edit the current task",
            icon: PhosphorIcons.pencilSimpleLight,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.only(left: 10.0, right: 10.0, top: 10.0),
        child: RefreshIndicator(
          // color: Colors.black,
          onRefresh: () => Future.delayed(
            const Duration(seconds: 2),
          ),
          child: TaskDetailsBody(task: task),
        ),
      ),
    );
  }

  /// Text displaying task status - whether task is open or done.
  Widget _textStatus(Task task) {
    return Text(" - ${task.done ? "done" : "open"}");
  }

  /// Button for opening or closing the task.
  Widget _openCloseTaskButton(Task task) {
    return AppBarButton(
        handler: () {
          setState(() {
            task.done = !task.done;
          });
        },
        tooltip: "Open or close the current task",
        icon: task.done
            ? PhosphorIcons.arrowsCounterClockwise
            : PhosphorIcons.checkCircle);
  }
}

/// Body for the detailed information of a task in the task-details screen.
class TaskDetailsBody extends StatefulWidget {
  final Task task;
  const TaskDetailsBody({super.key, required this.task});
  @override
  State<TaskDetailsBody> createState() => _TaskDetailsBodyState();
}

class _TaskDetailsBodyState extends State<TaskDetailsBody> {
  Task task = Task();

  @override
  void initState() {
    task = widget.task;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const Text("tags",
              style: TextStyle(
                fontWeight: FontWeight.bold,
              )),
          const SizedBox(
            height: 5,
          ),
          TagsList(
            tags: task.tags,
            size: widget_tag.Size.large,
          ),
          const SizedBox(
            height: 20,
          ),
          const Text("description",
              style: TextStyle(
                fontWeight: FontWeight.bold,
              )),
          const SizedBox(
            height: 5,
          ),
          Text(task.description),
          const SizedBox(
            height: 20,
          ),
          const Text("comments",
              style: TextStyle(
                fontWeight: FontWeight.bold,
              )),
          const SizedBox(
            height: 5,
          ),
          CommentList(comments: widget.task.comments),
        ]);
  }
}
