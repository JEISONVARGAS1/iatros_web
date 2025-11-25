import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:iatros_web/uikit/index.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iatros_web/features/home/provider/home_controller.dart';
import 'package:iatros_web/features/home/pages/widget/appointment_calendar.dart';
import 'package:iatros_web/features/home/pages/widget/form_schedule_appointment.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  @override
  void initState() {
    SchedulerBinding.instance.addPostFrameCallback(
      (_) => ref.read(homeControllerProvider.notifier).init(),
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(homeControllerProvider).value!;
    final controller = ref.read(homeControllerProvider.notifier);

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 320),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text('Notificaciones', style: AppTypography.h5),
              UIHelpers.verticalSpaceSM,
              ...List.generate(3, (i) {
                return BaseCard(
                  backgroundColor: AppColors.surface,
                  child: Row(
                    children: [
                      Container(
                        width: 8,
                        height: 8,
                        decoration: const BoxDecoration(
                          color: AppColors.secondary,
                          shape: BoxShape.circle,
                        ),
                      ),
                      UIHelpers.horizontalSpaceMD,
                      const Expanded(
                        child: Text('Recordatorio de cita y seguimiento.'),
                      ),
                      Text('29 Ago', style: AppTypography.bodySmall),
                    ],
                  ),
                );
              }),
            ],
          ),
        ),
        UIHelpers.horizontalSpaceLG,
        // Panel principal
        Expanded(
          child: DefaultTabController(
            length: 2,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TabBar(
                  tabs: const [
                    Tab(text: 'Agenda'),
                    Tab(text: 'Agendamiento'),
                  ],
                ),
                Expanded(
                  child: TabBarView(
                    children: [
                      const AppointmentCalendar(),
                      SingleChildScrollView(
                        padding: EdgeInsets.all(AppSpacing.paddingMD),
                        child: FormScheduleAppointment(
                          timeSlots: controller.generateListTimeSlots(),
                          selectedTimeSlot: state.selectedTimeSlotNotifier.value,
                          onTimeSlotSelected: controller.selectedTimeSlot,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}


