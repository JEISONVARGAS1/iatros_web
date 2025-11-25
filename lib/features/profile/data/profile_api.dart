import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:iatros_web/core/models/doctor_setting_model.dart';
import 'package:iatros_web/features/profile/data/profile_api_interface.dart';

class Profile extends ProfileInterface {
  final SupabaseClient _supabase;

  Profile() : _supabase = Supabase.instance.client, super();

  @override
  Future<void> saveWorkTimeList(DoctorSettingModel items) async {
    final data = items.toJson();
    await _supabase.from('doctor_settings').insert(data);
  }

  @override
  Future<void> updateWorkTimeList(DoctorSettingModel items) async {
    final data = items.toJson();
    await _supabase.from('doctor_settings').update(data).eq('id', items.id!);
  }
}

final profileApiProvider = Provider<ProfileInterface>((Ref ref) => Profile());
