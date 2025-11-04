import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:iatros_web/core/models/diagnosis_model.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:iatros_web/features/patient/provider/model/patient_state.dart';
import 'package:iatros_web/features/patient/repository/patients_repository.dart';

part 'patient_controller.g.dart';

@riverpod
class PatientController extends _$PatientController {
  @override
  FutureOr<PatientState> build() => PatientState.initial();
  PatientsRepositoryInterface get _repository =>
      ref.read(patientRepositoryProvider);

  initPage(String userId) {
    _getUserData(userId);
    _bloodPressureListener();
  }

  Future<void> _getUserData(id) async {
    final res = await _repository.getUserById(id);
    if (res.isSuccessful) {
      _setState(state.value!.copyWith(selectedPatient: res.data!));
    }
  }

  searchDiagnoses(String text) {
    if (text.isNotEmpty) {
      state.value!.debouncer.run(() async {
        final res = await _repository.searchDiagnoses(text);
        if (res.isSuccessful) {
          _setState(state.value!.copyWith(diagnosesFound: res.data!));
        }
      });
    } else {
      _setState(state.value!.copyWith(diagnosesFound: []));
    }
  }

  _bloodPressureListener() {
    state.value!.systolicController.addListener(_applyTAMFromSystolic);
    state.value!.diastolicController.addListener(_applyTAMFromSystolic);
  }

  _applyTAMFromSystolic() {
    final systolic = double.parse(state.value!.systolicController.text);
    final diastolic = double.parse(state.value!.diastolicController.text);

    final value = (systolic + (2 * diastolic)) / 3;
    state.value!.tamController.text = value.toStringAsFixed(0);
  }

  void updateSelectedDiagnoses(List<DiagnosisModel> diagnoses) {
    _setState(state.value!.copyWith(selectedDiagnoses: diagnoses));
  }

  void saveConsultation(BuildContext context) {
    context.pop();
  }

  void _setState(PatientState newState) => state = AsyncValue.data(newState);
}
