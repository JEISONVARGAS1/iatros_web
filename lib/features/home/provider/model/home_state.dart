import 'dart:async';

import 'package:flutter/material.dart';
import 'package:iatros_web/core/models/gender.dart';
import 'package:iatros_web/core/models/blood_type.dart';
import 'package:iatros_web/core/models/user_model.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:iatros_web/core/models/time_slots_model.dart';
import 'package:iatros_web/core/models/doctor_setting_model.dart';

part 'home_state.freezed.dart';

@freezed
sealed class HomeState with _$HomeState {
  const factory HomeState({
    required int index,
    required UserModel myUser,
    StreamSubscription? userSub,
    required DateTime dateSelected,
    required PageController pageController,
    required DoctorSettingModel doctorSetting,
    required List<TimeSlotsModel> listTimeSlots,
    required TextEditingController nameController,
    required TextEditingController emailController,
    required TextEditingController phoneController,
    required TextEditingController addressController,
    required TextEditingController lastNameController,
    required ValueNotifier<DateTime?> dateOfBirthNotifier,
    required ValueNotifier<Gender?> selectedGenderNotifier,
    required ValueNotifier<DateTime?> selectedAppointmentDate,
    required ValueNotifier<BloodType?> selectedBloodTypeNotifier,
    required TextEditingController identificationNumberController,
    required ValueNotifier<String?> selectedIdentificationTypeNotifier,
    required ValueNotifier<TimeSlotsModel?> selectedTimeSlotNotifier,
  }) = HomeStateData;

  factory HomeState.initial() => HomeState(
    index: 0,
    listTimeSlots: [],
    myUser: UserModel.init(),
    dateSelected: DateTime.now(),
    pageController: PageController(),
    nameController: TextEditingController(),
    phoneController: TextEditingController(),
    doctorSetting: DoctorSettingModel.init(),
    emailController: TextEditingController(),
    addressController: TextEditingController(),
    lastNameController: TextEditingController(),
    dateOfBirthNotifier: ValueNotifier<DateTime?>(null),
    selectedGenderNotifier: ValueNotifier<Gender?>(null),
    identificationNumberController: TextEditingController(),
    selectedAppointmentDate: ValueNotifier<DateTime?>(null),
    selectedBloodTypeNotifier: ValueNotifier<BloodType?>(null),
    selectedIdentificationTypeNotifier: ValueNotifier<String?>(null),
    selectedTimeSlotNotifier: ValueNotifier<TimeSlotsModel?>(null),
  );
}
