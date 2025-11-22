import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iatros_web/features/profile/pages/widgets/custom_hours_per_day.dart';
import 'package:iatros_web/features/profile/pages/widgets/custom_specific_day.dart';
import 'package:iatros_web/features/profile/provider/profile_controller.dart';
import 'package:iatros_web/uikit/index.dart';

class SettingsWidget extends ConsumerStatefulWidget {
  const SettingsWidget({super.key});

  @override
  ConsumerState<SettingsWidget> createState() => _SettingsWidgetState();
}

class _SettingsWidgetState extends ConsumerState<SettingsWidget> {
  final List<int> durationOptions = [5, 10, 15, 20, 25, 30];

  @override
  Widget build(BuildContext context) {
    final profileState = ref.watch(profileControllerProvider);
    final controller = ref.read(profileControllerProvider.notifier);

    return profileState.when(
      data: (state) => SingleChildScrollView(
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
                  Text(
                    'Duración de Consulta (minutos)',
                    style: AppTypography.h5,
                  ),
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
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Configuración guardada')),
                  );
                },
                child: const Text('Guardar'),
              ),
            ),
          ],
        ),
      ),
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stack) => Center(child: Text('Error: $error')),
    );
  }
}
