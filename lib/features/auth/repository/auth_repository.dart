import 'package:iatros_web/core/models/query_response_model.dart';
import 'package:iatros_web/features/auth/data/auth_api.dart';
import 'package:iatros_web/features/auth/data/auth_api_interface.dart';
import 'package:iatros_web/core/models/user_model.dart';

abstract class AuthRepositoryInterface {
  Future<QueryResponseModel> login(String email, String password);
  Future<QueryResponseModel> register(UserModel user, String password);
  Future<QueryResponseModel> logout();/* 
  Future<QueryResponseModel<UserModel>> getCurrentUser(); */
  Future<QueryResponseModel> resetPassword(String email);
  Future<QueryResponseModel> updatePassword(String newPassword);
}

class AuthRepository implements AuthRepositoryInterface {
  final AuthApiInterface _authApi;

  AuthRepository({AuthApiInterface? authApi}) 
      : _authApi = authApi ?? AuthApi();

  @override
  Future<QueryResponseModel> login(String email, String password) async {
    try {
      final res = await _authApi.login(email, password);
      return QueryResponseModel(data: res);
    } catch (e) {
      return QueryResponseModel(
        isSuccessful: false, 
        message: e.toString()
      );
    }
  }

  @override
  Future<QueryResponseModel> register(UserModel user, String password) async {
    try {
      final res = await _authApi.register(user, password);
      return res;
    } catch (e) {
      return QueryResponseModel(
        isSuccessful: false, 
        message: e.toString()
      );
    }
  }

  @override
  Future<QueryResponseModel> logout() async {
    try {
      final res = await _authApi.logout();
      return res;
    } catch (e) {
      return QueryResponseModel(
        isSuccessful: false, 
        message: e.toString()
      );
    }
  }

/*   @override
  Future<QueryResponseModel<UserModel>> getCurrentUser() async {
    try {
      final res = await _authApi.getCurrentUser();
      return res;
    } catch (e) {
      return QueryResponseModel<UserModel>(
        isSuccessful: false, 
        message: e.toString()
      );
    }
  } */

  @override
  Future<QueryResponseModel> resetPassword(String email) async {
    try {
      final res = await _authApi.resetPassword(email);
      return res;
    } catch (e) {
      return QueryResponseModel(
        isSuccessful: false, 
        message: e.toString()
      );
    }
  }

  @override
  Future<QueryResponseModel> updatePassword(String newPassword) async {
    try {
      final res = await _authApi.updatePassword(newPassword);
      return res;
    } catch (e) {
      return QueryResponseModel(
        isSuccessful: false, 
        message: e.toString()
      );
    }
  }
}
