import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:iatros_web/uikit/index.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iatros_web/uikit/extensions/context_extension.dart';
import 'package:iatros_web/features/home/provider/home_controller.dart';
import 'package:iatros_web/features/home/pages/widget/notification_panel.dart';
import 'package:iatros_web/features/home/pages/widget/doctor_filter_card.dart';
import 'package:iatros_web/features/home/pages/widget/appointment_calendar.dart';
import 'package:iatros_web/features/home/pages/widget/form_schedule_appointment.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  double _opacity = 1.0;

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

    return LoadingOverlay(
      isLoading: state.loading,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            UIHelpers.horizontalSpaceLG,
            AnimatedOpacity(
              opacity: _opacity,
              duration: const Duration(milliseconds: 500),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Visibility(
                    visible: controller.handledShowPanelDoctors(),
                    child: DoctorFilterCard(
                      doctors: state.doctorsFilter,
                      doctorSelected: state.doctorSelected,
                      cleanFilter: controller.cleanFilterDoctor,
                      onDoctorSelected: controller.changeDoctorSelected,
                      searchDoctorController: state.searchDoctorController,
                      selectedSpecialization: state.selectedSpecialization,
                      selectSpecialization: controller.selectSpecialization,
                    ),
                  ),
                  Visibility(
                    visible: !controller.handledShowPanelDoctors(),
                    child: SizedBox(height: context.sizeHeight(0.04)),
                  ),

                  NotificationPanel(controller: controller, state: state),
                ],
              ),
            ),
            UIHelpers.horizontalSpaceLG,
            Expanded(
              child: DefaultTabController(
                initialIndex: state.index,
                length: 2,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    TabBar(
                      onTap: (index) async {
                        setState(() => _opacity = 0.0);
                        await Future.delayed(const Duration(milliseconds: 500));
                        controller.changeIndex(index);
                        setState(() => _opacity = 1.0);
                      },
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
                              state: state,
                              controller: controller,
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
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () => controller.clearForm(),
          child: Icon(Icons.clear),
        ),
      ),
    );
  }
}
