import 'package:iatros_web/core/models/medical_appointment_booking_model.dart';
import 'package:iatros_web/core/models/user_company_model.dart';

class MedicalAppointmentBookingViewModel {
  final String userId;
  final String bookingId;
  final DateTime updateAt;
  final DateTime createdAt;
  final String userCompanyId;
  final AppointmentStatus status;
  final DateTime scheduleMedicalAppointment;

  final PatientUserModel patient;
  final UserCompanyModel doctor;

  MedicalAppointmentBookingViewModel({
    required this.userId,
    required this.status,
    required this.doctor,
    required this.patient,
    required this.updateAt,
    required this.bookingId,
    required this.createdAt,
    required this.userCompanyId,
    required this.scheduleMedicalAppointment,
  });

  factory MedicalAppointmentBookingViewModel.fromJson(
      Map<String, dynamic> json) {
    return MedicalAppointmentBookingViewModel(
      bookingId: json['booking_id'],
      userId: json['user_id'],
      userCompanyId: json['user_company_id'],
      status: generateStatus(json['status']),
      createdAt: DateTime.parse(json['created_at']).toLocal(),
      updateAt: DateTime.parse(json['update_at']).toLocal(),
      scheduleMedicalAppointment:
          DateTime.parse(json['schedule_medical_appointment']).toLocal(),

      /// Paciente
      patient: PatientUserModel.fromJson(json),

      /// Doctor
      doctor: UserCompanyModel.fromJson(json),
    );
  }
}


class PatientUserModel {
  final String id;
  final String name;
  final String lastName;
  final String email;
  final String identificationNumber;

  PatientUserModel({
    required this.id,
    required this.name,
    required this.lastName,
    required this.email,
    required this.identificationNumber,
  });

  factory PatientUserModel.fromJson(Map<String, dynamic> json) {
    return PatientUserModel(
      id: json['patient_id'],
      name: json['patient_name'],
      lastName: json['patient_last_name'],
      email: json['patient_email'],
      identificationNumber: json['patient_identification_number'],
    );
  }
}


AppointmentStatus generateStatus(String item) {
  if (item == AppointmentStatus.NOT_BILLED.name) {
    return AppointmentStatus.NOT_BILLED;
  }
  if (item == AppointmentStatus.WAITING.name) {
    return AppointmentStatus.WAITING;
  }

  if (item == AppointmentStatus.COMPLETED.name) {
    return AppointmentStatus.COMPLETED;
  }
  return AppointmentStatus.NOT_BILLED;
}