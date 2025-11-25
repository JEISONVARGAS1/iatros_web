import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iatros_web/core/models/doctor_setting_model.dart';
import 'package:iatros_web/core/models/query_response_model.dart';
import 'package:iatros_web/features/profile/data/profile_api.dart';
import 'package:iatros_web/features/profile/data/profile_api_interface.dart';

abstract class ProfileRepositoryInterface {
  Future<QueryResponseModel> saveWorkTimeList(DoctorSettingModel items);
  Future<QueryResponseModel> updateWorkTimeList(DoctorSettingModel items);
}

class _ProfileRepository implements ProfileRepositoryInterface {
  final ProfileInterface _globalApi;

  _ProfileRepository(ProfileInterface globalApi)
    : _globalApi = globalApi;

  @override
  Future<QueryResponseModel> saveWorkTimeList(DoctorSettingModel items) async {
    try {
      await _globalApi.saveWorkTimeList(items);
      return QueryResponseModel();
    } catch (e) {
      return QueryResponseModel(isSuccessful: false, message: e.toString());
    }
  }
  
  @override
  Future<QueryResponseModel> updateWorkTimeList(DoctorSettingModel items) async {
    try {
      await _globalApi.updateWorkTimeList(items);
      return QueryResponseModel();
    } catch (e) {
      return QueryResponseModel(isSuccessful: false, message: e.toString());
    }
  }
}

final profileRepositoryProvider = Provider<_ProfileRepository>(
  (Ref ref) => _ProfileRepository(ref.read(profileApiProvider)),
);
