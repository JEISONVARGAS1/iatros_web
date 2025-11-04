import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:iatros_web/core/models/user_model.dart';
import 'package:iatros_web/features/patients_seek/data/patients_seek_api_interface.dart';

class PatientsSeek extends PatientsSeekInterface {
  final SupabaseClient _supabase;

  PatientsSeek() : _supabase = Supabase.instance.client, super();

  @override
  Future<List<UserModel>> getUsers(String document) async {
    final response = await _supabase
        .from('users')
        .select('*')
        .eq("identification_number", document)
        .eq('type_user', 'PATIENT');

    final List<UserModel> users = response
        .map<UserModel>((json) => UserModel.fromJson(json))
        .toList();
    return users;
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
}

final patientSeekApiProvider = Provider<PatientsSeekInterface>(
  (Ref ref) => PatientsSeek(),
);
