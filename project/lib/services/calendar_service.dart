import 'package:flutter_native_timezone/flutter_native_timezone.dart';
import 'package:device_calendar/device_calendar.dart';
import 'package:flutter/material.dart';
import 'package:project/providers/auth_provider.dart';
import 'package:project/styles/theme.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timezone/standalone.dart';

import '../models/task.dart';

class CalendarService {
  final DeviceCalendarPlugin _deviceCalendarPlugin = DeviceCalendarPlugin();
  Future<List<Calendar>> retrieveCalendars() async {
    //Retrieve user's calendars from mobile device
    //Request permissions first if they haven't been granted
    try {
      var permissionsGranted = await _deviceCalendarPlugin.hasPermissions();
      if (permissionsGranted.isSuccess && !permissionsGranted.data!) {
        permissionsGranted = await _deviceCalendarPlugin.requestPermissions();
        if (!permissionsGranted.isSuccess || !permissionsGranted.data!) {
          return [];
        }
      }

      final calendarsResult = await _deviceCalendarPlugin.retrieveCalendars();
      return calendarsResult.data as List<Calendar>;
    } catch (e) {
      print(e);
      return [];
    }
  }

  void addTasksToCalendar(
      {required List<Task> tasks, required String email}) async {
    String calendarId = await _getCalendar(email) ?? "";
    if (calendarId.isEmpty) return;

    for (Task task in tasks) {
      _addTaskEvent(calendarId, task);
    }
  }

  Future<void> addTaskToCalendar(
      {required Task task, required String email}) async {
    String calendarId = await _getCalendar(email) ?? "";
    if (calendarId.isEmpty) return;
    return _addTaskEvent(calendarId, task);
  }

  void removeTaskFromCalendar(Calendar calendar, Task task) {}

  void _addTaskEvent(String calendarId, Task task) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    // only add if it has a deadline.
    if (task.deadline == null || task.taskId == "") return;

    Event? eventToAdd;
    _fetchEvents(calendarId).then((value) async {
      for (Event event in value) {
        if (event.eventId == prefs.getString(task.taskId)) {
          eventToAdd = event;
          await _deviceCalendarPlugin.deleteEvent(calendarId, event.eventId);
          break;
        }
      }
    });

    // create event
    eventToAdd ??= Event(calendarId);
    TZDateTime startTime =
        TZDateTime.from(task.deadline!, await _fetchLocation());
    eventToAdd!.title = task.title;
    eventToAdd!.start = startTime;
    eventToAdd!.end = startTime.add(const Duration(hours: 1));
    eventToAdd!.description = task.description;
    eventToAdd!.allDay = true;

    // add to calendar
    var result = await _deviceCalendarPlugin.createOrUpdateEvent(eventToAdd);
    if (result!.isSuccess && (result.data?.isNotEmpty ?? false)) {
      prefs.setString(task.taskId, result.data!);
    } else {
      if (result.hasErrors) {
        for (var error in result.errors) {
          print("error: " + error.errorMessage);
        }
      }
    }
  }

  Future<String?> _getCalendar(String email) async {
    _deviceCalendarPlugin.retrieveCalendars().then((value) {
      for (Calendar calendar in value.data!) {
        if (calendar.name == "SolveIt Calendar") {
          return calendar.id;
        }
      }
    });
    return (await _deviceCalendarPlugin.createCalendar("SolveIt Calendar",
            calendarColor: Themes.primaryColor, localAccountName: email))
        .data;
  }

  Future<Location> _fetchLocation() async {
    String timezone = 'Etc/UTC';
    try {
      timezone = await FlutterNativeTimezone.getLocalTimezone();
    } catch (e) {
      print('Could not get the local timezone');
    }
    return getLocation(timezone);
  }

  Future<List<Event>> _fetchEvents(String calendarId) async {
    List<Event> events = [];
    await _deviceCalendarPlugin
        .retrieveEvents(
            calendarId,
            RetrieveEventsParams(
                startDate: DateTime.now(),
                endDate: DateTime.now().add(const Duration(days: 730))))
        .then((value) {
      if (value.hasErrors)
        print("FETCH EVENT ERROR: ${value.errors.first.errorMessage}");
      if (value.data != null) {
        for (Event event in value.data!) {
          events.add(event);
        }
      }
    });
    return events;
  }
}
