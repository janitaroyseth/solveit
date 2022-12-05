import 'package:flutter_native_timezone/flutter_native_timezone.dart';
import 'package:device_calendar/device_calendar.dart';
import 'package:project/models/task.dart';
import 'package:project/styles/theme.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timezone/standalone.dart';

class CalendarService {
  final DeviceCalendarPlugin _deviceCalendarPlugin = DeviceCalendarPlugin();
  Future<List<Calendar>> retrieveCalendars() async {
    //Retrieve user's calendars from mobile device
    //Request permissions first if they haven't been granted
    if (!await _checkPermissions()) return [];
    try {
      final calendarsResult = await _deviceCalendarPlugin.retrieveCalendars();
      return calendarsResult.data as List<Calendar>;
    } catch (e) {
      print(e);
      return [];
    }
  }

  Future<bool> _checkPermissions() async {
    var permissionsGranted = await _deviceCalendarPlugin.hasPermissions();
    if (permissionsGranted.isSuccess && !permissionsGranted.data!) {
      permissionsGranted = await _deviceCalendarPlugin.requestPermissions();
      if (!permissionsGranted.isSuccess || !permissionsGranted.data!) {
        return false;
      }
    }
    return true;
  }

  void addTasksToCalendar(
      {required List<Task> tasks, required String email}) async {
    if (!await _checkPermissions()) return;
    var permissionsGranted = await _deviceCalendarPlugin.hasPermissions();
    if (permissionsGranted.isSuccess && !permissionsGranted.data!) {}
    await _getCalendar(email).then(
      (value) async {
        for (Task task in tasks) {
          await _addTaskEvent(value, task);
        }
      },
    );
  }

  Future<void> addTaskToCalendar(
      {required Task task, required String email}) async {
    if (!await _checkPermissions()) return;
    _getCalendar(email).then((value) {
      if (value.isNotEmpty) {
        _addTaskEvent(value, task);
      }
    });
  }

  void removeTaskFromCalendar(String email, Task task) async {
    if (!await _checkPermissions()) return;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _getCalendar(email).then(
      (value) {
        _deviceCalendarPlugin.deleteEvent(value, prefs.getString(task.taskId));
      },
    );
  }

  Future<void> _addTaskEvent(String calendarId, Task task) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    // only add if it has a deadline.
    if (task.deadline == null || task.taskId == "") return;

    Event? eventToAdd;
    await _fetchEvents(calendarId).then((value) async {
      for (Event event in value) {
        print("existing event id: ${event.eventId}");
        if (event.eventId == prefs.getString(task.taskId)) {
          eventToAdd = event;
          // await _deviceCalendarPlugin
          //     .deleteEvent(calendarId, event.eventId)
          //     .then((value) => print(
          //         "old event with id ${event.eventId} deleted: ${value.data}"));
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
      print("successfully added event with id: ${result.data}");
      prefs.setString(task.taskId, result.data!);
    } else {
      if (result.hasErrors) {
        for (var error in result.errors) {
          print("error: " + error.errorMessage);
        }
      }
    }
  }

  Future<String> _getCalendar(String email) async {
    String calendarId = "";
    await _deviceCalendarPlugin.retrieveCalendars().then((value) async {
      for (Calendar calendar in value.data!) {
        print("calendar: ${calendar.id} : ${calendar.name}");
        if (calendar.name == "SolveIt Calendar") {
          print("${calendar.name} : ${calendar.id}");
          calendarId = calendar.id ?? "";
          break;
        }
      }
      if (calendarId == "") {
        calendarId = (await _deviceCalendarPlugin.createCalendar(
                    "SolveIt Calendar",
                    calendarColor: Themes.primaryColor,
                    localAccountName: email))
                .data ??
            "";
      }
    });
    return calendarId;
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
      print(
          "fetch event result: hasError: ${value.hasErrors}, data: ${value.data}");
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
