import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iatros_web/uikit/index.dart';
import 'package:iatros_web/core/models/user_model.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:iatros_web/features/patients_seek/provider/patients_seek_controller.dart';
import 'package:iatros_web/features/patients_seek/provider/model/patients_seek_state.dart';

class FormCreatePatient extends ConsumerStatefulWidget {
  final Function(UserModel) goToPatient;

  const FormCreatePatient({
    super.key,
    required this.goToPatient,
  });

  @override
  ConsumerState<FormCreatePatient> createState() => _FormCreatePatientState();
}

class _FormCreatePatientState extends ConsumerState<FormCreatePatient> {
  String? phoneErrorMessage;
  late String phoneData = "";
  final _formKey = GlobalKey<FormState>();
  bool _hasTriedToValidate = false; // Flag para saber si se intentó validar

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(patientsSeekControllerProvider);
    final controller = ref.read(patientsSeekControllerProvider.notifier);

    return state.when(
      data: (data) => _buildForm(context, data, controller),
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stack) => Center(child: Text('Error: $error')),
    );
  }

  Widget _buildForm(BuildContext context, PatientsSeekState state, PatientsSeekController controller) {
    return Form(
      key: _formKey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          UIHelpers.verticalSpaceXL,

          Row(
            children: [
              Expanded(
                child: TextInput(
                  label: 'Nombre',
                  hint: 'Tu nombre',
                  controller: state.nameController,
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
                  controller: state.lastNameController,
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
            controller: state.emailController,
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
            selectedTypeNotifier: state.selectedIdentificationTypeNotifier,
            numberController: state.identificationNumberController,
            errorText: (state.selectedIdentificationType == null || state.identificationNumber.isEmpty) && _hasTriedToValidate
                ? 'La identificación es requerida'
                : null,
            onTypeChanged: controller.setSelectedIdentificationType,
            onNumberChanged: controller.setIdentificationNumber,
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
                  controller.setPhoneNumber(phone.completeNumber);
                  setState(() {
                    phoneData = phone.completeNumber;
                    phoneErrorMessage = null;
                  });
                },
                validator: (value) {
                  if (value == null || value.number.isEmpty) {
                    return 'El teléfono es requerido';
                  }
                  if (value.number.length < 10) {
                    return 'El teléfono debe tener al menos 10 dígitos';
                  }
                  if (!RegExp(r'^\d+$').hasMatch(value.number)) {
                    return 'El teléfono solo puede contener números';
                  }
                  return null;
                },
              ),

              if (phoneErrorMessage != null)
                Text(
                  phoneErrorMessage!,
                  style: AppTypography.caption.copyWith(color: AppColors.error),
                ),
            ],
          ),

          UIHelpers.verticalSpaceMD,

          AddressAutocompleteInput(
            label: 'Dirección de Residencia',
            hint: 'Busca tu dirección',
            controller: state.addressController,
            isRequired: true,
            errorText:
                (state.addressController.text.isEmpty &&
                    _hasTriedToValidate)
                ? 'La dirección es requerida'
                : null,
            onAddressSelected: (address) {
              setState(() {
                // La dirección ya se actualiza en el controller
              });
            },
            onPlaceDetailsSelected: (placeDetails) {
              setState(() {
                controller.setAddressLatitude(placeDetails.latitude);
                controller.setAddressLongitude(placeDetails.longitude);
                state.addressController.text =
                    placeDetails.formattedAddress;
              });
            },
          ),
          UIHelpers.verticalSpaceMD,
          DatePickerInput(
            isRequired: true,
            label: 'Fecha de Nacimiento',
            selectedDateNotifier: state.dateOfBirthNotifier,
            onDateSelected: controller.setDateOfBirth,
            lastDate: DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day),
            errorText: state.dateOfBirth == null && _hasTriedToValidate
                ? 'La fecha de nacimiento es requerida'
                : null,
          ),
          UIHelpers.verticalSpaceMD,

          GenderSelector(
            selectedGenderNotifier: state.selectedGenderNotifier,
            onChanged: controller.setSelectedGender,
            isRequired: true,
            errorText:
                state.selectedGender == null && _hasTriedToValidate
                ? 'El sexo es requerido'
                : null,
          ),
          UIHelpers.verticalSpaceMD,

          BloodTypeSelector(
            selectedBloodTypeNotifier: state.selectedBloodTypeNotifier,
            onChanged: controller.setSelectedBloodType,
            isRequired: true,
            errorText:
                state.selectedBloodType == null && _hasTriedToValidate
                ? 'El grupo sanguíneo es requerido'
                : null,
          ),
          UIHelpers.verticalSpaceMD,

          Center(
            child: SecondaryButton(
              label: "Crear paciente",
              onPressed: () {
                setState(() => _hasTriedToValidate = true);

                // Validate form
                if (_formKey.currentState!.validate()) {
                  // Additional validation for identification
                  if (state.selectedIdentificationType == null || state.identificationNumber.isEmpty) {
                    return;
                  }
                  if (phoneData.isEmpty) {
                    setState(() {
                      phoneErrorMessage = 'El numero de telefono es requerida';
                    });
                    return;
                  }
                  if (state.dateOfBirth == null) {
                    return;
                  }
                  if (state.selectedGender == null) {
                    return;
                  }
                  if (state.selectedBloodType == null) {
                    return;
                  }

                  controller.createPatient(
                    context,
                    (user) => widget.goToPatient(user),
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
