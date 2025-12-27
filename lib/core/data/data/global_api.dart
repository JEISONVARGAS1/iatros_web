import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iatros_web/core/models/doctor_setting_model.dart';
import 'package:iatros_web/core/models/user_company_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:iatros_web/core/models/user_model.dart';
import 'package:iatros_web/core/data/data/global_api_interface.dart';

class GlobalApi extends GlobalApiInterface {
  final SupabaseClient _supabase;

  GlobalApi() : _supabase = Supabase.instance.client, super();

  @override
  Stream<UserModel> getStreamUser(String id) {
    final controller = StreamController<UserModel>();

    final channel = _supabase
        .channel('user-changes-$id')
        .onPostgresChanges(
          table: 'users',
          schema: 'public',
          event: PostgresChangeEvent.all,
          filter: PostgresChangeFilter(
            value: id,
            column: 'id',
            type: PostgresChangeFilterType.eq,
          ),
          callback: (payload) {
            try {
              final record = payload.newRecord.isNotEmpty
                  ? payload.newRecord
                  : payload.oldRecord;

              final user = UserModel.fromJson(record);
              controller.add(user);
            } catch (e) {
              controller.addError(e);
            }
          },
        )
        .subscribe();

    controller.onCancel = () => _supabase.removeChannel(channel);

    return controller.stream;
  }

  @override
  Stream<List<UserCompanyModel>> getUserCompaniesWithCompanyStream(
    String userId,
  ) {
    final controller = StreamController<List<UserCompanyModel>>();

    Future<void> emitUserCompanies() async {
      try {
        final response = await _supabase
            .from('users_companies')
            .select('''
          *,
          company:company_id (
            id,
            nit,
            nit_url,
            company_name,
            created_at,
            user_owner_id,
            company_type
          )
        ''')
            .eq('user_id', userId);

        final userCompanies = (response as List<dynamic>)
            .map((json) => UserCompanyModel.fromJson(json))
            .toList();

        controller.add(userCompanies);
      } catch (e) {
        controller.addError(e);
      }
    }

    final channel = _supabase
        .channel('user-companies-with-company-$userId')
        .onPostgresChanges(
          schema: 'public',
          table: 'users_companies',
          event: PostgresChangeEvent.all,
          filter: PostgresChangeFilter(
            value: userId,
            column: 'user_id',
            type: PostgresChangeFilterType.eq,
          ),
          callback: (payload) async {
            await emitUserCompanies();
          },
        )
        .subscribe();

    controller.onCancel = () => _supabase.removeChannel(channel);

    // Emit initial data
    emitUserCompanies();

    return controller.stream;
  }

  @override
  Stream<DoctorSettingModel> getStreamSettingDoctor(String id) {
    final controller = StreamController<DoctorSettingModel>();

    final channel = _supabase
        .channel('doctor-settings-changes-$id')
        .onPostgresChanges(
          table: 'doctor_settings',
          schema: 'public',
          event: PostgresChangeEvent.all,
          filter: PostgresChangeFilter(
            value: id,
            column: 'user_company_id',
            type: PostgresChangeFilterType.eq,
          ),
          callback: (payload) {
            try {
              final record = payload.newRecord.isNotEmpty
                  ? payload.newRecord
                  : payload.oldRecord;

              final setting = DoctorSettingModel.fromJson(record);
              controller.add(setting);
            } catch (e) {
              print('Error parsing setting: $e');
              controller.addError(e);
            }
          },
        )
        .subscribe();

    controller.onCancel = () => _supabase.removeChannel(channel);
    getSettingDoctor(id)
        .then((initial) {
          controller.add(initial);
        })
        .catchError((e) {
          controller.addError(e);
        });

    return controller.stream;
  }

  @override
  Future<UserModel> getUserById(String id) async {
    final response = await _supabase
        .from('users')
        .select()
        .eq('id', id)
        .single();

    final user = UserModel.fromJson(response);
    return user;
  }

  @override
  Future<DoctorSettingModel> getSettingDoctor(String id) async {
    final response = await _supabase
        .from('doctor_settings')
        .select()
        .eq('user_company_id', id)
        .single();

    if (response.isEmpty) return DoctorSettingModel.init();
    return DoctorSettingModel.fromJson(response);
  }
}

final globalApiProvider = Provider<GlobalApiInterface>(
  (Ref ref) => GlobalApi(),
);
