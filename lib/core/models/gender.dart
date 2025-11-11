enum Gender {
  male,   // Hombre
  female, // Mujer
  other,  // Otros
}

extension GenderExtension on Gender {
  String get displayName {
    switch (this) {
      case Gender.male:
        return 'Hombre';
      case Gender.female:
        return 'Mujer';
      case Gender.other:
        return 'Otros';
    }
  }
}

