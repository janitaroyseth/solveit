import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:project/widgets/appbar_button.dart';
import 'package:project/widgets/calendar.dart';
import 'package:project/widgets/calendar_task_list.dart';
import 'package:project/widgets/tag_widget.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart';

/// Represents a calnder view of a projects tasks.
class ProjectCalendarScreen extends StatefulWidget {
  const ProjectCalendarScreen({super.key});

  @override
  State<ProjectCalendarScreen> createState() => _ProjectCalendarScreenState();
}

class _ProjectCalendarScreenState extends State<ProjectCalendarScreen> {
  var taskList = [
    {
      "title": "Clean house",
      "deadline": "09/10/2022",
      "description":
          "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam.",
      "tags": <TagWidget>[
        const TagWidget(
          size: Size.small,
          color: Color.fromRGBO(255, 0, 0, 1),
          tagText: "urgent",
        ),
      ]
    },
    {
      "title": "Water flowers",
      "deadline": "10/10/2022",
      "description":
          "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam.",
      "tags": <TagWidget>[
        const TagWidget(
          size: Size.small,
          color: Colors.lightGreen,
          tagText: "green",
        ),
        const TagWidget(
          size: Size.small,
          color: Color.fromRGBO(4, 0, 255, 1),
          tagText: "fun",
        ),
      ]
    },
  ];

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

    /// Creates and returns a [Map] where each deadline in the tasks is a key, and the values
    /// a list of tasks for the deadline.
    Map<DateTime, dynamic> groupTasks() {
      Map<DateTime, dynamic> groupedTasks = {};
      for (var task in taskList) {
        DateTime key =
            DateFormat("dd/MM/yyyy").parse(task["deadline"] as String);

        List<Map> values = taskList
            .where((element) =>
                DateFormat("dd/MM/yyyy").parse(element["deadline"] as String) ==
                key)
            .toList();
        groupedTasks[key] = values;
      }
      return groupedTasks;
    }

    tasks = LinkedHashMap<DateTime, dynamic>(
      equals: isSameDay,
      hashCode: (DateTime key) =>
          key.day * 1000000 + key.month * 10000 + key.year,
    )..addAll(groupTasks());
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
    return Scaffold(
      appBar: AppBar(
        title: const Text("project 1 - calendar"),
        centerTitle: false,
        titleSpacing: -4,
        leading: AppBarButton(
          handler: () {
            Navigator.of(context).pop();
          },
          tooltip: "Add new task",
          icon: PhosphorIcons.caretLeftLight,
        ),
        actions: <Widget>[
          AppBarButton(
            handler: () {},
            tooltip: "Add new task",
            icon: PhosphorIcons.plusLight,
          )
        ],
      ),
      body: Column(
        children: <Widget>[
          Calendar(
            selectedDay: _selectedDay,
            onDaySelected: _onDaySelected,
            eventLoader: _getTasksForDay,
          ),
          CalendarTaskList(
              selectedTasks: _selectedTasks, selectedDay: _selectedDay),
        ],
      ),
    );
  }
}
