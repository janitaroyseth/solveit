import 'package:flutter/material.dart';
import 'package:solveit/styles/theme.dart';
import 'package:table_calendar/table_calendar.dart';

/// Calendar spanning from 2021 to 2 years in the future.
class Calendar extends StatefulWidget {
  /// The [DateTime] selected in the calendar,
  final DateTime? selectedDay;

  /// [Function] for what happens when a date is selected.
  final void Function(DateTime, DateTime)? onDaySelected;

  /// [Function] which returns a list for loading events in the calendar.
  final List<dynamic> Function(DateTime)? eventLoader;

  /// Creates an instant of Calendar, with the given [DateTime] selected day,
  /// [Function] on day selected handler and a [Function] event loader
  /// handler for displaying events in calendar.
  const Calendar({
    super.key,
    required this.selectedDay,
    required this.onDaySelected,
    required this.eventLoader,
  });
  @override
  State<Calendar> createState() => _CalendarState();
}

class _CalendarState extends State<Calendar> {
  DateTime _focusedDay = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return TableCalendar(
      rowHeight: 45.0,
      headerStyle: Themes.calendarHeaderTheme,
      daysOfWeekStyle: const DaysOfWeekStyle(
        weekdayStyle: TextStyle(
          fontWeight: FontWeight.w700,
        ),
        weekendStyle: TextStyle(
          fontWeight: FontWeight.w700,
        ),
      ),
      firstDay: DateTime.utc(2021, 10, 16),
      lastDay: DateTime.utc(DateTime.now().year + 2, 3, 14),
      focusedDay: _focusedDay,
      startingDayOfWeek: StartingDayOfWeek.monday,
      selectedDayPredicate: (day) => isSameDay(widget.selectedDay, day),
      onDaySelected: widget.onDaySelected,
      eventLoader: widget.eventLoader,
      calendarStyle: Themes.calendarTheme,
      onPageChanged: (newFocusedDay) {
        _focusedDay = newFocusedDay;
      },
    );
  }
}
