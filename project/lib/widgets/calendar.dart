import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:project/models/project.dart';
import 'package:project/models/task.dart';
import 'package:project/providers/auth_provider.dart';
import 'package:project/providers/task_provider.dart';
import 'package:project/screens/task_details_screen.dart';
import 'package:project/styles/theme.dart';
import 'package:project/utilities/date_formatting.dart';
import 'package:project/widgets/loading_spinner.dart';
import 'package:project/widgets/task_list_item.dart';
import 'package:table_calendar/table_calendar.dart';

/// Calendar spanning from 2021 to 2 years in the future.
class Calendar extends StatefulWidget {
  /// [Project] project to display deadline of tasks in calendar for.
  final Project project;

  final Function selectDay;

  /// Creates an instance of [Calendar], which displays the deadline of the tasks
  /// in the given `project`.
  const Calendar({super.key, required this.project, required this.selectDay});

  @override
  State<Calendar> createState() => _CalendarState();
}

class _CalendarState extends State<Calendar> {
  /// [List] of tasks for the day selected, notifies on value changes.
  late final ValueNotifier<List<dynamic>> _selectedTasks;

  /// [DateTime] day which is focused in the calendar.
  DateTime _focusedDay = DateTime.now();

  /// [Datetime] day which is selected in the calendar.
  DateTime? _selectedDay;

  /// [Map] over [DateTime] deadline as key and [List] of tasks as value.
  late Map<DateTime, dynamic> tasks = {};

  @override
  void initState() {
    super.initState();
    _selectedDay = _focusedDay;

    _selectedTasks = ValueNotifier(_getTasksForDay(_selectedDay!));

    // /// Creates and returns a [Map] where each deadline in the tasks is a key, and the values
    // /// a list of tasks for the deadline.
    // Map<DateTime, dynamic> groupTasks() {
    //   Map<DateTime, dynamic> groupedTasks = {};
    //   for (var task in widget.project.tasks) {
    //     DateTime key = DateTime.parse(task.deadline as String);

    //     List<Task> values = widget.project.tasks
    //         .where(
    //             (element) => DateTime.parse(element.deadline as String) == key)
    //         .toList();
    //     groupedTasks[key] = values;
    //   }
    //   return groupedTasks;
    // }

    // tasks = LinkedHashMap<DateTime, dynamic>(
    //   equals: isSameDay,
    //   hashCode: (DateTime key) =>
    //       key.day * 1000000 + key.month * 10000 + key.year,
    // )..addAll(groupTasks());
  }

  @override
  void didChangeDependencies() {
    //widget.selectDay(_selectedDay);
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _selectedTasks.dispose();
    super.dispose();
  }

  /// Sets the selected day and focused day on an select day event in calendar.
  void _onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    if (!isSameDay(_selectedDay, selectedDay)) {
      setState(() {
        _selectedDay = selectedDay;
        widget.selectDay(_selectedDay);
        _focusedDay = focusedDay;
      });
      _selectedTasks.value = _getTasksForDay(selectedDay);
    }
  }

  /// Returns a [List] of tasks which has deadline for the given [DateTime] day.
  List<dynamic> _getTasksForDay(DateTime day) {
    return tasks[day] ?? [];
  }

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, child) => StreamBuilder<List<Task?>>(
        stream: ref.watch(taskProvider).getTasks(widget.project.projectId),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List<Task?> items = snapshot.data!;

            /// Creates and returns a [Map] where each deadline in the tasks is a key, and the values
            /// a list of tasks for the deadline.
            Map<DateTime, dynamic> groupTasks() {
              Map<DateTime, dynamic> groupedTasks = {};
              for (var task in items) {
                DateTime? key;
                if (task!.deadline != null) {
                  key = task.deadline;
                }
                if (key != null) {
                  List<Task?> values = items
                      .where((element) => element!.deadline == key)
                      .toList();
                  groupedTasks[key] = values;
                }
              }
              return groupedTasks;
            }

            tasks = LinkedHashMap<DateTime, dynamic>(
              equals: isSameDay,
              hashCode: (DateTime key) =>
                  key.day * 1000000 + key.month * 10000 + key.year,
            )..addAll(groupTasks());
            return Column(
              children: <Widget>[
                TableCalendar(
                  rowHeight: 45.0,
                  headerStyle: Themes.calendarHeaderTheme(ref),
                  daysOfWeekStyle: Themes.daysOfWeekStyle(),
                  firstDay: DateTime.utc(2021, 10, 16),
                  lastDay: DateTime.utc(DateTime.now().year + 2, 3, 14),
                  focusedDay: _focusedDay,
                  startingDayOfWeek: StartingDayOfWeek.monday,
                  selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
                  onDaySelected: _onDaySelected,
                  eventLoader: _getTasksForDay,
                  calendarStyle: Themes.calendarTheme(ref),
                  onPageChanged: (newFocusedDay) {
                    _focusedDay = newFocusedDay;
                  },
                ),
                Expanded(
                  child: ValueListenableBuilder(
                    valueListenable: _selectedTasks,
                    builder: (context, List<dynamic> value, child) =>
                        ListView.builder(
                      padding: EdgeInsets.zero,
                      scrollDirection: Axis.vertical,
                      itemCount: value.isEmpty ? 0 : value.length + 1,
                      itemBuilder: (context, index) {
                        if (index == 0) {
                          return Container(
                            padding: const EdgeInsets.only(top: 16.0),
                            child: Text(
                              DateFormatting.longDate(_selectedDay!),
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          );
                        }
                        return TaskListItem(
                          task: value[index - 1],
                          handler: () {
                            ref
                                .read(editTaskProvider.notifier)
                                .setTask(value[index - 1]);
                            ref.read(currentTaskProvider.notifier).setTask(ref
                                .watch(taskProvider)
                                .getTask(value[index - 1].projectId,
                                    value[index - 1].taskId));
                            Navigator.of(context).pushNamed(
                                TaskDetailsScreen.routeName,
                                arguments: widget.project.collaborators
                                    .contains(ref
                                        .watch(authProvider)
                                        .currentUser!
                                        .uid));
                          },
                        );
                      },
                    ),
                  ),
                ),
              ],
            );
          }
          return const LoadingSpinner();
        },
      ),
    );
  }
}
