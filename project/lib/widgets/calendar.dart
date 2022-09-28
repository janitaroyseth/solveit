import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

/// Calendar spanning from 2021 to 2 years in the future.
class Calendar extends StatefulWidget {
  /// the [DateTime] selected in the calendar,
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
      rowHeight: 40.0,
      headerStyle: const HeaderStyle(
        formatButtonVisible: false,
        headerPadding: EdgeInsets.only(
          top: 10.0,
          bottom: 10.0,
        ),
        titleCentered: true,
      ),
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
      calendarStyle: CalendarStyle(
        markerDecoration: BoxDecoration(
          color: Colors.blue.shade900,
          shape: BoxShape.circle,
        ),
        selectedDecoration: BoxDecoration(
          color: Colors.blue.shade400,
          shape: BoxShape.circle,
        ),
        selectedTextStyle: isSameDay(widget.selectedDay, DateTime.now())
            ? const TextStyle(
                fontWeight: FontWeight.w900,
                color: Colors.white,
              )
            : const TextStyle(color: Colors.white),
        todayDecoration: const BoxDecoration(
          shape: BoxShape.circle,
        ),
        todayTextStyle: const TextStyle(
          fontWeight: FontWeight.w900,
        ),
      ),
      onPageChanged: (newFocusedDay) {
        _focusedDay = newFocusedDay;
      },
    );
  }
}
