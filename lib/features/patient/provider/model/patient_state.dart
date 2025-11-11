import 'package:flutter/widgets.dart';
import 'package:iatros_web/core/models/user_model.dart';
import 'package:iatros_web/core/models/diagnosis_model.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:iatros_web/core/util/debouncer_util.dart';

part 'patient_state.freezed.dart';

@freezed
sealed class PatientState with _$PatientState {
  const factory PatientState({
    required bool isLoading,
    required UserModel myUser,
    required DebouncerUtil debouncer,
    required UserModel? selectedPatient,
    required TextEditingController tController,
    required TextEditingController nController,
    required TextEditingController fcController,
    required TextEditingController frController,
    required TextEditingController anController,
    required TextEditingController so2Controller,
    required TextEditingController tamController,
    required List<DiagnosisModel> diagnosesFound,
    required TextEditingController imcController,
    required TextEditingController sizeController,
    required TextEditingController reasonController,
    required List<DiagnosisModel> selectedDiagnoses,
    required TextEditingController weightController,
    required TextEditingController heightController,
    required TextEditingController systolicController,
    required TextEditingController diastolicController,
    required TextEditingController backgroundController,
    required TextEditingController paraclinicalController,
    required TextEditingController diseaseAndReviewBySystemsController,
  }) = PatientStateData;

  factory PatientState.initial() => PatientState(
    isLoading: false,
    diagnosesFound: [],
    selectedDiagnoses: [],
    selectedPatient: null,
    myUser: UserModel.init(),
    debouncer: DebouncerUtil(seconds: 1),
    tController: TextEditingController(),
    nController: TextEditingController(),
    fcController: TextEditingController(),
    anController: TextEditingController(),
    frController: TextEditingController(),
    tamController: TextEditingController(),
    so2Controller: TextEditingController(),
    imcController: TextEditingController(),
    sizeController: TextEditingController(),
    weightController: TextEditingController(),
    reasonController: TextEditingController(),
    heightController: TextEditingController(),
    systolicController: TextEditingController(),
    diastolicController: TextEditingController(),
    backgroundController: TextEditingController(),
    paraclinicalController: TextEditingController(),
    diseaseAndReviewBySystemsController: TextEditingController(),
  );
}
