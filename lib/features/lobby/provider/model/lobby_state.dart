import 'package:flutter/material.dart';
import 'package:iatros_web/core/models/user_model.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'lobby_state.freezed.dart';

@freezed
sealed class LobbyState with _$LobbyState {
  const factory LobbyState({
    required double width,
    required UserModel myUser,
    required int selectedIndex,
    required bool isMenuVisible,
    TabController? tabController,
  }) = LobbyStateData;

  factory LobbyState.initial() => LobbyState(
    width: 280,
    selectedIndex: 0,
    tabController: null,
    myUser: UserModel.init(),
    isMenuVisible: true,
  );
}
