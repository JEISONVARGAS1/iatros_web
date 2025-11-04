import 'package:hive_flutter/hive_flutter.dart';
import 'package:iatros_web/core/models/user_hive_model.dart';

// Hive box names
class HiveConstants {
  static const String userBox = 'user_box';
  static const String authBox = 'auth_box';
}

initHive() async {
  try {
    await Hive.initFlutter();
  
    // Register adapters
    try {
      Hive.registerAdapter(UserHiveModelAdapter());
    } catch (e) {
      print('UserHiveModelAdapter already registered: $e');
    }
    
    // Open boxes safely
    await _openBoxSafely<UserHiveModel>(HiveConstants.userBox);
    await _openBoxSafely(HiveConstants.authBox);
    
    print('Hive initialized successfully');
  } catch (e) {
    print('Error initializing Hive: $e');
    rethrow;
  }
}

/// Abre un box de Hive de forma segura
Future<void> _openBoxSafely<T>(String boxName) async {
  try {
    if (!Hive.isBoxOpen(boxName)) {
      await Hive.openBox<T>(boxName);
    }
  } catch (e) {
    print('Error opening box $boxName: $e');
    // En caso de error, intentar abrir sin tipo específico
    try {
      if (!Hive.isBoxOpen(boxName)) {
        await Hive.openBox(boxName);
      }
    } catch (e2) {
      print('Error opening box $boxName without type: $e2');
      rethrow;
    }
  }
}
