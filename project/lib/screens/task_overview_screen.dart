import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:project/data/sorting_methods.dart';
import 'package:project/utilities/filter.dart';
import 'package:project/utilities/filter_option.dart';
import 'package:project/models/tag.dart';
import 'package:project/providers/auth_provider.dart';
import 'package:project/providers/project_provider.dart';
import 'package:project/providers/task_provider.dart';
import 'package:project/screens/edit_task_screen.dart';
import 'package:project/screens/project_calendar_screen.dart';
import 'package:project/screens/task_details_screen.dart';
import 'package:project/styles/curve_clipper.dart';
import 'package:project/styles/theme.dart';
import 'package:project/widgets/loading_spinner.dart';
import 'package:project/widgets/project_pop_up_menu.dart';
import 'package:project/widgets/app_bar_button.dart';
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
  /// The project to show tasks for.
  Project? _project;
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<Project?>(
      stream: ref.watch(currentProjectProvider),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          _project = snapshot.data!;

          return Scaffold(
            extendBodyBehindAppBar: true,
            appBar: AppBar(
              foregroundColor: Colors.white,
              toolbarHeight: 95,
              title: _appBarTitle(context),
              titleSpacing: -4,
              leading: _backButton(context),
              actions: <Widget>[
                _calendarButton(context),
                _projectPopUpButton(),
              ],
            ),
            body: _TaskOverviewBody(_project!),
            floatingActionButton: _addNewTaskButton(context),
          );
        }
        return const LoadingSpinner();
      },
    );
  }

  /// Returns the button for displaying a pop up menu for projects.
  ProjectPopUpMenu _projectPopUpButton() {
    return ProjectPopUpMenu(
      project: _project!,
      currentRouteName: TaskOverviewScreen.routeName,
    );
  }

  /// Returns the title [Row Widget] for this project, containing
  /// an [Image] and a [Text].
  Row _appBarTitle(BuildContext context) {
    return Row(
      children: [
        Image.asset(
          _project!.imageUrl,
          height: 90,
        ),
        Expanded(
          child: Text(
            _project!.title.toLowerCase(),
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
  AppBarButton _calendarButton(BuildContext context) {
    return AppBarButton(
      handler: () => Navigator.of(context).popAndPushNamed(
          ProjectCalendarScreen.routeName,
          arguments: _project),
      tooltip: "Open calendar for this project",
      icon: PhosphorIcons.calendarCheckLight,
      color: Colors.white,
    );
  }

  /// Button for adding a new task.TaskDetails
  FloatingActionButton _addNewTaskButton(BuildContext context) {
    return FloatingActionButton(
      onPressed: () async {
        ref.read(editTaskProvider.notifier).setTask(null);
        Navigator.of(context)
            .pushNamed(EditTaskScreen.routeName)
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
  late Project _project;
  String _sortType = SortingMethods.dateDesc;

  late Stream<List<Task?>> currentStream;

  @override
  void initState() {
    _project = widget.project;
    super.initState();
  }

  @override
  void didChangeDependencies() {
    currentStream = ref.watch(taskProvider).getTasks(_project.projectId);
    _sort();
    super.didChangeDependencies();
  }

  /// When sorting method is changed by user, sort the list by new method.
  /// [FilterOption] filterOption - The sorting method to use when sorting the task list.
  void _onSortChange(FilterOption filterOption) {
    _sortType = filterOption.description;
    _sort();
  }

  /// Sorts the task list by the chosen method.
  void _sort() {
    switch (_sortType) {
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
          _project.projectId,
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
          _project.projectId,
          filterOptions.map((e) => e.value as Tag).toList());
      setState(() {});
    } else {
      currentStream = ref.watch(taskProvider).getTasks(_project.projectId);
      setState(() {});
    }
  }

  /// Builds the list of tag filter options.
  /// [Project] the project to retrieve the tags of.
  List<FilterOption> _buildTagFilterOptions(Project project) {
    List<FilterOption> options = [];

    for (Tag tag in project.tags) {
      options.add(
          FilterOption(value: tag, description: tag.text, filterBy: false));
    }
    return options;
  }

  /// Searches through the list of tasks with the given query.
  _searchFunction(String query) {
    if (_searchController.text.isEmpty) {
      currentStream = ref.watch(taskProvider).getTasks(
            _project.projectId,
          );
    } else {
      currentStream = ref.watch(taskProvider).searchTask(
            _project.projectId,
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
          final tasks = snapshot.data!;
          return Expanded(
            child: ListView.builder(
              padding: EdgeInsets.zero,
              itemBuilder: ((context, index) => TaskListItem(
                    task: tasks[index]!,
                    handler: () {
                      ref
                          .read(editTaskProvider.notifier)
                          .setTask(tasks[index]!);
                      ref.read(currentTaskProvider.notifier).setTask(ref
                          .watch(taskProvider)
                          .getTask(
                              tasks[index]!.projectId, tasks[index]!.taskId));
                      Navigator.of(context).pushNamed(
                          TaskDetailsScreen.routeName,
                          arguments: _project.collaborators.contains(
                              ref.watch(authProvider).currentUser!.uid));
                    },
                  )),
              itemCount: tasks.length,
            ),
          );
        }
        if (snapshot.hasError) print(snapshot.error);
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
            filterType: FilterType.radio,
          ),
          Filter(
            title: "tags",
            filterOptions: _buildTagFilterOptions(_project),
            filterHandler: _filterByTags,
            filterType: FilterType.check,
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
