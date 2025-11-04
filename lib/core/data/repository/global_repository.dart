import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iatros_web/core/data/data/global_api.dart';
import 'package:iatros_web/core/data/data/global_api_interface.dart';
import 'package:iatros_web/core/models/user_model.dart';
import 'package:iatros_web/core/models/query_response_model.dart';

abstract class GlobalRepositoryInterface {
  QueryResponseModel<Stream<UserModel>> getUserStream(String id);
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
}

final globalRepositoryProvider = Provider<_GlobalRepository>(
  (Ref ref) => _GlobalRepository(ref.read(globalApiProvider)),
);
