import 'package:flutter/material.dart';
import 'package:iatros_web/core/enum/days_week_enum.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:iatros_web/core/models/time_slots_model.dart';
import 'package:iatros_web/core/extension/date_extension.dart';
import 'package:iatros_web/core/models/query_response_model.dart';
import 'package:iatros_web/core/models/doctor_setting_model.dart';
import 'package:iatros_web/core/data/provider/global_controller.dart';
import 'package:iatros_web/features/profile/provider/model/profile_state.dart';
import 'package:iatros_web/features/profile/repository/profile_repository.dart';
import 'package:iatros_web/features/lobby/provider/lobby_controller.dart';

part 'profile_controller.g.dart';

@riverpod
class ProfileController extends _$ProfileController {
  @override
  FutureOr<ProfileState> build() => ProfileState.initial();

  ProfileRepositoryInterface get repository =>
      ref.read(profileRepositoryProvider);

  LobbyController get lobbyController =>
      ref.read(lobbyControllerProvider.notifier);

  init() => _getMyUser();

  void openCompanySelectionPanel() => lobbyController.openCompanyPanel();

  _getMyUser() {
    ref.listen(globalControllerProvider, (previous, next) {
      final user = next.value!.myUser;
      final doctorSetting = next.value!.doctorSetting;
      final userCompanySelected = next.value!.userCompanySelected;

      _setState(
        state.value!.copyWith(
          myUser: user,
          setting: doctorSetting,
          userCompany: userCompanySelected,
          listTimeSlots: doctorSetting.listTimeSlots,
          consultationDurationMinutes: doctorSetting.consultationDuration == 0
              ? 30
              : doctorSetting.consultationDuration,
        ),
      );
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
      listWork.add(
        WorkTimeModel(
          dateKey: weekday,
          workDateList: [
            TimeSlotsModel(startWorkHours: start, endWorkHours: end),
          ],
        ),
      );
    }

    _setState(state.value!.copyWith(listTimeSlots: listWork));
  }

  void removeScheduleForDay(DaysWeekEnum weekday, int index) {
    final listWork = state.value!.listTimeSlots.toList();
    final workIndex = listWork.indexWhere((item) => item.dateKey == weekday);

    if (workIndex != -1) {
      final workDateList = listWork[workIndex].workDateList.toList();
      if (index >= 0 && index < workDateList.length) {
        workDateList.removeAt(index);
        listWork[workIndex] = listWork[workIndex].copyWith(
          workDateList: workDateList,
        );
        if (workDateList.isEmpty) {
          listWork.removeAt(workIndex);
        }
      }
    }

    _setState(state.value!.copyWith(listTimeSlots: listWork));
  }

  void addSpecificSchedule(DateTime date, TimeOfDay start, TimeOfDay end) {
    final listWork = state.value!.listTimeSlots.toList();
    final index = listWork.indexWhere(
      (item) => item.dateKey == date.toDaysWeekEnum,
    );

    if (index != -1) {
      listWork[index] = listWork[index].copyWith(
        workDateList: [
          ...listWork[index].workDateList,
          TimeSlotsModel(startWorkHours: start, endWorkHours: end),
        ],
      );
    } else {
      listWork.add(
        WorkTimeModel(
          specificDay: date,
          dateKey: date.toDaysWeekEnum,
          workDateList: [
            TimeSlotsModel(startWorkHours: start, endWorkHours: end),
          ],
        ),
      );
    }

    _setState(state.value!.copyWith(listTimeSlots: listWork));
  }

  void removeSpecificSchedule(DateTime date, int index) {
    final listWork = state.value!.listTimeSlots.toList();
    final workIndex = listWork.indexWhere(
      (item) => item.dateKey == date.toDaysWeekEnum,
    );

    if (workIndex != -1) {
      final workDateList = listWork[workIndex].workDateList.toList();
      if (index >= 0 && index < workDateList.length) {
        workDateList.removeAt(index);
        listWork[workIndex] = listWork[workIndex].copyWith(
          workDateList: workDateList,
        );
        if (workDateList.isEmpty) {
          listWork.removeAt(workIndex);
        }
      }
    }

    _setState(state.value!.copyWith(listTimeSlots: listWork));
  }

  void editScheduleForDay(
    DaysWeekEnum weekday,
    int index,
    TimeOfDay start,
    TimeOfDay end,
  ) {
    final listWork = state.value!.listTimeSlots.toList();
    final workIndex = listWork.indexWhere((item) => item.dateKey == weekday);

    if (workIndex != -1) {
      final workDateList = listWork[workIndex].workDateList.toList();
      if (index >= 0 && index < workDateList.length) {
        workDateList[index] = TimeSlotsModel(
          startWorkHours: start,
          endWorkHours: end,
        );
        listWork[workIndex] = listWork[workIndex].copyWith(
          workDateList: workDateList,
        );
      }
    }

    _setState(state.value!.copyWith(listTimeSlots: listWork));
  }

  void editSpecificSchedule(
    DateTime date,
    int index,
    TimeOfDay start,
    TimeOfDay end,
  ) {
    final listWork = state.value!.listTimeSlots.toList();
    final workIndex = listWork.indexWhere(
      (item) => item.dateKey == date.toDaysWeekEnum,
    );

    if (workIndex != -1) {
      final workDateList = listWork[workIndex].workDateList.toList();
      if (index >= 0 && index < workDateList.length) {
        workDateList[index] = TimeSlotsModel(
          startWorkHours: start,
          endWorkHours: end,
        );
        listWork[workIndex] = listWork[workIndex].copyWith(
          workDateList: workDateList,
        );
      }
    }

    _setState(state.value!.copyWith(listTimeSlots: listWork));
  }

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
      if (endTime != null) {
        callBack(weekday, startTime, endTime);
      }
    }
  }

  saveWorkTimeList(BuildContext context) async {

    if (state.value!.listTimeSlots.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Debe agregar al menos un horario')),
      );
      return;
    }
    if (state.value!.userCompany.id == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Debe primero seleccionar una empresa')),
      );
      return;
    }


    final data = state.value!.setting.copyWith(
      userCompanyId: state.value!.userCompany.id,
      listTimeSlots: state.value!.listTimeSlots,
      consultationDuration: state.value!.consultationDurationMinutes,
    );

    QueryResponseModel res; 
    if (state.value!.setting.id != null) {
      res = await repository.updateWorkTimeList(data);
    } else {
      res = await repository.saveWorkTimeList(data);
    }
    if (res.isSuccessful) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Configuración guardada')));
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(res.message)));
    }
  }
}
