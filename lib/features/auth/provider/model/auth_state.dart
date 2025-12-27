import 'package:iatros_web/core/models/user_model.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'auth_state.freezed.dart';

@freezed
sealed class AuthState with _$AuthState {
  const factory AuthState({
    required bool isLoading,
    UserModel? user,
    required bool isLoginLoading,
    required bool isLogoutLoading,
    required String errorMessage,
    required bool isAuthenticated,
    required bool isAuthChecked,
  }) = AuthStateData;

  factory AuthState.initial() => AuthState(
    isLoading: false,
    errorMessage: "",
    isLoginLoading: false,
    user: UserModel.init(),
    isLogoutLoading: false,
    isAuthenticated: false,
    isAuthChecked: false,
  );
}
