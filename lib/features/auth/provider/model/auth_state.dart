import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:iatros_web/core/models/user_model.dart';

part 'auth_state.freezed.dart';

@freezed
class AuthState with _$AuthState {
  const factory AuthState({
    @Default(false) bool isLoading,
    @Default(false) bool isAuthenticated,
    UserModel? user,
    String? errorMessage,
    @Default(false) bool isLoginLoading,
    @Default(false) bool isRegisterLoading,
    @Default(false) bool isLogoutLoading,
  }) = _AuthState;

  factory AuthState.init() => const AuthState();
}
