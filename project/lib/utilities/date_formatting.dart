import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jiffy/jiffy.dart';
import 'package:project/providers/settings_provider.dart';

/// Represents date formats used in the app.
class DateFormatting {
  /// A long date showing in the format of: "Monday, 21st of October 2022";
  static String longDate(DateTime dateTime) {
    return Jiffy(dateTime).format("EEEE, do of MMMM yyyy");
  }

  /// A short compact date showing in the format the user has decided,
  /// default to "21/20/2022" or "dd/MM/yyyy".
  static String shortDate(WidgetRef ref, DateTime dateTime) {
    return Jiffy(dateTime).format(ref.watch(dateFormatProvider));
  }

  /// Returns time passed since given date time.
  static String timeSince(DateTime dateTime) {
    return Jiffy(dateTime).fromNow();
  }
}
