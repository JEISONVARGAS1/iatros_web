enum TypeUser { DOCTOR, PATIENT }

class UserModel {
  final String? id;
  final String name;
  final String phone;
  final String email;
  final String lastName;
  final DateTime updateAt;
  final DateTime createdAt;
  final TypeUser typeUser;
  final String specialization;
  final String medicalLicense;
  final int yearsOfExperience;
  final String professionalCardUrl;
  final String identityDocumentUrl;
  final String professionalBiography;
  final String identificationType;
  final String identificationNumber;

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
  }) => UserModel(
    id: id ?? this.id,
    name: name ?? this.name,
    phone: phone ?? this.phone,
    email: email ?? this.email,
    updateAt: updateAt ?? this.updateAt,
    typeUser: typeUser ?? this.typeUser,
    lastName: lastName ?? this.lastName,
    createdAt: createdAt ?? this.createdAt,
    medicalLicense: medicalLicense ?? this.medicalLicense,
    specialization: specialization ?? this.specialization,
    yearsOfExperience: yearsOfExperience ?? this.yearsOfExperience,
    professionalCardUrl: professionalCardUrl ?? this.professionalCardUrl,
    identityDocumentUrl: identityDocumentUrl ?? this.identityDocumentUrl,
    professionalBiography: professionalBiography ?? this.professionalBiography,
    identificationType: identificationType ?? this.identificationType,
    identificationNumber: identificationNumber ?? this.identificationNumber,
  );

  factory UserModel.fromJson(json) => UserModel(
    id: json["id"],
    name: json["name"] ?? "",
    phone: json["phone"] ?? "",
    email: json["email"] ?? "",
    createdAt: json["created_at"] != null
        ? DateTime.parse(json["created_at"])
        : DateTime.now(),

    lastName: json["last_name"] ?? "",

    updateAt: json["update_at"] != null
        ? DateTime.parse(json["update_at"])
        : DateTime.now(),

    specialization: json["specialization"] ?? "",
    medicalLicense: json["medical_license"] ?? "",
    yearsOfExperience: json["years_experience"] ?? 0,
    typeUser: _generateTypeUser(json["type_user"]),
    professionalCardUrl: json["professional_card_url"] ?? "",
    identityDocumentUrl: json["identity_document_url"] ?? "",
    professionalBiography: json["professional_biography"] ?? "",
    identificationType: json["identification_type"] ?? "",
    identificationNumber: json["identification_number"] ?? "",
  );

  factory UserModel.init() => UserModel(
    name: "",
    email: "",
    phone: "",
    lastName: "",
    specialization: "",
    medicalLicense: "",
    yearsOfExperience: 0,
    professionalCardUrl: "",
    identityDocumentUrl: "",
    typeUser: TypeUser.DOCTOR,
    updateAt: DateTime.now(),
    createdAt: DateTime.now(),
    professionalBiography: "",
    identificationType: "",
    identificationNumber: "",
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
    };

    if (id != null) data["id"] = id!;

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
