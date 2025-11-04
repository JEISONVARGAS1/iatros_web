import 'package:iatros_web/core/models/user_model.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:iatros_web/core/data/provider/model/global_state.dart';
import 'package:iatros_web/core/data/repository/global_repository.dart';

part 'global_controller.g.dart';

@riverpod
class GlobalController extends _$GlobalController {
  @override
  FutureOr<GlobalState> build() {
    ref.onDispose(() => state.value!.userSub!.cancel());

    return GlobalState.initial();
  }

  GlobalRepositoryInterface get repository =>
      ref.read(globalRepositoryProvider);

  void getStreamUser(String id) {
    final res = repository.getUserStream(id);
    if (res.isSuccessful) {
      final stream = res.data!;
      final subscription = stream.listen((UserModel user) {
        _setState(state.value!.copyWith(myUser: user));
      });
      _setState(state.value!.copyWith(userSub: subscription));
    }
  }

  _setState(GlobalState newState) => state = AsyncValue.data(newState);
}
