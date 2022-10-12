import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

/// Represents the theme the app is displaying.
class Themes {
  static Color textColor = Colors.black;

  static ThemeData themeData = ThemeData(
    primarySwatch: Colors.indigo,
    scaffoldBackgroundColor: Colors.white,
    fontFamily: "Comfortaa",
    indicatorColor: Colors.black,
    appBarTheme: const AppBarTheme(
      color: Colors.white,
      foregroundColor: Colors.black,
      shadowColor: Colors.black54,
      elevation: 3,
    ),
    textTheme: textTheme,
  );

  static HeaderStyle calendarHeaderTheme = const HeaderStyle(
    formatButtonVisible: false,
    headerPadding: EdgeInsets.only(top: 10.0, bottom: 10.0),
    titleCentered: true,
  );

  static CalendarStyle calendarTheme = CalendarStyle(
    markerDecoration: BoxDecoration(
      color: Colors.blue.shade900,
      shape: BoxShape.circle,
    ),
    selectedDecoration: BoxDecoration(
      color: Colors.blue.shade400,
      shape: BoxShape.circle,
    ),
    todayDecoration: const BoxDecoration(
      shape: BoxShape.circle,
    ),
    todayTextStyle: const TextStyle(
      fontWeight: FontWeight.w900,
    ),
  );

  static TextTheme textTheme = TextTheme(
    displayMedium: TextStyle(
      fontWeight: FontWeight.w600,
      color: textColor,
      fontSize: 14,
    ),
    displaySmall: TextStyle(
      fontWeight: FontWeight.w500,
      fontSize: 13,
      color: textColor,
    ),
    bodySmall: const TextStyle(
      fontSize: 11,
    ),
    bodyLarge: const TextStyle(fontSize: 12, height: 1.5),
    labelSmall: TextStyle(
      color: textColor.withOpacity(0.54),
      fontSize: 12,
      letterSpacing: 0,
    ),
  );
}
