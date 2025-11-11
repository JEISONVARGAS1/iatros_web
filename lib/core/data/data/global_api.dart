import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
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
  Future<UserModel> getUserById(String id) async {
    final response = await _supabase
        .from('users')
        .select()
        .eq('id', id)
        .single();

    final user = UserModel.fromJson(response);
    return user;
  }
}

final globalApiProvider = Provider<GlobalApiInterface>(
  (Ref ref) => GlobalApi(),
);
