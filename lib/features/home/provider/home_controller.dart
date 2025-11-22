import 'package:iatros_web/core/data/provider/global_controller.dart';
import 'package:iatros_web/core/models/blood_type.dart';
import 'package:iatros_web/core/models/gender.dart';
import 'package:iatros_web/features/home/provider/model/home_state.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'home_controller.g.dart';

@riverpod
class HomeController extends _$HomeController {
  @override
  FutureOr<HomeState> build() {
    ref.onDispose(() {
      state.value!.userSub!.cancel();
      state.value!.pageController.dispose();
      state.value!.nameController.dispose();
      state.value!.emailController.dispose();
      state.value!.phoneController.dispose();
      state.value!.addressController.dispose();
      state.value!.lastNameController.dispose();
      state.value!.identificationNumberController.dispose();

    });

    return HomeState.initial();
  }

  init() => _getMyUser();

  _getMyUser() {
    ref.listen(globalControllerProvider, (previous, next) {
      final user = next.value!.myUser;

      _setState(state.value!.copyWith(myUser: user));
    }, fireImmediately: true);
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
    state.value!.selectedAppointmentDate.value = item;
  }

  _setState(HomeState newState) => state = AsyncValue.data(newState);
}
