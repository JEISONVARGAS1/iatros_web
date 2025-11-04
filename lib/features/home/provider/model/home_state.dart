import 'dart:async';

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:iatros_web/core/models/user_model.dart';

part 'home_state.freezed.dart';

@freezed
sealed class HomeState with _$HomeState {
  const factory HomeState({
    required UserModel myUser,
    StreamSubscription? userSub,
  }) = HomeStateData;

  factory HomeState.initial() => HomeState(myUser: UserModel.init());
}
