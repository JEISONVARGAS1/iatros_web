import 'package:flutter/material.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:iatros_web/core/models/user_company_model.dart';
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
    required PanelController panelController,
    required List<UserCompanyModel> userCompanies,
    required UserCompanyModel userCompaniesSelected,
  }) = LobbyStateData;

  factory LobbyState.initial() => LobbyState(
    width: 280,
    selectedIndex: 0,
    userCompanies: [],
    tabController: null,
    isMenuVisible: true,
    myUser: UserModel.init(),
    panelController: PanelController(),
    userCompaniesSelected: UserCompanyModel.init(),
  );
}
