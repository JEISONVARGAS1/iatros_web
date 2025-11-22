import 'package:flutter/material.dart';
import 'package:iatros_web/uikit/index.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:iatros_web/core/models/time_slots_model.dart';
import 'package:iatros_web/features/home/provider/home_controller.dart';

class FormScheduleAppointment extends ConsumerStatefulWidget {
  const FormScheduleAppointment({super.key});

  @override
  ConsumerState<FormScheduleAppointment> createState() =>
      _FormScheduleAppointmentState();
}

class _FormScheduleAppointmentState
    extends ConsumerState<FormScheduleAppointment> {
  final _formKey = GlobalKey<FormState>();
  bool _hasTriedToValidate = false;

  String? phoneErrorMessage;
  String phoneData = "";

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(homeControllerProvider).value!;
    final controller = ref.read(homeControllerProvider.notifier);

    return Form(
      key: _formKey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          UIHelpers.verticalSpaceXL,

          // Name and Last Name
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

          // Email
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

          // Identification
          IdentificationSelector(
            isRequired: true,
            onNumberChanged: (value) {},
            numberController: state.identificationNumberController,
            onTypeChanged: controller.selectedIdentificationTypeNotifier,
            selectedTypeNotifier: state.selectedIdentificationTypeNotifier,
            errorText:
                state.identificationNumberController.text.isEmpty &&
                    _hasTriedToValidate
                ? 'La identificación es requerida'
                : null,
          ),
          UIHelpers.verticalSpaceMD,

          // Phone
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
                  phoneData = phone.completeNumber;
                  setState(() {
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

          // Address
          AddressAutocompleteInput(
            label: 'Dirección de Residencia',
            hint: 'Busca tu dirección',
            controller: state.addressController,
            isRequired: true,
            errorText:
                (state.addressController.text.isEmpty && _hasTriedToValidate)
                ? 'La dirección es requerida'
                : null,
            onAddressSelected: (address) {},
            onPlaceDetailsSelected: (placeDetails) {
              // Handle place details if needed
            },
          ),
          UIHelpers.verticalSpaceMD,

          // Date of Birth
          DatePickerInput(
            isRequired: true,
            label: 'Fecha de Nacimiento',
            selectedDateNotifier: state.dateOfBirthNotifier,
            onDateSelected: (date) {},
            lastDate: DateTime(
              DateTime.now().year,
              DateTime.now().month,
              DateTime.now().day,
            ),
            errorText:
                state.dateOfBirthNotifier.value == null && _hasTriedToValidate
                ? 'La fecha de nacimiento es requerida'
                : null,
          ),
          UIHelpers.verticalSpaceMD,

          // Gender
          GenderSelector(
            isRequired: true,
            onChanged: controller.selectedGender,
            selectedGenderNotifier: state.selectedGenderNotifier,
            errorText:
                state.selectedGenderNotifier.value == null &&
                    _hasTriedToValidate
                ? 'El sexo es requerido'
                : null,
          ),
          UIHelpers.verticalSpaceMD,

          // Blood Type
          BloodTypeSelector(
            isRequired: true,
            onChanged: controller.selectedBloodType,
            selectedBloodTypeNotifier: state.selectedBloodTypeNotifier,
            errorText:
                state.selectedBloodTypeNotifier.value == null &&
                    _hasTriedToValidate
                ? 'El grupo sanguíneo es requerido'
                : null,
          ),
          UIHelpers.verticalSpaceMD,

          // Appointment Scheduling
          Container(
            decoration: BoxDecoration(
              border: Border.all(color: AppColors.gray300),
              borderRadius: BorderRadius.circular(AppSpacing.radiusMD),
            ),
            padding: const EdgeInsets.all(AppSpacing.paddingMD),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                RichText(
                  text: TextSpan(
                    text: "Selecciona la fecha y hora de la cita",
                    style: AppTypography.label,
                    children: [
                      const TextSpan(
                        text: ' *',
                        style: TextStyle(color: AppColors.error),
                      ),
                    ],
                  ),
                ),
                UIHelpers.verticalSpaceMD,
                // Calendar
                SizedBox(
                  height: 250,
                  child: SfCalendar(
                    view: CalendarView.month,
                    onTap: (CalendarTapDetails details) {
                      final date = details.date;
                      if (date != null) {
                        controller.selectedAppointmentDate(date);
                      }
                    },
                    todayHighlightColor: AppColors.primary,
                    selectionDecoration: BoxDecoration(
                      color: AppColors.primary.withOpacity(0.2),
                      border: Border.all(color: AppColors.primary),
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ),
                UIHelpers.verticalSpaceMD,
                // Time Slots
                Text('Horarios disponibles:', style: AppTypography.label),
                UIHelpers.verticalSpaceSM,
                ValueListenableBuilder<TimeSlotsModel?>(
                  valueListenable: state.selectedTimeSlot,
                  builder: (context, selectedSlot, _) {
                    return Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: state.listTimeSlots.map((slot) {
                        bool isSelected = selectedSlot == slot;
                        return GestureDetector(
                          onTap: () {},
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 8,
                            ),
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? AppColors.primary
                                  : AppColors.surface,
                              border: Border.all(color: AppColors.gray300),
                              borderRadius: BorderRadius.circular(
                                AppSpacing.radiusSM,
                              ),
                            ),
                            child: Text(
                              "slot",
                              style: AppTypography.bodyMedium.copyWith(
                                color: isSelected
                                    ? Colors.white
                                    : AppColors.textPrimary,
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    );
                  },
                ),
              ],
            ),
          ),

          UIHelpers.verticalSpaceMD,

          // Submit Button
          Center(
            child: SecondaryButton(
              label: "Agendar Cita",
              onPressed: () {
                setState(() => _hasTriedToValidate = true);

                if (_formKey.currentState!.validate()) {
                  if (state.selectedIdentificationTypeNotifier.value == null ||
                      state.identificationNumberController.text.isEmpty) {
                    return;
                  }
                  if (phoneData.isEmpty) {
                    setState(() {
                      phoneErrorMessage = 'El número de teléfono es requerido';
                    });
                    return;
                  }
                  if (state.dateOfBirthNotifier.value == null) return;
                  if (state.selectedGenderNotifier.value == null) return;
                  if (state.selectedBloodTypeNotifier.value == null) return;
                  if (state.selectedAppointmentDate.value == null) return;
                  if (state.selectedTimeSlot.value == null) return;

                  // Here you would handle the appointment scheduling
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Cita agendada exitosamente')),
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
