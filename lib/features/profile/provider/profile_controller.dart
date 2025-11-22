import 'package:flutter/material.dart';
import 'package:iatros_web/core/enum/days_week_enum.dart';
import 'package:iatros_web/core/extension/date_extension.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:iatros_web/core/models/time_slots_model.dart';
import 'package:iatros_web/core/data/provider/global_controller.dart';
import 'package:iatros_web/features/profile/provider/model/profile_state.dart';

part 'profile_controller.g.dart';

@riverpod
class ProfileController extends _$ProfileController {
  @override
  FutureOr<ProfileState> build() {
    ref.onDispose(() {});

    return ProfileState.initial();
  }

  init() => _getMyUser();

  _getMyUser() {
    ref.listen(globalControllerProvider, (previous, next) {
      final user = next.value!.myUser;

      _setState(state.value!.copyWith(myUser: user));
    }, fireImmediately: true);
  }

  _setState(ProfileState newState) => state = AsyncValue.data(newState);

  // Settings methods
  void updateConsultationDuration(int minutes) {
    final current = state.value!;
    _setState(current.copyWith(consultationDurationMinutes: minutes));
  }

  void addScheduleForDay(DaysWeekEnum weekday, TimeOfDay start, TimeOfDay end) {
    final listWork = state.value!.listTimeSlots.toList();
    final index = listWork.indexWhere((item) => item.dateKey == weekday);

    if (index != -1) {
      listWork[index] = listWork[index].copyWith(
        workDateList: [
          ...listWork[index].workDateList,
          TimeSlotsModel(startWorkHours: start, endWorkHours: end),
        ],
      );
    } else {
      listWork[index].workDateList.add(
        TimeSlotsModel(startWorkHours: start, endWorkHours: end),
      );
    }

    _setState(state.value!.copyWith(listTimeSlots: listWork));
  }

  /* 

  void addScheduleForDay(int weekday, TimeOfDay start, TimeOfDay end) {
    final current = state.value!;
    final newSchedules = Map<int, List<({TimeOfDay start, TimeOfDay end})>>.from(current.schedules);
    if (!newSchedules.containsKey(weekday)) {
      newSchedules[weekday] = [];
    }
    newSchedules[weekday]!.add((start: start, end: end));
    _setState(current.copyWith(schedules: newSchedules));
  }

  void removeScheduleForDay(int weekday, int index) {
    final current = state.value!;
    final newSchedules = Map<int, List<({TimeOfDay start, TimeOfDay end})>>.from(current.schedules);
    if (newSchedules.containsKey(weekday) && newSchedules[weekday]!.length > index) {
      newSchedules[weekday]!.removeAt(index);
      if (newSchedules[weekday]!.isEmpty) {
        newSchedules.remove(weekday);
      }
      _setState(current.copyWith(schedules: newSchedules));
    }
  }


 */

  void removeScheduleForDay(DaysWeekEnum weekday, int index) {
    print(weekday);
  }

  void addSpecificSchedule(DateTime date, TimeOfDay start, TimeOfDay end) {
        final listWork = state.value!.listTimeSlots.toList();
    final index = listWork.indexWhere((item) => item.dateKey == date.toDaysWeekEnum);

    if (index != -1) {
      listWork[index] = listWork[index].copyWith(
        specificDay: date,
        workDateList: [
          ...listWork[index].workDateList,
          TimeSlotsModel(startWorkHours: start, endWorkHours: end),
        ],
      );
    } else {
      listWork[index].copyWith(specificDay: date).workDateList.add(
        TimeSlotsModel(startWorkHours: start, endWorkHours: end),
      );
    }

    _setState(state.value!.copyWith(listTimeSlots: listWork));
  }

  void removeSpecificSchedule(DateTime date, int index) {}

  Future<void> selectDate(
    BuildContext context, {
    required DaysWeekEnum weekday,
    required Function(DaysWeekEnum, TimeOfDay, TimeOfDay) callBack,
  }) async {
    final startTime = await showTimePicker(
      context: context,
      initialTime: const TimeOfDay(hour: 9, minute: 0),
    );
    if (startTime != null && context.mounted) {
      final endTime = await showTimePicker(
        context: context,
        initialTime: const TimeOfDay(hour: 17, minute: 0),
      );
      if (endTime != null) callBack(weekday, startTime, endTime);
    }
  }
}
