import 'package:iatros_web/core/api/center_api.dart';
import 'package:iatros_web/core/models/diagnosis_model.dart';
import 'package:iatros_web/core/models/medical_consultation_model.dart';
import 'package:iatros_web/core/models/user_model.dart';

abstract class PatientsInterface extends CenterApi {
  Future<UserModel> getUserById(String document);
  Future<List<DiagnosisModel>> searchDiagnoses(String query);
  Future<MedicalConsultationModel> createMedicalConsultation(MedicalConsultationModel user);
}
