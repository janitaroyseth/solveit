import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

import '../widgets/appbar_button.dart';
import '../widgets/search_bar.dart';
import '../widgets/tag.dart';
import '../widgets/task_list_item.dart';

/// Screen/Scaffold for the overview of tasks in a project
class TaskOverviewScreen extends StatelessWidget {
  const TaskOverviewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("project 1"),
        titleSpacing: -4,
        leading: AppBarButton(
          handler: () {},
          tooltip: "Go back",
          icon: PhosphorIcons.caretLeftLight,
        ),
        actions: <Widget>[
          AppBarButton(
            handler: () {},
            tooltip: "Open calendar for this project",
            icon: PhosphorIcons.calendarLight,
          ),
          AppBarButton(
            handler: () {},
            tooltip: "Edit the current project",
            icon: PhosphorIcons.pencilSimpleLight,
          ),
          AppBarButton(
            handler: () {},
            tooltip: "Add a new task to the current project",
            icon: PhosphorIcons.plusLight,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.only(left: 8.0, right: 8.0),
        child: RefreshIndicator(
          // color: Colors.black,
          onRefresh: () => Future.delayed(
            const Duration(seconds: 2),
          ),
          child: const TaskOverviewBody(),
        ),
      ),
    );
  }
}

/// Body for the overview of tasks in the task-overview screen.
class TaskOverviewBody extends StatefulWidget {
  const TaskOverviewBody({super.key});

  /// Temp list for displaying tasks.
  static var tasks = const [
    {
      "title": "Clean house",
      "deadline": "10/10/2022",
      "description":
          "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam.",
      "tags": <Tag>[
        Tag(
          size: Size.small,
          color: Color.fromRGBO(255, 0, 0, 1),
          tagText: "urgent",
        ),
      ]
    },
    {
      "title": "Water flowers",
      "deadline": "15/10/2022",
      "description":
          "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam.",
      "tags": <Tag>[
        Tag(
          size: Size.small,
          color: Colors.lightGreen,
          tagText: "green",
        ),
        Tag(
          size: Size.small,
          color: Color.fromRGBO(4, 0, 255, 1),
          tagText: "fun",
        ),
      ]
    },
  ];

  @override
  State<TaskOverviewBody> createState() => _TaskOverviewBodyState();
}

class _TaskOverviewBodyState extends State<TaskOverviewBody> {
  final TextEditingController _searchController = TextEditingController();

  List<dynamic> items = [];

  @override
  void initState() {
    items.addAll(TaskOverviewBody.tasks);
    super.initState();
  }

  /// Filters through task with the given query string
  /// [query] - the string to filter through the tasklist for.
  void filterSearchResults(String query) {
    if (query.isNotEmpty) {
      List<Map> searchResult = [];
      for (var item in TaskOverviewBody.tasks) {
        if (item.values
            .toString()
            .toLowerCase()
            .contains(query.toLowerCase())) {
          searchResult.add(item);
        }
      }
      setState(() {
        items.clear();
        items.addAll(searchResult);
      });
      return;
    } else {
      setState(() {
        items.clear();
        items.addAll(TaskOverviewBody.tasks);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        SearchBar(
          textEditingController: _searchController,
          searchFunction: filterSearchResults,
          placeholderText: "Search for tasks",
          // TODO: Add filter modal
          filterModal: const SizedBox(),
        ),
        TaskList(
          tasks: items,
        ),
      ],
    );
  }
}

/// The list over tasks in the project.
class TaskList extends StatefulWidget {
  final List<dynamic> tasks;
  const TaskList({Key? key, required this.tasks}) : super(key: key);

  @override
  State<TaskList> createState() => _TaskListState();
}

class _TaskListState extends State<TaskList> {
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView.builder(
        itemBuilder: ((context, index) => TaskListItem(
              title: widget.tasks[index]["title"] as String,
              deadline: widget.tasks[index]["deadline"],
              description: widget.tasks[index]["description"],
              tags: widget.tasks[index]["tags"],
            )),
        itemCount: widget.tasks.length,
      ),
    );
  }
}
