import 'package:flutter/material.dart';
import 'package:iatros_web/core/models/medical_appointment_booking_view.dart';
import 'package:iatros_web/uikit/index.dart';
import 'package:iatros_web/core/extension/appointment_status_extension.dart';
import 'package:iatros_web/core/models/medical_appointment_booking_model.dart';

class AppointmentBookingCard extends StatelessWidget {
  final VoidCallback onEditTap;
  final Function() onTapCard;
  final MedicalAppointmentBookingViewModel appointment;

  const AppointmentBookingCard({
    super.key,
    required this.onEditTap,
    required this.onTapCard,
    required this.appointment,
  });

  @override
  Widget build(BuildContext context) {
    final status = appointment.status;
    final statusColor = status.toColor;
    final userName =
        '${appointment.patient.name} ${appointment.patient.lastName}';
    final dateTime = appointment.scheduleMedicalAppointment.toLocal();
    final date = '${dateTime.day}/${dateTime.month}/${dateTime.year}';
    final time =
        '${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [AppColors.surface, AppColors.surface.withOpacity(0.8)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(AppSpacing.radiusLG),
        border: Border.all(color: statusColor.withOpacity(0.2), width: 1.5),
        boxShadow: [
          BoxShadow(
            color: statusColor.withOpacity(0.1),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
          BoxShadow(
            color: AppColors.gray900.withOpacity(0.05),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(AppSpacing.radiusLG),
        child: InkWell(
          borderRadius: BorderRadius.circular(AppSpacing.radiusLG),
          onTap: onTapCard,
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.paddingMD),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                // Status indicator with gradient
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [statusColor, statusColor.withOpacity(0.8)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(AppSpacing.radiusMD),
                    boxShadow: [
                      BoxShadow(
                        color: statusColor.withOpacity(0.3),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Icon(
                    status == AppointmentStatus.COMPLETED
                        ? Icons.check_circle
                        : status == AppointmentStatus.WAITING
                        ? Icons.schedule
                        : Icons.attach_money,
                    color: AppColors.white,
                    size: 24,
                  ),
                ),
                UIHelpers.horizontalSpaceMD,
                // Main content
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // User name
                    Text(
                      userName,
                      style: AppTypography.bodyLarge.copyWith(
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    UIHelpers.verticalSpaceXS,
                    // Date and time
                    Row(
                      children: [
                        Icon(
                          Icons.calendar_today,
                          size: 16,
                          color: AppColors.textSecondary,
                        ),
                        UIHelpers.horizontalSpaceXS,
                        Text(
                          date,
                          style: AppTypography.bodyMedium.copyWith(
                            color: AppColors.textSecondary,
                          ),
                        ),
                        UIHelpers.horizontalSpaceMD,
                        Icon(
                          Icons.access_time,
                          size: 16,
                          color: AppColors.textSecondary,
                        ),
                        UIHelpers.horizontalSpaceXS,
                        Text(
                          time,
                          style: AppTypography.bodyMedium.copyWith(
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                UIHelpers.horizontalSpaceXL,
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.paddingSM,
                  ),
                  margin: EdgeInsets.only(top: 2),
                  decoration: BoxDecoration(
                    color: statusColor.withOpacity(0.1),
                    border: Border.all(
                      color: statusColor.withOpacity(0.3),
                      width: 1,
                    ),
                    borderRadius: BorderRadius.circular(AppSpacing.radiusSM),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 6,
                        height: 6,
                        decoration: BoxDecoration(
                          color: statusColor,
                          shape: BoxShape.circle,
                        ),
                      ),
                      UIHelpers.horizontalSpaceXS,
                      Text(
                        status.toName,
                        style: AppTypography.label.copyWith(
                          color: statusColor,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
                Spacer(),
                // Edit icon
                Material(
                  color: Colors.transparent,
                  borderRadius: BorderRadius.circular(AppSpacing.radiusMD),
                  child: InkWell(
                    onTap: onEditTap,
                    borderRadius: BorderRadius.circular(AppSpacing.radiusMD),
                    child: Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color: AppColors.primary.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(
                          AppSpacing.radiusMD,
                        ),
                      ),
                      child: Icon(
                        Icons.edit,
                        color: AppColors.primary,
                        size: 20,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
