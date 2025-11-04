import 'dart:async';

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:iatros_web/core/models/user_model.dart';

part 'global_state.freezed.dart';

@freezed
sealed class GlobalState with _$GlobalState {
  const factory GlobalState({
    required UserModel myUser,
    StreamSubscription? userSub,
  }) = GlobalStateData;

  factory GlobalState.initial() => GlobalState(myUser: UserModel.init());
}
