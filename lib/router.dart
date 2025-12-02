import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:iatros_web/features/auth/presentation/login_page.dart';
import 'package:iatros_web/features/auth/presentation/register_page.dart';
import 'package:iatros_web/features/auth/provider/auth_controller.dart';
import 'package:iatros_web/features/auth/provider/model/auth_state.dart';
import 'package:iatros_web/features/lobby/pages/lobby.dart';
import 'package:iatros_web/features/profile/pages/profile_page.dart';
import 'package:iatros_web/features/patient/pages/patient_page.dart';
import 'package:iatros_web/features/appointment_day/pages/appointment_day_page.dart';
import 'package:iatros_web/page_not_found.dart';

/// Enum que define todas las rutas de la aplicación
enum AppRoutes {
  splash('/'),
  login('/login'),
  register('/register'),
  lobby('/lobby'),
  profile('/profile'),
  patient('/patient/:userId'),
  appointmentDay('/appointment-day/:date'),
  notFound('/404');

  const AppRoutes(this.path);
  final String path;
}

/// ChangeNotifier que escucha cambios en el estado de autenticación
/// GoRouter lo usa para refrescar las redirecciones automáticamente
class AuthNotifier extends ChangeNotifier {
  AuthNotifier(this._ref) {
    // Escuchamos cambios en el authControllerProvider
    _subscription = _ref.listen<AuthState>(
      authControllerProvider,
      (previous, next) {
        notifyListeners(); // Notifica a GoRouter que refresque
      },
    );
  }

  final Ref _ref;
  late final ProviderSubscription<AuthState> _subscription;

  /// Obtiene el estado actual de autenticación
  AuthState get authState => _ref.read(authControllerProvider);

  @override
  void dispose() {
    _subscription.close();
    super.dispose();
  }
}

/// Provider que crea el AuthNotifier
final authNotifierProvider = ChangeNotifierProvider<AuthNotifier>((ref) {
  return AuthNotifier(ref);
});

/// Provider principal del GoRouter con configuración completa
final goRouterProvider = Provider<GoRouter>((ref) {
  // Obtenemos el notifier de autenticación
  final authNotifier = ref.watch(authNotifierProvider);

  return GoRouter(
    // Configuración inicial
    initialLocation: AppRoutes.login.path,
    errorBuilder: (context, state) => const PageNotFound(),

    // Refresh listenable para que GoRouter reaccione a cambios de auth
    refreshListenable: authNotifier,

    // Función de redirección global basada en estado de autenticación
    redirect: (context, state) {
      // Obtenemos el estado actual de autenticación
      final authState = authNotifier.authState;
      final isAuthenticated = authState.isAuthenticated;
      final isLoading = authState.isLoading;
      final currentPath = state.uri.path;

      // Rutas públicas (accesibles sin autenticación)
      final publicRoutes = [
        AppRoutes.login.path,
        AppRoutes.register.path,
        AppRoutes.splash.path,
        AppRoutes.notFound.path,
      ];

      // Si está cargando, no redirigimos para evitar flickering
      if (isLoading) {
        return null;
      }

      // REGLAS DE REDIRECCIÓN:

      // 1. Usuario NO autenticado
      if (!isAuthenticated) {
        // Solo puede acceder a rutas públicas
        if (!publicRoutes.contains(currentPath) &&
            !currentPath.startsWith('/patient/') &&
            !currentPath.startsWith('/appointment-day/')) {
          // Redirigir a login si intenta acceder a ruta protegida
          return AppRoutes.login.path;
        }
        return null; // Permite acceso a rutas públicas
      }

      // 2. Usuario SÍ autenticado
      if (isAuthenticated) {
        // No debe ver login/register si ya está autenticado
        if (currentPath == AppRoutes.login.path ||
            currentPath == AppRoutes.register.path) {
          // Redirigir a lobby
          return AppRoutes.lobby.path;
        }

        // Si está en splash, redirigir a lobby
        if (currentPath == AppRoutes.splash.path) {
          return AppRoutes.lobby.path;
        }
      }

      // No hay redirección necesaria
      return null;
    },

    // Definición de rutas
    routes: [
      // Splash route (siempre redirige)
      GoRoute(
        path: AppRoutes.splash.path,
        redirect: (context, state) => AppRoutes.login.path,
      ),

      // Rutas de autenticación
      GoRoute(
        path: AppRoutes.login.path,
        name: AppRoutes.login.name,
        builder: (context, state) => const LoginPage(),
      ),
      GoRoute(
        path: AppRoutes.register.path,
        name: AppRoutes.register.name,
        builder: (context, state) => const RegisterPage(),
      ),

      // Rutas principales (protegidas)
      GoRoute(
        path: AppRoutes.lobby.path,
        name: AppRoutes.lobby.name,
        builder: (context, state) => const LobbyPage(),
      ),
      GoRoute(
        path: AppRoutes.profile.path,
        name: AppRoutes.profile.name,
        builder: (context, state) => const ProfilePage(),
      ),
      GoRoute(
        path: AppRoutes.patient.path,
        name: AppRoutes.patient.name,
        builder: (context, state) {
          final userId = state.pathParameters['userId'] ?? '';
          return PatientPage(userId: userId);
        },
      ),
      GoRoute(
        path: AppRoutes.appointmentDay.path,
        name: AppRoutes.appointmentDay.name,
        builder: (context, state) {
          final dateString = state.pathParameters['date'] ?? '';
          final selectedDate = DateTime.tryParse(dateString) ?? DateTime.now();
          return AppointmentDayPage(selectedDate: selectedDate);
        },
      ),

      // Ruta 404
      GoRoute(
        path: AppRoutes.notFound.path,
        name: AppRoutes.notFound.name,
        builder: (context, state) => const PageNotFound(),
      ),

      // Catch-all para rutas no encontradas
      GoRoute(
        path: '/:path(.*)',
        name: 'catch-all',
        builder: (context, state) {
          debugPrint('Ruta no encontrada: ${state.matchedLocation}');
          return const PageNotFound();
        },
      ),
    ],
  );
});
