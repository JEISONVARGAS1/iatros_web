import 'package:iatros_web/core/api/center_api.dart';
import 'package:iatros_web/core/models/user_model.dart';

abstract class GlobalApiInterface extends CenterApi {
  GlobalApiInterface({super.token});

  Stream<UserModel> getStreamUser(String id);
  Future<UserModel> getUserById(String id);
}
