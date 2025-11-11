import 'gender.dart';
import 'blood_type.dart';

enum TypeUser { DOCTOR, PATIENT }

class UserModel {
  final String? id;
  final String name;
  final String phone;
  final String email;
  final Gender? gender;
  final String address;
  final String lastName;
  final double? latitude;
  final double? longitude;
  final TypeUser typeUser;
  final DateTime updateAt;
  final DateTime createdAt;
  final BloodType? bloodType;
  final String specialization;
  final String medicalLicense;
  final int yearsOfExperience;
  final DateTime? dateOfBirth;
  final String identificationType;
  final String professionalCardUrl;
  final String identityDocumentUrl;
  final String identificationNumber;
  final String professionalBiography;

  UserModel({
    this.id,
    required this.name,
    required this.phone,
    required this.email,
    required this.typeUser,
    required this.lastName,
    required this.updateAt,
    required this.createdAt,
    required this.medicalLicense,
    required this.specialization,
    required this.yearsOfExperience,
    required this.identificationType,
    required this.professionalCardUrl,
    required this.identityDocumentUrl,
    required this.professionalBiography,
    required this.identificationNumber,
    this.address = "",
    this.latitude,
    this.longitude,
    this.dateOfBirth,
    this.gender,
    this.bloodType,
  });

  UserModel copyWith({
    String? id,
    String? name,
    String? email,
    String? phone,
    String? lastName,
    DateTime? updateAt,
    TypeUser? typeUser,
    DateTime? createdAt,
    String? specialization,
    String? medicalLicense,
    int? yearsOfExperience,
    String? professionalCardUrl,
    String? identityDocumentUrl,
    String? professionalBiography,
    String? identificationType,
    String? identificationNumber,
    String? address,
    double? latitude,
    double? longitude,
    DateTime? dateOfBirth,
    Gender? gender,
    BloodType? bloodType,
  }) => UserModel(
    id: id ?? this.id,
    name: name ?? this.name,
    phone: phone ?? this.phone,
    email: email ?? this.email,
    gender: gender ?? this.gender,
    address: address ?? this.address,
    latitude: latitude ?? this.latitude,
    longitude: longitude ?? this.longitude,
    updateAt: updateAt ?? this.updateAt,
    typeUser: typeUser ?? this.typeUser,
    lastName: lastName ?? this.lastName,
    bloodType: bloodType ?? this.bloodType,
    createdAt: createdAt ?? this.createdAt,
    dateOfBirth: dateOfBirth ?? this.dateOfBirth,
    medicalLicense: medicalLicense ?? this.medicalLicense,
    specialization: specialization ?? this.specialization,
    yearsOfExperience: yearsOfExperience ?? this.yearsOfExperience,
    identificationType: identificationType ?? this.identificationType,
    professionalCardUrl: professionalCardUrl ?? this.professionalCardUrl,
    identityDocumentUrl: identityDocumentUrl ?? this.identityDocumentUrl,
    identificationNumber: identificationNumber ?? this.identificationNumber,
    professionalBiography: professionalBiography ?? this.professionalBiography,
  );

  factory UserModel.fromJson(json) => UserModel(
    id: json["id"],
    name: json["name"] ?? "",
    phone: json["phone"] ?? "",
    email: json["email"] ?? "",
    address: json["address"] ?? "",
    latitude: json["latitude"]?.toDouble(),
    longitude: json["longitude"]?.toDouble(),
    lastName: json["last_name"] ?? "",
    specialization: json["specialization"] ?? "",
    medicalLicense: json["medical_license"] ?? "",
    typeUser: _generateTypeUser(json["type_user"]),
    yearsOfExperience: json["years_experience"] ?? 0,
    identificationType: json["identification_type"] ?? "",
    professionalCardUrl: json["professional_card_url"] ?? "",
    identityDocumentUrl: json["identity_document_url"] ?? "",
    professionalBiography: json["professional_biography"] ?? "",
    identificationNumber: json["identification_number"] ?? "",
    gender: json["gender"] != null ? _generateGender(json["gender"]) : null,
    bloodType: json["blood_type"] != null ? bloodTypeFromString(json["blood_type"]) : null,
    updateAt: json["update_at"] != null ? DateTime.parse(json["update_at"]): DateTime.now(),
    dateOfBirth: json["date_of_birth"] != null ? DateTime.parse(json["date_of_birth"]) : null,
    createdAt: json["created_at"] != null ? DateTime.parse(json["created_at"]) : DateTime.now(),
  );

  factory UserModel.init() => UserModel(
    name: "",
    email: "",
    phone: "",
    address: "",
    latitude: null,
    longitude: null,
    lastName: "",
    gender: null,
    bloodType: null,
    dateOfBirth: null,
    specialization: "",
    medicalLicense: "",
    yearsOfExperience: 0,
    identificationType: "",
    professionalCardUrl: "",
    identityDocumentUrl: "",
    updateAt: DateTime.now(),
    identificationNumber: "",
    typeUser: TypeUser.DOCTOR,
    createdAt: DateTime.now(),
    professionalBiography: "",
  );

  Map<String, dynamic> toJson() {
    final data = {
      "name": name,
      "email": email,
      "phone": phone,
      "last_name": lastName,
      "type_user": typeUser.name,
      "specialization": specialization,
      "medical_license": medicalLicense,
      "years_experience": yearsOfExperience,
      "update_at": updateAt.toIso8601String(),
      "created_at": createdAt.toIso8601String(),
      "professional_card_url": professionalCardUrl,
      "identity_document_url": identityDocumentUrl,
      "professional_biography": professionalBiography,
      "identification_type": identificationType,
      "identification_number": identificationNumber,
      "address": address,
    };

    if (id != null) data["id"] = id!;
    if (dateOfBirth != null) {
      data["date_of_birth"] = dateOfBirth!.toIso8601String();
    }
    if (gender != null) {
      data["gender"] = gender!.name;
    }
    if (bloodType != null) {
      data["blood_type"] = bloodType!.value;
    }
    if (latitude != null) {
      data["latitude"] = latitude as Object;
    }
    if (longitude != null) {
      data["longitude"] = longitude as Object;
    }

    return data;
  }
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

Gender _generateGender(String? text) {
  switch (text?.toLowerCase()) {
    case 'male':
      return Gender.male;
    case 'female':
      return Gender.female;
    case 'other':
      return Gender.other;
    default:
      return Gender.other;
  }
}
