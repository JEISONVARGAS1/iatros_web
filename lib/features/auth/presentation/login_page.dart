import 'dart:html' as html;
import 'package:flutter/material.dart';
import 'package:iatros_web/router.dart';
import 'package:go_router/go_router.dart';
import 'package:iatros_web/uikit/index.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iatros_web/features/auth/provider/auth_controller.dart';
import 'package:iatros_web/features/auth/provider/model/auth_state.dart';

class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key});

  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(authControllerProvider);
    final controller = ref.read(authControllerProvider.notifier);

    ref.listen<AuthState>(authControllerProvider, (previous, next) {
      if (next.errorMessage.isNotEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(next.errorMessage),
            backgroundColor: AppColors.error,
          ),
        );
        controller.clearError();
      }
      
      // Navigate to lobby on successful login
      if (previous?.isAuthenticated == false && next.isAuthenticated) {
        context.go(AppRoutes.lobby.path);
        // Prevent back button from going to login page
        html.window.history.pushState(null, '', AppRoutes.lobby.path);
      }
    });

    return Scaffold(
      body: SimpleMedicalBackground(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(AppSpacing.paddingLG),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 400),
              child: BaseCard(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Logo
                    IatrosLogoVertical(width: 100, height: 100),
                    Text(
                      'Bienvenido a Iatros',
                      style: AppTypography.h3,
                      textAlign: TextAlign.center,
                    ),
                    UIHelpers.verticalSpaceSM,
                    Text(
                      'Inicia sesión en tu cuenta',
                      style: AppTypography.bodyMedium.copyWith(
                        color: AppColors.textSecondary,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    UIHelpers.verticalSpaceXL,

                    // Formulario
                    Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          TextInput(
                            isRequired: true,
                            hint: 'tu@email.com',
                            label: 'Correo electrónico',
                            controller: _emailController,
                            validator: controller.emailValidation,
                            keyboardType: TextInputType.emailAddress,
                          ),
                          UIHelpers.verticalSpaceMD,
                          PasswordInput(
                            isRequired: true,
                            label: 'Contraseña',
                            hint: 'Tu contraseña',
                            controller: _passwordController,
                            validator: controller.passwordValidation,
                          ),
                          UIHelpers.verticalSpaceLG,
                          PrimaryButton(
                            label: 'Iniciar Sesión',
                            isLoading: state.isLoginLoading,
                            onPressed: () {
                              if (_formKey.currentState!.validate()) {
                                controller.login(
                                  _emailController.text.trim(),
                                  _passwordController.text,
                                );
                              }
                            },
                          ),
                          UIHelpers.verticalSpaceMD,

                          TextButton(
                            onPressed: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Función en desarrollo'),
                                ),
                              );
                            },
                            child: const Text('¿Olvidaste tu contraseña?'),
                          ),
                        ],
                      ),
                    ),

                    UIHelpers.verticalSpaceLG,
                    UIHelpers.divider(),
                    UIHelpers.verticalSpaceMD,

                    // Enlace a registro
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          '¿No tienes cuenta? ',
                          style: AppTypography.bodyMedium,
                        ),
                        TextButton(
                          onPressed: () {
                            context.go(AppRoutes.register.path);
                          },
                          child: const Text('Regístrate'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
