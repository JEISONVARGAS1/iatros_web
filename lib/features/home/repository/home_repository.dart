import 'package:iatros_web/core/models/doctor_setting_model.dart';
import 'package:iatros_web/core/models/user_company_model.dart';
import 'package:iatros_web/core/models/user_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iatros_web/features/home/data/home_api.dart';
import 'package:iatros_web/core/models/query_response_model.dart';
import 'package:iatros_web/features/home/data/home_api_interface.dart';
import 'package:iatros_web/core/models/medical_appointment_booking_model.dart';

abstract class HomeRepositoryInterface {
  Future<QueryResponseModel<UserModel>> getUsers(String id);
  Future<QueryResponseModel<UserModel>> createUsers(UserModel user);
  Future<QueryResponseModel<UserModel>> updateUsers(UserModel user);
  Future<QueryResponseModel<DoctorSettingModel>>getSettingDoctor(String id);
  Future<QueryResponseModel<List<UserCompanyModel>>>getDoctorsFromCompany(String company);
  Future<QueryResponseModel<List<MedicalAppointmentBookingModel>>>getBookingFromCompany(String id);
  Future<QueryResponseModel> createMedicalAppointmentBooking(MedicalAppointmentBookingModel appointment);
  QueryResponseModel<Stream<List<MedicalAppointmentBookingModel>>>getMedicalAppointmentBooking(String doctorId);
}

class _HomeRepository implements HomeRepositoryInterface {
  final HomeInterface _globalApi;

  _HomeRepository(HomeInterface globalApi) : _globalApi = globalApi;

  @override
  Future<QueryResponseModel<UserModel>> getUsers(String id) async {
    try {
      final res = await _globalApi.getUsers(id);
      return QueryResponseModel(data: res);
    } catch (e) {
      return QueryResponseModel(isSuccessful: false, message: e.toString());
    }
  }

  @override
  Future<QueryResponseModel<UserModel>> createUsers(UserModel user) async {
    try {
      final res = await _globalApi.createUsers(user);
      return QueryResponseModel(data: res);
    } catch (e) {
      return QueryResponseModel(isSuccessful: false, message: e.toString());
    }
  }

  @override
  Future<QueryResponseModel<UserModel>> updateUsers(UserModel user) async {
    try {
      final res = await _globalApi.updateUsers(user);
      return QueryResponseModel(data: res);
    } catch (e) {
      return QueryResponseModel(isSuccessful: false, message: e.toString());
    }
  }

  @override
  Future<QueryResponseModel> createMedicalAppointmentBooking(
    MedicalAppointmentBookingModel appointment,
  ) async {
    try {
      final res = await _globalApi.createMedicalAppointmentBooking(appointment);
      return QueryResponseModel(data: res);
    } catch (e) {
      return QueryResponseModel(isSuccessful: false, message: e.toString());
    }
  }

  @override
  QueryResponseModel<Stream<List<MedicalAppointmentBookingModel>>>getMedicalAppointmentBooking(String doctorId) {
    try {
      final data = _globalApi.getMedicalAppointmentBooking(doctorId);
      return QueryResponseModel(data: data);
    } catch (e) {
      return QueryResponseModel(isSuccessful: false, message: e.toString());
    }
  }
  
  @override
  Future<QueryResponseModel<List<UserCompanyModel>>>getDoctorsFromCompany(String company) async {
    try {
      final data = await _globalApi.getDoctorsFromCompany(company);
      return QueryResponseModel(data: data);
    } catch (e) {
      return QueryResponseModel(isSuccessful: false, message: e.toString());
    }
  }
  
  @override
  Future<QueryResponseModel<DoctorSettingModel>>getSettingDoctor(String id) async {
    try {
      final data = await _globalApi.getSettingDoctor(id);
      return QueryResponseModel(data: data);
    } catch (e) {
      return QueryResponseModel(isSuccessful: false, message: e.toString());
    }
  }
  
  @override
  Future<QueryResponseModel<List<MedicalAppointmentBookingModel>>>getBookingFromCompany(String id) async {
    try {
      final data = await _globalApi.getBookingFromCompany(id);
      return QueryResponseModel(data: data);
    } catch (e) {
      return QueryResponseModel(isSuccessful: false, message: e.toString());
    }
  }
}

final homeRepositoryProvider = Provider<_HomeRepository>(
  (Ref ref) => _HomeRepository(ref.read(homeApiProvider)),
);
