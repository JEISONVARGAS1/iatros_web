import 'package:iatros_web/core/enum/days_week_enum.dart';
import 'package:iatros_web/core/models/time_slots_model.dart';

class DoctorSettingModel {
  final dynamic userId;
  final List<WorkTimeModel> listWorkTime;

  DoctorSettingModel({required this.userId, required this.listWorkTime});

  DoctorSettingModel copyWith({
    dynamic userId,
    List<WorkTimeModel>? listWorkTime,
  }) => DoctorSettingModel(
    userId: userId ?? this.userId,
    listWorkTime: listWorkTime ?? this.listWorkTime,
  );

  factory DoctorSettingModel.fromJson(Map<String, dynamic> json) =>
      DoctorSettingModel(
        userId: json["user_id"],
        listWorkTime: List<WorkTimeModel>.from(
          json["list_work_time"].map((x) => WorkTimeModel.fromJson(x)),
        ),
      );

  Map<String, dynamic> toJson() => {
    "user_id": userId,
    "list_work_time": List<dynamic>.from(listWorkTime.map((x) => x.toJson())),
  };
}

class WorkTimeModel {
  final DaysWeekEnum dateKey;
  final DateTime? specificDay;
  final List<TimeSlotsModel> workDateList;

  WorkTimeModel({
    required this.dateKey,
    this.specificDay,
    required this.workDateList,
  });

  WorkTimeModel copyWith({
    DateTime? specificDay,
    DaysWeekEnum? dateKey,
    List<TimeSlotsModel>? workDateList,
  }) => WorkTimeModel(
    dateKey: dateKey ?? this.dateKey,
    specificDay: specificDay ?? this.specificDay,
    workDateList: workDateList ?? this.workDateList,
  );

  factory WorkTimeModel.fromJson(Map<String, dynamic> json) => WorkTimeModel(
    specificDay: json["specific_day"] != null
        ? DateTime.parse(json["specific_day"])
        : null,
    dateKey: _generateDaysWeekEnum(json["date_key"] ?? ""),
    workDateList: List<TimeSlotsModel>.from(
      json["work_date_list"].map((x) => TimeSlotsModel.fromJson(json)),
    ),
  );

  Map<String, dynamic> toJson() => {
    "date_key": dateKey.name,
    "specific_day": specificDay?.toIso8601String(),
    "work_date_list": List<dynamic>.from(workDateList.map((x) => x.toJson())),
  };
}

DaysWeekEnum _generateDaysWeekEnum(String value) {
  if (value == DaysWeekEnum.MONDAY.name) return DaysWeekEnum.MONDAY;
  if (value == DaysWeekEnum.TUESDAY.name) return DaysWeekEnum.TUESDAY;
  if (value == DaysWeekEnum.WEDNESDAY.name) return DaysWeekEnum.WEDNESDAY;
  if (value == DaysWeekEnum.THURSDAY.name) return DaysWeekEnum.THURSDAY;
  if (value == DaysWeekEnum.FRIDAY.name) return DaysWeekEnum.FRIDAY;
  if (value == DaysWeekEnum.SATURDAY.name) return DaysWeekEnum.SATURDAY;
  if (value == DaysWeekEnum.SUNDAY.name) return DaysWeekEnum.SUNDAY;
  return DaysWeekEnum.MONDAY;
}
