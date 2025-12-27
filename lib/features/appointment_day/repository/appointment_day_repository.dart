import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iatros_web/core/models/medical_appointment_booking_model.dart';
import 'package:iatros_web/core/models/medical_appointment_booking_view.dart';
import 'package:iatros_web/features/appointment_day/data/appointment_day_api.dart';
import 'package:iatros_web/features/appointment_day/data/appointment_day_api_interface.dart';

import 'package:iatros_web/core/models/query_response_model.dart';

abstract class AppointmentDayRepositoryInterface {
  QueryResponseModel<Stream<List<MedicalAppointmentBookingViewModel>>>
  getMedicalAppointmentBooking(String doctorId, DateTime day);

  QueryResponseModel<Stream<List<MedicalAppointmentBookingViewModel>>>
  getMedicalAppointmentBookingFromSecretary(
    String companyId,
    DateTime day,
  );

  Future<QueryResponseModel<List<MedicalAppointmentBookingModel>>>
  updateMedicalAppointmentBooking(String id, AppointmentStatus status);
}

class _AppointmentDayRepository implements AppointmentDayRepositoryInterface {
  final AppointmentDayInterface _globalApi;

  _AppointmentDayRepository(AppointmentDayInterface globalApi)
    : _globalApi = globalApi;

  @override
  QueryResponseModel<Stream<List<MedicalAppointmentBookingViewModel>>>
  getMedicalAppointmentBooking(String doctorId, DateTime day) {
    try {
      final stream = _globalApi.getMedicalAppointmentBooking(doctorId, day);
      return QueryResponseModel(data: stream);
    } catch (e) {
      return QueryResponseModel(isSuccessful: false, message: e.toString());
    }
  }

  @override
  QueryResponseModel<Stream<List<MedicalAppointmentBookingViewModel>>>
  getMedicalAppointmentBookingFromSecretary(
    String companyId, 
    DateTime day,
  ) {
    try {
      final stream = _globalApi.getMedicalAppointmentBookingFromCompany(
        companyId,
        day,
      );
      return QueryResponseModel(data: stream);
    } catch (e) {
      return QueryResponseModel(isSuccessful: false, message: e.toString());
    }
  }

  @override
  Future<QueryResponseModel<List<MedicalAppointmentBookingModel>>>
  updateMedicalAppointmentBooking(String id, AppointmentStatus status) async {
    try {
      await _globalApi.updateMedicalAppointmentBooking(id, status);
      return QueryResponseModel();
    } catch (e) {
      return QueryResponseModel(isSuccessful: false, message: e.toString());
    }
  }
}

final appointmentDayRepositoryProvider = Provider<_AppointmentDayRepository>(
  (Ref ref) => _AppointmentDayRepository(ref.read(appointmentDayApiProvider)),
);
