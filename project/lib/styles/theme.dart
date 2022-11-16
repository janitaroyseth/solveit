import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

/// Represents the theme the app is displaying.
class Themes {
  static Color textColor = Colors.black;

  // TODO: fix this shit
  static const MaterialColor primaryColor = MaterialColor(
    0xff5C00F1,
    <int, Color>{
      50: Color.fromRGBO(92, 0, 241, 0.2),
      100: Color.fromRGBO(92, 0, 241, 0.4),
      200: Color.fromRGBO(92, 0, 241, 0.6),
      300: Color.fromRGBO(92, 0, 241, 0.8),
      400: Color.fromRGBO(92, 0, 241, 1),
      500: Color.fromRGBO(92, 0, 241, 1),
      600: Color.fromRGBO(92, 0, 241, 1),
      700: Color.fromRGBO(92, 0, 241, 1),
      800: Color.fromRGBO(92, 0, 241, 1),
      900: Color(0xff5C00F1),
    },
  );

  static const String fontFamily = "Comfortaa";

  static ThemeData themeData = ThemeData(
    primarySwatch: primaryColor,

    // TODO: set this up on screens
    // primaryColor: const Color.fromRGBO(92, 0, 241, 1),
    scaffoldBackgroundColor: Colors.white,
    fontFamily: "Comfortaa",
    indicatorColor: Colors.black,
    // TODO: Fix this.
    bottomSheetTheme: const BottomSheetThemeData(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20.0),
          topRight: Radius.circular(20.0),
        ),
      ),
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.white,
      foregroundColor: Colors.black,
      elevation: 0,
    ),
    textTheme: textTheme,
  );

  static const HeaderStyle calendarHeaderTheme = HeaderStyle(
    formatButtonVisible: false,
    headerPadding: EdgeInsets.only(top: 10.0, bottom: 10.0),
    titleCentered: true,
  );

  static CalendarStyle calendarTheme = CalendarStyle(
    markerDecoration: BoxDecoration(
      color: primaryColor.shade900,
      shape: BoxShape.circle,
    ),
    selectedDecoration: BoxDecoration(
      color: primaryColor.shade300,
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
      fontSize: 12,
    ),
    bodyMedium: const TextStyle(
      fontSize: 13,
      fontWeight: FontWeight.w300,
    ),
    bodyLarge: const TextStyle(
      fontSize: 12,
      height: 1.5,
    ),
    labelLarge: const TextStyle(
      fontSize: 18,
      overflow: TextOverflow.ellipsis,
    ),
    labelMedium: const TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w600,
    ),
    labelSmall: TextStyle(
      color: textColor.withOpacity(0.54),
      fontSize: 12,
      letterSpacing: 0,
      overflow: TextOverflow.ellipsis,
    ),
  );

  static ButtonStyle primaryElevatedButtonStyle = ButtonStyle(
    elevation: MaterialStateProperty.all<double>(0),
    foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
      RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(50.0),
      ),
    ),
  );

  static ButtonStyle secondaryElevatedButtonStyle = ButtonStyle(
    elevation: MaterialStateProperty.all<double>(0),
    backgroundColor: MaterialStateProperty.all<Color>(Colors.white),
    foregroundColor: MaterialStateProperty.all<Color>(
      const Color.fromRGBO(92, 0, 241, 1),
    ),
    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
      RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(50.0),
        side: const BorderSide(
          color: Color.fromRGBO(190, 153, 250, 1),
          width: 1.5,
        ),
      ),
    ),
  );

  static ButtonStyle softPrimaryElevatedButtonStyle = ButtonStyle(
    elevation: MaterialStateProperty.all<double>(0),
    foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
    backgroundColor: MaterialStateProperty.all<Color>(
      primaryColor.withOpacity(0.6),
    ),
    textStyle: MaterialStateProperty.all<TextStyle>(
      const TextStyle(fontSize: 16, fontFamily: Themes.fontFamily),
    ),
    padding: MaterialStateProperty.all<EdgeInsets>(
        const EdgeInsets.symmetric(horizontal: 12.0, vertical: 0.0)),
    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
      RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
    ),
  );

  static ButtonStyle circularButtonStyle = ButtonStyle(
    padding: MaterialStateProperty.all<EdgeInsets>(
      const EdgeInsets.all(11.0),
    ),
    elevation: MaterialStateProperty.all<double>(0),
    shape: MaterialStateProperty.all<OutlinedBorder>(
      const CircleBorder(),
    ),
  );

  static ButtonStyle textButtonStyle = ButtonStyle(
    textStyle: MaterialStateProperty.all<TextStyle>(
      const TextStyle(fontSize: 16, fontFamily: Themes.fontFamily),
    ),
  );
}
