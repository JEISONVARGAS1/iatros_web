import 'package:hive/hive.dart';
import 'package:iatros_web/core/models/user_model.dart';

part 'user_hive_model.g.dart';

@HiveType(typeId: 0)
class UserHiveModel extends HiveObject {
  @HiveField(1)
  final String? id;

  @HiveField(2)
  final String name;

  @HiveField(3)
  final String lastName;

  @HiveField(4)
  final String email;

  @HiveField(5)
  final String phone;

  @HiveField(6)
  final String specialization;

  @HiveField(7)
  final String medicalLicense;

  @HiveField(8)
  final int yearsOfExperience;

  @HiveField(9)
  final String professionalCardUrl;

  @HiveField(10)
  final String identityDocumentUrl;

  @HiveField(11)
  final String professionalBiography;

  @HiveField(12)
  final String identificationType;

  @HiveField(13)
  final String identificationNumber;

  @HiveField(14)
  final DateTime createdAt;

  @HiveField(15)
  final DateTime updateAt;

  @HiveField(16)
  final String typeUser;

  UserHiveModel({
    this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.lastName,
    required this.updateAt,
    required this.typeUser,
    required this.createdAt,
    required this.specialization,
    required this.medicalLicense,
    required this.yearsOfExperience,
    required this.professionalCardUrl,
    required this.identityDocumentUrl,
    required this.professionalBiography,
    required this.identificationType,
    required this.identificationNumber,
  });

  // Computed full name getter
  String get fullName => '$name $lastName'.trim();

  /// Convert to `UserModel`
  UserModel toUser() => UserModel(
        id: id,
        name: name,
        email: email,
        phone: phone,
        updateAt: updateAt,
        lastName: lastName,
        createdAt: createdAt,
        specialization: specialization,
        medicalLicense: medicalLicense,
        yearsOfExperience: yearsOfExperience,
        typeUser: _generateTypeUser(typeUser),
        professionalCardUrl: professionalCardUrl,
        identityDocumentUrl: identityDocumentUrl,
        professionalBiography: professionalBiography,
        identificationType: identificationType,
        identificationNumber: identificationNumber,
      );

  /// Convert from `UserModel`
  factory UserHiveModel.fromUser(UserModel user) => UserHiveModel(
        id: user.id,
        name: user.name,
        email: user.email,
        phone: user.phone,
        lastName: user.lastName,
        typeUser: user.typeUser.name,
        specialization: user.specialization,
        medicalLicense: user.medicalLicense,
        yearsOfExperience: user.yearsOfExperience,
        professionalCardUrl: user.professionalCardUrl,
        identityDocumentUrl: user.identityDocumentUrl,
        professionalBiography: user.professionalBiography,
        identificationType: user.identificationType,
        identificationNumber: user.identificationNumber,
        // ignore: unnecessary_type_check
        createdAt: user.createdAt is DateTime
            ? user.createdAt
            : DateTime.parse(user.createdAt.toString()),
        // ignore: unnecessary_type_check
        updateAt: user.updateAt is DateTime
            ? user.updateAt
            : DateTime.parse(user.updateAt.toString()),
      );

  /// Create an empty instance
  factory UserHiveModel.empty() => UserHiveModel(
        id: null,
        name: '',
        email: '',
        phone: '',
        lastName: '',
        typeUser: "",
        medicalLicense: '',
        specialization: '',
        yearsOfExperience: 0,
        professionalCardUrl: '',
        identityDocumentUrl: '',
        updateAt: DateTime.now(),
        professionalBiography: '',
        identificationType: '',
        identificationNumber: '',
        createdAt: DateTime.now(),
      );

  /// Copy with method
  UserHiveModel copyWith({
    String? id,
    String? name,
    String? email,
    String? phone,
    String? lastName,
    String? typeUser,
    DateTime? updateAt,
    DateTime? createdAt,
    String? specialization,
    String? medicalLicense,
    int? yearsOfExperience,
    String? professionalCardUrl,
    String? identityDocumentUrl,
    String? professionalBiography,
    String? identificationType,
    String? identificationNumber,
  }) => UserHiveModel(
        id: id ?? this.id,
        name: name ?? this.name,
        email: email ?? this.email,
        phone: phone ?? this.phone,
        lastName: lastName ?? this.lastName,
        typeUser: typeUser ?? this.typeUser,
        updateAt: updateAt ?? this.updateAt,
        createdAt: createdAt ?? this.createdAt,
        specialization: specialization ?? this.specialization,
        medicalLicense: medicalLicense ?? this.medicalLicense,
        yearsOfExperience: yearsOfExperience ?? this.yearsOfExperience,
        professionalCardUrl: professionalCardUrl ?? this.professionalCardUrl,
        identityDocumentUrl: identityDocumentUrl ?? this.identityDocumentUrl,
        professionalBiography: professionalBiography ?? this.professionalBiography,
        identificationType: identificationType ?? this.identificationType,
        identificationNumber: identificationNumber ?? this.identificationNumber,
      );
}


TypeUser _generateTypeUser(String? text) {
  if (text == TypeUser.DOCTOR.name) {
    return TypeUser.DOCTOR;
  }
  if (text == TypeUser.PATIENT.name) {
    return TypeUser.PATIENT;
  } else {
    return TypeUser.DOCTOR;
  }
}
