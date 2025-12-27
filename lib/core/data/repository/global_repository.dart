import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iatros_web/core/data/data/global_api.dart';
import 'package:iatros_web/core/data/data/global_api_interface.dart';
import 'package:iatros_web/core/models/doctor_setting_model.dart';
import 'package:iatros_web/core/models/user_company_model.dart';
import 'package:iatros_web/core/models/user_model.dart';
import 'package:iatros_web/core/models/query_response_model.dart';

abstract class GlobalRepositoryInterface {
  Future<QueryResponseModel<UserModel>> getUserById(String id);
  QueryResponseModel<Stream<UserModel>> getUserStream(String id);
  Future<QueryResponseModel<DoctorSettingModel>> getSettingDoctor(String id);
  QueryResponseModel<Stream<DoctorSettingModel>> getSettingDoctorStream(String id);
  QueryResponseModel<Stream<List<UserCompanyModel>>> getUserCompaniesWithCompanyStream(String userId);
}

class _GlobalRepository implements GlobalRepositoryInterface {
  final GlobalApiInterface _globalApi;

  _GlobalRepository(GlobalApiInterface globalApi) : _globalApi = globalApi;

  @override
  QueryResponseModel<Stream<UserModel>> getUserStream(String id) {
    try {
      final res = _globalApi.getStreamUser(id);
      return QueryResponseModel(data: res);
    } catch (e) {
      return QueryResponseModel(isSuccessful: false, message: e.toString());
    }
  }

  @override
  QueryResponseModel<Stream<DoctorSettingModel>> getSettingDoctorStream(
    String id,
  ) {
    try {
      final res = _globalApi.getStreamSettingDoctor(id);
      return QueryResponseModel(data: res);
    } catch (e) {
      return QueryResponseModel(isSuccessful: false, message: e.toString());
    }
  }

  @override
  Future<QueryResponseModel<UserModel>> getUserById(String id) async {
    try {
      final res = await _globalApi.getUserById(id);
      return QueryResponseModel(data: res);
    } catch (e) {
      return QueryResponseModel(isSuccessful: false, message: e.toString());
    }
  }

  @override
  Future<QueryResponseModel<DoctorSettingModel>> getSettingDoctor(
    String id,
  ) async {
    try {
      final res = await _globalApi.getSettingDoctor(id);
      return QueryResponseModel(data: res);
    } catch (e) {
      return QueryResponseModel(isSuccessful: false, message: e.toString());
    }
  }

  @override
  QueryResponseModel<Stream<List<UserCompanyModel>>> getUserCompaniesWithCompanyStream(String id) {
    try {
      final res = _globalApi.getUserCompaniesWithCompanyStream(id);
      return QueryResponseModel(data: res);
    } catch (e) {
      return QueryResponseModel(isSuccessful: false, message: e.toString());
    }
  }
}

final globalRepositoryProvider = Provider<_GlobalRepository>(
  (Ref ref) => _GlobalRepository(ref.read(globalApiProvider)),
);
