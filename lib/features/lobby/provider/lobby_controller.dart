import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:iatros_web/core/models/user_company_model.dart';
import 'package:iatros_web/core/data/provider/global_controller.dart';
import 'package:iatros_web/features/auth/provider/auth_controller.dart';
import 'package:iatros_web/features/lobby/provider/model/lobby_state.dart';
import 'package:iatros_web/features/lobby/pages/widget/custom_alert_logout.dart';

part 'lobby_controller.g.dart';

@riverpod
class LobbyController extends _$LobbyController {



  GlobalController get _globalController => ref.read(globalControllerProvider.notifier);

  @override
  FutureOr<LobbyState> build() {
    ref.keepAlive();
    ref.onDispose(() {
      if (state.value?.tabController != null) {
        state.value!.tabController!.dispose();
      }
    });

    return LobbyState.initial();
  }

  initPage(TickerProvider item) {
    if (state.value != null) {
      _setState(
        state.value!.copyWith(
          tabController: TabController(length: 4, vsync: item),
        ),
      );
      _getMyUser();
    }
  }

  AuthController get _authProvider {
    return ref.watch(authControllerProvider.notifier);
  }

  changeIndex(int index) {
    _setState(state.value!.copyWith(selectedIndex: index));
  }

  _getMyUser() {
    ref.listen(globalControllerProvider, (previous, next) {
      final user = next.value!.myUser;
      final userCompanies = next.value!.userCompanies;
      final userCompanySelected = next.value!.userCompanySelected;

      _setState(
        state.value!.copyWith(
          myUser: user,
          userCompanies: userCompanies,
          userCompaniesSelected: userCompanySelected,
        ),
      );
    }, fireImmediately: true);
  }

  logout() => _authProvider.logout();

  void showLogoutConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) => CustomAlertLogout(
        onTap: () {
          Navigator.of(context).pop();
          logout();
        },
      ),
    );
  }

  changeMenuWidth(double width) {
    if (width == 280) {
      _setState(state.value!.copyWith(width: width));
      Future.delayed(const Duration(milliseconds: 200), () {
        _setState(state.value!.copyWith(isMenuVisible: true));
      });
    } else {
      _setState(state.value!.copyWith(width: width, isMenuVisible: false));
    }
  }

  void openCompanyPanel() => state.value!.panelController.open();

  void closeCompanyPanel() {
    state.value!.panelController.close();
  }

  void selectCompany(UserCompanyModel company) {
    _globalController.selectUserCompany(company);
    _setState(state.value!.copyWith(userCompaniesSelected: company));
    closeCompanyPanel();
  }

  _setState(LobbyState newState) => state = AsyncValue.data(newState);
}
