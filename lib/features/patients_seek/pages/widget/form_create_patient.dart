import 'package:flutter/material.dart';
import 'package:iatros_web/uikit/index.dart';
import 'package:iatros_web/core/models/user_model.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:iatros_web/features/patients_seek/provider/patients_seek_controller.dart';
import 'package:iatros_web/features/patients_seek/provider/model/patients_seek_state.dart';

class FormCreatePatient extends StatefulWidget {
  final PatientsSeekState state;
  final Function(UserModel) goToPatient;
  final PatientsSeekController controller;

  const FormCreatePatient({
    super.key,
    required this.state,
    required this.controller,
    required this.goToPatient,
  });

  @override
  State<FormCreatePatient> createState() => _FormCreatePatientState();
}

class _FormCreatePatientState extends State<FormCreatePatient> {
  String? errorMessage;
  String? phoneErrorMessage;
  late String phoneData = "";
  String? identificationType;
  late String identification = "";
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
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
                  controller: widget.state.nameController,
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
                  controller: widget.state.lastNameController,
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
            controller: widget.state.emailController,
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
            selectedType: identificationType,
            identificationNumber: identification,
            errorText: errorMessage,
            onTypeChanged: (value) {
              setState(() => identificationType = value);
              widget.controller.setSelectedIdentificationType(value);
            },
            onNumberChanged: (value) {
              setState(() => identification = value);
              widget.controller.setIdentificationNumber(value);
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
                  widget.controller.setPhoneNumber(phone.completeNumber);
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

          Center(
            child: SecondaryButton(
              label: "Crear paciente",
              onPressed: () {
                setState(() => errorMessage = null);

                // Validate form
                if (_formKey.currentState!.validate()) {
                  // Additional validation for identification
                  if (identificationType == null || identification.isEmpty) {
                    setState(
                      () => errorMessage = 'La identificación es requerida',
                    );
                    return;
                  }
                  if (phoneData.isEmpty) {
                    setState(() {
                      phoneErrorMessage = 'El numero de telefono es requerida';
                    });
                    return;
                  }

                  widget.controller.createPatient(
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
