import 'package:iatros_web/core/api/center_api.dart';
import 'package:iatros_web/core/models/query_response_model.dart';
import 'package:iatros_web/core/models/user_company_model.dart';
import 'package:iatros_web/core/models/user_model.dart';

abstract class AuthApiInterface extends CenterApi {
  AuthApiInterface({super.token});

  Future<QueryResponseModel> logout();
  Future<UserModel> login(String email, String password);
  Future<QueryResponseModel> resetPassword(String email);
  Future<QueryResponseModel> updatePassword(String newPassword);
  Future<QueryResponseModel> register(UserCompanyModel userCompanyModel, String password);
}
