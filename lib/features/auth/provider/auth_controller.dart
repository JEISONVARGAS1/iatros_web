import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iatros_web/core/models/user_model.dart';
import 'package:iatros_web/features/auth/provider/model/auth_state.dart';
import 'package:iatros_web/features/auth/repository/auth_repository.dart';

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepository();
});

final authControllerProvider = StateNotifierProvider<AuthController, AuthState>(
  (ref) {
    final repository = ref.watch(authRepositoryProvider);
    return AuthController(repository);
  },
);

class AuthController extends StateNotifier<AuthState> {
  final AuthRepository _repository;

  AuthController(this._repository) : super(AuthState.init()) {
    /* _checkAuthStatus(); */
  }
  /* 
  Future<void> _checkAuthStatus() async {
    state = state.copyWith(isLoading: true);
    
    final response = await _repository.getCurrentUser();
    
    if (response.isSuccessful && response.data != null) {
      state = state.copyWith(
        isLoading: false,
        isAuthenticated: true,
        user: response.data,
        errorMessage: null,
      );
    } else {
      state = state.copyWith(
        isLoading: false,
        isAuthenticated: false,
        user: null,
        errorMessage: response.message,
      );
    }
  } */

  Future<void> login(String email, String password) async {
    state = state.copyWith(isLoginLoading: true, errorMessage: null);

    final response = await _repository.login(email, password);

    if (response.isSuccessful) {
      // Obtener el usuario actual después del login exitoso
      /* final userResponse = await _repository.getCurrentUser(); */

      state = state.copyWith(
        isLoginLoading: false,
        isAuthenticated: true,

        errorMessage: null,
      );
    } else {
      state = state.copyWith(
        isLoginLoading: false,
        isAuthenticated: false,
        user: null,
        errorMessage: response.message,
      );
    }
  }

  Future<void> register(UserModel user, String password) async {
    state = state.copyWith(isRegisterLoading: true, errorMessage: null);

    final response = await _repository.register(user, password);

    if (response.isSuccessful) {
      // Obtener el usuario actual después del registro exitoso
      /* final userResponse = await _repository.getCurrentUser(); */

      state = state.copyWith(
        user: user,
        errorMessage: null,
        isAuthenticated: true,
        isRegisterLoading: false,
      );
    } else {
      state = state.copyWith(
        isRegisterLoading: false,
        isAuthenticated: false,
        user: null,
        errorMessage: response.message,
      );
    }
  }

  Future<void> logout() async {
    state = state.copyWith(isLogoutLoading: true, errorMessage: null);

    final response = await _repository.logout();

    state = state.copyWith(
      isLogoutLoading: false,
      isAuthenticated: false,
      user: null,
      errorMessage: response.isSuccessful ? null : response.message,
    );
  }

  Future<void> resetPassword(String email) async {
    state = state.copyWith(isLoading: true, errorMessage: null);

    final response = await _repository.resetPassword(email);

    state = state.copyWith(
      isLoading: false,
      errorMessage: response.isSuccessful ? null : response.message,
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

  void clearError() {
    state = state.copyWith(errorMessage: null);
  }
}
