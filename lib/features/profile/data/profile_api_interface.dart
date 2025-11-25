import 'package:iatros_web/core/api/center_api.dart';
import 'package:iatros_web/core/models/doctor_setting_model.dart';

abstract class ProfileInterface extends CenterApi {
  Future<void> saveWorkTimeList(DoctorSettingModel items);
  Future<void> updateWorkTimeList(DoctorSettingModel items);
}
