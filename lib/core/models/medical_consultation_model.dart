class MedicalConsultationModel {
    final String fr;
    final String fc;
    final String so2;
    final String tam;
    final String imc;
    final String reason;
    final String height;
    final String weight;
    final String doctorId;
    final String systolic;
    final String diastolic;
    final String background;
    final DateTime createdAt;
    final String temperature;
    final String paraclinical;
    final List<String> diagnoses;
    final String diseaseAndReviewBySystems;

    MedicalConsultationModel({
        required this.fr,
        required this.fc,
        required this.so2,
        required this.tam,
        required this.imc,
        required this.reason,
        required this.height,
        required this.weight,
        required this.doctorId,
        required this.systolic,
        required this.diastolic,
        required this.diagnoses,
        required this.createdAt,
        required this.background,
        required this.temperature,
        required this.paraclinical,
        required this.diseaseAndReviewBySystems,
    });

    MedicalConsultationModel copyWith({
        String? fr,
        String? fc,
        String? so2,
        String? tam,
        String? imc,
        String? reason,
        String? height,
        String? weight,
        String? doctorId,
        String? systolic,
        String? diastolic,
        dynamic createdAt,
        String? background,
        String? temperature,
        String? paraclinical,
        List<String>? diagnoses,
        String? diseaseAndReviewBySystems,
    }) => 
        MedicalConsultationModel(
            fr: fr ?? this.fr,
            fc: fc ?? this.fc,
            so2: so2 ?? this.so2,
            tam: tam ?? this.tam,
            imc: imc ?? this.imc,
            reason: reason ?? this.reason,
            height: height ?? this.height,
            weight: weight ?? this.weight,
            doctorId: doctorId ?? this.doctorId,
            systolic: systolic ?? this.systolic,
            diastolic: diastolic ?? this.diastolic,
            createdAt: createdAt ?? this.createdAt,
            diagnoses: diagnoses ?? this.diagnoses,
            background: background ?? this.background,
            temperature: temperature ?? this.temperature,
            paraclinical: paraclinical ?? this.paraclinical,
            diseaseAndReviewBySystems: diseaseAndReviewBySystems ?? this.diseaseAndReviewBySystems,
        );

    factory MedicalConsultationModel.fromJson(Map<String, dynamic> json) => MedicalConsultationModel(
        fr: json["fr"],
        fc: json["fc"],
        so2: json["so2"],
        tam: json["tam"],
        imc: json["imc"],
        reason: json["reason"],
        height: json["height"],
        weight: json["weight"],
        systolic: json["systolic"],
        doctorId: json["doctor_id"],
        diastolic: json["diastolic"],
        background: json["background"],
        temperature: json["temperature"],
        paraclinical: json["paraclinical"],
        diagnoses: List<String>.from(json["diagnoses"].map((x) => x)),
        diseaseAndReviewBySystems: json["diseaseAnd_review_by_systems"],
        createdAt: json['created_at'] != null ? DateTime.parse(json['created_at'] as String) : DateTime.now(),
    );

    Map<String, dynamic> toJson() => {
        "fr": fr,
        "fc": fc,
        "so2": so2,
        "tam": tam,
        "imc": imc,
        "reason": reason,
        "height": height,
        "weight": weight,
        "systolic": systolic,
        "doctor_id": doctorId,
        "diastolic": diastolic,
        "background": background,
        "temperature": temperature,
        "paraclinical": paraclinical,
        "created_at": createdAt.toUtc().toIso8601String(),
        "diagnoses": List<dynamic>.from(diagnoses.map((x) => x)),
        "diseaseAnd_review_by_systems": diseaseAndReviewBySystems,
    };
}
