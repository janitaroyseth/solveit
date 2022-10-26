import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

import '../models/task.dart';
import '../widgets/appbar_button.dart';
import '../widgets/comment_list.dart';
import '../widgets/tags_list.dart';

/// Screen/Scaffold for the details of a task in a project
class TaskDetailScreen extends StatefulWidget {
  const TaskDetailScreen({super.key});

  @override
  State<StatefulWidget> createState() => _TaskDetailsScreenState();
}

class _TaskDetailsScreenState extends State<TaskDetailScreen> {
  Task task = Task();
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    task = ModalRoute.of(context)!.settings.arguments as Task;
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
          AppBarButton(
              handler: _closeTask,
              tooltip: "Open or close the current task",
              icon: task.done == true
                  ? PhosphorIcons.arrowsCounterClockwiseLight
                  : PhosphorIcons.checkCircleLight),
          AppBarButton(
            handler: () {},
            tooltip: "Edit the current task",
            icon: PhosphorIcons.pencilSimpleLight,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.only(left: 18.0, right: 10.0, top: 18.0),
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

  Text openStatus =
      const Text(" - open", style: TextStyle(color: Colors.green));

  /// Text displaying task status - whether task is open or done.
  Widget _textStatus(Task task) {
    return Text(" - ${task.done ? "done" : "open"}");
  }

  void _closeTask() {
    setState(() {
      task.done = task.done ? false : true;
    });
  }
}

/// Body for the detailed information of a task in the task-details screen.
class TaskDetailsBody extends StatefulWidget {
  const TaskDetailsBody({super.key, required this.task});
  final Task task;

  @override
  State<TaskDetailsBody> createState() => _TaskDetailsBodyState();
}

class _TaskDetailsBodyState extends State<TaskDetailsBody> {
  Task? task;
  TagsList tags = const TagsList(tags: []);

  @override
  Widget build(BuildContext context) {
    task = ModalRoute.of(context)!.settings.arguments as Task;
    tags = TagsList(tags: task!.tags);
    return Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          _taskTags(),
          const SizedBox(
            height: 32,
          ),
          _description(),
          const SizedBox(
            height: 32,
          ),
          _comments()
        ]);
  }

  /// Tags section - displaying the tags that have been set on the task.
  Widget _taskTags() {
    return Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            "tags",
            style: Theme.of(context).textTheme.displayMedium,
          ),
          const SizedBox(
            height: 5,
          ),
          tags
        ]
    );
  }

  /// Description section - displaying the task description.
  Widget _description() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          "description",
          style: Theme.of(context).textTheme.displayMedium,
        ),
        const SizedBox(
          height: 5,
        ),
        Text(
          widget.task.description,
          style: Theme.of(context).textTheme.bodyLarge,
        )
      ],
    );
  }

  /// The comment section - displaying all comments to the task.
  Widget _comments() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          "comments",
          style: Theme.of(context).textTheme.displayMedium,
        ),
        /*TextStyle(
              fontWeight: FontWeight.bold,
            )),*/
        const SizedBox(
          height: 5,
        ),
        // Text(
        //   "comments go here",
        //   style: Theme.of(context).textTheme.bodyLarge,
        // )
        CommentList(comments: widget.task.comments),
      ],
    );
  }
}
