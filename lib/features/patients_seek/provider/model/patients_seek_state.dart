import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:iatros_web/core/models/user_model.dart';
import 'package:iatros_web/core/models/gender.dart';
import 'package:iatros_web/core/models/blood_type.dart';
import 'package:iatros_web/core/util/debouncer_util.dart';

part 'patients_seek_state.freezed.dart';

@freezed
sealed class PatientsSeekState with _$PatientsSeekState {
 const factory PatientsSeekState({
  required UserModel myUser,
  StreamSubscription? userSub,
  required String? phoneNumber,
  required List<UserModel> users,
  required DebouncerUtil debouncer,
  required String identificationNumber,
  required TextEditingController nameController,
  required TextEditingController emailController,
  required TextEditingController lastNameController,
  required TextEditingController addressController,
  required TextEditingController identificationNumberController,
  required ValueNotifier<String?> selectedIdentificationTypeNotifier,
  required ValueNotifier<DateTime?> dateOfBirthNotifier,
  required ValueNotifier<Gender?> selectedGenderNotifier,
  required ValueNotifier<BloodType?> selectedBloodTypeNotifier,

  String? selectedIdentificationType,
  String? identificationError,

  DateTime? dateOfBirth,
  Gender? selectedGender,
  BloodType? selectedBloodType,
  double? addressLatitude,
  double? addressLongitude,


 }) = PatientsSeekStateData;

  factory PatientsSeekState.initial() => PatientsSeekState(
    users: [],
    phoneNumber: null,
    myUser: UserModel.init(),
    identificationNumber: "",
    selectedIdentificationType: null,
    identificationError: null,
    debouncer: DebouncerUtil(seconds: 1),
    nameController: TextEditingController(),
    emailController: TextEditingController(),
    lastNameController: TextEditingController(),
    addressController: TextEditingController(),
    identificationNumberController: TextEditingController(),
    selectedIdentificationTypeNotifier: ValueNotifier<String?>(null),
    dateOfBirthNotifier: ValueNotifier<DateTime?>(null),
    selectedGenderNotifier: ValueNotifier<Gender?>(null),
    selectedBloodTypeNotifier: ValueNotifier<BloodType?>(null),
    dateOfBirth: null,
    selectedGender: null,
    selectedBloodType: null,
    addressLatitude: null,
    addressLongitude: null,
  );
}
