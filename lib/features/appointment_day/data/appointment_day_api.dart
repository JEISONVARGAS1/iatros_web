import 'dart:async';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iatros_web/core/extension/stream_extension.dart';
import 'package:iatros_web/core/models/medical_appointment_booking_view.dart';
import 'package:iatros_web/core/models/medical_appointment_booking_model.dart';
import 'package:iatros_web/features/appointment_day/data/appointment_day_api_interface.dart';

class AppointmentDayApi extends AppointmentDayInterface {
  final SupabaseClient _supabase;

  AppointmentDayApi() : _supabase = Supabase.instance.client, super();

  @override
  Stream<List<MedicalAppointmentBookingViewModel>> getMedicalAppointmentBooking(
    String doctorId,
    DateTime day,
  ) {
    final response = _supabase
        .from('medical_appointment_booking')
        .stream(primaryKey: ['id'])
        .eq('user_company_id', doctorId);

    final bookings =
        response.StreamToStream<
          List<Map<String, dynamic>>,
          List<MedicalAppointmentBookingViewModel>
        >((data, sink) async {
          final viewData = await _getMedicalAppointmentBookingView(
            doctorId,
            day,
          );

          sink.add(viewData);
        });

    return bookings;
  }

  Future<List<MedicalAppointmentBookingViewModel>>
  _getMedicalAppointmentBookingView(String doctorId, DateTime day) async {
    final startOfDay = DateTime(day.year, day.month, day.day);
    final endOfDay = startOfDay.add(const Duration(days: 1));

    final data = await _supabase
        .from('medical_appointment_booking_view')
        .select('*')
        .eq('user_company_id', doctorId)
        .gte('schedule_medical_appointment', startOfDay.toIso8601String())
        .lt('schedule_medical_appointment', endOfDay.toIso8601String());

    return data
        .map<MedicalAppointmentBookingViewModel>(
          (e) => MedicalAppointmentBookingViewModel.fromJson(e),
        )
        .toList();
  }

  @override
  Stream<List<MedicalAppointmentBookingViewModel>>
  getMedicalAppointmentBookingFromCompany(String companyId, DateTime day) {
    final response = _supabase
        .from('medical_appointment_booking')
        .stream(primaryKey: ['id'])
        .eq('company_id', companyId);

    final bookings =
        response.StreamToStream<
          List<Map<String, dynamic>>,
          List<MedicalAppointmentBookingViewModel>
        >((data, sink) async {
          final viewData = await _getMedicalAppointmentBookingViewForCompany(
            companyId,
            day,
          );

          sink.add(viewData);
        });

    return bookings;
  }

  Future<List<MedicalAppointmentBookingViewModel>>
  _getMedicalAppointmentBookingViewForCompany(
    String companyId,
    DateTime day,
  ) async {
    final startOfDay = DateTime(day.year, day.month, day.day);
    final endOfDay = startOfDay.add(const Duration(days: 1));

   final data = await _supabase
        .from('medical_appointment_booking_view')
        .select('*')
        .eq('company_id', companyId)
        .gte('schedule_medical_appointment', startOfDay.toIso8601String())
        .lt('schedule_medical_appointment', endOfDay.toIso8601String());


    return data
        .map<MedicalAppointmentBookingViewModel>(
          (e) => MedicalAppointmentBookingViewModel.fromJson(e),
        )
        .toList();
  }

  @override
  Future<void> updateMedicalAppointmentBooking(
    String id,
    AppointmentStatus status,
  ) async {
    await _supabase
        .from('medical_appointment_booking')
        .update({
          "status": status.name,
          "update_at": DateTime.now().toIso8601String(),
        })
        .eq('id', id);
  }
}

final appointmentDayApiProvider = Provider<AppointmentDayInterface>(
  (Ref ref) => AppointmentDayApi(),
);
