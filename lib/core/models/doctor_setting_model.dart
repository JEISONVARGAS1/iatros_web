import 'package:iatros_web/core/enum/days_week_enum.dart';
import 'package:iatros_web/core/models/time_slots_model.dart';

class DoctorSettingModel {
  final String? id;
  final String doctorId;
  final DateTime updateAt;
  final DateTime createAt;
  final int consultationDuration;
  final List<WorkTimeModel> listTimeSlots;

  DoctorSettingModel({
    this.id,
    required this.doctorId,
    required this.createAt,
    required this.updateAt,
    required this.listTimeSlots,
    required this.consultationDuration
,
  });

  DoctorSettingModel copyWith({
    String? id,
    String? doctorId,
    int? consultationDuration,
    List<WorkTimeModel>? listTimeSlots,
  }) => DoctorSettingModel(
    id: id ?? this.id,
    updateAt: updateAt,
    createAt: createAt,
    doctorId: doctorId ?? this.doctorId,
    listTimeSlots: listTimeSlots ?? this.listTimeSlots,
    consultationDuration: consultationDuration ?? this.consultationDuration,
  );

  factory DoctorSettingModel.fromJson(Map<String, dynamic> json) =>
      DoctorSettingModel(
        id: json["id"],
        doctorId: json["doctor_id"],
        consultationDuration: json["consultation_duration"] ?? 0,
        createAt: json["created_at"] != null
            ? DateTime.parse(json["created_at"])
            : DateTime.now(),
        updateAt: json["updated_at"] != null
            ? DateTime.parse(json["updated_at"])
            : DateTime.now(),
        listTimeSlots: List<WorkTimeModel>.from(
          json["list_time_slots"].map((x) => WorkTimeModel.fromJson(x)),
        ),
      );

  factory DoctorSettingModel.init() => DoctorSettingModel(
    doctorId: "",
    listTimeSlots: [],
    consultationDuration: 0,
    createAt: DateTime.now(),
    updateAt: DateTime.now(),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "doctor_id": doctorId,
    "created_at": createAt.toIso8601String(),
    "updated_at": updateAt.toIso8601String(),
    "consultation_duration": consultationDuration,
    "list_time_slots": List<dynamic>.from(listTimeSlots.map((x) => x.toJson())),
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
      json["work_date_list"].map((x) => TimeSlotsModel.fromJson(x)),
    ),
  );

  factory WorkTimeModel.init(DaysWeekEnum key) =>
      WorkTimeModel(specificDay: null, dateKey: key, workDateList: []);

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
