import 'dart:async';
import 'package:flutter/material.dart';
import 'package:iatros_web/router.dart';
import 'package:go_router/go_router.dart';
import 'package:iatros_web/uikit/index.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:iatros_web/core/models/time_slots_model.dart';
import 'package:iatros_web/core/models/user_company_model.dart';
import 'package:iatros_web/core/data/provider/global_controller.dart';
import 'package:iatros_web/core/models/medical_appointment_booking_view.dart';
import 'package:iatros_web/core/models/medical_appointment_booking_model.dart';
import 'package:iatros_web/features/appointment_day/provider/model/appointment_day_state.dart';
import 'package:iatros_web/features/appointment_day/repository/appointment_day_repository.dart';
import 'package:iatros_web/features/appointment_day/pages/widget/appointment_details_dialog.dart';

part 'appointment_day_controller.g.dart';

@riverpod
class AppointmentDayController extends _$AppointmentDayController {
  @override
  FutureOr<AppointmentDayState> build() {
    ref.onDispose(() {
      state.value!.sub!.cancel();
    });
    return AppointmentDayState.initial();
  }

  init(DateTime currentDate) {
    _setState(
      state.value!.copyWith(
        currentDate: currentDate,
        searchController:
            state.value!.searchController ?? TextEditingController(),
      ),
    );
    _getMyUser();
    _addListenerToSearchController();
  }

  List<MedicalAppointmentBookingViewModel> _applyFilters(
    List<MedicalAppointmentBookingViewModel> appointments,
  ) {
    final query = state.value!.searchController!.text.toLowerCase();
    final selectedStatus = state.value!.selectedStatusFilter;
    return appointments.where((appointment) {
      final userName =
          '${appointment.patient.name} ${appointment.patient.lastName}'
              .toLowerCase();

      final userIdentificationNumber =
          '${appointment.patient.identificationNumber} ${appointment.patient.identificationNumber}'
              .toLowerCase();

      final userLastName =
          '$appointment.patient.identificationNumber} ${appointment.patient.identificationNumber}'
              .toLowerCase();
      final matchesSearch =
          userName.contains(query) ||
          userIdentificationNumber.contains(query) ||
          userLastName.contains(query);
      final matchesStatus =
          selectedStatus == null || appointment.status == selectedStatus;
      return matchesSearch && matchesStatus;
    }).toList();
  }

  _addListenerToSearchController() {
    state.value!.searchController!.addListener(() {
      final filteredAppointments = _applyFilters(
        state.value!.medicalAppointmentBooking,
      );

      _setState(
        state.value!.copyWith(
          medicalAppointmentBookingFilter: filteredAppointments,
        ),
      );
    });
  }

  AppointmentDayRepositoryInterface get repository =>
      ref.read(appointmentDayRepositoryProvider);

  _getMyUser() {
    ref.listen(globalControllerProvider, (previous, next) {
      final user = next.value!.myUser;
      final userCompany = next.value!.userCompanySelected;
      _setState(state.value!.copyWith(myUser: user, userCompany: userCompany));

      final userCompanyNotNull = userCompany.id != null;
      final isDoctor = userCompany.rolUser == RolUser.DOCTOR;
      final isSecretary = userCompany.rolUser == RolUser.SECRETARIAT;

      if (userCompanyNotNull && isDoctor) {
        getMedicalAppointmentBooking(userCompany.id!); 
      }
      if (userCompanyNotNull && isSecretary) {
        getMedicalAppointmentBookingFromSecretary(userCompany.id!); 
      }
    }, fireImmediately: true);
  }

  List<TimeSlotsModel> divideTimeSlots(
    List<TimeSlotsModel> slots,
    int minutes,
  ) {
    List<TimeSlotsModel> result = [];
    for (var slot in slots) {
      int startMinutes =
          slot.startWorkHours.hour * 60 + slot.startWorkHours.minute;
      int endMinutes = slot.endWorkHours.hour * 60 + slot.endWorkHours.minute;
      for (
        int current = startMinutes;
        current < endMinutes;
        current += minutes
      ) {
        int next = current + minutes;
        if (next > endMinutes) next = endMinutes;
        TimeOfDay start = TimeOfDay(hour: current ~/ 60, minute: current % 60);
        TimeOfDay end = TimeOfDay(hour: next ~/ 60, minute: next % 60);
        if (start.hour >= 10 && start.hour < 16) continue;
        result.add(TimeSlotsModel(startWorkHours: start, endWorkHours: end));
      }
    }
    return result;
  }

  void getMedicalAppointmentBooking(String doctorId) {
    state.value!.sub?.cancel();

    final res = repository.getMedicalAppointmentBooking(
      doctorId,
      state.value!.currentDate,
    );

    if (res.isSuccessful) {
      final _sub = res.data!.listen((appointments) {
        final filtered = _applyFilters(appointments);
        _setState(
          state.value!.copyWith(
            medicalAppointmentBooking: appointments,
            medicalAppointmentBookingFilter: filtered,
          ),
        );
      });
      _setState(state.value!.copyWith(sub: _sub));
    }
  }

  void getMedicalAppointmentBookingFromSecretary(String doctorId) {
    state.value!.sub?.cancel();

    final res = repository.getMedicalAppointmentBookingFromSecretary(
      state.value!.userCompany.companyId,
      state.value!.currentDate,
    );

    if (res.isSuccessful) {
      final _sub = res.data!.listen((appointments) {
        final filtered = _applyFilters(appointments);
        _setState(
          state.value!.copyWith(
            medicalAppointmentBooking: appointments,
            medicalAppointmentBookingFilter: filtered,
          ),
        );
      });
      _setState(state.value!.copyWith(sub: _sub));
    }
  }

  void showAppointmentDetails(
    BuildContext context,
    MedicalAppointmentBookingViewModel appointment,
  ) {
    showDialog(
      context: context,
      builder: (context) => AppointmentDetailsDialog(
        appointment: appointment,
        onStatusChanged: (newStatus) {
          updateAppointmentStatus(context, appointment.bookingId, newStatus);
        },
      ),
    );
  }

  void goToPatient(BuildContext context, PatientUserModel user) {
    if (context.mounted) {
      final path = AppRoutes.patient.path.replaceFirst(':userId', user.id);
      context.go(path);
    }
  }

  void setStatusFilter(AppointmentStatus? status) {
    _setState(state.value!.copyWith(selectedStatusFilter: status));
    final filteredAppointments = _applyFilters(
      state.value!.medicalAppointmentBooking,
    );
    _setState(
      state.value!.copyWith(
        medicalAppointmentBookingFilter: filteredAppointments,
      ),
    );
  }

  Future<void> updateAppointmentStatus(
    BuildContext context,
    String appointmentId,
    AppointmentStatus newStatus,
  ) async {
    final res = await repository.updateMedicalAppointmentBooking(
      appointmentId,
      newStatus,
    );

    if (res.isSuccessful && context.mounted) context.pop();
  }

  void generateSnackbarMessage(
    BuildContext context, {
    bool isError = false,
    required String message,
  }) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: !isError ? AppColors.error : AppColors.success,
      ),
    );
  }

  _setState(AppointmentDayState newState) => state = AsyncValue.data(newState);
}
