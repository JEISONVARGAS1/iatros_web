import 'package:flutter/material.dart';
import 'package:iatros_web/uikit/index.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:iatros_web/core/models/user_company_model.dart';
import 'package:iatros_web/core/data/provider/global_controller.dart';
import 'package:iatros_web/core/data/provider/model/global_state.dart';
import 'package:iatros_web/features/auth/provider/model/auth_state.dart';
import 'package:iatros_web/features/auth/repository/auth_repository.dart';

part 'auth_controller.g.dart';

@riverpod
class AuthController extends _$AuthController {
  AuthRepository get repository => ref.read(authRepositoryProvider);
  GlobalController get globalController =>
      ref.read(globalControllerProvider.notifier);

  @override
  FutureOr<AuthState> build() {
    ref.onDispose(() {
      // No controllers to dispose in auth state anymore
    });

    // Listen to GlobalController for existing user
    ref.listen<AsyncValue<GlobalState>>(globalControllerProvider, (
      previous,
      next,
    ) {
      if (next.hasValue) {
        final globalState = next.value!;
        final hasUser =
            globalState.myUser.id != null && globalState.myUser.id!.isNotEmpty;

        // If we have a user but auth state shows not authenticated, update it
        if (hasUser && !state.value!.isAuthenticated) {
          _setState(
            state.value!.copyWith(
              isAuthenticated: true,
              user: globalState.myUser,
              isAuthChecked: true,
            ),
          );
        } else if (!hasUser && state.value!.isAuthenticated) {
          // If no user but auth state shows authenticated, update it
          _setState(
            state.value!.copyWith(
              isAuthenticated: false,
              user: null,
              isAuthChecked: true,
            ),
          );
        } else {
          // Mark as checked even if no change
          _setState(state.value!.copyWith(isAuthChecked: true));
        }
      }
    }, fireImmediately: true);

    return AuthState.initial();
  }

  Future<void> login(String email, String password) async {
    _setState(state.value!.copyWith(isLoginLoading: true, errorMessage: ""));

    final response = await repository.login(email, password);

    if (response.isSuccessful) {
      _setState(
        state.value!.copyWith(
          errorMessage: "",
          isLoginLoading: false,
          isAuthenticated: true,
        ),
      );

      // Start streaming user data after successful login

      globalController.getStreamUser(response.data!.id!);
    } else {
      _setState(
        state.value!.copyWith(
          isLoginLoading: false,
          isAuthenticated: false,
          user: null,
          errorMessage: response.message,
        ),
      );
    }
  }


  Future<void> register(UserCompanyModel userCompanyModel, String password) async {
    final response = await repository.register(userCompanyModel, password);

    if (response.isSuccessful) {
      _setState(
        state.value!.copyWith(
          errorMessage: "",
          isAuthenticated: true,
          user: userCompanyModel.user,
        ),
      );

      // Start streaming user data after successful registration
      globalController.getStreamUser(response.data!.id!);
    } else {
      _setState(
        state.value!.copyWith(
          user: null,
          isAuthenticated: false,
          errorMessage: response.message,
        ),
      );
    }
  }

  Future<void> logout() async {
    // Cancel user stream subscription before logout
    globalController.cancelUserSub();
    globalController.deleteStoredData(); // Clear stored user data

    _setState(
      state.value!.copyWith(
        user: null,
        errorMessage: "",
        isAuthenticated: false,
      ),
    );

    final response = await repository.logout();

    _setState(
      state.value!.copyWith(
        user: null,
        isLogoutLoading: false,
        isAuthenticated: false,
        errorMessage: response.isSuccessful ? "" : response.message,
      ),
    );
  }

  Future<void> resetPassword(String email) async {
    _setState(state.value!.copyWith(isLoading: false, errorMessage: ""));

    final response = await repository.resetPassword(email);

    _setState(
      state.value!.copyWith(
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

  void clearError() => _setState(state.value!.copyWith(errorMessage: ""));

  activeError(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: AppColors.error),
    );
  }


  _setState(AuthState newState) => state = AsyncValue.data(newState);
}
