import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:project/models/filter.dart';
import 'package:project/models/filter_option.dart';
import 'package:project/widgets/appbar_button.dart';
import 'package:project/widgets/filtering_modal.dart';
import 'package:project/widgets/search_bar.dart';
import 'package:project/widgets/tag_widget.dart';
import 'package:project/widgets/task_list_item.dart';
import 'package:project/models/project.dart';
import 'package:project/models/task.dart';

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

  //var displayedItems = List<Map>.from(tasks);

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

  void sortByNearestDeadline() {
    List<Map> sortResults = List<Map>.from(items);
    sortResults.sort((a, b) => (a["deadline"] as String).compareTo(
          (b["deadline"] as String),
        ));

    setState(() {
      items = sortResults.cast<Task>();
    });
  }

  void sortByFurthestDeadline() {
    List<Map> sortResults = List<Map>.from(items);
    sortResults.sort((a, b) => (b["deadline"] as String).compareTo(
          (a["deadline"] as String),
        ));

    setState(() {
      items = sortResults.cast<Task>();
    });
  }

  void filterByTags(Filter filter) {
    // List<FilterOption> filterOptions =
    //     filter.filterOptions.where((element) => element.filterBy).toList();
    //
    // List<Map> filterResults = [];
    // for (Task item in widget.project.tasks) {
    //   for (var element in filterOptions) {
    //     if ((item.tags as List<Tag>).contains(element.filterOption) &&
    //         !filterResults.contains(item)) {
    //       filterResults.add(item);
    //     }
    //   }
    // }
    //
    // if (filterResults.isNotEmpty) {
    //   setState(() {
    //     items = filterResults;
    //   });
    // } else {
    //   setState(() {
    //     items = TaskOverviewBody.tasks;
    //   });
    // }
  }

  /// Filters through task with the given query [String] query - the string to filter through the tasklist for.
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
          filterModal: FilterModal(
            modalTitle: "Sort and filter tasks",
            filters: [
              Filter(
                title: "sort by",
                filterHandler: null,
                filterOptions: [
                  FilterOption(
                    filterOption: const Text("nearest deadline"),
                    filterBy: false,
                    filterHandler: sortByNearestDeadline,
                  ),
                  FilterOption(
                    filterOption: const Text("furthest deadline"),
                    filterBy: false,
                    filterHandler: sortByFurthestDeadline,
                  ),
                ],
                filterType: FilterType.sort,
              ),
              Filter(
                title: "tags",
                filterHandler: filterByTags,
                filterOptions: [
                  FilterOption(
                    filterOption: const TagWidget(
                      size: Size.large,
                      color: Color.fromRGBO(255, 0, 0, 1),
                      tagText: "urgent",
                    ),
                    filterBy: false,
                  ),
                  FilterOption(
                    filterOption: const TagWidget(
                      size: Size.large,
                      color: Color.fromRGBO(4, 0, 255, 1),
                      tagText: "fun",
                    ),
                    filterBy: false,
                  ),
                  FilterOption(
                    filterOption: const TagWidget(
                      size: Size.large,
                      color: Colors.lightGreen,
                      tagText: "green",
                    ),
                    filterBy: false,
                  ),
                  FilterOption(
                    filterOption: const TagWidget(
                      size: Size.large,
                      color: Colors.brown,
                      tagText: "house",
                    ),
                    filterBy: false,
                  ),
                ],
                filterType: FilterType.check,
              ),
            ],
          ),
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
