import 'package:flutter/material.dart';
import 'package:iatros_web/uikit/index.dart';
import 'package:iatros_web/features/profile/provider/model/profile_state.dart';
import 'package:iatros_web/features/profile/provider/profile_controller.dart';

class CustomSpecificDay extends StatelessWidget {
  final ProfileState state;
  final ProfileController controller;

  const CustomSpecificDay({
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
          Container(width: double.infinity),
          Text('Días Específicos', style: AppTypography.h5),
          UIHelpers.verticalSpaceMD,
          ElevatedButton.icon(
            onPressed: () async {
              final date = await showDatePicker(
                context: context,
                initialDate: DateTime.now(),
                firstDate: DateTime.now(),
                lastDate: DateTime.now().add(const Duration(days: 365)),
              );
              if (date != null) {
                final startTime = await showTimePicker(
                  context: context,
                  initialTime: const TimeOfDay(hour: 9, minute: 0),
                );
                if (startTime != null) {
                  final endTime = await showTimePicker(
                    context: context,
                    initialTime: const TimeOfDay(hour: 17, minute: 0),
                  );
                  if (endTime != null) {
                    controller.addSpecificSchedule(date, startTime, endTime);
                  }
                }
              }
            },
            icon: const Icon(Icons.add),
            label: const Text('Agregar Día Específico'),
          ),

          UIHelpers.verticalSpaceMD,
          if (state.listTimeSlots.isNotEmpty) ...[
            Text(
              'Días Específicos Configurados:',
              style: AppTypography.bodyMedium,
            ),
            UIHelpers.verticalSpaceSM,
            ...state.listTimeSlots.reversed.map((entry) {

              if(entry.specificDay == null) return Container();

              final date = entry.specificDay!;
              final schedules = entry.workDateList;
              return Column(
                spacing: 10,
                children: [
                  Material(
                    borderRadius: BorderRadius.circular(5),
                    color: AppColors.primary,
                    child: Padding(
                      padding: EdgeInsetsGeometry.symmetric(
                        horizontal: 16,
                        vertical: 10,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '${date.day}/${date.month}/${date.year}',
                            style: AppTypography.h6.copyWith(
                              color: AppColors.textInverse,
                            ),
                          ),
                          IconButton(
                            icon: const Icon(
                              Icons.add,
                              color: AppColors.textInverse,
                            ),
                            onPressed: () async {
                              final startTime = await showTimePicker(
                                context: context,
                                initialTime: const TimeOfDay(
                                  hour: 9,
                                  minute: 0,
                                ),
                              );
                              if (startTime != null) {
                                final endTime = await showTimePicker(
                                  context: context,
                                  initialTime: const TimeOfDay(
                                    hour: 17,
                                    minute: 0,
                                  ),
                                );
                                if (endTime != null) {
                                  controller.addSpecificSchedule(
                                    date,
                                    startTime,
                                    endTime,
                                  );
                                }
                              }
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                  ...schedules.asMap().entries.map((scheduleEntry) {
                    final end = scheduleEntry.value.startWorkHours;
                    final start = scheduleEntry.value.startWorkHours;

                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: BaseCard(
                        margin: const EdgeInsets.only(
                          bottom: AppSpacing.paddingSM,
                        ),
                        child: InkWell(
                          onTap: () async {
                            final startTime = await showTimePicker(
                              context: context,
                              initialTime: start,
                            );
                            if (startTime != null) {
                              final endTime = await showTimePicker(
                                context: context,
                                initialTime: end,
                              );
                              if (endTime != null) {
                                // Remove old and add new
                                /* controller.removeSpecificSchedule(date, index); */
                                controller.addSpecificSchedule(
                                  date,
                                  startTime,
                                  endTime,
                                );
                              }
                            }
                          },
                          child: Row(
                            children: [
                              Expanded(
                                child: Text(
                                  '${start.format(context)} - ${end.format(context)}',
                                  style: AppTypography.bodyMedium,
                                ),
                              ),
                              IconButton(
                                icon: const Icon(
                                  Icons.delete,
                                  color: AppColors.error,
                                ),
                                onPressed: () {} /* controller
                                    .removeSpecificSchedule(date, index) */,
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  }),
                ],
              );
            }),
          ],
        ],
      ),
    );
  }
}
