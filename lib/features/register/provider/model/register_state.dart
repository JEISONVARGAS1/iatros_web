import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:iatros_web/core/models/gender.dart';
import 'package:iatros_web/core/models/blood_type.dart';
import 'package:iatros_web/core/enum/company_type.dart';

part 'register_state.freezed.dart';

@freezed
class RegisterState with _$RegisterState {
  const factory RegisterState({
    required bool isRegisterLoading,
    required GlobalKey<FormState> formKey,
    required PageController pageController,
    required TextEditingController bioController,
    required TextEditingController nameController,
    required TextEditingController emailController,
    required TextEditingController addressController,
    required TextEditingController lastNameController,
    required TextEditingController passwordController,
    required TextEditingController medicalLicenseController,
    required TextEditingController confirmPasswordController,
    required TextEditingController yearsExperienceController,
    required TextEditingController companyNameController,
    required TextEditingController companyNitController,
    required TextEditingController identificationNumberController,
    required int currentPage,
    required String phoneNumber,
    required String identificationNumber,
    required bool hasTriedToValidate,
    CompanyType? selectedCompanyType,
    dynamic companyDocumentImage,
    required ValueNotifier<Gender?> selectedGender,
    double? addressLatitude,
    double? addressLongitude,
    required ValueNotifier<BloodType?> selectedBloodType,
    dynamic professionalCardImage,
    dynamic identityDocumentImage,
    String? selectedSpecialization,
    required ValueNotifier<String?> selectedIdentificationType,
    required ValueNotifier<DateTime?> dateOfBirth,
  }) = _RegisterState;

  factory RegisterState.initial() => RegisterState(
        isRegisterLoading: false,
        formKey: GlobalKey<FormState>(),
        pageController: PageController(),
        bioController: TextEditingController(),
        nameController: TextEditingController(),
        emailController: TextEditingController(),
        addressController: TextEditingController(),
        lastNameController: TextEditingController(),
        passwordController: TextEditingController(),
        medicalLicenseController: TextEditingController(),
        confirmPasswordController: TextEditingController(),
        yearsExperienceController: TextEditingController(),
        companyNameController: TextEditingController(),
        companyNitController: TextEditingController(),
        identificationNumberController: TextEditingController(),
        currentPage: 0,
        phoneNumber: '',
        identificationNumber: '',
        hasTriedToValidate: false,
        selectedGender: ValueNotifier<Gender?>(null),
        selectedBloodType: ValueNotifier<BloodType?>(null),
        selectedIdentificationType: ValueNotifier<String?>(null),
        dateOfBirth: ValueNotifier<DateTime?>(null),
      );
}