import 'package:flutter/material.dart';

import 'package:table_calendar/table_calendar.dart';

class ProjectCalendarScreen extends StatelessWidget {
  const ProjectCalendarScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Project calendar"),
      ),
      body: TableCalendar(
        headerStyle: const HeaderStyle(
          formatButtonVisible: false,
          headerPadding: EdgeInsets.only(
            top: 20.0,
            bottom: 32.0,
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
        firstDay: DateTime.utc(2018, 10, 16),
        lastDay: DateTime.utc(DateTime.now().year + 10, 3, 14),
        focusedDay: DateTime.now(),
        calendarStyle: const CalendarStyle(
          todayDecoration: BoxDecoration(
            color: Colors.blue,
            shape: BoxShape.circle,
          ),
        ),
      ),
    );
  }
}
