import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:project/services/calendar_service.dart';

final calendarProvider = Provider<CalendarService>((ref) {
  final CalendarService calendarService = CalendarService();
  return calendarService;
});
