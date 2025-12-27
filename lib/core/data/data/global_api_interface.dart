import 'package:iatros_web/core/api/center_api.dart';
import 'package:iatros_web/core/models/doctor_setting_model.dart';
import 'package:iatros_web/core/models/user_company_model.dart';
import 'package:iatros_web/core/models/user_model.dart';

abstract class GlobalApiInterface extends CenterApi {
  GlobalApiInterface({super.token});

  Future<UserModel> getUserById(String id);
  Stream<UserModel> getStreamUser(String id);
  Future<DoctorSettingModel> getSettingDoctor(String id);
  Stream<DoctorSettingModel> getStreamSettingDoctor(String id);
  Stream<List<UserCompanyModel>> getUserCompaniesWithCompanyStream(String userId);
}
