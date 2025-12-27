enum AppointmentStatus { NOT_BILLED, WAITING, COMPLETED }

class MedicalAppointmentBookingModel {
  final String? id;
  final String userId;
  final String companyId;
  final DateTime updateAt;
  final DateTime createdAt;
  final String userCompanyId;
  final AppointmentStatus status;
  final DateTime scheduleMedicalAppointment;

  MedicalAppointmentBookingModel({
    this.id,
    required this.userId,
    required this.status,
    required this.updateAt,
    required this.createdAt,
    required this.companyId,
    required this.userCompanyId,
    required this.scheduleMedicalAppointment,
  });

  MedicalAppointmentBookingModel copyWith({
    String? id,
    String? userId,
    String? companyId,
    DateTime? updateAt,
    DateTime? createdAt,
    String? userCompanyId,
    AppointmentStatus? status,
    DateTime? scheduleMedicalAppointment,
  }) => MedicalAppointmentBookingModel(
    id: id ?? this.id,
    status: status ?? this.status,
    userId: userId ?? this.userId,
    updateAt: updateAt ?? this.updateAt,
    createdAt: createdAt ?? this.createdAt,
    companyId: companyId ?? this.companyId,
    userCompanyId: userCompanyId ?? this.userCompanyId,
    scheduleMedicalAppointment:
        scheduleMedicalAppointment ?? this.scheduleMedicalAppointment,
  );

  factory MedicalAppointmentBookingModel.fromJson(Map<String, dynamic> json) =>
      MedicalAppointmentBookingModel(
        id: json["id"],
        userId: json["user_id"],
        companyId: json["company_id"],
        userCompanyId: json["user_company_id"],
        status: generateStatus(json["status"]),
        createdAt: json["created_at"] != null
            ? DateTime.parse(json["created_at"])
            : DateTime.now(),
        updateAt: json["update_at"] != null
            ? DateTime.parse(json["update_at"])
            : DateTime.now(),
        scheduleMedicalAppointment: json["schedule_medical_appointment"] != null
            ? DateTime.parse(json["schedule_medical_appointment"])
            : DateTime.now(),
      );

  factory MedicalAppointmentBookingModel.init() =>
      MedicalAppointmentBookingModel(
        userId: "",
        companyId: "",
        userCompanyId: "",
        updateAt: DateTime.now(),
        createdAt: DateTime.now(),
        status: AppointmentStatus.NOT_BILLED,
        scheduleMedicalAppointment: DateTime.now(),
      );

  Map<String, dynamic> toJson() => {
    "user_id": userId,
    "status": status.name,
    "company_id": companyId,
    "user_company_id": userCompanyId,
    "update_at": updateAt.toIso8601String(),
    "created_at": createdAt.toIso8601String(),
    "schedule_medical_appointment": scheduleMedicalAppointment
        .toIso8601String(),
  };
}

AppointmentStatus generateStatus(String item) {
  if (item == AppointmentStatus.NOT_BILLED.name) {
    return AppointmentStatus.NOT_BILLED;
  }
  if (item == AppointmentStatus.WAITING.name) {
    return AppointmentStatus.WAITING;
  }

  if (item == AppointmentStatus.COMPLETED.name) {
    return AppointmentStatus.COMPLETED;
  }
  return AppointmentStatus.NOT_BILLED;
}
