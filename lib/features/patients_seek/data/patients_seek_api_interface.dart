import 'package:iatros_web/core/api/center_api.dart';
import 'package:iatros_web/core/models/user_model.dart';

abstract class PatientsSeekInterface extends CenterApi {
  Future<UserModel> createUsers(UserModel use);
  Future<List<UserModel>> getUsers(String document);
}
