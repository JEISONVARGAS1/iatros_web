import 'package:iatros_web/core/models/user_model.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'lobby_state.freezed.dart';

@freezed
sealed class LobbyState with _$LobbyState {
  const factory LobbyState({
    required UserModel myUser,
    required int selectedIndex,
  }) = LobbyStateData;

  factory LobbyState.initial() => LobbyState(
    selectedIndex: 0,
    myUser: UserModel.init(),
  );
}
