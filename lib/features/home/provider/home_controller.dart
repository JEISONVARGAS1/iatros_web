import 'package:flutter/material.dart';
import 'package:iatros_web/core/models/gender.dart';
import 'package:intl_phone_field/phone_number.dart';
import 'package:iatros_web/core/models/user_model.dart';
import 'package:iatros_web/core/models/blood_type.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:iatros_web/core/models/time_slots_model.dart';
import 'package:iatros_web/core/extension/date_extension.dart';
import 'package:iatros_web/core/models/user_company_model.dart';
import 'package:iatros_web/core/models/doctor_setting_model.dart';
import 'package:iatros_web/core/data/provider/global_controller.dart';
import 'package:iatros_web/core/models/notification_result_model.dart';
import 'package:iatros_web/features/home/provider/model/home_state.dart';
import 'package:iatros_web/features/home/repository/home_repository.dart';
import 'package:iatros_web/core/models/medical_appointment_booking_model.dart';

part 'home_controller.g.dart';

@riverpod
class HomeController extends _$HomeController {
  @override
  FutureOr<HomeState> build() {
    ref.onDispose(() {
      state.value!.medicalSub!.cancel();
      state.value!.pageController.dispose();
      state.value!.nameController.dispose();
      state.value!.emailController.dispose();
      state.value!.phoneController.dispose();
      state.value!.addressController.dispose();
      state.value!.lastNameController.dispose();
      state.value!.searchDoctorController.dispose();
      state.value!.identificationNumberController.dispose();
    });
    return HomeState.initial();
  }

  init() {
    _getMyUser();
    _listenerToSearchDoctor();
    listenerToIdentification();
  }

  HomeRepositoryInterface get repository => ref.read(homeRepositoryProvider);

  _getMyUser() {
    ref.listen(globalControllerProvider, (previous, next) {
      final user = next.value!.myUser;
      final doctorSetting = next.value!.doctorSetting;
      final userCompanySelected = next.value!.userCompanySelected;
      _setState(
        state.value!.copyWith(
          myUser: user,
          doctorSetting: doctorSetting,
          userCompany: userCompanySelected,
        ),
      );

      bool userIsNotNull = user.id != null;
      bool isDoctor = userCompanySelected.rolUser == RolUser.DOCTOR;
      bool userCompanySelectedIsNotNull = userCompanySelected.id != null;

      if (userIsNotNull && userCompanySelectedIsNotNull && !isDoctor) {
        getDoctorsFromCompany();
        getBookingFromCompany();
      } else if (userIsNotNull && userCompanySelectedIsNotNull && isDoctor) {
        getMedicalAppointmentBooking(userCompanySelected.id!);
      }
    }, fireImmediately: true);
  }

  getDoctorsFromCompany() async {
    final res = await repository.getDoctorsFromCompany(
      state.value!.userCompany.companyId,
    );
    if (res.isSuccessful) {
      _setState(
        state.value!.copyWith(doctors: res.data!, doctorsFilter: res.data!),
      );
    } else {
      addNotification(
        "No se pudo obtener los doctores: ${res.message}",
        StatusNotification.ERROR,
      );
    }
  }

  getBookingFromCompany() async {
    final res = await repository.getBookingFromCompany(
      state.value!.userCompany.companyId,
    );
    if (res.isSuccessful) {
      _setState(state.value!.copyWith(medicalAppointmentBooking: res.data!));
    } else {
      addNotification(
        "No se pudo obtener las citas: ${res.message}",
        StatusNotification.ERROR,
      );
    }
  }

  listenerToIdentification() {
    state.value!.identificationNumberController.addListener(
      searchUserByDocument,
    );
  }

  _listenerToSearchDoctor() {
    state.value!.searchDoctorController.addListener(handledToFilerDoctors);
  }

  selectedIdentificationTypeNotifier(String? item) {
    state.value!.selectedIdentificationTypeNotifier.value = item;
  }

  selectedBloodType(BloodType? item) {
    state.value!.selectedBloodTypeNotifier.value = item;
  }

  selectedGender(Gender? item) {
    state.value!.selectedGenderNotifier.value = item;
  }

  selectedAppointmentDate(DateTime? item) {
    _setState(state.value!.copyWith(selectedAppointmentDate: item));
  }

  List<TimeSlotsModel> generateListTimeSlots() {
    late List<TimeSlotsModel> listTimeZone = [];
    final listTimeSlots = state.value!.doctorSetting.listTimeSlots;
    final currentDate = state.value!.selectedAppointmentDate;

    if (currentDate == null) return [];

    final list = listTimeSlots
        .where(
          (e) =>
              e.dateKey == currentDate.toDaysWeekEnum ||
              (e.specificDay != null &&
                  e.specificDay!.isAtSameMomentAs(currentDate)),
        )
        .toList();

    for (var e in list) {
      listTimeZone = [...listTimeZone, ...e.workDateList];
    }

    final availableSlots = divideTimeSlots(
      listTimeZone,
      state.value!.doctorSetting.consultationDuration,
    );

    return availableSlots.where((slot) {
      final slotDateTime = DateTime(
        currentDate.year,
        currentDate.month,
        currentDate.day,
        slot.startWorkHours.hour,
        slot.startWorkHours.minute,
      );
      return !state.value!.medicalAppointmentBooking.any(
        (booking) =>
            booking.scheduleMedicalAppointment.isAtSameMomentAs(slotDateTime),
      );
    }).toList();
  }

  bool hasAvailableSlots(DateTime date) {
    final listTimeSlots = state.value!.doctorSetting.listTimeSlots;

    final list = listTimeSlots
        .where(
          (e) =>
              e.dateKey == date.toDaysWeekEnum ||
              (e.specificDay != null && e.specificDay!.isAtSameMomentAs(date)),
        )
        .toList();

    if (list.isEmpty) return false;

    final listTimeZone = list.expand((e) => e.workDateList).toList();

    final slots = divideTimeSlots(
      listTimeZone,
      state.value!.doctorSetting.consultationDuration,
    );

    final availableSlots = slots.where((slot) {
      final slotDateTime = DateTime(
        date.year,
        date.month,
        date.day,
        slot.startWorkHours.hour,
        slot.startWorkHours.minute,
      );
      return !state.value!.medicalAppointmentBooking.any(
        (booking) =>
            booking.scheduleMedicalAppointment.isAtSameMomentAs(slotDateTime),
      );
    }).toList();

    return availableSlots.isNotEmpty;
  }

  selectedDateOfBirth(DateTime? item) {
    state.value!.dateOfBirthNotifier.value = item;
  }

  selectedTimeSlot(TimeSlotsModel? item) {
    state.value!.selectedTimeSlotNotifier.value = item;
  }

  List<TimeSlotsModel> divideTimeSlots(
    List<TimeSlotsModel> slots,
    int minutes,
  ) {
    List<TimeSlotsModel> result = [];
    for (var slot in slots) {
      int startMinutes =
          slot.startWorkHours.hour * 60 + slot.startWorkHours.minute;
      int endMinutes = slot.endWorkHours.hour * 60 + slot.endWorkHours.minute;
      for (
        int current = startMinutes;
        current < endMinutes;
        current += minutes
      ) {
        int next = current + minutes;
        if (next > endMinutes) next = endMinutes;
        TimeOfDay start = TimeOfDay(hour: current ~/ 60, minute: current % 60);
        TimeOfDay end = TimeOfDay(hour: next ~/ 60, minute: next % 60);
        result.add(TimeSlotsModel(startWorkHours: start, endWorkHours: end));
      }
    }
    return result;
  }

  setHasTriedToValidate(bool value) {
    _setState(state.value!.copyWith(hasTriedToValidate: value));
  }

  setPhone(PhoneNumber phone) {
    _setState(
      state.value!.copyWith(
        phoneNumber: phone.number,
        countryCode: phone.countryCode,
      ),
    );
  }

  setPhoneMessageError(String? error) {
    _setState(state.value!.copyWith(phoneErrorMessage: error));
  }

  onTimeSlotSelected(TimeSlotsModel? timeSlot) {
    _setState(state.value!.copyWith(timeSlotsSelected: timeSlot));
  }

  String? validateField(String? value) {
    if (value == null || value.isEmpty) {
      return 'El campo es requerido';
    }
    if (value.length < 2) {
      return 'El campo debe tener al menos 2 caracteres';
    }
    return null;
  }

  String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'El correo es requerido';
    }
    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
      return 'Ingresa un correo válido';
    }
    return null;
  }

  FutureOr<String?> validatePhone(PhoneNumber? value) {
    if (value == null || value.number.isEmpty) {
      return 'El teléfono es requerido';
    }
    if (value.number.length < 10) {
      return 'El teléfono debe tener al menos 10 dígitos';
    }
    if (!RegExp(r'^\d+$').hasMatch(value.number)) {
      return 'El teléfono solo puede contener números';
    }
    return null;
  }

  String? validateIdentification() {
    final identification = state.value!.identificationNumberController.text;
    final hasTriedToValidate = state.value!.hasTriedToValidate;

    if (identification.isEmpty && hasTriedToValidate) {
      return 'La identificación es requerida';
    }
    return null;
  }

  String? validateAddress() {
    final address = state.value!.addressController.text;
    final hasTriedToValidate = state.value!.hasTriedToValidate;

    if (address.isEmpty && hasTriedToValidate) {
      return 'La dirección es requerida';
    }
    return null;
  }

  String? validateBirth() {
    final birth = state.value!.dateOfBirthNotifier.value;
    final hasTriedToValidate = state.value!.hasTriedToValidate;

    if (birth == null && hasTriedToValidate) {
      return 'La fecha de nacimiento es requerida';
    }
    return null;
  }

  String? validateBlood() {
    final blood = state.value!.selectedBloodTypeNotifier.value;
    final hasTriedToValidate = state.value!.hasTriedToValidate;

    if (blood == null && hasTriedToValidate) {
      return 'El grupo sanguíneo es requerido';
    }
    return null;
  }

  String? validateGender() {
    final gender = state.value!.selectedGenderNotifier.value;
    final hasTriedToValidate = state.value!.hasTriedToValidate;

    if (gender == null && hasTriedToValidate) {
      return 'El sexo es requerido';
    }
    return null;
  }

  searchUserByDocument() {
    final value = state.value!.identificationNumberController.text;
    if (value.isEmpty) return;

    state.value!.debouncer.run(() async {
      final res = await repository.getUsers(value);
      if (res.isSuccessful) {
        final UserModel user = res.data!;

        state.value!.nameController.text = user.name;
        state.value!.emailController.text = user.email;
        state.value!.phoneController.text = user.phone;
        state.value!.addressController.text = user.address;
        state.value!.lastNameController.text = user.lastName;
        state.value!.selectedGenderNotifier.value = user.gender;
        state.value!.dateOfBirthNotifier.value = user.dateOfBirth;
        state.value!.selectedBloodTypeNotifier.value = user.bloodType;
        state.value!.selectedIdentificationTypeNotifier.value =
            user.identificationType;
        setPhone(
          PhoneNumber(
            countryISOCode: "",
            number: user.phone,
            countryCode: user.countryCode,
          ),
        );

        _setState(state.value!.copyWith(userFount: user));
      } else {
        addNotification("Usuario no encontrado", StatusNotification.ALERT);
      }
    });
  }

  Future<void> scheduleAppointment() async {
    _setState(state.value!.copyWith(loading: true));
    final res = await _validateAndPerformUser();
    if (res) {
      String userId = state.value!.myUser.id ?? "";
      String userCompanyId = state.value!.userCompany.id ?? "";

      if (state.value!.userCompany.rolUser != RolUser.DOCTOR) {
        userId = state.value!.doctorSetting.id ?? "";
        userCompanyId = state.value!.doctorSetting.userCompanyId;
      }

      final selectedDate = state.value!.selectedAppointmentDate!;
      final timeSlot = state.value!.timeSlotsSelected!;
      final scheduleDateTime = DateTime(
        selectedDate.year,
        selectedDate.month,
        selectedDate.day,
        timeSlot.startWorkHours.hour,
        timeSlot.startWorkHours.minute,
      );
      final appointment = MedicalAppointmentBookingModel.init().copyWith(
        userId: userId,
        userCompanyId: userCompanyId,
        scheduleMedicalAppointment: scheduleDateTime,
        companyId: state.value!.userCompany.companyId,
      );
      final res = await repository.createMedicalAppointmentBooking(appointment);
      if (res.isSuccessful) {
        _setState(state.value!.copyWith(loading: false));
        addNotification(
          "Cita medica agendada correctamente",
          StatusNotification.SUCCESS,
        );
        clearForm();
      } else {
        addNotification(res.message, StatusNotification.ERROR);
        _setState(state.value!.copyWith(loading: false));
      }
    } else {
      _setState(state.value!.copyWith(loading: false));
      addNotification("Error con el usuario", StatusNotification.ERROR);
    }
  }

  Future<bool> _validateAndPerformUser() async {
    final newUser = _generateUser();
    final userId = state.value!.userFount.id;

    if (userId != null && userId.isNotEmpty) {
      final oldUser = state.value!.userFount;

      final validate = newUser.compareWith(oldUser);

      if (!validate) return await _updateUser(newUser);
      return true;
    } else {
      return await _saveUser(newUser);
    }
  }

  Future<bool> _saveUser(UserModel user) async {
    final res = await repository.createUsers(user);
    if (res.isSuccessful) {
      _setState(state.value!.copyWith(userFount: res.data!));
      return true;
    }
    return false;
  }

  Future<bool> _updateUser(UserModel user) async {
    final res = await repository.updateUsers(user);
    if (res.isSuccessful) {
      _setState(state.value!.copyWith(userFount: res.data!));
      return true;
    }
    return false;
  }

  UserModel _generateUser() {
    final phone = state.value!.phoneNumber;

    final user = state.value!.userFount.copyWith(
      phone: phone,
      countryCode: state.value!.countryCode,
      name: state.value!.nameController.text,
      email: state.value!.emailController.text,
      address: state.value!.addressController.text,
      lastName: state.value!.lastNameController.text,
      gender: state.value!.selectedGenderNotifier.value,
      dateOfBirth: state.value!.dateOfBirthNotifier.value,
      bloodType: state.value!.selectedBloodTypeNotifier.value,
      identificationType: state.value!.selectedIdentificationTypeNotifier.value,
      identificationNumber: state.value!.identificationNumberController.text,
    );

    return user;
  }

  void clearForm() {
    state.value!.nameController.text = '';
    state.value!.emailController.text = '';
    state.value!.phoneController.text = '';
    state.value!.addressController.text = '';
    state.value!.lastNameController.text = '';
    state.value!.identificationNumberController.text = '';
    state.value!.selectedIdentificationTypeNotifier.value = null;
    state.value!.selectedBloodTypeNotifier.value = null;
    state.value!.selectedGenderNotifier.value = null;
    state.value!.dateOfBirthNotifier.value = null;
    state.value!.selectedTimeSlotNotifier.value = null;
    _setState(
      state.value!.copyWith(
        phoneNumber: '',
        doctorSelected: null,
        phoneErrorMessage: null,
        timeSlotsSelected: null,
        hasTriedToValidate: false,
        userFount: UserModel.init(),
        selectedAppointmentDate: null,
        doctorSetting: DoctorSettingModel.init(),
      ),
    );
  }

  void addNotification(String message, StatusNotification status) {
    final notification = NotificationResultModel(
      message: message,
      status: status,
      createdAt: DateTime.now(),
    );
    final newList = [...state.value!.listNotification, notification];
    _setState(state.value!.copyWith(listNotification: newList));
    Future.delayed(const Duration(seconds: 30), () {
      removeNotification(notification);
    });
  }

  void removeNotification(NotificationResultModel notification) {
    final newList = state.value!.listNotification
        .where((n) => n != notification)
        .toList();
    _setState(state.value!.copyWith(listNotification: newList));
  }

  void getMedicalAppointmentBooking(String doctorId) {
    final res = repository.getMedicalAppointmentBooking(doctorId);
    if (res.isSuccessful) {
      state.value!.medicalSub?.cancel();
      final sub = res.data!.listen((event) {
        if (event.isNotEmpty) {
          _setState(state.value!.copyWith(medicalAppointmentBooking: event));
        } else {
          _setState(state.value!.copyWith(medicalAppointmentBooking: []));
        }
      });
      _setState(state.value!.copyWith(medicalSub: sub));
    }
  }

  bool handledShowPanelDoctors() {
    bool isNotDoctor = state.value!.userCompany.rolUser != RolUser.DOCTOR;
    bool isScheduling = state.value!.index == 1;

    return isNotDoctor && isScheduling;
  }

  Future<void> changeDoctorSelected(UserCompanyModel doctor) async {
    _setState(state.value!.copyWith(loading: true));
    if (doctor.user!.id == state.value!.doctorSelected?.id) {
      _setState(
        state.value!.copyWith(
          doctorSelected: null,
          selectedAppointmentDate: null,
          doctorSetting: DoctorSettingModel.init(),
        ),
      );
    } else {
      final res = await repository.getSettingDoctor(doctor.id!);
      if (res.isSuccessful) {
        _setState(
          state.value!.copyWith(
            doctorSetting: res.data!,
            doctorSelected: doctor.user!,
          ),
        );
      }
    }
    _setState(state.value!.copyWith(loading: false));
  }

  void changeIndex(int index) {
    _setState(
      state.value!.copyWith(
        index: index,
        doctorSelected: null,
        selectedAppointmentDate: null,
        doctorSetting: DoctorSettingModel.init(),
      ),
    );
  }

  void selectSpecialization(String? item) {
    _setState(state.value!.copyWith(selectedSpecialization: item ?? ""));
    handledToFilerDoctors();
  }

  void handledToFilerDoctors() {
    List<UserCompanyModel> doctors = state.value!.doctors.toList();

    if (state.value!.selectedSpecialization.isNotEmpty) {
      doctors = doctors.where((e) {
        return e.user!.specialization == state.value!.selectedSpecialization;
      }).toList();
    }

    if (state.value!.searchDoctorController.text.isNotEmpty) {
      doctors = doctors.where((e) {
        return "${e.user!.name} ${e.user!.lastName}".toLowerCase().contains(
          state.value!.searchDoctorController.text.toLowerCase(),
        );
      }).toList();
    }

    _setState(state.value!.copyWith(doctorsFilter: doctors));
  }

  cleanFilterDoctor() {
    state.value!.searchDoctorController.clear();
    selectSpecialization(null);
  }

  _setState(HomeState newState) => state = AsyncValue.data(newState);
}
