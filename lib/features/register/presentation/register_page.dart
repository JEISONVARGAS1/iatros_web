import 'package:flutter/material.dart';
import 'package:iatros_web/router.dart';
import 'package:go_router/go_router.dart';
import 'package:iatros_web/uikit/index.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:iatros_web/core/enum/company_type.dart';
import 'package:iatros_web/uikit/extensions/context_extension.dart';
import 'package:iatros_web/features/register/provider/register_controller.dart';
import 'package:iatros_web/features/register/provider/model/register_state.dart';
import 'package:iatros_web/features/auth/provider/auth_controller.dart';

class RegisterPage extends ConsumerStatefulWidget {
  const RegisterPage({super.key});

  @override
  ConsumerState<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends ConsumerState<RegisterPage> {
  @override
  Widget build(BuildContext context) {
    final registerState = ref.watch(registerControllerProvider).value!;
    final registerController = ref.read(registerControllerProvider.notifier);

    ref.listen(authControllerProvider, (previous, next) {
      if (next.value!.errorMessage.isNotEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(next.value!.errorMessage),
            backgroundColor: AppColors.error,
          ),
        );
        ref.read(authControllerProvider.notifier).clearError();
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
                      children: List.generate(5, (index) {
                        return Container(
                          width: 8,
                          height: 8,
                          margin: const EdgeInsets.symmetric(horizontal: 4),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: index <= registerState.currentPage
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
                        controller: registerState.pageController,
                        onPageChanged: (page) {
                          registerController.setCurrentPage(page);
                        },
                        children: [
                          SingleChildScrollView(
                            child: _buildPersonalInfoStep(
                              registerState,
                              registerController,
                            ),
                          ),
                          SingleChildScrollView(
                            child: _buildCompanyStep(registerState, registerController),
                          ),
                          SingleChildScrollView(
                            child: _buildMedicalInfoStep(
                              registerState,
                              registerController,
                            ),
                          ),
                          SingleChildScrollView(
                            child: _buildDocumentationStep(
                              registerState,
                              registerController,
                            ),
                          ),
                          SingleChildScrollView(
                            child: _buildSecurityStep(
                              registerState,
                              registerController,
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Botones de navegación
                    Row(
                      children: [
                        if (registerState.currentPage > 0)
                          Expanded(
                            child: SecondaryButton(
                              label: 'Anterior',
                              onPressed: () {
                                registerState.pageController.previousPage(
                                  duration: const Duration(milliseconds: 300),
                                  curve: Curves.easeInOut,
                                );
                              },
                            ),
                          ),
                        if (registerState.currentPage > 0)
                          UIHelpers.horizontalSpaceMD,
                        Expanded(
                          child: registerState.currentPage == 4
                              ? PrimaryButton(
                                  label: 'Registrarse como Médico',
                                  isLoading: registerState.isRegisterLoading,
                                  onPressed: () =>
                                      registerController.registerFromForm(context),
                                )
                              : PrimaryButton(
                                  label: 'Siguiente',
                                  onPressed: () {
                                    registerController.setHasTriedToValidate(true);
                                    if (registerController.validateCurrentStep()) {
                                      registerState.pageController.nextPage(
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

  Widget _buildPersonalInfoStep(
    RegisterState registerState,
    RegisterController registerController,
  ) {
    return Form(
      key: registerState.formKey,
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
                  controller: registerState.nameController,
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
                  controller: registerState.lastNameController,
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
            controller: registerState.emailController,
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

          AddressAutocompleteInput(
            label: 'Dirección de Residencia',
            hint: 'Busca tu dirección',
            controller: registerState.addressController,
            isRequired: true,
            errorText:
                (registerState.addressController.text.isEmpty &&
                    registerState.hasTriedToValidate &&
                    registerState.currentPage == 0)
                ? 'La dirección es requerida'
                : null,
            onAddressSelected: (address) {
              // La dirección ya se actualiza en el controller
            },
            onPlaceDetailsSelected: (placeDetails) {
              registerController.setAddressCoordinates(
                placeDetails.latitude,
                placeDetails.longitude,
              );
              registerState.addressController.text = placeDetails.formattedAddress;
            },
          ),
          UIHelpers.verticalSpaceMD,

          DatePickerInput(
            isRequired: true,
            label: 'Fecha de Nacimiento',
            selectedDateNotifier: registerState.dateOfBirth,
            onDateSelected: registerController.setDateOfBirth,
            errorText:
                (registerState.dateOfBirth.value == null) &&
                    registerState.hasTriedToValidate &&
                    registerState.currentPage == 0
                ? 'La fecha de nacimiento es requerida'
                : null,
          ),
          UIHelpers.verticalSpaceMD,

          GenderSelector(
            selectedGenderNotifier: registerState.selectedGender,
            onChanged: (value) {
              registerController.setSelectedGender(value);
            },
            isRequired: true,
            errorText:
                registerState.selectedGender.value == null &&
                    registerState.hasTriedToValidate &&
                    registerState.currentPage == 0
                ? 'El sexo es requerido'
                : null,
          ),
          UIHelpers.verticalSpaceMD,

          BloodTypeSelector(
            selectedBloodTypeNotifier: registerState.selectedBloodType,
            onChanged: (value) {
              registerController.setSelectedBloodType(value);
            },
            isRequired: true,
            errorText:
                registerState.selectedBloodType.value == null &&
                    registerState.hasTriedToValidate &&
                    registerState.currentPage == 0
                ? 'El grupo sanguíneo es requerido'
                : null,
          ),
          UIHelpers.verticalSpaceMD,

          IdentificationSelector(
            selectedTypeNotifier: registerState.selectedIdentificationType,
            numberController: registerState.identificationNumberController,
            onTypeChanged: (value) {
              registerController.setSelectedIdentificationType(value);
            },
            onNumberChanged: (value) {
              registerController.setIdentificationNumber(value);
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
                  registerController.setPhoneNumber(phone.completeNumber);
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

  Widget _buildCompanyStep(RegisterState registerState, RegisterController registerController) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Información de Empresa', style: AppTypography.h5),
        UIHelpers.verticalSpaceMD,

        TextInput(
          label: 'Nombre de la Empresa',
          hint: 'Ej: Clínica San José',
          controller: registerState.companyNameController,
          isRequired: true,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'El nombre de la empresa es requerido';
            }
            if (value.length < 3) {
              return 'El nombre debe tener al menos 3 caracteres';
            }
            return null;
          },
        ),
        UIHelpers.verticalSpaceMD,

        TextInput(
          label: 'Documentación Empresa (NIT)',
          hint: 'Ej: 900123456-7',
          controller: registerState.companyNitController,
          isRequired: true,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'El NIT es requerido';
            }
            if (value.length < 5) {
              return 'Ingresa un NIT válido';
            }
            return null;
          },
        ),
        UIHelpers.verticalSpaceMD,

        FilePickerInput(
          label: 'Documentación de la Empresa',
          hint: 'Sube documentos de la empresa en formato PDF',
          selectedFile: registerState.companyDocumentImage,
          onFileSelected: (file) {
            registerController.setCompanyDocumentImage(file);
          },
          isRequired: true,
          allowedExtensions: ['pdf'],
        ),
        UIHelpers.verticalSpaceMD,

        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            RichText(
              text: TextSpan(
                text: "Tipo de Empresa",
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
            Row(
              children: [
                Expanded(
                  child: _buildCompanyTypeButton(
                    label: CompanyType.personal.label,
                    type: CompanyType.personal,
                    icon: Icons.person,
                  ),
                ),
                UIHelpers.horizontalSpaceMD,
                Expanded(
                  child: _buildCompanyTypeButton(
                    label: CompanyType.company.label,
                    type: CompanyType.company,
                    icon: Icons.business,
                  ),
                ),
              ],
            ),
            UIHelpers.verticalSpaceXL,
            if (registerState.selectedCompanyType == null &&
                registerState.hasTriedToValidate &&
                registerState.currentPage == 1)
              Padding(
                padding: const EdgeInsets.only(top: AppSpacing.sm),
                child: Text(
                  'Selecciona el tipo de empresa',
                  style: AppTypography.bodySmall.copyWith(
                    color: AppColors.error,
                  ),
                ),
              ),
          ],
        ),
      ],
    );
  }

  Widget _buildCompanyTypeButton({
    required String label,
    required CompanyType type,
    required IconData icon,
  }) {
    final registerState = ref.watch(registerControllerProvider).value!;
    final registerController = ref.read(registerControllerProvider.notifier);
    final isSelected = registerState.selectedCompanyType == type;

    return InkWell(
      onTap: () {
        registerController.setSelectedCompanyType(type);
      },
      borderRadius: BorderRadius.circular(AppSpacing.radiusMD),
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.paddingLG),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.primary.withValues(alpha: 0.1)
              : AppColors.surface,
          border: Border.all(
            color: isSelected ? AppColors.primary : AppColors.gray300,
            width: isSelected ? 2 : 1,
          ),
          borderRadius: BorderRadius.circular(AppSpacing.radiusMD),
        ),
        child: Column(
          children: [
            Icon(
              icon,
              size: 40,
              color: isSelected ? AppColors.primary : AppColors.textSecondary,
            ),
            UIHelpers.verticalSpaceSM,
            Text(
              label,
              style: AppTypography.bodyMedium.copyWith(
                color: isSelected ? AppColors.primary : AppColors.textPrimary,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMedicalInfoStep(
    RegisterState registerState,
    RegisterController registerController,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Información Médica', style: AppTypography.h5),
        UIHelpers.verticalSpaceMD,

        TextInput(
          label: 'Número de Licencia Médica',
          hint: 'Ej: 12345678',
          controller: registerState.medicalLicenseController,
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
          selectedSpecialization: registerState.selectedSpecialization,
          onChanged: (value) {
            registerController.setSelectedSpecialization(value);
          },
          isRequired: true,
        ),
        UIHelpers.verticalSpaceMD,

        TextInput(
          label: 'Años de Experiencia',
          hint: 'Ej: 5',
          controller: registerState.yearsExperienceController,
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
          controller: registerState.bioController,
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

  Widget _buildDocumentationStep(
    RegisterState registerState,
    RegisterController registerController,
  ) {
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
                selectedImage: registerState.identityDocumentImage,
                onImageSelected: (image) {
                  registerController.setIdentityDocumentImage(image);
                },
                isRequired: true,
              ),
            ),
            UIHelpers.horizontalSpaceMD,
            Expanded(
              child: ImagePickerInput(
                label: 'Foto de Tarjeta Profesional',
                hint: 'Sube una foto clara de tu tarjeta profesional',
                selectedImage: registerState.professionalCardImage,
                onImageSelected: (image) {
                  registerController.setProfessionalCardImage(image);
                },
                isRequired: true,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSecurityStep(
    RegisterState registerState,
    RegisterController registerController,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Seguridad', style: AppTypography.h5),
        UIHelpers.verticalSpaceMD,

        PasswordInput(
          label: 'Contraseña',
          hint: 'Mínimo 6 caracteres',
          controller: registerState.passwordController,
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
          controller: registerState.confirmPasswordController,
          isRequired: true,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Confirma tu contraseña';
            }
            if (value != registerState.passwordController.text) {
              return 'Las contraseñas no coinciden';
            }
            return null;
          },
        ),
      ],
    );
  }
}
