import 'package:iatros_web/core/models/diagnosis_model.dart';
import 'package:iatros_web/core/models/user_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iatros_web/core/models/query_response_model.dart';
import 'package:iatros_web/features/patient/data/patients_api.dart';
import 'package:iatros_web/features/patient/data/patients_api_interface.dart';

abstract class PatientsRepositoryInterface {
  Future<QueryResponseModel<UserModel>> getUserById(String id);
  Future<QueryResponseModel<UserModel>> createUsers(UserModel user);
  Future<QueryResponseModel<List<DiagnosisModel>>> searchDiagnoses(String query);
}

class _PatientsRepository implements PatientsRepositoryInterface {
  final PatientsInterface _globalApi;

  _PatientsRepository(PatientsInterface globalApi)
    : _globalApi = globalApi;

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
  Future<QueryResponseModel<List<DiagnosisModel>>> searchDiagnoses(String query) async {
    try {
      final res = await _globalApi.searchDiagnoses(query);
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

final patientRepositoryProvider = Provider<_PatientsRepository>(
  (Ref ref) => _PatientsRepository(ref.read(patientApiProvider)),
);
