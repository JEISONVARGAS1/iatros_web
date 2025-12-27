import 'package:flutter/material.dart';
import 'package:iatros_web/uikit/index.dart';
import 'package:iatros_web/core/models/time_slots_model.dart';
import 'package:iatros_web/core/extension/date_extension.dart';

class SelectorHour extends StatelessWidget {
  final List<TimeSlotsModel> listSlots;
  final TimeSlotsModel? selectedTimeSlot;
  final Function(TimeSlotsModel) onTimeSlotSelect;

  const SelectorHour({
    super.key,
    required this.listSlots,
    required this.selectedTimeSlot,
    required this.onTimeSlotSelect,
  });

  @override
  Widget build(BuildContext context) {
    final slots = listSlots;
    final Map<String, List<TimeSlotsModel>> groupedSlots = {};

    for (var slot in slots) {
      int hour = slot.startWorkHours.hour;
      String period = hour >= 12 ? 'PM' : 'AM';
      int displayHour = hour == 0 ? 12 : (hour > 12 ? hour - 12 : hour);
      String key = '$displayHour $period';
      groupedSlots.putIfAbsent(key, () => []).add(slot);
    }

    final sortedKeys = groupedSlots.keys.toList()
      ..sort((a, b) {
        var partsA = a.split(' ');
        var partsB = b.split(' ');
        int hourA = int.parse(partsA[0]);
        int hourB = int.parse(partsB[0]);
        String periodA = partsA[1];
        String periodB = partsB[1];
        int sortA = periodA == 'AM' ? hourA : 12 + hourA;
        int sortB = periodB == 'AM' ? hourB : 12 + hourB;
        return sortA.compareTo(sortB);
      });

    return Column(
      children: sortedKeys.map((key) {
        final groupSlots = groupedSlots[key]!;
        return ExpansionTile(
          backgroundColor: AppColors.surface.withOpacity(0.05),
          title: Row(
            children: [
              Icon(Icons.schedule, size: 20, color: AppColors.primary),
              const SizedBox(width: 8),
              Text(
                key,
                style: AppTypography.bodyMedium.copyWith(
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Wrap(
                spacing: 12,
                runSpacing: 12,
                children: groupSlots.map((slot) {
                  bool isSelected = selectedTimeSlot == slot;
                  return _generateCard(slot, isSelected, onTimeSlotSelect);
                }).toList(),
              ),
            ),
            const SizedBox(height: 16),
          ],
        );
      }).toList(),
    );
  }

  Widget _generateCard(
    TimeSlotsModel slot,
    bool isSelected,
    Function(TimeSlotsModel) onTap,
  ) {
    return Material(
      borderRadius: BorderRadius.circular(AppSpacing.radiusMD),
      color: isSelected ? AppColors.primary : AppColors.surface,
      child: InkWell(
        borderRadius: BorderRadius.circular(AppSpacing.radiusMD),
        onTap: () => onTap(slot),
        child: Container(
          constraints: const BoxConstraints(minWidth: 120),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppSpacing.radiusMD),
            border: Border.all(
              width: isSelected ? 2 : 1,
              color: isSelected ? AppColors.primary : AppColors.gray300,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.access_time,
                size: 16,
                color: isSelected ? Colors.white : AppColors.textSecondary,
              ),
              const SizedBox(width: 4),
              Text(
                "${slot.startWorkHours.toHour} - ${slot.endWorkHours.toHour}",
                style: AppTypography.bodySmall.copyWith(
                  color: isSelected ? Colors.white : AppColors.textPrimary,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
