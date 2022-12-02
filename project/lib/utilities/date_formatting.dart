import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jiffy/jiffy.dart';
import 'package:project/models/settings.dart';
import 'package:project/providers/settings_provider.dart';

class DateFormatting {
  static String longDate(DateTime dateTime) {
    return Jiffy(dateTime).format("EEEE, do of MMMM yyyy");
  }

  static String shortDate(WidgetRef ref, DateTime dateTime) {
    return Jiffy(dateTime).format(ref.watch(dateFormatProvider));
  }

  static String timeSince(DateTime dateTime) {
    return Jiffy(dateTime).fromNow();
  }
}
