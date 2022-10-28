import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:project/models/filter.dart';
import 'package:project/models/filter_option.dart';
import 'package:project/widgets/appbar_button.dart';
import 'package:project/widgets/filter_modal.dart';
import 'package:project/widgets/search_bar.dart';
import 'package:project/widgets/task_list_item.dart';
import 'package:project/models/project.dart';
import 'package:project/models/task.dart';

import '../static_data/sorting_methods.dart';
import '../models/tag.dart';

/// Screen/Scaffold for the overview of tasks in a project
class TaskOverviewScreen extends StatelessWidget {
  static const routeName = "/tasks";
  const TaskOverviewScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final Project project =
        ModalRoute.of(context)!.settings.arguments as Project;
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
          child: _TaskOverviewBody(project: project),
        ),
      ),
    );
  }
}

/// Body for the overview of tasks in the task-overview screen.
class _TaskOverviewBody extends StatefulWidget {
  final Project project;
  const _TaskOverviewBody({required this.project});

  @override
  State<_TaskOverviewBody> createState() => _TaskOverviewBodyState();
}

class _TaskOverviewBodyState extends State<_TaskOverviewBody> {
  final TextEditingController _searchController = TextEditingController();

  List<Task> items = [];
  String sortType = SortingMethods.dateDesc;

  @override
  void initState() {
    items = widget.project.tasks;
    sort();
    super.initState();
  }

  /// When sorting method is changed by user, sort the list by new method.
  /// [FilterOption] filterOption - The sorting method to use when sorting the task list.
  void onSortChange(FilterOption filterOption) {
    sortType = filterOption.description;
    sort();
  }

  /// Sorts the task list by the chosen method.
  void sort() {
    switch (sortType) {
      case SortingMethods.titleAsc:
        sortByVariable("title", false);
        break;
      case SortingMethods.titleDesc:
        sortByVariable("title", true);
        break;
      case SortingMethods.dateAsc:
        sortByVariable("deadline", false);
        break;
      case SortingMethods.dateDesc:
        sortByVariable("deadline", true);
    }
  }

  /// Sorts the task list by attribute name.
  /// [String] attribute - Name of the attribute by which to sort.
  /// [bool] descending - Whether or not the list should be sorted descending.
  void sortByVariable(String attribute, bool descending) {
    List<Map> sortResults = [];
    for (Task task in items) {
      sortResults.add(task.asMap());
    }
    if (descending) {
      sortResults.sort((a, b) => (a[attribute] as String).compareTo(
            (b[attribute] as String),
          ));
    } else {
      sortResults.sort((a, b) => (b[attribute] as String).compareTo(
            (a[attribute] as String),
          ));
    }
    setState(() {
      items.clear();
      for (Map map in sortResults) {
        items.add(Task(
            title: map["title"],
            description: map["description"],
            tags: map["tags"],
            deadline: map["deadline"],
            done: map["done"],
            comments: map["comments"]));
      }
    });
  }

  /// Filters the task list by the selected tags.
  /// [Filter] filter - the filter containing the tags from which to filter.
  void filterByTags(Filter filter) {
    List<FilterOption> filterOptions =
        filter.filterOptions.where((element) => element.filterBy).toList();

    List<Task> filterResults = [];
    for (Task task in widget.project.tasks) {
      for (FilterOption option in filterOptions) {
        for (Tag tag in task.tags) {
          if (tag.text == option.description && !filterResults.contains(task)) {
            filterResults.add(task);
          }
        }
      }
    }
    if (filterResults.isNotEmpty) {
      setState(() {
        items = filterResults;
      });
    } else {
      setState(() {
        items = widget.project.tasks;
      });
    }
  }

  /// Filters through task with the given query.
  /// [String] query - the string to filter through the tasklist for.
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
    Project project = ModalRoute.of(context)!.settings.arguments as Project;
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
                filterOptions: [
                  FilterOption(
                      description: SortingMethods.dateDesc, filterBy: false),
                  FilterOption(
                      description: SortingMethods.dateAsc, filterBy: false),
                  FilterOption(
                      description: SortingMethods.titleDesc, filterBy: false),
                  FilterOption(
                      description: SortingMethods.titleAsc, filterBy: false),
                ],
                filterHandler: onSortChange,
                filterType: FilterType.sort,
              ),
              Filter(
                  title: "tags",
                  filterOptions: _buildTagFilterOptions(project),
                  filterHandler: filterByTags,
                  filterType: FilterType.tag),
            ],
          ),
        ),
        TaskList(
          tasks: items,
        ),
      ],
    );
  }

  /// Builds the list of tag filter options.
  /// [Project] the project to retrieve the tags of.
  List<FilterOption> _buildTagFilterOptions(Project project) {
    List<FilterOption> options = [];

    for (Tag tag in project.tags) {
      options
          .add(FilterOption(tag: tag, description: tag.text, filterBy: false));
    }
    return options;
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
