import 'dart:convert';

import 'package:hive_flutter/hive_flutter.dart';
import 'package:iatros_web/core/models/user_model.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:iatros_web/core/data/provider/model/global_state.dart';
import 'package:iatros_web/core/data/repository/global_repository.dart';

part 'global_controller.g.dart';

@riverpod
class GlobalController extends _$GlobalController {
  @override
  Future<GlobalState> build() async {
    ref.keepAlive();
    ref.onDispose(() => state.value!.userSub!.cancel());

    final box = await Hive.openBox('userBox');
    final userJson = box.get('myUser') as String?;
    UserModel myUser = UserModel.init();
    if (userJson != null) {
      try {
        final userMap = jsonDecode(userJson) as Map<String, dynamic>;
        myUser = UserModel.fromJson(userMap);
      } catch (e) {
        // If parsing fails, use init
      }
    }

    return GlobalState(myUser: myUser);
  }

  GlobalRepositoryInterface get repository =>
      ref.read(globalRepositoryProvider);
 
  Future<void> getStreamUser(String id) async {
    // Fetch initial user
    final userRes = await repository.getUserById(id);
    if (userRes.isSuccessful) {
      _setState(state.value!.copyWith(myUser: userRes.data!));
    }

    // Set up stream for changes
    final res = repository.getUserStream(id);
    if (res.isSuccessful) {
      final stream = res.data!;
      final subscription = stream.listen((UserModel user) {
        _setState(state.value!.copyWith(myUser: user));
      });
      _setState(state.value!.copyWith(userSub: subscription));
    }
  }

  void cancelUserSub() {
    state.value?.userSub?.cancel();
    _setState(state.value!.copyWith(userSub: null));
  }

  _setState(GlobalState newState) {
    state = AsyncValue.data(newState);
    _saveUser(newState.myUser);
  }

  void _saveUser(UserModel user) async {
    if (user.id != null) {
      final box = await Hive.openBox('userBox');
      final userJson = jsonEncode(user.toJson());
      await box.put('myUser', userJson);
    }
  }
}



