import 'dart:async';

import 'package:flutter/material.dart';
import 'package:iatros_web/core/models/gender.dart';
import 'package:iatros_web/core/models/blood_type.dart';
import 'package:iatros_web/core/models/user_model.dart';
import 'package:iatros_web/core/util/debouncer_util.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:iatros_web/core/models/time_slots_model.dart';
import 'package:iatros_web/core/models/user_company_model.dart';
import 'package:iatros_web/core/models/doctor_setting_model.dart';
import 'package:iatros_web/core/models/notification_result_model.dart';
import 'package:iatros_web/core/models/medical_appointment_booking_model.dart';

part 'home_state.freezed.dart';

@freezed
sealed class HomeState with _$HomeState {
  const factory HomeState({
    required int index,
    required bool loading,
    required UserModel myUser,
    required String countryCode,
    required String phoneNumber,
    required UserModel userFount,
    required DateTime dateSelected,
    StreamSubscription? medicalSub,
    required bool hasTriedToValidate,
    required DebouncerUtil debouncer,
    required UserModel? doctorSelected,
    required String? phoneErrorMessage,
    required GlobalKey<FormState> form,
    required UserCompanyModel userCompany,
    required String selectedSpecialization,
    required PageController pageController,
    required List<UserCompanyModel> doctors,
    required DoctorSettingModel doctorSetting,
    required TimeSlotsModel? timeSlotsSelected,
    required DateTime? selectedAppointmentDate,
    required List<TimeSlotsModel> listTimeSlots,
    required List<UserCompanyModel> doctorsFilter,
    required TextEditingController nameController,
    required TextEditingController emailController,
    required TextEditingController phoneController,
    required TextEditingController addressController,
    required TextEditingController lastNameController,
    required TextEditingController searchDoctorController,
    required ValueNotifier<DateTime?> dateOfBirthNotifier,
    required ValueNotifier<Gender?> selectedGenderNotifier,
    required List<NotificationResultModel> listNotification,
    required ValueNotifier<BloodType?> selectedBloodTypeNotifier,
    required TextEditingController identificationNumberController,
    required ValueNotifier<TimeSlotsModel?> selectedTimeSlotNotifier,
    required ValueNotifier<String?> selectedIdentificationTypeNotifier,
    required List<MedicalAppointmentBookingModel> medicalAppointmentBooking,
  }) = HomeStateData;

  factory HomeState.initial() => HomeState(
    index: 0,
    doctors: [],
    loading: false,
    phoneNumber: "",
    countryCode: "",
    listTimeSlots: [], 
    doctorsFilter: [],
    doctorSelected: null,
    listNotification: [],
    phoneErrorMessage: null,
    timeSlotsSelected: null,
    myUser: UserModel.init(),
    hasTriedToValidate: false,
    selectedSpecialization: "",
    userFount: UserModel.init(),
    form: GlobalKey<FormState>(),
    dateSelected: DateTime.now(),
    medicalAppointmentBooking: [],
    selectedAppointmentDate: null,
    pageController: PageController(),
    userCompany: UserCompanyModel.init(),
    debouncer: DebouncerUtil(seconds: 3),
    nameController: TextEditingController(),
    phoneController: TextEditingController(),
    doctorSetting: DoctorSettingModel.init(),
    emailController: TextEditingController(),
    addressController: TextEditingController(),
    lastNameController: TextEditingController(),
    searchDoctorController: TextEditingController(),
    dateOfBirthNotifier: ValueNotifier<DateTime?>(null),
    selectedGenderNotifier: ValueNotifier<Gender?>(null),
    identificationNumberController: TextEditingController(),
    selectedBloodTypeNotifier: ValueNotifier<BloodType?>(null),
    selectedIdentificationTypeNotifier: ValueNotifier<String?>(null),
    selectedTimeSlotNotifier: ValueNotifier<TimeSlotsModel?>(null),
  );
}
