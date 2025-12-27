import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:go_router/go_router.dart';
import 'package:iatros_web/uikit/index.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:iatros_web/core/extension/appointment_status_extension.dart';
import 'package:iatros_web/core/models/medical_appointment_booking_model.dart';
import 'package:iatros_web/features/appointment_day/provider/appointment_day_controller.dart';
import 'package:iatros_web/features/appointment_day/pages/widget/appointment_booking_card.dart';

class AppointmentDayPage extends ConsumerStatefulWidget {
  final DateTime selectedDate;

  const AppointmentDayPage({super.key, required this.selectedDate});

  @override
  ConsumerState<AppointmentDayPage> createState() => _AppointmentDayPageState();
}

class _AppointmentDayPageState extends ConsumerState<AppointmentDayPage> {
  @override
  void initState() {
    SchedulerBinding.instance.addPostFrameCallback(
      (_) => ref
          .read(appointmentDayControllerProvider.notifier)
          .init(widget.selectedDate),
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final appointmentState = ref.watch(appointmentDayControllerProvider);

    // Handle loading state
    if (appointmentState.isLoading) {
      return Scaffold(
        body: SimpleMedicalBackground(
          child: const Center(child: CircularProgressIndicator()),
        ),
      );
    }

    // Handle error state
    if (appointmentState.hasError) {
      return Scaffold(
        body: SimpleMedicalBackground(
          child: Center(child: Text('Error: ${appointmentState.error}')),
        ),
      );
    }

    final state = appointmentState.value!;
    final controller = ref.read(appointmentDayControllerProvider.notifier);
    final dateFormat = DateFormat('dd/MM/yyyy');

    return WillPopScope(
      onWillPop: () async {
        context.go('/lobby');
        return false;
      },
      child: Scaffold(
        body: SimpleMedicalBackground(
          child: Padding(
            padding: EdgeInsetsGeometry.all(30),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Citas Del Día', style: AppTypography.h5),

                          Text(
                            dateFormat.format(widget.selectedDate),
                            style: AppTypography.h2,
                          ),
                        ],
                      ),
                    ),
                    UIHelpers.horizontalSpaceXL,
                    Expanded(
                      child: TextField(
                        controller: state.searchController!,
                        decoration: InputDecoration(
                          hintText: 'Buscar por nombre del paciente...',
                          prefixIcon: const Icon(Icons.search),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          filled: true,
                          fillColor: Colors.white,
                        ),
                        onChanged: (value) => setState(() {}),
                      ),
                    ),
                  ],
                ),
                UIHelpers.verticalSpaceMD,
                Row(
                  children: [
                    Expanded(
                      child: DropdownButtonFormField<AppointmentStatus>(
                        initialValue: state.selectedStatusFilter,
                        hint: const Text('Filtrar por estado'),
                        items: [
                          const DropdownMenuItem<AppointmentStatus>(
                            value: null,
                            child: Text('Todos'),
                          ),
                          ...AppointmentStatus.values.map(
                            (status) => DropdownMenuItem<AppointmentStatus>(
                              value: status,
                              child: Row(
                                children: [
                                  Container(
                                    width: 12,
                                    height: 12,
                                    decoration: BoxDecoration(
                                      color: status.toColor,
                                      shape: BoxShape.circle,
                                    ),
                                  ),
                                  UIHelpers.horizontalSpaceSM,
                                  Text(status.toName),
                                ],
                              ),
                            ),
                          ),
                        ],
                        onChanged: (value) => controller.setStatusFilter(value),
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: AppColors.surface,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(
                              AppSpacing.radiusMD,
                            ),
                            borderSide: const BorderSide(
                              color: AppColors.gray300,
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(
                              AppSpacing.radiusMD,
                            ),
                            borderSide: const BorderSide(
                              color: AppColors.gray300,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(
                              AppSpacing.radiusMD,
                            ),
                            borderSide: const BorderSide(
                              color: AppColors.primary,
                              width: 2,
                            ),
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: AppSpacing.paddingMD,
                            vertical: AppSpacing.paddingMD,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                UIHelpers.verticalSpaceLG,
                Expanded(
                  child: Card(
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: state.medicalAppointmentBookingFilter.isEmpty
                          ? Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.search_off,
                                    size: 64,
                                    color: Colors.grey,
                                  ),
                                  const SizedBox(height: 16),
                                  Text(
                                    state.searchController!.text.isEmpty
                                        ? 'No hay citas programadas'
                                        : 'No se encontraron citas que coincidan con la búsqueda',
                                    style: AppTypography.bodyMedium.copyWith(
                                      color: AppColors.textSecondary,
                                    ),
                                  ),
                                ],
                              ),
                            )
                          : ListView.builder(
                              itemCount:
                                  state.medicalAppointmentBookingFilter.length,
                              itemBuilder: (context, index) {
                                final appointment = state
                                    .medicalAppointmentBookingFilter[index];
                                return AppointmentBookingCard(
                                  appointment: appointment,
                                  onTapCard: () {
                                    final completed =
                                        AppointmentStatus.COMPLETED;
                                    final notBilled =
                                        AppointmentStatus.NOT_BILLED;

                                    if (appointment.status == completed) {
                                      controller.generateSnackbarMessage(
                                        context,
                                        message: "Cita finalizada",
                                      );
                                      return;
                                    }
                                    if (appointment.status == notBilled) {
                                      controller.generateSnackbarMessage(
                                        context,
                                        message: "Cita no facturada",
                                      );
                                      return;
                                    }

                                    controller.goToPatient(
                                      context,
                                      appointment.patient,
                                    );
                                  },
                                  onEditTap: () {
                                    controller.showAppointmentDetails(
                                      context,
                                      appointment,
                                    );
                                  },
                                );
                              },
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
