import 'package:flutter/material.dart';
import 'package:iatros_web/uikit/index.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iatros_web/core/models/user_model.dart';
import 'package:iatros_web/core/data/provider/global_controller.dart';
import 'package:iatros_web/features/auth/provider/model/auth_state.dart';
import 'package:iatros_web/features/auth/repository/auth_repository.dart';

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepository();
});

final authControllerProvider = StateNotifierProvider<AuthController, AuthState>(
  (ref) {
    final repository = ref.watch(authRepositoryProvider);
    final globalController = ref.read(globalControllerProvider.notifier);
    return AuthController(repository, globalController, ref);
  },
);

class AuthController extends StateNotifier<AuthState> {
  final Ref _ref;
  final AuthRepository _repository;
  final GlobalController _globalController;

  AuthController(this._repository, this._globalController, this._ref)
    : super(AuthState.initial());

  Future<void> login(String email, String password) async {
    _setState(state.copyWith(isLoginLoading: true, errorMessage: ""));

    final response = await _repository.login(email, password);

    if (response.isSuccessful) {
      _setState(
        state.copyWith(
          errorMessage: "",
          isLoginLoading: false,
          isAuthenticated: true,
        ),
      );

      // Start streaming user data after successful login

      _globalController.getStreamUser(response.data!.id!);
    } else {
      _setState(
        state.copyWith(
          isLoginLoading: false,
          isAuthenticated: false,
          user: null,
          errorMessage: response.message,
        ),
      );
    }
  }

  Future<void> register(UserModel user, String password) async {
    _setState(state.copyWith(errorMessage: "", isRegisterLoading: false));

    final response = await _repository.register(user, password);

    if (response.isSuccessful) {
      _setState(
        state.copyWith(
          user: user,
          errorMessage: "",
          isAuthenticated: true,
          isRegisterLoading: false,
        ),
      );
    } else {
      _setState(
        state.copyWith(
          user: null,
          isAuthenticated: false,
          isRegisterLoading: false,
          errorMessage: response.message,
        ),
      );
    }
  }

  Future<void> logout() async {
    // Cancel user stream subscription before logout
    final globalController = _ref.read(globalControllerProvider.notifier);
    globalController.cancelUserSub();

    _setState(
      state.copyWith(
        user: null,
        errorMessage: "",
        isAuthenticated: false,
        isRegisterLoading: false,
      ),
    );

    final response = await _repository.logout();

    _setState(
      state.copyWith(
        user: null,
        isLogoutLoading: false,
        isAuthenticated: false,
        errorMessage: response.isSuccessful ? "" : response.message,
      ),
    );
  }

  Future<void> resetPassword(String email) async {
    _setState(state.copyWith(isLoading: false, errorMessage: ""));

    final response = await _repository.resetPassword(email);

    _setState(
      state.copyWith(
        isLoading: false,
        errorMessage: response.isSuccessful ? "" : response.message,
      ),
    );
  }

  String? emailValidation(String? value) {
    if (value == null || value.isEmpty) {
      return 'El correo es requerido';
    }
    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
      return 'Ingresa un correo válido';
    }
    return null;
  }

  String? passwordValidation(String? value) {
    if (value == null || value.isEmpty) {
      return 'La contraseña es requerida';
    }
    if (value.length < 6) {
      return 'La contraseña debe tener al menos 6 caracteres';
    }
    return null;
  }

  void clearError() => _setState(state.copyWith(errorMessage: ""));

  activeError(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: AppColors.error),
    );
  }

  _setState(AuthState newState) => state = newState;
}
