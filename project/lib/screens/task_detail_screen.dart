import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

import '../widgets/appbar_button.dart';
import '../widgets/tag.dart';
import '../widgets/tags_list.dart';

/// Screen/Scaffold for the details of a task in a project
class TaskDetailScreen extends StatefulWidget {
  const TaskDetailScreen({super.key});
  static var task = {
    "title": "Clean house",
    "deadline": "10/10/2022",
    "description":
    "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam.",
    "done": true,
    "tags": <Tag>[
      const Tag(
        size: Size.small,
        color: Color.fromRGBO(255, 0, 0, 1),
        tagText: "urgent",
      ),
    ]
  };

  @override
  State<StatefulWidget> createState() => _TaskDetailsScreenState();
}

class _TaskDetailsScreenState extends State<TaskDetailScreen> {

  var task = {};

  @override
  void initState() {
    task = TaskDetailScreen.task;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const Text(
              'task 1',
            ),
            Visibility(
              visible: true,
              child: _textStatus(),
            ),
          ],
        ),
        titleSpacing: -4,
        leading: AppBarButton(
          handler: () {},
          tooltip: "Go back",
          icon: PhosphorIcons.caretLeftLight,
        ),
        actions: <Widget>[
          _openCloseTaskButton(),
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
          child: const TaskDetailsBody(),
        ),
      ),
    );
  }

  /// Text displaying task status - whether task is open or done.
  Widget _textStatus() {
    return Text(" - ${task['status'] == true ? "done" : "open"}");
  }

  /// Button for opening or closing the task.
  Widget _openCloseTaskButton() {
    return AppBarButton(
        handler: () {
          setState(() {
            task["done"] = task["done"] == true ? false : true;
          });
        },
        tooltip: "Open or close the current task",
        icon: task["done"] == true ? PhosphorIcons.arrowsCounterClockwise : PhosphorIcons.checkCircle);
  }
}

/// Body for the detailed information of a task in the task-details screen.
class TaskDetailsBody extends StatefulWidget {
  const TaskDetailsBody({super.key});

  static TagsList tags = const TagsList(tags: [
    Tag(
      size: Size.small,
      color: Color.fromRGBO(255, 0, 0, 1),
      tagText: "urgent",
    ),
    Tag(
      size: Size.small,
      color: Color.fromRGBO(0, 200, 0, 1),
      tagText: "long-term",
    ),
    Tag(
      size: Size.small,
      color: Color.fromRGBO(255, 0, 200, 1),
      tagText: "recurring",
    ),
  ]);


  @override
  State<TaskDetailsBody> createState() => _TaskDetailsBodyState();
}

class _TaskDetailsBodyState extends State<TaskDetailsBody> {

  TagsList tags = const TagsList(tags:[]);
  String description = "Amet minim mollit non deserunt ullamco est sit aliqua dolor do amet sint. "
      "Velit officia consequat duis enim velit mollit. Exercitation veniam consequat sunt nostrud...";

  @override
  void initState() {
    tags = TaskDetailsBody.tags;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        _taskTags(),
        const SizedBox(height: 20,),
        _description(),
        const SizedBox(height: 20,),
        _comments()
      ]
    );
  }

  /// Tags section - displaying the tags that have been set on the task.
  Widget _taskTags() {
    return Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const Text("tags", style: TextStyle(
            fontWeight: FontWeight.bold,
          )),
          const SizedBox(height: 5,),
          tags]
    );
  }

  /// Description section - displaying the task description.
  Widget _description() {
    return Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const Text("description",
          style: TextStyle(
            fontWeight: FontWeight.bold,
          )),
          const SizedBox(height: 5,),
          Text(description)
        ],
    );
  }

  /// The comment section - displaying all comments to the task.
  Widget _comments() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: const <Widget>[
        Text("comments",
            style: TextStyle(
              fontWeight: FontWeight.bold,
            )),
        SizedBox(height: 5,),
        Text("comments go here")
      ],
    );
  }
}
