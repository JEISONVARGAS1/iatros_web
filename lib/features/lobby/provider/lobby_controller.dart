import 'package:iatros_web/features/auth/provider/auth_controller.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:iatros_web/features/lobby/provider/model/lobby_state.dart';

part 'lobby_controller.g.dart';

@riverpod
class LobbyController extends _$LobbyController {
  @override
  FutureOr<LobbyState> build() => LobbyState.initial();

  AuthController get _authProvider =>
      ref.watch(authControllerProvider.notifier);

  changeIndex(int index) =>
      _setState(state.value!.copyWith(selectedIndex: index));

  logout() => _authProvider.logout();

  _setState(LobbyState newState) => state = AsyncValue.data(newState);
}
