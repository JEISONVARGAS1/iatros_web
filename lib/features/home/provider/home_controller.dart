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



 // _setState(HomeState newState) => state = AsyncValue.data(newState);
}
