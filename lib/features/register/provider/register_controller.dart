import 'package:flutter/material.dart';
import 'package:iatros_web/core/models/user_company_model.dart';
import 'package:iatros_web/uikit/index.dart';
import 'package:iatros_web/core/models/user_model.dart';
import 'package:iatros_web/core/models/gender.dart';
import 'package:iatros_web/core/models/blood_type.dart';
import 'package:iatros_web/core/models/company_model.dart';
import 'package:iatros_web/core/enum/company_type.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:iatros_web/features/auth/provider/auth_controller.dart';
import 'package:iatros_web/features/register/provider/model/register_state.dart';

part 'register_controller.g.dart';

@riverpod
class RegisterController extends _$RegisterController {
  @override
  FutureOr<RegisterState> build() {
    ref.onDispose(() {
      state.value!.dateOfBirth.dispose();
      state.value!.bioController.dispose();
      state.value!.selectedGender.dispose();
      state.value!.pageController.dispose();
      state.value!.nameController.dispose();
      state.value!.emailController.dispose();
      state.value!.addressController.dispose();
      state.value!.selectedBloodType.dispose();
      state.value!.lastNameController.dispose();
      state.value!.passwordController.dispose();
      state.value!.companyNitController.dispose();
      state.value!.companyNameController.dispose();
      state.value!.medicalLicenseController.dispose();
      state.value!.yearsExperienceController.dispose();
      state.value!.confirmPasswordController.dispose();
      state.value!.selectedIdentificationType.dispose();
      state.value!.identificationNumberController.dispose();
    });

    return RegisterState.initial();
  }

  AuthController get authController =>
      ref.read(authControllerProvider.notifier);

  // Register page setters
  void setCurrentPage(int page) {
    _setState(
      state.value!.copyWith(currentPage: page, hasTriedToValidate: false),
    );
  }

  void setHasTriedToValidate(bool value) {
    _setState(state.value!.copyWith(hasTriedToValidate: value));
  }

  void setPhoneNumber(String value) {
    _setState(state.value!.copyWith(phoneNumber: value));
  }

  void setSelectedGender(Gender? value) {
    state.value!.selectedGender.value = value;
  }

  void setSelectedBloodType(BloodType? value) {
    state.value!.selectedBloodType.value = value;
  }

  void setSelectedIdentificationType(String? value) {
    state.value!.selectedIdentificationType.value = value;
  }

  void setIdentificationNumber(String value) {
    _setState(state.value!.copyWith(identificationNumber: value));
  }

  void setDateOfBirth(DateTime? date) {
    state.value!.dateOfBirth.value = date;
  }

  void setAddressCoordinates(double? latitude, double? longitude) {
    _setState(
      state.value!.copyWith(
        addressLatitude: latitude,
        addressLongitude: longitude,
      ),
    );
  }

  void setSelectedCompanyType(CompanyType? value) {
    _setState(state.value!.copyWith(selectedCompanyType: value));
  }

  void setCompanyDocumentImage(dynamic image) {
    _setState(state.value!.copyWith(companyDocumentImage: image));
  }

  void setSelectedSpecialization(String? value) {
    _setState(state.value!.copyWith(selectedSpecialization: value));
  }

  void setIdentityDocumentImage(dynamic image) {
    _setState(state.value!.copyWith(identityDocumentImage: image));
  }

  void setProfessionalCardImage(dynamic image) {
    _setState(state.value!.copyWith(professionalCardImage: image));
  }

  // Register page validation
  bool validateCurrentStep() {
    switch (state.value!.currentPage) {
      case 0:
        return state.value!.selectedIdentificationType.value != null &&
            state.value!.identificationNumber.isNotEmpty &&
            state.value!.dateOfBirth.value != null &&
            state.value!.selectedGender.value != null &&
            state.value!.selectedBloodType.value != null;
      case 1:
        return state.value!.selectedCompanyType != null &&
            state.value!.companyDocumentImage != null;
      case 2:
        return state.value!.selectedSpecialization != null;
      case 3:
        return state.value!.identityDocumentImage != null &&
            state.value!.professionalCardImage != null;
      case 4:
        return true;
      default:
        return false;
    }
  }

  // Register validation with user model creation
  Future<void> registerFromForm(BuildContext context) async {
    // Set loading to true
    setRegisterLoading(true);

    try {
      // Validate all required fields
      if (state.value!.selectedIdentificationType.value == null) {
        _showError(context, 'Por favor selecciona tu tipo de identificación');
        return;
      }
      if (state.value!.identificationNumber.isEmpty) {
        _showError(context, 'Por favor ingresa tu número de identificación');
        return;
      }
      if (state.value!.dateOfBirth.value == null) {
        _showError(context, 'Por favor selecciona tu fecha de nacimiento');
        return;
      }
      if (state.value!.selectedGender.value == null) {
        _showError(context, 'Por favor selecciona tu sexo');
        return;
      }
      if (state.value!.selectedBloodType.value == null) {
        _showError(context, 'Por favor selecciona tu grupo sanguíneo');
        return;
      }
      if (state.value!.selectedSpecialization == null) {
        _showError(context, 'Por favor selecciona tu especialización');
        return;
      }
      if (state.value!.identityDocumentImage == null) {
        _showError(
          context,
          'Por favor sube una foto de tu documento de identidad',
        );
        return;
      }
      if (state.value!.professionalCardImage == null) {
        _showError(
          context,
          'Por favor sube una foto de tu tarjeta profesional',
        );
        return;
      }
      if (state.value!.companyNameController.text.trim().isEmpty) {
        _showError(context, 'Por favor ingresa el nombre de la empresa');
        return;
      }
      if (state.value!.companyNitController.text.trim().isEmpty) {
        _showError(context, 'Por favor ingresa el NIT de la empresa');
        return;
      }
      if (state.value!.companyDocumentImage == null) {
        _showError(context, 'Por favor sube la documentación de la empresa');
        return;
      }
      if (state.value!.selectedCompanyType == null) {
        _showError(context, 'Por favor selecciona el tipo de empresa');
        return;
      }

      final user = _generateUser();
      final company = _generateCompany();

      final userCompany = UserCompanyModel.init().copyWith(
        user: user,
        company: company,
      );

      await authController.register(
        userCompany,
        state.value!.passwordController.text,
      );
    } finally {
      // Set loading to false
      setRegisterLoading(false);
    }
  }

  CompanyModel _generateCompany() {
    final companyModel = CompanyModel.init().copyWith(
      userOwnerId: "",
      companyType: state.value!.selectedCompanyType,
      nit: state.value!.companyNitController.text.trim(),
      companyName: state.value!.companyNameController.text.trim(),      
    );
    return companyModel;
  }

  UserModel _generateUser() {  
    final userModel = UserModel.init().copyWith(
      name: state.value!.nameController.text.trim(),
      phone: state.value!.phoneNumber,
      email: state.value!.emailController.text.trim(),
      lastName: state.value!.lastNameController.text.trim(),
      specialization: state.value!.selectedSpecialization!,
      medicalLicense: state.value!.medicalLicenseController.text.trim(),
      professionalBiography: state.value!.bioController.text.trim().isNotEmpty
          ? state.value!.bioController.text.trim()
          : "",
      yearsOfExperience: state.value!.yearsExperienceController.text.isNotEmpty
          ? int.parse(state.value!.yearsExperienceController.text)
          : 0,
      identificationType: state.value!.selectedIdentificationType.value!,
      identificationNumber: state.value!.identificationNumber,
      address: state.value!.addressController.text.trim(),
      latitude: state.value!.addressLatitude,
      longitude: state.value!.addressLongitude,
      dateOfBirth: state.value!.dateOfBirth.value!,
      gender: state.value!.selectedGender.value!,
      bloodType: state.value!.selectedBloodType.value!,
    );

    return userModel;
  }

  void setRegisterLoading(bool loading) {
    _setState(state.value!.copyWith(isRegisterLoading: loading));
  }

  void _showError(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: AppColors.error),
    );
  }

  _setState(RegisterState newState) => state = AsyncValue.data(newState);
}
