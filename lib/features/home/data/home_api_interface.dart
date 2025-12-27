import 'package:iatros_web/core/api/center_api.dart';
import 'package:iatros_web/core/models/doctor_setting_model.dart';
import 'package:iatros_web/core/models/medical_appointment_booking_model.dart';
import 'package:iatros_web/core/models/user_company_model.dart';
import 'package:iatros_web/core/models/user_model.dart';

abstract class HomeInterface extends CenterApi {
  Future<UserModel> getUsers(String document);
  Future<UserModel> createUsers(UserModel user);
  Future<UserModel> updateUsers(UserModel user);
  Future<List<MedicalAppointmentBookingModel>> getBookingFromCompany(String id);
  Future<bool> createMedicalAppointmentBooking(
    MedicalAppointmentBookingModel appointment,
  );
  Stream<List<MedicalAppointmentBookingModel>> getMedicalAppointmentBooking(
    String doctorId,
  );
  Future<List<UserCompanyModel>> getDoctorsFromCompany(String companyId);
  Future<DoctorSettingModel> getSettingDoctor(String userCompanyId);
}
