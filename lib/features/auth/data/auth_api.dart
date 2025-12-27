import 'package:iatros_web/core/models/user_company_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:iatros_web/core/models/user_model.dart';
import 'package:iatros_web/core/models/query_response_model.dart';
import 'package:iatros_web/features/auth/data/auth_api_interface.dart';

class AuthApi extends AuthApiInterface {
  final SupabaseClient _supabase;

  AuthApi({super.token}) : _supabase = Supabase.instance.client;

  @override
  Future<UserModel> login(String email, String password) async {
    final item = await _supabase.auth.signInWithPassword(
      email: email,
      password: password,
    );
    final user = UserModel.init().copyWith(email: email, id: item.user!.id);
    return user;
  }

  @override
  Future<QueryResponseModel> register(
    UserCompanyModel userCompany,
    String password,
  ) async {
    final response = await _supabase.auth.signUp(
      password: password,
      email: userCompany.user!.email,
      data: userCompany.user!.toJson(),
    );

    await _supabase
        .from('users')
        .insert(userCompany.user!.copyWith(id: response.user!.id).toJson());

    final res = await _supabase
        .from('companies')
        .insert(
          userCompany.company!
              .copyWith(userOwnerId: response.user!.id)
              .toJson(),
        )
        .select()
        .single();

    await _supabase
        .from('users_companies')
        .insert(
          userCompany.copyWith(userId: response.user!.id, companyId: res['id']).toJson(),
        );

    if (response.user != null) {
      return QueryResponseModel(
        data: {
          'user': response.user?.toJson(),
          'session': response.session?.toJson(),
        },
        message: 'Registro exitoso',
      );
    } else {
      return QueryResponseModel(
        data: null,
        message: 'Error en el registro',
        isSuccessful: false,
      );
    }
  }

  @override
  Future<QueryResponseModel> logout() async {
    try {
      await _supabase.auth.signOut();
      return QueryResponseModel(data: null, message: 'Logout exitoso');
    } catch (e) {
      return QueryResponseModel(
        data: null,
        message: e.toString(),
        isSuccessful: false,
      );
    }
  }

  @override
  Future<QueryResponseModel> resetPassword(String email) async {
    try {
      await _supabase.auth.resetPasswordForEmail(email);
      return QueryResponseModel(
        data: null,
        message: 'Email de recuperación enviado',
      );
    } catch (e) {
      return QueryResponseModel(
        data: null,
        message: e.toString(),
        isSuccessful: false,
      );
    }
  }

  @override
  Future<QueryResponseModel> updatePassword(String newPassword) async {
    try {
      await _supabase.auth.updateUser(UserAttributes(password: newPassword));
      return QueryResponseModel(
        data: null,
        message: 'Contraseña actualizada exitosamente',
      );
    } catch (e) {
      return QueryResponseModel(
        data: null,
        message: e.toString(),
        isSuccessful: false,
      );
    }
  }
}
