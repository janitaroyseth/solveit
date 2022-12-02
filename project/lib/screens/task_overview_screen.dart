import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:project/data/sorting_methods.dart';
import 'package:project/models/filter.dart';
import 'package:project/models/filter_option.dart';
import 'package:project/models/tag.dart';
import 'package:project/providers/project_provider.dart';
import 'package:project/providers/task_provider.dart';
import 'package:project/screens/configure_task_screen.dart';
import 'package:project/screens/project_calendar_screen.dart';
import 'package:project/styles/curve_clipper.dart';
import 'package:project/styles/theme.dart';
import 'package:project/widgets/loading_spinner.dart';
import 'package:project/widgets/project_pop_up_menu.dart';
import 'package:project/widgets/appbar_button.dart';
import 'package:project/widgets/filter_modal.dart';
import 'package:project/widgets/search_bar.dart';
import 'package:project/widgets/task_list_item.dart';
import 'package:project/models/project.dart';
import 'package:project/models/task.dart';

/// Screen/Scaffold for the overview of tasks in a project
class TaskOverviewScreen extends ConsumerStatefulWidget {
  /// Named route for this screen.
  static const routeName = "/tasks";

  /// Creates an instance of [TaskOverviewScreen].
  const TaskOverviewScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      TaskOverviewScreenState();
}

class TaskOverviewScreenState extends ConsumerState {
  @override
  Widget build(BuildContext context) {
    Project project;

    return StreamBuilder<Project?>(
      stream: ref.watch(currentProjectProvider),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          project = snapshot.data!;

          return Scaffold(
            extendBodyBehindAppBar: true,
            appBar: AppBar(
              foregroundColor: Colors.white,
              toolbarHeight: 95,
              title: _appBarTitle(project, context),
              titleSpacing: -4,
              leading: _backButton(context),
              actions: <Widget>[
                _calendarButton(context, project),
                _projectPopUpButton(project),
              ],
            ),
            body: _TaskOverviewBody(project),
            floatingActionButton: _addNewTaskButton(project, context),
          );
        }
        return const LoadingSpinner();
      },
    );
  }

  /// Returns the button for displaying a pop up menu for projects.
  ProjectPopUpMenu _projectPopUpButton(Project project) {
    return ProjectPopUpMenu(
      project: project,
      currentRouteName: TaskOverviewScreen.routeName,
    );
  }

  /// Returns the title [Row Widget] for this project, containing
  /// an [Image] and a [Text].
  Row _appBarTitle(Project project, BuildContext context) {
    return Row(
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
    );
  }

  /// Button for going back to previous screen.
  AppBarButton _backButton(BuildContext context) {
    return AppBarButton(
      handler: () {
        Navigator.of(context).pop();
      },
      tooltip: "Go back",
      icon: PhosphorIcons.caretLeftLight,
      color: Colors.white,
    );
  }

  /// Button for navigating to the [CalendarScreen].
  AppBarButton _calendarButton(BuildContext context, Project project) {
    return AppBarButton(
      handler: () => Navigator.of(context)
          .popAndPushNamed(ProjectCalendarScreen.routeName, arguments: project),
      tooltip: "Open calendar for this project",
      icon: PhosphorIcons.calendarCheckLight,
      color: Colors.white,
    );
  }

  /// Button for adding a new task.TaskDetails
  FloatingActionButton _addNewTaskButton(
      Project project, BuildContext context) {
    return FloatingActionButton(
      onPressed: () async {
        ref.read(editTaskProvider.notifier).setTask(null);
        Navigator.of(context)
            .pushNamed(ConfigureTaskScreen.routeName)
            .whenComplete(() => setState(() {}));
      },
      child: const Icon(
        PhosphorIcons.plus,
        color: Colors.white,
      ),
    );
  }
}

/// Body for the overview of tasks in the task-overview screen.
class _TaskOverviewBody extends ConsumerStatefulWidget {
  final Project project;
  const _TaskOverviewBody(this.project);

  @override
  ConsumerState<_TaskOverviewBody> createState() => _TaskOverviewBodyState();
}

class _TaskOverviewBodyState extends ConsumerState<_TaskOverviewBody> {
  final TextEditingController _searchController = TextEditingController();
  late Project project;
  String sortType = SortingMethods.dateDesc;

  late Stream<List<Task?>> currentStream;

  @override
  void initState() {
    project = widget.project;
    super.initState();
  }

  @override
  void didChangeDependencies() {
    currentStream = ref.watch(taskProvider).getTasks(project.projectId);
    _sort();
    super.didChangeDependencies();
  }

  /// When sorting method is changed by user, sort the list by new method.
  /// [FilterOption] filterOption - The sorting method to use when sorting the task list.
  void _onSortChange(FilterOption filterOption) {
    sortType = filterOption.description;
    _sort();
  }

  /// Sorts the task list by the chosen method.
  void _sort() {
    switch (sortType) {
      case SortingMethods.titleAsc:
        _sortByVariable("title", false);
        break;
      case SortingMethods.titleDesc:
        _sortByVariable("title", true);
        break;
      case SortingMethods.dateAsc:
        _sortByVariable("deadline", false);
        break;
      case SortingMethods.dateDesc:
        _sortByVariable("deadline", true);
    }
  }

  /// Sorts the task list by attribute name.
  /// [String] attribute - Name of the attribute by which to sort.
  /// [bool] descending - Whether or not the list should be sorted descending.
  void _sortByVariable(String attribute, bool descending) {
    currentStream = ref.watch(taskProvider).getTasks(
          project.projectId,
          field: attribute,
          descending: descending,
        );

    setState(() {});
  }

  /// Filters the task list by the selected tags.
  /// [Filter] filter - the filter containing the tags from which to filter.
  void _filterByTags(Filter filter) {
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

  /// Searches through the list of tasks with the given query.
  _searchFunction(String query) {
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
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        _curvedBackground(),
        _searchBar(),
        _taskList(),
      ],
    );
  }

  /// Returns a streambuilder displaying the tasks
  /// for the project.
  StreamBuilder<List<Task?>> _taskList() {
    return StreamBuilder<List<Task?>>(
      stream: currentStream,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return TaskList(tasks: snapshot.data!);
        }
        if (snapshot.hasError) {
          showDialog(
            context: context,
            builder: (context) => const DataErrorDialog(),
          );
        }
        return const LoadingSpinner();
      },
    );
  }

  /// The searchbar customized for task list.
  SearchBar _searchBar() {
    return SearchBar(
      textEditingController: _searchController,
      searchFunction: _searchFunction,
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
            filterHandler: _onSortChange,
            filterType: FilterType.sort,
          ),
          Filter(
            title: "tags",
            filterOptions: _buildTagFilterOptions(project),
            filterHandler: _filterByTags,
            filterType: FilterType.tag,
          ),
        ],
      ),
    );
  }

  /// Curbed background displayed behind appbar.
  ClipPath _curvedBackground() {
    return ClipPath(
      clipper: CurveClipper(),
      child: Container(
        color: Themes.primaryColor,
        height: Platform.isIOS ? 150 : 130,
      ),
    );
  }
}

class DataErrorDialog extends ConsumerWidget {
  const DataErrorDialog({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AlertDialog(
      title: const Text("An error occured"),
      content: const Text(
          "An error occured while loading data, if problem persists please contact customer service"),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(
            "close",
            style: TextStyle(
              color: Themes.textColor(ref),
            ),
          ),
        )
      ],
    );
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
              task: widget.tasks[index]!,
            )),
        itemCount: widget.tasks.length,
      ),
    );
  }
}
