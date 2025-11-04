import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:iatros_web/features/auth/presentation/login_page.dart';
import 'package:iatros_web/features/auth/presentation/register_page.dart';
import 'package:iatros_web/features/lobby/pages/lobby.dart';
import 'package:iatros_web/features/patient/pages/patient_page.dart';
import 'package:iatros_web/page_not_found.dart';

enum AppRoutes {
  splash('/'),
  login('/login'),
  register('/register'),
  lobby('/lobby'),
  patient('/patient/:userId'),
  notFound('/404');

  final String path;
  const AppRoutes(this.path);
}

final goRouterProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: AppRoutes.login.path,
    errorBuilder: (context, state) => const PageNotFound(),
    redirect: (context, state) {
      final path = state.uri.path;

      if (path == AppRoutes.lobby.path) {
        return AppRoutes.lobby.path;
      }

      return null;
    },
    routes: [
      // Splash route
      GoRoute(
        path: AppRoutes.splash.path,
        redirect: (context, state) => AppRoutes.login.path,
      ),

      // Authentication routes
      GoRoute(
        path: AppRoutes.login.path,
        name: AppRoutes.login.name,
        builder: (context, state) {
          return LoginPage();
        },
      ),
      GoRoute(
        path: AppRoutes.register.path,
        name: AppRoutes.register.name,
        builder: (context, state) {
          return const RegisterPage();
        },
      ),

      // Main app routes
      GoRoute(
        path: AppRoutes.lobby.path,
        name: AppRoutes.lobby.name,
        builder: (context, state) {
          return const LobbyPage();
        },
      ),
      GoRoute(
        path: AppRoutes.patient.path,
        name: AppRoutes.patient.name,
        builder: (context, state) {
          final userId = state.pathParameters['userId'] ?? '';
          return PatientPage(userId: userId);
        },
      ),

      // Not found route
      GoRoute(
        path: AppRoutes.notFound.path,
        name: AppRoutes.notFound.name,
        builder: (context, state) {
          return const PageNotFound();
        },
      ),

      // Catch-all route para manejar rutas no encontradas
      GoRoute(
        path: '/:path(.*)',
        name: 'catch-all',
        builder: (context, state) {
          print('Ruta no encontrada: ${state.matchedLocation}');
          return const PageNotFound();
        },
      ),
    ],
  );
});
