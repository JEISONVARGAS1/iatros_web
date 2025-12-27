import 'package:flutter/material.dart';
import 'package:iatros_web/core/models/time_slots_model.dart';
import 'package:iatros_web/uikit/index.dart';

class DateSelectedCard extends StatelessWidget {
  final DateTime date;
  final TimeSlotsModel timeSlot;

  const DateSelectedCard({
    super.key,
    required this.date,
    required this.timeSlot,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.primary.withOpacity(0.15),
            AppColors.primary.withOpacity(0.05),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(AppSpacing.radiusMD),
        border: Border.all(
          color: AppColors.primary.withOpacity(0.4),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.2),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.event_available,
              size: 12,
              color: AppColors.primary,
            ),
          ),
          UIHelpers.horizontalSpaceSM,
          Text(
            _formatSelectedDateTime(date, timeSlot),
            style: AppTypography.bodySmall.copyWith(
              color: AppColors.primary,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.5,
            ),
          ),
        ],
      ),
    );
  }

  String _formatSelectedDateTime(DateTime date, TimeSlotsModel timeSlot) {
    // Format date as "dd/MM/yyyy"
    String formattedDate =
        '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';

    // Format time
    String formattedTime = _formatTimeSlot(timeSlot);

    return '$formattedDate • $formattedTime';
  }

  String _formatTimeSlot(TimeSlotsModel slot) {
    int startHour = slot.startWorkHours.hour;
    int startMinute = slot.startWorkHours.minute;
    String startPeriod = startHour >= 12 ? 'PM' : 'AM';
    int startDisplayHour = startHour == 0
        ? 12
        : (startHour > 12 ? startHour - 12 : startHour);
    String startMinuteStr = startMinute.toString().padLeft(2, '0');

    int endHour = slot.endWorkHours.hour;
    int endMinute = slot.endWorkHours.minute;
    String endPeriod = endHour >= 12 ? 'PM' : 'AM';
    int endDisplayHour = endHour == 0
        ? 12
        : (endHour > 12 ? endHour - 12 : endHour);
    String endMinuteStr = endMinute.toString().padLeft(2, '0');

    return '$startDisplayHour:$startMinuteStr $startPeriod - $endDisplayHour:$endMinuteStr $endPeriod';
  }
}
