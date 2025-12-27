import 'package:flutter/material.dart';
import 'package:iatros_web/core/models/medical_appointment_booking_model.dart';
import 'package:iatros_web/features/home/provider/home_controller.dart';
import 'package:iatros_web/features/home/provider/model/home_state.dart';
import 'package:iatros_web/uikit/index.dart';
import 'package:intl/intl.dart';

class AppointmentDayPopup extends StatelessWidget {
  final HomeState state;
  final HomeController controller;
  final DateTime selectedDate;

  const AppointmentDayPopup({
    super.key,
    required this.state,
    required this.controller,
    required this.selectedDate,
  });

  @override
  Widget build(BuildContext context) {
    final appointments = _getAppointmentsForDate();
    final dateFormat = DateFormat('dd/MM/yyyy');
    final timeFormat = DateFormat('HH:mm');

    return AlertDialog(
      title: Text(
        'Citas del ${dateFormat.format(selectedDate)}',
        style: AppTypography.h5.copyWith(color: AppColors.primary),
      ),
      content: SizedBox(
        width: double.maxFinite,
        child: appointments.isEmpty
            ? Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.search_off,
                      size: 48,
                      color: AppColors.textSecondary,
                    ),
                    UIHelpers.verticalSpaceSM,
                    Text(
                      'No hay citas programadas',
                      style: AppTypography.bodyMedium.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              )
            : ListView.builder(
                shrinkWrap: true,
                itemCount: appointments.length,
                itemBuilder: (context, index) {
                  final appointment = appointments[index];
                  return Card(
                    elevation: 2,
                    margin: EdgeInsets.only(bottom: AppSpacing.paddingSM),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: ListTile(
                      leading: Container(
                        width: 12,
                        height: 12,
                        decoration: BoxDecoration(
                          color: Colors.blueAccent,
                          shape: BoxShape.circle,
                        ),
                      ),
                      title: Text(
                        'Cita Médica',
                        style: AppTypography.bodyMedium.copyWith(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text(
                        'Hora: ${timeFormat.format(appointment.scheduleMedicalAppointment)}',
                        style: AppTypography.bodySmall,
                      ),
                      trailing: Icon(
                        Icons.medical_services,
                        color: AppColors.primary,
                      ),
                    ),
                  );
                },
              ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(
            'Cerrar',
            style: AppTypography.button.copyWith(color: AppColors.primary),
          ),
        ),
      ],
    );
  }

  List<MedicalAppointmentBookingModel> _getAppointmentsForDate() {
    return state.medicalAppointmentBooking.where((appointment) {
      final appointmentDate = DateTime(
        appointment.scheduleMedicalAppointment.year,
        appointment.scheduleMedicalAppointment.month,
        appointment.scheduleMedicalAppointment.day,
      );
      final selectedDateOnly = DateTime(
        selectedDate.year,
        selectedDate.month,
        selectedDate.day,
      );
      return appointmentDate.isAtSameMomentAs(selectedDateOnly);
    }).toList();
  }
}