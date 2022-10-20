import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

import '../models/project.dart';
import '../models/task.dart';
import '../widgets/appbar_button.dart';
import '../widgets/search_bar.dart';
import '../widgets/task_list_item.dart';

/// Screen/Scaffold for the overview of tasks in a project
class TaskOverviewScreen extends StatelessWidget {
  const TaskOverviewScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final project = ModalRoute.of(context)!.settings.arguments as Project;
    return Scaffold(
      appBar: AppBar(
        title: Text(project.title),
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
          child: TaskOverviewBody(project: project),
        ),
      ),
    );
  }
}

/// Body for the overview of tasks in the task-overview screen.
class TaskOverviewBody extends StatefulWidget {
  final Project project;
  const TaskOverviewBody({super.key, required this.project});

  @override
  State<TaskOverviewBody> createState() => _TaskOverviewBodyState();
}

class _TaskOverviewBodyState extends State<TaskOverviewBody> {
  final TextEditingController _searchController = TextEditingController();

  List<Task> items = [];

  @override
  void initState() {
    items.addAll(widget.project.tasks);
    super.initState();
  }

  /// Filters through task with the given query string
  /// [query] - the string to filter through the tasklist for.
  void filterSearchResults(String query) {
    if (query.isNotEmpty) {
      List<Task> searchResult = [];
      for (var item in widget.project.tasks) {
        if (item
            .values()
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
        items.addAll(widget.project.tasks);
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
  final List<Task> tasks;
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
              task: widget.tasks[index],
            )),
        itemCount: widget.tasks.length,
      ),
    );
  }
}
