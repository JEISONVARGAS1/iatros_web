import 'package:flutter/material.dart';

class TimeSlotsModel {
  final TimeOfDay endWorkHours;
  final TimeOfDay startWorkHours;

  TimeSlotsModel({required this.startWorkHours, required this.endWorkHours});

  TimeSlotsModel copyWith({
    TimeOfDay? endWorkHours,
    DateTime? specificDate,
    TimeOfDay? startWorkHours,
  }) => TimeSlotsModel(
    endWorkHours: endWorkHours ?? this.endWorkHours,
    startWorkHours: startWorkHours ?? this.startWorkHours,
  );

  // -------------------------------
  //   FROM JSON (Supabase → Dart)
  // -------------------------------
  factory TimeSlotsModel.fromJson(Map<String, dynamic> json) => TimeSlotsModel(
    startWorkHours: json["start_work_hours"] != null
        ? _stringToTimeOfDay(json["start_work_hours"])
        : const TimeOfDay(hour: 0, minute: 0),

    endWorkHours: json["end_work_hours"] != null
        ? _stringToTimeOfDay(json["end_work_hours"])
        : const TimeOfDay(hour: 0, minute: 0),
  );

  // -------------------------------
  //   TO JSON (Dart → Supabase)
  // -------------------------------
  Map<String, dynamic> toJson() => {
    "end_work_hours": _timeOfDayToString(endWorkHours), // "HH:mm"
    "start_work_hours": _timeOfDayToString(startWorkHours), // "HH:mm"
  };

  // -------------------------------
  //   CONVERTIR TimeOfDay <-> String
  // -------------------------------
  static String _timeOfDayToString(TimeOfDay time) {
    final h = time.hour.toString().padLeft(2, '0');
    final m = time.minute.toString().padLeft(2, '0');
    return "$h:$m"; // Ejemplo: "08:30"
  }

  static TimeOfDay _stringToTimeOfDay(String text) {
    final parts = text.split(":"); // ["08", "30"]
    return TimeOfDay(hour: int.parse(parts[0]), minute: int.parse(parts[1]));
  }
}
