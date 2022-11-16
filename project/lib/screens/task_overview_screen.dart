import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:project/models/filter.dart';
import 'package:project/models/filter_option.dart';
import 'package:project/screens/create_task_screen.dart';
import 'package:project/screens/project_calendar_screen.dart';
import 'package:project/styles/curve_clipper.dart';
import 'package:project/styles/theme.dart';
import 'package:project/widgets/project_pop_up_menu.dart';
import 'package:project/widgets/appbar_button.dart';
import 'package:project/widgets/filter_modal.dart';
import 'package:project/widgets/search_bar.dart';
import 'package:project/widgets/task_list_item.dart';
import 'package:project/models/project.dart';
import 'package:project/models/task.dart';

import '../data/sorting_methods.dart';
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
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        foregroundColor: Colors.white,
        elevation: 0,
        toolbarHeight: 90,
        title: Row(
          children: [
            Image.asset(
              project.imageUrl,
              height: 90,
            ),
            Expanded(
              child: Text(
                project.title.toLowerCase(),
                overflow: TextOverflow.fade,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w300,
                ),
              ),
            ),
            const SizedBox(width: 8.0)
          ],
        ),
        titleSpacing: -4,
        backgroundColor: Colors.transparent,
        leading: AppBarButton(
          handler: () {
            Navigator.pop(context);
          },
          tooltip: "Go back",
          icon: PhosphorIcons.caretLeftLight,
          color: Colors.white,
        ),
        actions: <Widget>[
          AppBarButton(
            handler: () => Navigator.of(context).popAndPushNamed(
                ProjectCalendarScreen.routeName,
                arguments: project),
            tooltip: "Open calendar for this project",
            icon: PhosphorIcons.calendarCheckLight,
            color: Colors.white,
          ),
          ProjectPopUpMenu(
            project: project,
            currentRouteName: routeName,
          ),
        ],
      ),
      body: RefreshIndicator(
        // color: Colors.black,
        onRefresh: () => Future.delayed(
          const Duration(seconds: 2),
        ),
        child: _TaskOverviewBody(project: project),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.pushNamed(
            context, CreateTaskScreen.routeName,
            arguments: project),
        child: const Icon(
          PhosphorIcons.plus,
          color: Colors.white,
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
    items.addAll(widget.project.tasks);
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
    if (descending) {
      items.sort((b, a) => (a.asMap()[attribute] as String)
          .compareTo(b.asMap()[attribute] as String));
    } else {
      items.sort((a, b) => (a.asMap()[attribute] as String)
          .compareTo(b.asMap()[attribute] as String));
    }

    setState(() {});
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
        ClipPath(
          clipper: CurveClipper(),
          child: Container(
            color: Themes.primaryColor,
            height: 150,
          ),
        ),
        SearchBar(
          textEditingController: _searchController,
          searchFunction: filterSearchResults,
          placeholderText: "Search for tasks",
          filter: true,
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
                      description: SortingMethods.titleAsc, filterBy: false),
                  FilterOption(
                      description: SortingMethods.titleDesc, filterBy: false),
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
        padding: EdgeInsets.zero,
        itemBuilder: ((context, index) => TaskListItem(
              task: widget.tasks[index],
            )),
        itemCount: widget.tasks.length,
      ),
    );
  }
}

class _ProjectPopUpMenu extends StatefulWidget {
  final Project project;
  const _ProjectPopUpMenu({required this.project});

  @override
  State<_ProjectPopUpMenu> createState() => __ProjectPopUpMenuState();
}

class __ProjectPopUpMenuState extends State<_ProjectPopUpMenu> {
  @override
  Widget build(BuildContext context) {
    return PopupMenuButton(
      icon: const Icon(
        PhosphorIcons.dotsThreeVertical,
        color: Colors.white,
        size: 34,
      ),
      tooltip: "Menu for project",
      itemBuilder: (context) => [
        const PopupMenuItem(
          value: 0,
          height: 48,
          child: Text("edit project"),
        ),
        PopupMenuItem(
          value: 1,
          height: 48,
          onTap: () {
            Future.delayed(
              const Duration(seconds: 0),
              () => Navigator.of(context).pushReplacementNamed(
                TaskOverviewScreen.routeName,
                arguments: widget.project,
              ),
            );
            setState(() {});
          },
          child: const Text("go to tasks"),
        ),
        PopupMenuItem(
          value: 2,
          height: 48,
          onTap: () {
            Future.delayed(
              const Duration(seconds: 0),
              () => showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text(
                    "deleting project",
                  ),
                  content: Text(
                    "Are you sure you want to delete the project \"${widget.project.title.toLowerCase()}\"",
                  ),
                  actions: [
                    TextButton(
                      onPressed: () {},
                      child: const Text("no"),
                    ),
                    TextButton(
                      onPressed: () {},
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
          },
          child: Text(
            "delete projext",
            style: TextStyle(color: Colors.red.shade900),
          ),
        ),
      ],
    );
  }
}
