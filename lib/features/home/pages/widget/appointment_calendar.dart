import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:iatros_web/uikit/index.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:iatros_web/features/home/provider/home_controller.dart';
import 'package:iatros_web/core/models/medical_appointment_booking_model.dart';

class AppointmentCalendar extends ConsumerWidget {
  const AppointmentCalendar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(homeControllerProvider).value!;
    return SfCalendar(
      key: ValueKey(state.medicalAppointmentBooking.length),
      view: CalendarView.month,
      dataSource: MeetingDataSource(
        _getDataSource(state.medicalAppointmentBooking),
      ),
      monthViewSettings: const MonthViewSettings(
        appointmentDisplayMode: MonthAppointmentDisplayMode.appointment,
      ),
      onTap: (CalendarTapDetails details) {
        if (details.targetElement == CalendarElement.calendarCell ||
            details.targetElement == CalendarElement.appointment) {
          context.go('/appointment-day/${details.date!.toIso8601String()}');
        }
      },
    );
  }

  List<Meeting> _getDataSource(
    List<MedicalAppointmentBookingModel> appointments,
  ) {
    final List<Meeting> meetings = <Meeting>[];
    for (var appointment in appointments) {
      final startTime = appointment.scheduleMedicalAppointment;
      final endTime = startTime.add(const Duration(hours: 1));
      meetings.add(
        Meeting('Cita Médica', startTime, endTime, AppColors.primary.withOpacity(0.7), true),
      );
    }
    return meetings;
  }
}

class MeetingDataSource extends CalendarDataSource {
  MeetingDataSource(List<Meeting> source) {
    appointments = source;
  }

  @override
  DateTime getStartTime(int index) {
    return appointments![index].from;
  }

  @override
  DateTime getEndTime(int index) {
    return appointments![index].to;
  }

  @override
  String getSubject(int index) {
    return appointments![index].eventName;
  }

  @override
  Color getColor(int index) {
    return appointments![index].background;
  }

  @override
  bool isAllDay(int index) {
    return appointments![index].isAllDay;
  }
}

class Meeting {
  Meeting(this.eventName, this.from, this.to, this.background, this.isAllDay);

  String eventName;
  DateTime from;
  DateTime to;
  Color background;
  bool isAllDay;
}
