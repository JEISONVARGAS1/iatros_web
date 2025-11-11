import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:iatros_web/core/models/user_model.dart';

part 'auth_state.freezed.dart';

@freezed
sealed class AuthState with _$AuthState {
  const factory AuthState({
    required bool isLoading,
    UserModel? user,
    required bool isLoginLoading,
    required bool isRegisterLoading,
    required bool isLogoutLoading,
    required String errorMessage,
    required bool isAuthenticated,

    required double addressLatitude,
    required double addressLongitude,
  }) = AuthStateData;

  factory AuthState.initial() => AuthState(
    isLoading: false,
    errorMessage: "",
    isLoginLoading: false,
    user: UserModel.init(),
    isLogoutLoading: false,
    isAuthenticated: false,
    isRegisterLoading: false,
    addressLatitude: 0,
    addressLongitude: 0
  );
}
