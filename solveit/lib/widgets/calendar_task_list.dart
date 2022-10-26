import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:solveit/widgets/task_list_item.dart';

/// Represents a list of tasks displayed in calendar.
class CalendarTaskList extends StatelessWidget {
  /// Creates an instance of calendar task list which displays tasks of the
  /// selected day -  [DateTime] from the given selected tasks - [List].
  const CalendarTaskList({
    Key? key,
    required ValueNotifier<List> selectedTasks,
    required DateTime? selectedDay,
  })  : _selectedTasks = selectedTasks,
        _selectedDay = selectedDay,
        super(key: key);

  final ValueNotifier<List> _selectedTasks;
  final DateTime? _selectedDay;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ValueListenableBuilder(
        valueListenable: _selectedTasks,
        builder: (context, List<dynamic> value, child) => ListView.builder(
          scrollDirection: Axis.vertical,
          itemCount: value.isEmpty ? 0 : value.length + 1,
          itemBuilder: (context, index) {
            if (index == 0) {
              return Container(
                padding: const EdgeInsets.only(top: 16.0),
                child: Text(
                  DateFormat("EEEEE, LLLL dd yyyy").format(_selectedDay!),
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                  textAlign: TextAlign.center,
                ),
              );
            }
            return TaskListItem(task: value[index-1]
            );
          },
        ),
      ),
    );
  }
}
