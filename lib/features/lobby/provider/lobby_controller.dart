import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:iatros_web/core/data/provider/global_controller.dart';
import 'package:iatros_web/features/auth/provider/auth_controller.dart';
import 'package:iatros_web/features/lobby/provider/model/lobby_state.dart';
import 'package:iatros_web/features/lobby/pages/widget/custom_alert_logout.dart';

part 'lobby_controller.g.dart';

@riverpod
class LobbyController extends _$LobbyController {
  @override
  FutureOr<LobbyState> build() {
    ref.onDispose(() {
      state.value!.tabController!.dispose();
    });

    return LobbyState.initial();
  }

  initPage(TickerProvider item) {
    _setState(
      state.value!.copyWith(
        tabController: TabController(length: 3, vsync: item),
      ),
    );
    _getMyUser();
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

      _setState(state.value!.copyWith(myUser: user));
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

  _setState(LobbyState newState) => state = AsyncValue.data(newState);
}
