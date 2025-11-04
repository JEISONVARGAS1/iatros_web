import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:iatros_web/core/models/user_model.dart';
import 'package:iatros_web/core/models/query_response_model.dart';
import 'package:iatros_web/features/auth/data/auth_api_interface.dart';

class AuthApi extends AuthApiInterface {
  final SupabaseClient _supabase;

  AuthApi({String token = ""})
    : _supabase = Supabase.instance.client,
      super(token: token);

  @override
  Future<UserModel> login(String email, String password) async {
    await _supabase.auth.signInWithPassword(email: email, password: password);
    return UserModel.init();
  }

  @override
  Future<QueryResponseModel> register(UserModel user, String password) async {
    final response = await _supabase.auth.signUp(
      email: user.email,
      password: password,
      data: user.toJson(),
    );

    await _supabase
        .from('users')
        .insert(user.copyWith(id: response.user!.id).toJson());

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
  /* 
  @override
  Future<QueryResponseModel<UserModel>> getCurrentUser() async {
    try {
      final user = _supabase.auth.currentUser;
      if (user != null) {
        final userModel = UserModel(
          id: user.id,
          email: user.email ?? '',
          name: user.userMetadata?['name'] as String?,
          lastName: user.userMetadata?['last_name'] as String?,
          avatar: user.userMetadata?['avatar_url'] as String?,
          medicalLicense: user.userMetadata?['medical_license'] as String?,
          specialization: user.userMetadata?['specialization'] as String?,
          phone: user.userMetadata?['phone'] as String?,
          bio: user.userMetadata?['bio'] as String?,
          yearsOfExperience: user.userMetadata?['years_of_experience'] as int?,
          professionalCardImage:
              user.userMetadata?['professional_card_image'] as String?,
          isVerified: user.userMetadata?['is_verified'] as bool?,
          createdAt: user.createdAt.isNotEmpty
              ? DateTime.tryParse(user.createdAt)
              : null,
          updatedAt: user.updatedAt?.isNotEmpty == true
              ? DateTime.tryParse(user.updatedAt!)
              : null,
        );
        return QueryResponseModel(
          data: userModel,
          message: 'Usuario obtenido exitosamente',
        );
      } else {
        return QueryResponseModel(
          data: null,
          message: 'No hay usuario autenticado',
          isSuccessful: false,
        );
      }
    } catch (e) {
      return QueryResponseModel(
        data: null,
        message: e.toString(),
        isSuccessful: false,
      );
    }
  } */

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
