import 'package:flutter/material.dart';
import 'package:iatros_web/router.dart';
import 'package:go_router/go_router.dart';
import 'package:iatros_web/uikit/index.dart';
import 'package:iatros_web/core/models/user_model.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:iatros_web/uikit/utils/custom_show_dialog.dart';
import 'package:iatros_web/features/patients_seek/repository/patients_seek_repository.dart';
import 'package:iatros_web/features/patients_seek/pages/widget/form_create_patient.dart';
import 'package:iatros_web/features/patients_seek/provider/model/patients_seek_state.dart';

part 'patients_seek_controller.g.dart';

@riverpod
class PatientsSeekController extends _$PatientsSeekController {
  PatientsSeekRepositoryInterface get repository =>
      ref.read(patientSeekRepositoryProvider);

  @override
  FutureOr<PatientsSeekState> build() {
    ref.onDispose(() => state.value!.userSub?.cancel());

    return PatientsSeekState.initial();
  }

  void searchUsers(String value) async {
    if (value.isEmpty) {
      _setState(state.value!.copyWith(users: []));
    } else {
      final res = await repository.getUsers(value);
      if (res.isSuccessful) {
        _setState(state.value!.copyWith(users: res.data!));
      }
    }
  }

  cleanSearch() => _setState(state.value!.copyWith(users: []));

  createPatient(BuildContext context, Function(UserModel) callBack) async {
    context.pop();
    final patient = UserModel.init().copyWith(
      typeUser: TypeUser.PATIENT,
      medicalLicense: "000000000000",
      phone: state.value!.phoneNumber!,
      name: state.value!.nameController.text,
      email: state.value!.emailController.text,
      lastName: state.value!.lastNameController.text,
      identificationNumber: state.value!.identificationNumber,
      identificationType: state.value!.selectedIdentificationType,
    );

    final res = await repository.createUsers(patient);

    if (res.isSuccessful) {
      callBack(res.data!);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(res.message), backgroundColor: AppColors.error),
      );
    }
    context.pop();
  }

  setPhoneNumber(String? value) =>
      _setState(state.value!.copyWith(phoneNumber: value));
  setIdentificationNumber(String? value) =>
      _setState(state.value!.copyWith(identificationNumber: value ?? ""));
  setSelectedIdentificationType(String? value) =>
      _setState(state.value!.copyWith(selectedIdentificationType: value));
  setIdentificationError(String? value) =>
      _setState(state.value!.copyWith(identificationError: value));

  Future<void> showCreatePatients(
    BuildContext context, {
    required String title,
    required String description,
    required Function(UserModel) goToPatient,
  }) async => await customShowDialog(
    context,
    title: title,
    description: description,
    body: FormCreatePatient(
      controller: this,
      state: state.value!,
      goToPatient: goToPatient,
    ),
  );

  void goToPatient(BuildContext context, UserModel user) {
    if (context.mounted) {
      final path = AppRoutes.patient.path.replaceFirst(':userId', user.id ?? '');
      context.go(path);
    }
  }

  _setState(PatientsSeekState newState) => state = AsyncValue.data(newState);
}
