import 'package:flutter/material.dart';
import 'package:iatros_web/features/profile/pages/widgets/custom_hours_per_day.dart';
import 'package:iatros_web/features/profile/pages/widgets/custom_specific_day.dart';
import 'package:iatros_web/features/profile/provider/profile_controller.dart';
import 'package:iatros_web/features/profile/provider/model/profile_state.dart';
import 'package:iatros_web/uikit/index.dart';

class SettingsWidget extends StatelessWidget {
  const SettingsWidget({
    super.key,
    required this.controller,
    required this.state,
  });

  final ProfileController controller;
  final ProfileState state;

  static const List<int> durationOptions = [5, 10, 15, 20, 25, 30];

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSpacing.paddingLG),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Configuración de Horarios', style: AppTypography.h4),
          UIHelpers.verticalSpaceLG,

          // Consultation Duration
          BaseCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Duración de Consulta (minutos)', style: AppTypography.h5),
                UIHelpers.verticalSpaceMD,
                DropdownButtonFormField<int>(
                  value: state.consultationDurationMinutes,
                  items: durationOptions.map((duration) {
                    return DropdownMenuItem(
                      value: duration,
                      child: Text('$duration minutos'),
                    );
                  }).toList(),
                  onChanged: (value) {
                    if (value != null) {
                      controller.updateConsultationDuration(value);
                    }
                  },
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                  ),
                ),
              ],
            ),
          ),

          UIHelpers.verticalSpaceLG,

          // Schedules per day
          CustomHoursPerDay(controller: controller, state: state),

          UIHelpers.verticalSpaceLG,

          // Specific Days
          CustomSpecificDay(controller: controller, state: state),
          UIHelpers.verticalSpaceLG,

          // Save button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              child: const Text('Guardar'),
              onPressed: () => controller.saveWorkTimeList(context),
            ),
          ),
        ],
      ),
    );
  }
}
