import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iatros_web/core/models/diagnosis_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:iatros_web/core/models/user_model.dart';
import 'package:iatros_web/features/patient/data/patients_api_interface.dart';

class Patients extends PatientsInterface {
  final SupabaseClient _supabase;

  Patients() : _supabase = Supabase.instance.client, super();

  @override
  Future<UserModel> getUserById(String document) async {
    final response = await _supabase
        .from('users')
        .select('*')
        .eq("id", document);

    final List<UserModel> users = response
        .map<UserModel>((json) => UserModel.fromJson(json))
        .toList();

    if(users.isNotEmpty) return users.first;
    return UserModel.init();
  }

@override
Future<List<DiagnosisModel>> searchDiagnoses(String query) async {
  final response = await _supabase
      .from('diagnoses')
      .select('*')
      .or('Codigo.ilike."%$query%",Nombre.ilike."%$query%"')
      .limit(10);

  final List<DiagnosisModel> diagnoses = response
      .map<DiagnosisModel>((json) => DiagnosisModel.fromJson(json))
      .toList();

  return diagnoses;
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

final patientApiProvider = Provider<PatientsInterface>((Ref ref) => Patients());
