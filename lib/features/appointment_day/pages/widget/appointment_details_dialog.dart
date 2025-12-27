import 'package:flutter/material.dart';
import 'package:iatros_web/core/extension/appointment_status_extension.dart';
import 'package:iatros_web/core/models/medical_appointment_booking_model.dart';
import 'package:iatros_web/core/models/medical_appointment_booking_view.dart';
import 'package:iatros_web/uikit/index.dart';

class AppointmentDetailsDialog extends StatefulWidget {
  final MedicalAppointmentBookingViewModel appointment;
  final Function(AppointmentStatus) onStatusChanged;

  const AppointmentDetailsDialog({
    super.key,
    required this.appointment,
    required this.onStatusChanged,
  });

  @override
  State<AppointmentDetailsDialog> createState() =>
      _AppointmentDetailsDialogState();
}

class _AppointmentDetailsDialogState extends State<AppointmentDetailsDialog> {
  late AppointmentStatus _selectedStatus;

  @override
  void initState() {
    super.initState();
    _selectedStatus = widget.appointment.status;
  }

  @override
  Widget build(BuildContext context) {
    final userName =
        '${widget.appointment.patient.name} ${widget.appointment.patient.lastName}';
    final userDocument = widget.appointment.patient.identificationNumber;
    final dateTime = widget.appointment.scheduleMedicalAppointment.toLocal();
    final date = '${dateTime.day}/${dateTime.month}/${dateTime.year}';
    final time =
        '${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';

    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSpacing.radiusLG),
      ),
      child: Container(
        constraints: const BoxConstraints(maxWidth: 500),
        padding: const EdgeInsets.all(AppSpacing.paddingLG),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              children: [
                Icon(
                  Icons.medical_services,
                  color: AppColors.primary,
                  size: 28,
                ),
                UIHelpers.horizontalSpaceMD,
                Expanded(
                  child: Text(
                    'Detalles de la Cita',
                    style: AppTypography.h5.copyWith(
                      color: AppColors.textPrimary,
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: Icon(Icons.close, color: AppColors.textSecondary),
                ),
              ],
            ),
            UIHelpers.verticalSpaceLG,

            // Patient Info
            _buildInfoSection('Paciente', [
              userName,
              userDocument,
            ], Icons.person),
            UIHelpers.verticalSpaceMD,

            // Date & Time
            Row(
              children: [
                Expanded(
                  child: _buildInfoSection('Fecha', [
                    date,
                  ], Icons.calendar_today),
                ),
                UIHelpers.horizontalSpaceMD,
                Expanded(
                  child: _buildInfoSection('Hora', [time], Icons.access_time),
                ),
              ],
            ),
            UIHelpers.verticalSpaceMD,

            // Doctor ID (placeholder)
            _buildInfoSection('ID del Doctor', [
              widget.appointment.userCompanyId,
            ], Icons.medical_services),
            UIHelpers.verticalSpaceMD,

            // Created At
            _buildInfoSection('Creado', [
              '${widget.appointment.createdAt.day}/${widget.appointment.createdAt.month}/${widget.appointment.createdAt.year}',
            ], Icons.history),
            UIHelpers.verticalSpaceLG,

            // Status Section
            Text(
              'Estado de la Cita',
              style: AppTypography.bodyLarge.copyWith(
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
            UIHelpers.verticalSpaceMD,

            // Status Dropdown
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.paddingMD,
              ),
              decoration: BoxDecoration(
                border: Border.all(color: AppColors.gray300),
                borderRadius: BorderRadius.circular(AppSpacing.radiusMD),
              ),
              child: DropdownButton<AppointmentStatus>(
                value: _selectedStatus,
                isExpanded: true,
                underline: const SizedBox(),
                items: AppointmentStatus.values.map((status) {
                  return DropdownMenuItem(
                    value: status,
                    child: Row(
                      children: [
                        Container(
                          width: 12,
                          height: 12,
                          decoration: BoxDecoration(
                            color: status.toColor,
                            shape: BoxShape.circle,
                          ),
                        ),
                        UIHelpers.horizontalSpaceSM,
                        Text(status.toName, style: AppTypography.bodyMedium),
                      ],
                    ),
                  );
                }).toList(),
                onChanged: (newStatus) {
                  if (newStatus != null) {
                    setState(() {
                      _selectedStatus = newStatus;
                    });
                  }
                },
              ),
            ),
            UIHelpers.verticalSpaceXL,

            // Action Buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text(
                    'Cancelar',
                    style: AppTypography.button.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                ),
                UIHelpers.horizontalSpaceMD,
                PrimaryButton(
                  label: 'Guardar Cambios',
                  onPressed: () {
                    widget.onStatusChanged(_selectedStatus);
                    Navigator.of(context).pop();
                    // Show success message
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Estado de la cita actualizado'),
                        backgroundColor: AppColors.success,
                      ),
                    );
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoSection(String label, List<String> values, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.paddingMD),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppSpacing.radiusMD),
        border: Border.all(color: AppColors.gray200),
      ),
      child: Row(
        children: [
          Icon(icon, color: AppColors.primary, size: 20),
          UIHelpers.horizontalSpaceMD,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: AppTypography.label.copyWith(
                    color: AppColors.textSecondary,
                    fontSize: 12,
                  ),
                ),
                UIHelpers.verticalSpaceXS,
                ...values.map(
                  (value) => Text(
                    values.length > 1 ? '- $value' : value,
                    style: AppTypography.bodyMedium.copyWith(
                      color: AppColors.textPrimary,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
