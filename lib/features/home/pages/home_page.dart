import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:iatros_web/uikit/index.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iatros_web/uikit/extensions/context_extension.dart';
import 'package:iatros_web/features/home/provider/home_controller.dart';
import 'package:iatros_web/features/home/pages/widget/notification_card.dart';
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

    return Scaffold(
      body: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          UIHelpers.horizontalSpaceLG,
          Padding(
            padding: EdgeInsetsGeometry.only(top: context.sizeHeight(0.04)),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 320),
              child: BaseCard(
                backgroundColor: AppColors.surface,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text('Notificaciones', style: AppTypography.h5),
                    UIHelpers.verticalSpaceSM,
                    if (state.listNotification.isEmpty)
                      Padding(
                        padding: EdgeInsets.only(top: context.sizeHeight(0.4)),
                        child: Column(children:[
                          Icon(Icons.notification_add_outlined, size: 45),
                          SizedBox(height: 10,),
                          Text('No hay notificaciones')
                        ]),
                      )
                    else
                      ...state.listNotification.map(
                        (notification) => NotificationCard(
                          notification: notification,
                          onRemove: () =>
                              controller.removeNotification(notification),
                        ),
                      ),
                  ],
                ),
              ),
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
    );
  }
}
