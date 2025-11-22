import 'dart:async';

import 'package:iatros_web/core/models/user_model.dart';
import 'package:iatros_web/core/enum/days_week_enum.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:iatros_web/core/models/doctor_setting_model.dart';

part 'profile_state.freezed.dart';

@freezed
sealed class ProfileState with _$ProfileState {
  const factory ProfileState({
    required UserModel myUser,
    StreamSubscription? userSub,
    required List<DaysWeekEnum> listDayWeek,
    required int consultationDurationMinutes,
    required List<WorkTimeModel> listTimeSlots,
  }) = ProfileStateData;

  factory ProfileState.initial() => ProfileState(
    listTimeSlots: [
      WorkTimeModel(dateKey: DaysWeekEnum.MONDAY, workDateList: []),
      WorkTimeModel(dateKey: DaysWeekEnum.TUESDAY, workDateList: []),
      WorkTimeModel(dateKey: DaysWeekEnum.WEDNESDAY, workDateList: []),
      WorkTimeModel(dateKey: DaysWeekEnum.THURSDAY, workDateList: []),
      WorkTimeModel(dateKey: DaysWeekEnum.FRIDAY, workDateList: []),
      WorkTimeModel(dateKey: DaysWeekEnum.SATURDAY, workDateList: []),
      WorkTimeModel(dateKey: DaysWeekEnum.SUNDAY, workDateList: []),
    ],
    myUser: UserModel.init(),
    listDayWeek: DaysWeekEnum.values,
    consultationDurationMinutes: 30,
  );
}
