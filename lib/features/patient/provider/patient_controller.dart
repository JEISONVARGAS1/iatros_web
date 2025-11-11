import 'dart:html' as html;
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:iatros_web/core/models/diagnosis_model.dart';
import 'package:iatros_web/core/util/custom_alerts.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:iatros_web/core/data/provider/global_controller.dart';
import 'package:iatros_web/core/models/medical_consultation_model.dart';
import 'package:iatros_web/features/patient/provider/model/patient_state.dart';
import 'package:iatros_web/features/patient/repository/patients_repository.dart';
import 'package:iatros_web/router.dart';

part 'patient_controller.g.dart';

@riverpod
class PatientController extends _$PatientController {
  @override
  FutureOr<PatientState> build() => PatientState.initial();
  PatientsRepositoryInterface get _repository =>
      ref.read(patientRepositoryProvider);

  initPage(String userId) {
    _getMyUser();
    _getUserData(userId);
    _bloodPressureListener();
  }

  _getMyUser() {
    ref.listen(globalControllerProvider, (previous, next) {
      final user = next.value!.myUser;

      _setState(state.value!.copyWith(myUser: user));
    }, fireImmediately: true);
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
        _setState(state.value!.copyWith(isLoading: true));
        final res = await _repository.searchDiagnoses(text);
        if (res.isSuccessful) {
          _setState(state.value!.copyWith(diagnosesFound: res.data!, isLoading: false));
        }
      });
    } else {
      _setState(state.value!.copyWith(diagnosesFound: [], isLoading: false));
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

  Future<void> createMedicalConsultation(BuildContext context) async {
    _setState(state.value!.copyWith(isLoading: true));
    late MedicalConsultationModel medicalConsultation;

    medicalConsultation = _generateMedicalConsultation();

    final res = await _repository.createMedicalConsultation(
      medicalConsultation,
    );

    if (res.isSuccessful && context.mounted) {
      _setState(state.value!.copyWith(isLoading: false));
      context.go(AppRoutes.lobby.path);
      // Prevent back button from going to patient page
      html.window.history.pushState(null, '', AppRoutes.lobby.path);
    } else {
      _setState(state.value!.copyWith(isLoading: false));
      CustomAlerts.showErrorAlert(context, description: res.message);
    }
  }

  MedicalConsultationModel _generateMedicalConsultation() {
    final data = MedicalConsultationModel(
      createdAt: DateTime.now(),
      doctorId: state.value!.myUser.id!,
      fr: state.value!.frController.text,
      fc: state.value!.fcController.text,
      so2: state.value!.so2Controller.text,
      tam: state.value!.tamController.text,
      imc: state.value!.imcController.text,
      reason: state.value!.reasonController.text,
      height: state.value!.heightController.text,
      weight: state.value!.weightController.text,
      temperature: state.value!.tController.text,
      systolic: state.value!.systolicController.text,
      diastolic: state.value!.diastolicController.text,
      background: state.value!.backgroundController.text,
      paraclinical: state.value!.paraclinicalController.text,
      diagnoses: state.value!.selectedDiagnoses.map((d) => d.name).toList(),
      diseaseAndReviewBySystems:
          state.value!.diseaseAndReviewBySystemsController.text,
    );

    return data;
  }

  void _setState(PatientState newState) => state = AsyncValue.data(newState);
}
