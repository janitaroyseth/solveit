import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:project/models/filter.dart';
import 'package:project/models/filter_option.dart';
import 'package:project/providers/project_provider.dart';
import 'package:project/providers/task_provider.dart';
import 'package:project/screens/configure_task_screen.dart';
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
class TaskOverviewScreen extends ConsumerStatefulWidget {
  static const routeName = "/tasks";

  const TaskOverviewScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      TaskOverviewScreenState();
}

class TaskOverviewScreenState extends ConsumerState {
  String? projectId;
  @override
  Widget build(BuildContext context) {
    Project project;
    return StreamBuilder<Project?>(
      stream: ref.watch(currentProjectProvider),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          project = snapshot.data!;
          projectId = project.projectId;
          return Scaffold(
            extendBodyBehindAppBar: true,
            appBar: AppBar(
              foregroundColor: Colors.white,
              elevation: 0,
              toolbarHeight: 95,
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
                      style: Theme.of(context)
                          .appBarTheme
                          .titleTextStyle!
                          .copyWith(color: Colors.white),
                    ),
                  ),
                  const SizedBox(width: 8.0)
                ],
              ),
              titleSpacing: -4,
              backgroundColor: Colors.transparent,
              leading: AppBarButton(
                handler: () {
                  Navigator.of(context).pop();
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
                  currentRouteName: TaskOverviewScreen.routeName,
                ),
              ],
            ),
            // body: StreamBuilder<List<Task?>>(
            //     stream: ref.watch(taskProvider).getTasks(project.projectId),
            //     builder: (context, snapshot) {
            //       if (snapshot.hasData) {
            body: _TaskOverviewBody(project, []),
            //   }
            //   return const Center(child: CircularProgressIndicator());
            // }),
            floatingActionButton: FloatingActionButton(
              onPressed: () async {
                ref.read(currentProjectProvider.notifier).setProject(
                    ref.watch(projectProvider).getProject(project.projectId));
                Navigator.of(context)
                    .pushNamed(ConfigureTaskScreen.routeName)
                    .whenComplete(() => setState(() {}));
              },
              child: const Icon(
                PhosphorIcons.plus,
                color: Colors.white,
              ),
            ),
          );
        }
        return const Center(child: CircularProgressIndicator());
      },
    );
  }
}

/// Body for the overview of tasks in the task-overview screen.
class _TaskOverviewBody extends ConsumerStatefulWidget {
  final Project project;
  final List<Task?>? tasks;
  const _TaskOverviewBody(this.project, this.tasks);

  @override
  ConsumerState<_TaskOverviewBody> createState() => _TaskOverviewBodyState();
}

class _TaskOverviewBodyState extends ConsumerState<_TaskOverviewBody> {
  final TextEditingController _searchController = TextEditingController();
  late Project project;
  List<Task?> items = [];
  String sortType = SortingMethods.dateDesc;

  late Stream<List<Task?>> currentStream;

  @override
  void initState() {
    project = widget.project;
    items.addAll(widget.tasks!);

    sort();
    super.initState();
  }

  @override
  void didChangeDependencies() {
    currentStream = ref.watch(taskProvider).getTasks(project.projectId);
    super.didChangeDependencies();
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
    if (attribute == "deadline") {
      if (descending) {
        items.sort((b, a) => (a!.toMap()[attribute] as DateTime)
            .compareTo(b!.toMap()[attribute] as DateTime));
      } else {
        items.sort((a, b) => (a!.toMap()[attribute] as DateTime)
            .compareTo(b!.toMap()[attribute] as DateTime));
      }
    } else {
      if (descending) {
        items.sort((b, a) => (a!.toMap()[attribute] as String)
            .compareTo(b!.toMap()[attribute] as String));
      } else {
        items.sort((a, b) => (a!.toMap()[attribute] as String)
            .compareTo(b!.toMap()[attribute] as String));
      }
    }

    setState(() {});
  }

  /// Filters the task list by the selected tags.
  /// [Filter] filter - the filter containing the tags from which to filter.
  void filterByTags(Filter filter) {
    List<FilterOption> filterOptions =
        filter.filterOptions.where((element) => element.filterBy).toList();

    if (filterOptions.isNotEmpty) {
      currentStream = ref.watch(taskProvider).filterTasksByTag(
          project.projectId, filterOptions.map((e) => e.tag!).toList());
      setState(() {});
    } else {
      currentStream = ref.watch(taskProvider).getTasks(project.projectId);
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        ClipPath(
          clipper: CurveClipper(),
          child: Container(
            color: Themes.primaryColor,
            height: Platform.isIOS ? 150 : 130,
          ),
        ),
        SearchBar(
          textEditingController: _searchController,
          searchFunction: /*filterSearchResults*/ (String query) {
            if (_searchController.text.isEmpty) {
              currentStream = ref.watch(taskProvider).getTasks(
                    project.projectId,
                  );
            } else {
              currentStream = ref.watch(taskProvider).searchTask(
                    project.projectId,
                    _searchController.text,
                  );
            }
            setState(() {});
          },
          placeholderText: "Search for tasks",
          filter: true,
          filterModal: FilterModal(
            modalTitle: "Sort and filter tasks",
            filters: [
              Filter(
                title: "sort by",
                filterOptions: [
                  FilterOption(
                    description: SortingMethods.dateDesc,
                    filterBy: false,
                  ),
                  FilterOption(
                    description: SortingMethods.dateAsc,
                    filterBy: false,
                  ),
                  FilterOption(
                    description: SortingMethods.titleAsc,
                    filterBy: false,
                  ),
                  FilterOption(
                    description: SortingMethods.titleDesc,
                    filterBy: false,
                  ),
                ],
                filterHandler: onSortChange,
                filterType: FilterType.sort,
              ),
              Filter(
                title: "tags",
                filterOptions: _buildTagFilterOptions(project),
                filterHandler: filterByTags,
                filterType: FilterType.tag,
              ),
            ],
          ),
        ),
        StreamBuilder<List<Task?>>(
          stream: currentStream,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return TaskList(tasks: snapshot.data!);
            }
            return const Center(child: CircularProgressIndicator());
          },
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
  final List<Task?> tasks;
  // final Project project;
  const TaskList({super.key, required this.tasks});

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
              task: widget.tasks[index] ?? Task(title: "SUCKER"),
            )),
        itemCount: widget.tasks.length,
      ),
    );
  }
}
