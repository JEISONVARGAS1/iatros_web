import 'package:flutter/animation.dart';
import 'package:iatros_web/core/models/medical_appointment_booking_model.dart';
import 'package:iatros_web/uikit/index.dart';

extension ContextExtension on AppointmentStatus {

  String get toName {
    switch (this) {
      case AppointmentStatus.NOT_BILLED:
        return 'No facturado';
      case AppointmentStatus.WAITING:
        return 'Esperando';
      case AppointmentStatus.COMPLETED:
        return 'Completado';
    }
  }

    Color get toColor{
    switch (this) {
      case AppointmentStatus.NOT_BILLED:
        return AppColors.warning;
      case AppointmentStatus.WAITING:
        return AppColors.primary;
      case AppointmentStatus.COMPLETED:
        return AppColors.success;
    }
  }

}