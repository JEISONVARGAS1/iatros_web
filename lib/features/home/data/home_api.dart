import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iatros_web/core/models/user_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:iatros_web/core/models/user_company_model.dart';
import 'package:iatros_web/core/extension/stream_extension.dart';
import 'package:iatros_web/core/models/doctor_setting_model.dart';
import 'package:iatros_web/features/home/data/home_api_interface.dart';
import 'package:iatros_web/core/models/medical_appointment_booking_model.dart';

class HomeApi extends HomeInterface {
  final SupabaseClient _supabase;

  HomeApi() : _supabase = Supabase.instance.client, super();

  @override
  Future<UserModel> getUsers(String document) async {
    final response = await _supabase
        .from('users')
        .select('*')
        .eq("identification_number", document);

    final List<UserModel> users = response
        .map<UserModel>((json) => UserModel.fromJson(json))
        .toList();

    if (users.isEmpty) throw Exception('No se encontro el usuario');

    return users.first;
  }

  @override
  Future<UserModel> createUsers(UserModel user) async {
    final res = await _supabase
        .from('users')
        .insert(user.toJson())
        .select()
        .maybeSingle();

    return UserModel.fromJson(res);
  }

  @override
  Future<UserModel> updateUsers(UserModel user) async {
    final res = await _supabase
        .from('users')
        .update(user.toJson())
        .eq('id', user.id!)
        .select()
        .maybeSingle();

    return UserModel.fromJson(res);
  }

  @override
  Future<bool> createMedicalAppointmentBooking(
    MedicalAppointmentBookingModel appointment,
  ) async {
    final map = appointment.toJson();

    await _supabase
        .from('medical_appointment_booking')
        .insert(map)
        .select()
        .maybeSingle();

    return true;
  }

  @override
  Stream<List<MedicalAppointmentBookingModel>> getMedicalAppointmentBooking(
    String doctorId,
  ) {
    final response = _supabase
        .from('medical_appointment_booking')
        .stream(primaryKey: ['id'])
        .eq('user_company_id', doctorId);

    final bookings =
        response.StreamToStream<
          List<Map<String, dynamic>>,
          List<MedicalAppointmentBookingModel>
        >(
          (data, sink) => sink.add(
            data
                .map((e) => MedicalAppointmentBookingModel.fromJson(e))
                .toList(),
          ),
        );

    return bookings;
  }

  @override
  Future<List<MedicalAppointmentBookingModel>> getBookingFromCompany(
    String id,
  ) async {
    final response = await _supabase
        .from('medical_appointment_booking')
        .select('''
      *,
      users_companies!inner (
        company_id,
        rol_user,
        users (
          name,
          email
        )
      )
    ''')
        .eq('users_companies.company_id', id);

    final bookings = response
        .map((e) => MedicalAppointmentBookingModel.fromJson(e))
        .toList();

    return bookings;
  }

  @override
  Future<List<UserCompanyModel>> getDoctorsFromCompany(String companyId) async {
    final response = await _supabase
        .from('users_companies')
        .select('*,users(*)')
        .eq('company_id', companyId)
        .eq('rol_user', 'DOCTOR');

    final List<UserCompanyModel> doctors = response
        .map<UserCompanyModel>((json) => UserCompanyModel.fromJson(json))
        .toList();

    return doctors;
  }

  @override
  Future<DoctorSettingModel> getSettingDoctor(String userCompanyId) async {
    final res = await _supabase
        .from('doctor_settings')
        .select()
        .eq('user_company_id', userCompanyId)
        .maybeSingle();

    if (res == null)
      throw Exception('No se encontraron configuraciones para este doctor');

    return DoctorSettingModel.fromJson(res);
  }
}

final homeApiProvider = Provider<HomeInterface>((Ref ref) => HomeApi());
