import 'package:hive_flutter/hive_flutter.dart';
import 'package:iatros_web/core/models/user_model.dart';
import 'package:iatros_web/core/models/user_hive_model.dart';
import 'package:iatros_web/hive_helper.dart';

class HiveUserHelper {
  static const String _userKey = 'current_user';

  /// Get the current user from Hive
  static UserModel? getCurrentUser() {
    try {
      final userBox = Hive.box<UserHiveModel>(HiveConstants.userBox);
      final userHive = userBox.get(_userKey);
      return userHive?.toUser();
    } catch (e) {
      print('Error getting current user from Hive: $e');
      return null;
    }
  }

  /// Save the current user to Hive
  static Future<bool> saveCurrentUser(UserModel user) async {
    try {
      final userBox = Hive.box<UserHiveModel>(HiveConstants.userBox);
      final userHive = UserHiveModel.fromUser(user);
      await userBox.put(_userKey, userHive);
      return true;
    } catch (e) {
      print('Error saving current user to Hive: $e');
      return false;
    }
  }

  /// Clear the current user from Hive
  static Future<bool> clearCurrentUser() async {
    try {
      final userBox = Hive.box<UserHiveModel>(HiveConstants.userBox);
      await userBox.delete(_userKey);
      return true;
    } catch (e) {
      print('Error clearing current user from Hive: $e');
      return false;
    }
  }

  /// Check if user is stored in Hive
  static bool hasStoredUser() {
    try {
      final userBox = Hive.box<UserHiveModel>(HiveConstants.userBox);
      return userBox.containsKey(_userKey);
    } catch (e) {
      print('Error checking stored user: $e');
      return false;
    }
  }

  /// Update user data in Hive
  static Future<bool> updateUser(UserModel user) async {
    try {
      final userBox = Hive.box<UserHiveModel>(HiveConstants.userBox);
      final userHive = UserHiveModel.fromUser(user);
      await userBox.put(_userKey, userHive);
      return true;
    } catch (e) {
      print('Error updating user in Hive: $e');
      return false;
    }
  }

  /// Get user data as UserHiveModel
  static UserHiveModel? getCurrentUserHive() {
    try {
      final userBox = Hive.box<UserHiveModel>(HiveConstants.userBox);
      return userBox.get(_userKey);
    } catch (e) {
      print('Error getting current user Hive model: $e');
      return null;
    }
  }
}
