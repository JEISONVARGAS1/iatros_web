import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:iatros_web/core/models/user_model.dart';
import 'package:iatros_web/features/auth/provider/auth_controller.dart';
import 'package:iatros_web/features/auth/provider/model/auth_state.dart';
import 'package:iatros_web/router.dart';
import 'package:iatros_web/uikit/extensions/context_extension.dart';
import 'package:iatros_web/uikit/index.dart';

class RegisterPage extends ConsumerStatefulWidget {
  const RegisterPage({super.key});

  @override
  ConsumerState<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends ConsumerState<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final _pageController = PageController();
  final _nameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _medicalLicenseController = TextEditingController();
  String _phoneNumber = '';
  final _bioController = TextEditingController();
  final _yearsExperienceController = TextEditingController();

  int _currentPage = 0;
  String? _selectedSpecialization;
  dynamic _professionalCardImage; // Cambiar a dynamic
  dynamic _identityDocumentImage; // Cambiar a dynamic
  String? _selectedIdentificationType;
  String _identificationNumber = '';

  @override
  void dispose() {
    _pageController.dispose();
    _nameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _medicalLicenseController.dispose();
    _bioController.dispose();
    _yearsExperienceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authControllerProvider);
    final authController = ref.read(authControllerProvider.notifier);

    ref.listen<AuthState>(authControllerProvider, (previous, next) {
      if (next.errorMessage != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(next.errorMessage!),
            backgroundColor: AppColors.error,
          ),
        );
        authController.clearError();
      }

      // Navigate to lobby on successful registration
      if (previous?.isAuthenticated == false && next.isAuthenticated) {
        context.go(AppRoutes.lobby.path);
      }
    });

    return Scaffold(
      body: SimpleMedicalBackground(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(AppSpacing.paddingLG),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 500),
              child: BaseCard(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Logo
                    IatrosLogoVertical(width: 100, height: 100),
                    Text(
                      'Registro Médico',
                      style: AppTypography.h3,
                      textAlign: TextAlign.center,
                    ),
                    UIHelpers.verticalSpaceSM,

                    Text(
                      'Únete a la plataforma médica de Iatros',
                      style: AppTypography.bodyMedium.copyWith(
                        color: AppColors.textSecondary,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    UIHelpers.verticalSpaceXL,

                    // Indicador de pasos
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(4, (index) {
                        return Container(
                          width: 8,
                          height: 8,
                          margin: const EdgeInsets.symmetric(horizontal: 4),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: index <= _currentPage
                                ? AppColors.primary
                                : AppColors.surfaceVariant,
                          ),
                        );
                      }),
                    ),
                    UIHelpers.verticalSpaceLG,

                    // PageView
                    SizedBox(
                      height: context.sizeHeight(0.5),
                      child: PageView(
                        controller: _pageController,
                        onPageChanged: (page) {
                          setState(() {
                            _currentPage = page;
                          });
                        },
                        children: [
                          SingleChildScrollView(
                            child: _buildPersonalInfoStep(),
                          ),
                          SingleChildScrollView(child: _buildMedicalInfoStep()),
                          SingleChildScrollView(
                            child: _buildDocumentationStep(),
                          ),
                          SingleChildScrollView(child: _buildSecurityStep()),
                        ],
                      ),
                    ),

                    // Botones de navegación
                    Row(
                      children: [
                        if (_currentPage > 0)
                          Expanded(
                            child: SecondaryButton(
                              label: 'Anterior',
                              onPressed: () {
                                _pageController.previousPage(
                                  duration: const Duration(milliseconds: 300),
                                  curve: Curves.easeInOut,
                                );
                              },
                            ),
                          ),
                        if (_currentPage > 0) UIHelpers.horizontalSpaceMD,
                        Expanded(
                          child: _currentPage == 3
                              ? PrimaryButton(
                                  label: 'Registrarse como Médico',
                                  isLoading: authState.isRegisterLoading,
                                  onPressed: _register,
                                )
                              : PrimaryButton(
                                  label: 'Siguiente',
                                  onPressed: () {
                                    if (_validateCurrentStep()) {
                                      _pageController.nextPage(
                                        duration: const Duration(
                                          milliseconds: 300,
                                        ),
                                        curve: Curves.easeInOut,
                                      );
                                    }
                                  },
                                ),
                        ),
                      ],
                    ),

                    UIHelpers.verticalSpaceLG,
                    UIHelpers.divider(),
                    UIHelpers.verticalSpaceMD,

                    // Enlace a login
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          '¿Ya tienes cuenta? ',
                          style: AppTypography.bodyMedium,
                        ),
                        TextButton(
                          onPressed: () {
                            context.go(AppRoutes.login.path);
                          },
                          child: const Text('Inicia sesión'),
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

  Widget _buildPersonalInfoStep() {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Información Personal', style: AppTypography.h5),
          UIHelpers.verticalSpaceMD,

          Row(
            children: [
              Expanded(
                child: TextInput(
                  label: 'Nombre',
                  hint: 'Tu nombre',
                  controller: _nameController,
                  isRequired: true,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'El nombre es requerido';
                    }
                    if (value.length < 2) {
                      return 'El nombre debe tener al menos 2 caracteres';
                    }
                    return null;
                  },
                ),
              ),
              UIHelpers.horizontalSpaceMD,
              Expanded(
                child: TextInput(
                  label: 'Apellido',
                  hint: 'Tu apellido',
                  controller: _lastNameController,
                  isRequired: true,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'El apellido es requerido';
                    }
                    if (value.length < 2) {
                      return 'El apellido debe tener al menos 2 caracteres';
                    }
                    return null;
                  },
                ),
              ),
            ],
          ),
          UIHelpers.verticalSpaceMD,

          TextInput(
            label: 'Correo electrónico',
            hint: 'tu@email.com',
            controller: _emailController,
            keyboardType: TextInputType.emailAddress,
            isRequired: true,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'El correo es requerido';
              }
              if (!RegExp(
                r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
              ).hasMatch(value)) {
                return 'Ingresa un correo válido';
              }
              return null;
            },
          ),
          UIHelpers.verticalSpaceMD,

          IdentificationSelector(
            selectedType: _selectedIdentificationType,
            identificationNumber: _identificationNumber,
            onTypeChanged: (value) {
              setState(() {
                _selectedIdentificationType = value;
              });
            },
            onNumberChanged: (value) {
              setState(() {
                _identificationNumber = value;
              });
            },
            isRequired: true,
          ),
          UIHelpers.verticalSpaceMD,

          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              RichText(
                text: TextSpan(
                  text: "Teléfono",
                  style: AppTypography.label,
                  children: [
                    const TextSpan(
                      text: ' *',
                      style: TextStyle(color: AppColors.error),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.sm),
              IntlPhoneField(
                decoration: InputDecoration(
                  labelText: 'Teléfono',
                  hintText: '+57 300 123 4567',
                  filled: true,
                  fillColor: AppColors.surface,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(AppSpacing.radiusMD),
                    borderSide: const BorderSide(color: AppColors.gray300),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(AppSpacing.radiusMD),
                    borderSide: const BorderSide(color: AppColors.gray300),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(AppSpacing.radiusMD),
                    borderSide: const BorderSide(
                      color: AppColors.primary,
                      width: 2,
                    ),
                  ),
                  errorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(AppSpacing.radiusMD),
                    borderSide: const BorderSide(color: AppColors.error),
                  ),
                  focusedErrorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(AppSpacing.radiusMD),
                    borderSide: const BorderSide(
                      color: AppColors.error,
                      width: 2,
                    ),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.paddingMD,
                    vertical: AppSpacing.paddingMD,
                  ),
                ),
                initialCountryCode: 'CO',
                onChanged: (phone) {
                  _phoneNumber = phone.completeNumber;
                },
                validator: (value) {
                  if (value == null || value.number.isEmpty) {
                    return 'El teléfono es requerido';
                  }
                  if (value.number.length < 10) {
                    return 'Ingresa un teléfono válido';
                  }
                  return null;
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMedicalInfoStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Información Médica', style: AppTypography.h5),
        UIHelpers.verticalSpaceMD,

        TextInput(
          label: 'Número de Licencia Médica',
          hint: 'Ej: 12345678',
          controller: _medicalLicenseController,
          isRequired: true,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'La licencia médica es requerida';
            }
            if (value.length < 5) {
              return 'Ingresa un número de licencia válido';
            }
            return null;
          },
        ),
        UIHelpers.verticalSpaceMD,

        SpecializationSelector(
          selectedSpecialization: _selectedSpecialization,
          onChanged: (value) {
            setState(() {
              _selectedSpecialization = value;
            });
          },
          isRequired: true,
        ),
        UIHelpers.verticalSpaceMD,

        TextInput(
          label: 'Años de Experiencia',
          hint: 'Ej: 5',
          controller: _yearsExperienceController,
          keyboardType: TextInputType.number,
          validator: (value) {
            if (value != null && value.isNotEmpty) {
              final years = int.tryParse(value);
              if (years == null || years < 0) {
                return 'Ingresa un número válido';
              }
            }
            return null;
          },
        ),
        UIHelpers.verticalSpaceMD,

        TextInput(
          label: 'Biografía Profesional',
          hint: 'Cuéntanos sobre tu experiencia y especialización...',
          controller: _bioController,
          maxLines: 3,
          validator: (value) {
            if (value != null && value.isNotEmpty && value.length < 50) {
              return 'La biografía debe tener al menos 50 caracteres';
            }
            return null;
          },
        ),
      ],
    );
  }

  Widget _buildDocumentationStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Documentación', style: AppTypography.h5),
        UIHelpers.verticalSpaceMD,

        Row(
          children: [
            Expanded(
              child: ImagePickerInput(
                label: 'Documento de Identidad',
                hint: 'Sube una foto de tu documento',
                selectedImage: _identityDocumentImage,
                onImageSelected: (image) {
                  setState(() {
                    _identityDocumentImage = image;
                  });
                },
                isRequired: true,
              ),
            ),
            UIHelpers.horizontalSpaceMD,
            Expanded(
              child: ImagePickerInput(
                label: 'Foto de Tarjeta Profesional',
                hint: 'Sube una foto clara de tu tarjeta profesional',
                selectedImage: _professionalCardImage,
                onImageSelected: (image) {
                  setState(() {
                    _professionalCardImage = image;
                  });
                },
                isRequired: true,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSecurityStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Seguridad', style: AppTypography.h5),
        UIHelpers.verticalSpaceMD,

        PasswordInput(
          label: 'Contraseña',
          hint: 'Mínimo 6 caracteres',
          controller: _passwordController,
          isRequired: true,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'La contraseña es requerida';
            }
            if (value.length < 6) {
              return 'La contraseña debe tener al menos 6 caracteres';
            }
            return null;
          },
        ),
        UIHelpers.verticalSpaceMD,

        PasswordInput(
          label: 'Confirmar contraseña',
          hint: 'Repite tu contraseña',
          controller: _confirmPasswordController,
          isRequired: true,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Confirma tu contraseña';
            }
            if (value != _passwordController.text) {
              return 'Las contraseñas no coinciden';
            }
            return null;
          },
        ),
      ],
    );
  }

  bool _validateCurrentStep() {
    switch (_currentPage) {
      case 0:
        return _formKey.currentState!.validate() &&
            _selectedIdentificationType != null &&
            _identificationNumber.isNotEmpty;
      case 1:
        return _selectedSpecialization != null;
      case 2:
        return _identityDocumentImage != null && _professionalCardImage != null;
      case 3:
        return _formKey.currentState!.validate();
      default:
        return false;
    }
  }

  void _register() {
    if (_selectedIdentificationType == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Por favor selecciona tu tipo de identificación'),
          backgroundColor: AppColors.error,
        ),
      );
      return;
    }
    if (_identificationNumber.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Por favor ingresa tu número de identificación'),
          backgroundColor: AppColors.error,
        ),
      );
      return;
    }
    if (_selectedSpecialization == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Por favor selecciona tu especialización'),
          backgroundColor: AppColors.error,
        ),
      );
      return;
    }
    if (_identityDocumentImage == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Por favor sube una foto de tu documento de identidad'),
          backgroundColor: AppColors.error,
        ),
      );
      return;
    }
    if (_professionalCardImage == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Por favor sube una foto de tu tarjeta profesional'),
          backgroundColor: AppColors.error,
        ),
      );
      return;
    }

    final userModel = UserModel.init().copyWith(
      name: _nameController.text.trim(),
      phone: _phoneNumber,
      email: _emailController.text.trim(),
      lastName: _lastNameController.text.trim(),
      specialization: _selectedSpecialization!,
      medicalLicense: _medicalLicenseController.text.trim(),
      professionalBiography: _bioController.text.trim().isNotEmpty
          ? _bioController.text.trim()
          : "",
      yearsOfExperience: _yearsExperienceController.text.isNotEmpty
          ? int.parse(_yearsExperienceController.text)
          : 0,
      identificationType: _selectedIdentificationType!,
      identificationNumber: _identificationNumber,
    );
    ref
        .read(authControllerProvider.notifier)
        .register(userModel, _passwordController.text);
  }
}
