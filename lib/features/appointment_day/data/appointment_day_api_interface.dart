import 'package:iatros_web/core/api/center_api.dart';
import 'package:iatros_web/core/models/medical_appointment_booking_model.dart';
import 'package:iatros_web/core/models/medical_appointment_booking_view.dart';

abstract class AppointmentDayInterface extends CenterApi {
  Stream<List<MedicalAppointmentBookingViewModel>> getMedicalAppointmentBooking(
    String doctorId,
    DateTime day,
  );
  Stream<List<MedicalAppointmentBookingViewModel>>
  getMedicalAppointmentBookingFromCompany(String companyId, DateTime day);
  Future<void> updateMedicalAppointmentBooking(
    String id,
    AppointmentStatus status,
  );
}
