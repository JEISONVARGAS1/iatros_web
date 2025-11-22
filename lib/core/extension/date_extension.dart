import '../enum/days_week_enum.dart';

extension ContextExtension on DateTime {

  DaysWeekEnum get toDaysWeekEnum {
    return DaysWeekEnum.values[weekday - 1];
  }
}