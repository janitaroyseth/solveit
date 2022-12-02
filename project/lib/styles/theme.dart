import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:project/providers/settings_provider.dart';
import 'package:table_calendar/table_calendar.dart';

/// Represents the theme the app is displaying.
class Themes {
  bool isDarkModeSelected(WidgetRef ref) {
    return ref.watch(darkModeProvider);
  }

  static Color textColor(WidgetRef ref) {
    if (ref.watch(darkModeProvider)) {
      return Colors.white;
    }
    return Colors.black;
  }

  // TODO: fix this shit
  static const MaterialColor primaryColor = MaterialColor(
    0xff5C00F1,
    <int, Color>{
      50: Color(0xff9d66f7),
      100: Color(0xff8d4df5),
      200: Color(0xff7d33f4),
      300: Color(0xff6c1af2),
      400: Color(0xff5C00F1),
      500: Color(0xff5300d9),
      600: Color(0xff4a00c1),
      700: Color(0xff4000a9),
      800: Color(0xff370091),
      900: Color(0xff2e0079),
    },
  );

  static const String fontFamily = "Comfortaa";

  static ThemeData themeData(WidgetRef ref) {
    return ThemeData(
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
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: Colors.white,
        unselectedLabelStyle: TextStyle(
          color: Colors.black,
        ),
      ),

      appBarTheme: AppBarTheme(
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.black,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: TextStyle(
          color: textColor(ref),
          fontWeight: FontWeight.w300,
          fontSize: 18,
          fontFamily: fontFamily,
        ),
      ),
      textTheme: textTheme(ref),
      tabBarTheme: const TabBarTheme(
        indicator: UnderlineTabIndicator(
          borderSide: BorderSide(color: primaryColor, width: 3),
        ),
        labelColor: primaryColor,
        unselectedLabelColor: Colors.black,
      ),
    );
  }

  static ThemeData darkTheme(WidgetRef ref) {
    return ThemeData(
      primarySwatch: primaryColor,
      errorColor: Colors.red.shade400,
      backgroundColor: Colors.black,
      scaffoldBackgroundColor: Colors.grey.shade900,
      fontFamily: "Comfortaa",
      indicatorColor: primaryColor,
      radioTheme: RadioThemeData(
          fillColor: MaterialStateProperty.all(primaryColor.shade100)),
      popupMenuTheme: PopupMenuThemeData(
        color: Colors.grey.shade900,
        textStyle: const TextStyle(
            color: Colors.white, fontFamily: fontFamily, fontSize: 16),
      ),
      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: Colors.grey.shade900,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20.0),
            topRight: Radius.circular(20.0),
          ),
        ),
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: Color.fromARGB(255, 21, 21, 21),
        unselectedLabelStyle: TextStyle(
          color: Colors.white,
        ),
      ),
      bottomAppBarColor: const Color.fromARGB(255, 21, 21, 21),
      appBarTheme: AppBarTheme(
        surfaceTintColor: Colors.black,
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: TextStyle(
          color: textColor(ref),
          fontWeight: FontWeight.w300,
          fontSize: 18,
          fontFamily: fontFamily,
        ),
      ),
      dialogBackgroundColor: Colors.grey.shade900,
      textTheme: textTheme(ref),
      tabBarTheme: TabBarTheme(
        indicator: UnderlineTabIndicator(
          borderSide: BorderSide(color: primaryColor.shade50, width: 3),
        ),
        labelColor: primaryColor.shade50,
        unselectedLabelColor: Colors.white,
        overlayColor: MaterialStateProperty.all(Colors.black),
      ),
      inputDecorationTheme: InputDecorationTheme(
        labelStyle: textTheme(ref).labelLarge,
        hintStyle: textTheme(ref).labelSmall,
        helperStyle: textTheme(ref).labelSmall,
        floatingLabelBehavior: FloatingLabelBehavior.always,
        border: UnderlineInputBorder(
          borderSide: BorderSide(
            color: Themes.textColor(ref).withOpacity(0.4),
          ),
        ),
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(
            color: Themes.textColor(ref).withOpacity(0.4),
          ),
        ),
      ),
      dialogTheme: DialogTheme(
        titleTextStyle: TextStyle(
            fontSize: 16, color: textColor(ref), fontFamily: fontFamily),
      ),
    );
  }

  static InputDecoration inputDecoration(
      WidgetRef ref, String label, String placeholderText) {
    return InputDecoration(
      labelStyle: textTheme(ref).labelLarge,
      label: Text(label, style: TextStyle(color: Themes.textColor(ref))),
      hintText: placeholderText,
      hintStyle: textTheme(ref).labelSmall!.copyWith(
            color: textColor(ref),
          ),
      floatingLabelBehavior: FloatingLabelBehavior.always,
      border: UnderlineInputBorder(
        borderSide: BorderSide(
          color: Themes.textColor(ref).withOpacity(0.4),
        ),
      ),
      enabledBorder: UnderlineInputBorder(
        borderSide: BorderSide(
          color: Themes.textColor(ref).withOpacity(0.4),
        ),
      ),
    );
  }

  static HeaderStyle calendarHeaderTheme(WidgetRef ref) {
    return HeaderStyle(
      formatButtonVisible: false,
      headerPadding: const EdgeInsets.only(top: 10.0, bottom: 10.0),
      titleCentered: true,
      leftChevronIcon: Icon(
        PhosphorIcons.caretLeftLight,
        size: 20,
        color: textColor(ref),
      ),
      rightChevronIcon: Icon(
        PhosphorIcons.caretRightLight,
        size: 20,
        color: textColor(ref),
      ),
    );
  }

  static CalendarStyle calendarTheme(WidgetRef ref) {
    return CalendarStyle(
      markerDecoration: BoxDecoration(
        color: primaryColor.shade50,
        shape: BoxShape.circle,
      ),
      selectedDecoration: BoxDecoration(
        color: primaryColor.shade600,
        shape: BoxShape.circle,
      ),
      todayDecoration: const BoxDecoration(
        shape: BoxShape.circle,
      ),
      todayTextStyle: const TextStyle(
        fontWeight: FontWeight.w900,
      ),
      weekendTextStyle: TextStyle(
        color: textColor(ref),
      ),
    );
  }

  static DaysOfWeekStyle daysOfWeekStyle() {
    return const DaysOfWeekStyle(
      weekdayStyle: TextStyle(
        fontWeight: FontWeight.w700,
      ),
      weekendStyle: TextStyle(
        fontWeight: FontWeight.w700,
      ),
    );
  }

  static TextTheme textTheme(ref) {
    bool isDarkMode = ref.watch(darkModeProvider);
    return TextTheme(
      displayLarge: TextStyle(
        fontSize: 40,
        fontWeight: FontWeight.w300,
        color: textColor(ref),
      ),
      displayMedium: TextStyle(
        fontSize: 20,
        color: isDarkMode ? primaryColor.shade50 : primaryColor,
        fontWeight: FontWeight.w600,
      ),
      displaySmall: TextStyle(
        color: textColor(ref),
        fontWeight: FontWeight.w300,
        fontSize: 18,
      ),
      titleMedium: TextStyle(
        fontWeight: FontWeight.w500,
        fontSize: 13,
        color: textColor(ref),
      ),
      titleSmall: TextStyle(
        color: textColor(ref),
      ),
      bodySmall: TextStyle(
        color: textColor(ref).withOpacity(0.8),
        fontSize: 12,
      ),
      bodyMedium: TextStyle(
        color: textColor(ref),
        fontSize: 13,
        fontWeight: FontWeight.w300,
      ),
      bodyLarge: TextStyle(
        color: textColor(ref),
        fontSize: 12,
        height: 1.5,
      ),
      labelLarge: TextStyle(
        color: textColor(ref),
        fontSize: 18,
        fontWeight: FontWeight.w500,
        overflow: TextOverflow.ellipsis,
      ),
      labelMedium: TextStyle(
        color: textColor(ref),
        fontSize: 14,
        fontWeight: FontWeight.w500,
      ),
      labelSmall: TextStyle(
        color: textColor(ref),
        fontSize: 12,
        letterSpacing: 0,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }

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

  static ButtonStyle textButtonStyle(WidgetRef ref) {
    bool isDarkMode = ref.watch(darkModeProvider);
    if (isDarkMode) {
      return ButtonStyle(
        padding: MaterialStateProperty.all(
          EdgeInsets.all(12.0),
        ),
        foregroundColor: MaterialStateProperty.all(primaryColor.shade50),
        textStyle: MaterialStateProperty.all<TextStyle>(
          TextStyle(
            color: primaryColor.shade50,
            fontSize: 16,
            fontFamily: fontFamily,
          ),
        ),
      );
    }
    return ButtonStyle(
      textStyle: MaterialStateProperty.all<TextStyle>(
        const TextStyle(fontSize: 16, fontFamily: fontFamily),
      ),
    );
  }

  static ButtonStyle formButtonStyle(WidgetRef ref) {
    return ButtonStyle(
      padding: MaterialStateProperty.all(EdgeInsets.zero),
      foregroundColor: MaterialStateProperty.all<Color>(textColor(ref)),
      textStyle: MaterialStateProperty.all<TextStyle>(
        const TextStyle(
          fontSize: 12,
          fontFamily: Themes.fontFamily,
        ),
      ),
    );
  }
}
