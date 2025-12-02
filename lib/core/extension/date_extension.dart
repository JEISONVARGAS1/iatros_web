import 'package:flutter/material.dart';

import '../enum/days_week_enum.dart';

extension ContextExtension on DateTime {

  DaysWeekEnum get toDaysWeekEnum {
    return DaysWeekEnum.values[weekday - 1];
  }

}


extension TimeExtension on TimeOfDay {

  String get toHour {
    int hour = this.hour;
    int minute = this.minute;
    String period = hour >= 12 ? 'PM' : 'AM';
    int displayHour = hour == 0 ? 12 : (hour > 12 ? hour - 12 : hour);
    String minuteStr = minute.toString().padLeft(2, '0');
    return '$displayHour:$minuteStr $period';
  }
}