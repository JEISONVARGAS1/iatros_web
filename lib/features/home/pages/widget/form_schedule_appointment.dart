import 'package:flutter/material.dart';
import 'package:iatros_web/core/models/notification_result_model.dart';
import 'package:iatros_web/core/models/user_company_model.dart';
import 'package:iatros_web/uikit/index.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:iatros_web/features/home/provider/home_controller.dart';
import 'package:iatros_web/features/home/provider/model/home_state.dart';
import 'package:iatros_web/features/home/pages/widget/selector_hour.dart';
import 'package:iatros_web/features/home/pages/widget/date_selected_card.dart';

class FormScheduleAppointment extends StatelessWidget {
  final HomeState state;
  final HomeController controller;

  const FormScheduleAppointment({
    super.key,
    required this.state,
    required this.controller,
  });

  Widget _buildMonthCell(BuildContext context, MonthCellDetails details) {
    bool hasSlots = controller.hasAvailableSlots(details.date);
    bool isPast = details.date.isBefore(DateTime.now());
    bool isSelected =
        state.selectedAppointmentDate != null &&
        details.date.isAtSameMomentAs(state.selectedAppointmentDate!);
    bool isToday =
        details.date.year == DateTime.now().year &&
        details.date.month == DateTime.now().month &&
        details.date.day == DateTime.now().day;

    Color backgroundColor;
    if (isSelected) {
      backgroundColor = AppColors.success.withOpacity(0.2);
    } else if (!isPast && hasSlots) {
      backgroundColor = AppColors.primary.withOpacity(0.1);
    } else {
      backgroundColor = Colors.transparent;
    }

    TextStyle textStyle;
    if (isToday) {
      textStyle = TextStyle(
        color: AppColors.primary,
        fontWeight: FontWeight.bold,
        fontSize: 15,
      );
    } else {
      textStyle = TextStyle(color: Colors.black);
    }

    Border? border;
    if (isSelected) {
      border = Border.all(color: AppColors.success);
    } else {
      border = Border.all(
        color: (isPast || !hasSlots)
            ? Colors.grey.withOpacity(0.5)
            : AppColors.primary,
        width: (isPast || !hasSlots) ? 1 : 2,
      );
    }

    return Padding(
      padding: const EdgeInsets.all(2),
      child: Container(
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: backgroundColor,
          border: border,
          borderRadius: BorderRadius.circular(4),
        ),
        child: Text(details.date.day.toString(), style: textStyle),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: state.form,
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
                  isRequired: true,
                  hint: 'Tu nombre',
                  controller: state.nameController,
                  validator: controller.validateField,
                ),
              ),
              UIHelpers.horizontalSpaceMD,
              Expanded(
                child: TextInput(
                  isRequired: true,
                  label: 'Apellido',
                  hint: 'Tu apellido',
                  validator: controller.validateField,
                  controller: state.lastNameController,
                ),
              ),
            ],
          ),
          UIHelpers.verticalSpaceMD,

          // Email
          TextInput(
            isRequired: true,
            hint: 'tu@email.com',
            label: 'Correo electrónico',
            controller: state.emailController,
            validator: controller.validateEmail,
            keyboardType: TextInputType.emailAddress,
          ),
          UIHelpers.verticalSpaceMD,

          // Identification
          IdentificationSelector(
            isRequired: true,
            errorText: controller.validateIdentification(),
            numberController: state.identificationNumberController,
            onTypeChanged: controller.selectedIdentificationTypeNotifier,
            selectedTypeNotifier: state.selectedIdentificationTypeNotifier,
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
                controller: state.phoneController,
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
                  controller.setPhoneMessageError(null);
                  controller.setPhone(phone);
                },
                validator: controller.validatePhone,
              ),

              if (state.phoneErrorMessage != null)
                Text(
                  state.phoneErrorMessage!,
                  style: AppTypography.caption.copyWith(color: AppColors.error),
                ),
            ],
          ),

          UIHelpers.verticalSpaceMD,

          // Address
          AddressAutocompleteInput(
            isRequired: true,
            hint: 'Busca tu dirección',
            onAddressSelected: (address) {},
            label: 'Dirección de Residencia',
            controller: state.addressController,
            errorText: controller.validateAddress(),
          ),
          UIHelpers.verticalSpaceMD,

          // Date of Birth
          DatePickerInput(
            isRequired: true,
            lastDate: DateTime.now(),
            label: 'Fecha de Nacimiento',
            errorText: controller.validateBirth(),
            selectedDateNotifier: state.dateOfBirthNotifier,
          ),
          UIHelpers.verticalSpaceMD,

          // Gender
          GenderSelector(
            isRequired: true,
            onChanged: controller.selectedGender,
            errorText: controller.validateGender(),
            selectedGenderNotifier: state.selectedGenderNotifier,
          ),
          UIHelpers.verticalSpaceMD,

          // Blood Type
          BloodTypeSelector(
            isRequired: true,
            onChanged: controller.selectedBloodType,
            selectedBloodTypeNotifier: state.selectedBloodTypeNotifier,
            errorText: controller.validateBlood(),
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
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                    if (state.selectedAppointmentDate != null &&
                        state.timeSlotsSelected != null) ...[
                      UIHelpers.horizontalSpaceMD,
                      DateSelectedCard(
                        date: state.selectedAppointmentDate!,
                        timeSlot: state.timeSlotsSelected!,
                      ),
                    ],
                  ],
                ),
                UIHelpers.verticalSpaceMD,
                // Calendar
                SizedBox(
                  height: 250,
                  child: SfCalendar(
                    minDate: DateTime.now(),
                    view: CalendarView.month,
                    onTap: (CalendarTapDetails details) {
                      final date = details.date;
                      if (date != null) {
                        controller.selectedAppointmentDate(date);
                      }
                    },
                    monthCellBuilder: _buildMonthCell,
                    todayHighlightColor: Colors.transparent,
                    todayTextStyle: TextStyle(
                      color: AppColors.primary,
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                    ),
                    showNavigationArrow: true,
                    selectionDecoration: BoxDecoration(
                      color: AppColors.primary.withOpacity(0.2),
                      border: Border.all(color: AppColors.primary),
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ),
                UIHelpers.verticalSpaceXL,
                Text('Horarios disponibles:', style: AppTypography.label),
                UIHelpers.verticalSpaceSM,
                SelectorHour(
                  selectedTimeSlot: state.timeSlotsSelected,
                  listSlots: controller.generateListTimeSlots(),
                  onTimeSlotSelect: controller.onTimeSlotSelected,
                ),
              ],
            ),
          ),
          UIHelpers.verticalSpaceMD,
          Center(
            child: SecondaryButton(
              label: "Agendar Cita",
              onPressed: () {
                controller.setHasTriedToValidate(true);

                if (state.form.currentState!.validate()) {
                  if (state.selectedIdentificationTypeNotifier.value == null ||
                      state.identificationNumberController.text.isEmpty) {
                    return;
                  }
                  if (state.phoneNumber.isEmpty) {
                    controller.setPhoneMessageError(
                      'El número de teléfono es requerido',
                    );
                    return;
                  }

                  if (state.dateOfBirthNotifier.value == null) {
                    controller.addNotification(
                      "Escoger el día de nacimiento es obligatorio.",
                      StatusNotification.ERROR,
                    );
                    return;
                  }
                  if (state.selectedGenderNotifier.value == null) {
                    controller.addNotification(
                      "Escoger el género es obligatorio.",
                      StatusNotification.ERROR,
                    );
                    return;
                  }
                  if (state.selectedBloodTypeNotifier.value == null) {
                    controller.addNotification(
                      "Escoger el tipo de sangre es obligatorio.",
                      StatusNotification.ERROR,
                    );
                    return;
                  }
                  if (state.userCompany.rolUser != RolUser.DOCTOR &&
                      state.doctorSelected == null) {
                    controller.addNotification(
                      "Escoger el médico es obligatorio.",
                      StatusNotification.ERROR,
                    );
                    return;
                  }
                  if (state.selectedAppointmentDate == null) {
                    controller.addNotification(
                      "Escoger el día de la cita es obligatorio.",
                      StatusNotification.ERROR,
                    );
                    return;
                  }
                  if (state.timeSlotsSelected == null) {
                    controller.addNotification(
                      "Escoger el horario de la cita es obligatorio.",
                      StatusNotification.ERROR,
                    );
                    return;
                  }

                  controller.scheduleAppointment();
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
