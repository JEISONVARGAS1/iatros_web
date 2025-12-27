import 'dart:convert';

import 'package:hive_flutter/hive_flutter.dart';
import 'package:iatros_web/core/models/user_model.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:iatros_web/core/models/user_company_model.dart';
import 'package:iatros_web/core/models/doctor_setting_model.dart';
import 'package:iatros_web/core/data/provider/model/global_state.dart';
import 'package:iatros_web/core/data/repository/global_repository.dart';
import 'package:iatros_web/features/lobby/provider/lobby_controller.dart';

part 'global_controller.g.dart';

@riverpod
class GlobalController extends _$GlobalController {
  LobbyController get lobbyController =>
      ref.read(lobbyControllerProvider.notifier);
  @override
  Future<GlobalState> build() async {
    ref.keepAlive();
    ref.onDispose(() {
      state.value?.userSub?.cancel();
      state.value?.doctorSettingSub?.cancel();
    });

    final box = await Hive.openBox('userBox');
    final userJson = box.get('myUser') as String?;
    UserModel myUser = UserModel.init();
    if (userJson != null) {
      try {
        final userMap = jsonDecode(userJson) as Map<String, dynamic>;
        myUser = UserModel.fromJson(userMap);
      } catch (e) {
        // If parsing fails, use init
      }
    }

    DoctorSettingModel doctorSettingModel = DoctorSettingModel.init();
    if (myUser.id != null) {
      final settingJson = box.get('doctorSetting') as String?;
      if (settingJson != null) {
        try {
          final settingMap = jsonDecode(settingJson) as Map<String, dynamic>;
          doctorSettingModel = DoctorSettingModel.fromJson(settingMap);
        } catch (e) {
          // If parsing fails, use init
        }
      }
    }

    return GlobalState.initial().copyWith(doctorSetting: doctorSettingModel);
  }

  _getSettings() async {
    DoctorSettingModel doctorSettingModel = DoctorSettingModel.init();

    final data = await repository.getSettingDoctor(
      state.value!.userCompanySelected.id!,
    );
    if (data.isSuccessful) {
      doctorSettingModel = data.data!;
    }

    _setState(state.value!.copyWith(doctorSetting: doctorSettingModel));
  }

  GlobalRepositoryInterface get repository =>
      ref.read(globalRepositoryProvider);

  Future<void> getStreamUser(String id) async {
    final userRes = await repository.getUserById(id);
    if (userRes.isSuccessful) {
      getUserCompaniesStream(userRes.data!.id!);
      _setState(state.value!.copyWith(myUser: userRes.data!));
    }

    // Set up stream for user changes
    final res = repository.getUserStream(id);
    if (res.isSuccessful) {
      final stream = res.data!;
      final subscription = stream.listen((UserModel user) {
        _setState(state.value!.copyWith(myUser: user));
      });
      _setState(state.value!.copyWith(userSub: subscription));
    }

    final settingRes = repository.getSettingDoctorStream(id);
    if (settingRes.isSuccessful) {
      final settingStream = settingRes.data!;
      final settingSubscription = settingStream.listen((
        DoctorSettingModel setting,
      ) {
        _setState(state.value!.copyWith(doctorSetting: setting));
        // Save to Hive
        final box = Hive.box('userBox');
        final settingJson = jsonEncode(setting.toJson());
        box.put('doctorSetting', settingJson);
      });
      _setState(state.value!.copyWith(doctorSettingSub: settingSubscription));
    }
  }

  void getUserCompaniesStream(String id) async {
    final res = repository.getUserCompaniesWithCompanyStream(id);
    if (res.isSuccessful) {
      final stream = res.data!;
      final subscription = stream.listen((
        List<UserCompanyModel> userCompanies,
      ) {
        if (userCompanies.length == 1) {
          _setState(
            state.value!.copyWith(
              userCompanies: userCompanies,
              userCompanySelected: userCompanies.first,
            ),
          );
          _getSettings();
        } else {
          _setState(state.value!.copyWith(userCompanies: userCompanies));
          Future.delayed(
            Duration(seconds: 1),
            () => lobbyController.openCompanyPanel(),
          );
        }
      });
      _setState(state.value!.copyWith(userCompanySub: subscription));
    }
  }

  void selectUserCompany(UserCompanyModel userCompany) {
    _setState(state.value!.copyWith(userCompanySelected: userCompany));
    _getSettings();
  }

  void cancelUserSub() {
    state.value?.userSub?.cancel();
    state.value?.doctorSettingSub?.cancel();
    _setState(state.value!.copyWith(userSub: null, doctorSettingSub: null));
  }

  _setState(GlobalState newState) {
    state = AsyncValue.data(newState);
    _saveUser(newState.myUser);
  }

  void _saveUser(UserModel user) async {
    if (user.id != null) {
      final box = await Hive.openBox('userBox');
      final userJson = jsonEncode(user.toJson());
      await box.put('myUser', userJson);
    }
  }

  void deleteStoredData() async {
    final box = await Hive.openBox('userBox');
    await box.delete('myUser');
    await box.delete('doctorSetting');
  }
}
