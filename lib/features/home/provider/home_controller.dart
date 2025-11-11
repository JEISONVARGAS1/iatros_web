import 'package:iatros_web/core/data/provider/global_controller.dart';
import 'package:iatros_web/features/home/provider/model/home_state.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'home_controller.g.dart';

@riverpod
class HomeController extends _$HomeController {
  @override
  FutureOr<HomeState> build() {
    ref.onDispose(() => state.value!.userSub!.cancel());

    return HomeState.initial();
  }

  init() {
    _getMyUser();
  }

  _getMyUser() {
    ref.listen(globalControllerProvider, (previous, next) {
      final user = next.value!.myUser;

      _setState(state.value!.copyWith(myUser: user));
    }, fireImmediately: true);
  }

  _setState(HomeState newState) => state = AsyncValue.data(newState);
}
