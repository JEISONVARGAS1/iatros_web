import 'dart:async';

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:iatros_web/core/models/doctor_setting_model.dart';
import 'package:iatros_web/core/models/user_company_model.dart';
import 'package:iatros_web/core/models/user_model.dart';

part 'global_state.freezed.dart';

@freezed
sealed class GlobalState with _$GlobalState {
  const factory GlobalState({
    required UserModel myUser,
    StreamSubscription? userSub,
    StreamSubscription? userCompanySub,
    StreamSubscription? doctorSettingSub,
    required DoctorSettingModel doctorSetting,
    required List<UserCompanyModel> userCompanies,
    required UserCompanyModel userCompanySelected,
  }) = GlobalStateData;

  factory GlobalState.initial() => GlobalState(
    userCompanies: [],
    userCompanySub: null,
    doctorSettingSub: null,
    myUser: UserModel.init(),
    doctorSetting: DoctorSettingModel.init(),
    userCompanySelected: UserCompanyModel.init(),
  );
}
