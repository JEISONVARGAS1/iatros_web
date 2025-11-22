import 'package:flutter/material.dart';
import 'package:iatros_web/core/enum/days_week_enum.dart';
import 'package:iatros_web/features/profile/provider/model/profile_state.dart';
import 'package:iatros_web/features/profile/provider/profile_controller.dart';
import 'package:iatros_web/uikit/index.dart';

class CustomHoursPerDay extends StatelessWidget {
  final ProfileState state;
  final ProfileController controller;

  const CustomHoursPerDay({
    super.key,
    required this.controller,
    required this.state,
  });

  @override
  Widget build(BuildContext context) {
    return BaseCard(
      padding: const EdgeInsets.all(AppSpacing.paddingLG),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Horarios por Día', style: AppTypography.h5),
          UIHelpers.verticalSpaceMD,
          ...List.generate(state.listDayWeek.length, (index) {
            final day = state.listDayWeek[index];
            final daySchedules = state.listTimeSlots[index];

            if (daySchedules.specificDay != null) Container();

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(day.toName, style: AppTypography.h6),
                    const Spacer(),
                    IconButton(
                      icon: const Icon(Icons.add),
                      onPressed: () => controller.selectDate(
                        context,
                        weekday: day,
                        callBack: controller.addScheduleForDay,
                      ),
                    ),
                  ],
                ),
                ...daySchedules.workDateList.asMap().entries.map((entry) {
                  final index = entry.key;
                  final end = entry.value.endWorkHours;
                  final start = entry.value.startWorkHours;
                  return BaseCard(
                    margin: const EdgeInsets.only(
                      left: 16,
                      bottom: AppSpacing.paddingSM,
                    ),
                    child: InkWell(
                      onTap: () => controller.selectDate(
                        context,
                        weekday: day,
                        callBack: (_, startParam, endParam) {
                          controller.removeScheduleForDay(day, index);
                          controller.addScheduleForDay(day, start, end);
                        },
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              '${start.format(context)} - ${end.format(context)}',
                              style: AppTypography.bodyMedium,
                            ),
                          ),
                          IconButton(
                            icon: Icon(Icons.delete, color: AppColors.error),
                            onPressed: () =>
                                controller.removeScheduleForDay(day, index),
                          ),
                        ],
                      ),
                    ),
                  );
                }),
                if (daySchedules.workDateList.isEmpty) ...[
                  Padding(
                    padding: const EdgeInsets.only(left: 16),
                    child: Text(
                      'No hay horarios configurados',
                      style: AppTypography.bodySmall,
                    ),
                  ),
                ],
                UIHelpers.verticalSpaceMD,
              ],
            );
          }),
        ],
      ),
    );
  }
}
