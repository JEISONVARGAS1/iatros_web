import 'dart:async';

import 'package:flutter/material.dart';
import 'package:iatros_web/core/models/medical_appointment_booking_view.dart';
import 'package:iatros_web/core/models/user_company_model.dart';
import 'package:iatros_web/core/models/user_model.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:iatros_web/core/models/medical_appointment_booking_model.dart';

part 'appointment_day_state.freezed.dart';

@freezed
sealed class AppointmentDayState with _$AppointmentDayState {
  const factory AppointmentDayState({
    required int index,
    StreamSubscription? sub,
    required UserModel myUser,
    required DateTime currentDate,
    required UserCompanyModel userCompany,
    AppointmentStatus? selectedStatusFilter,
    TextEditingController? searchController,
    required List<UserModel> usersClientList,
    required List<MedicalAppointmentBookingViewModel> medicalAppointmentBooking,
    required List<MedicalAppointmentBookingViewModel> medicalAppointmentBookingFilter,
  }) = AppointmentDayStateData;

  factory AppointmentDayState.initial() => AppointmentDayState(
    index: 0,
    usersClientList: [],
    searchController: null,
    myUser: UserModel.init(),
    selectedStatusFilter: null,
    currentDate: DateTime.now(),
    medicalAppointmentBooking: [],
    medicalAppointmentBookingFilter: [],
    userCompany: UserCompanyModel.init(),
  );
}
