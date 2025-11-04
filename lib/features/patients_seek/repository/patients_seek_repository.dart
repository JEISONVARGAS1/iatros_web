import 'package:iatros_web/core/models/user_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iatros_web/core/models/query_response_model.dart';
import 'package:iatros_web/features/patients_seek/data/patients_seek_api.dart';
import 'package:iatros_web/features/patients_seek/data/patients_seek_api_interface.dart';

abstract class PatientsSeekRepositoryInterface {
  Future<QueryResponseModel<List<UserModel>>> getUsers(String id);
  Future<QueryResponseModel<UserModel>> createUsers(UserModel user);
}

class _PatientsSeekRepository implements PatientsSeekRepositoryInterface {
  final PatientsSeekInterface _globalApi;

  _PatientsSeekRepository(PatientsSeekInterface globalApi)
    : _globalApi = globalApi;

  @override
  Future<QueryResponseModel<List<UserModel>>> getUsers(String id) async {
    try {
      final res = await _globalApi.getUsers(id);
      return QueryResponseModel(data: res);
    } catch (e) {
      return QueryResponseModel(isSuccessful: false, message: e.toString());
    }
  }

  @override
  Future<QueryResponseModel<UserModel>> createUsers(UserModel user) async {
    try {
      final res = await _globalApi.createUsers(user);
      return QueryResponseModel(data: res);
    } catch (e) {
      return QueryResponseModel(isSuccessful: false, message: e.toString());
    }
  }
}

final patientSeekRepositoryProvider = Provider<_PatientsSeekRepository>(
  (Ref ref) => _PatientsSeekRepository(ref.read(patientSeekApiProvider)),
);
