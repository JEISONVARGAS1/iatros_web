class MedicalConsultationModel {
    final String? id;
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
    final String analysisAndPlan;
    final String diseaseAndReviewBySystems;

    MedicalConsultationModel({
        this.id,
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
        required this.createdAt,
        required this.background,
        required this.temperature,
        required this.paraclinical,
        required this.analysisAndPlan,
        required this.diseaseAndReviewBySystems,
    });

    MedicalConsultationModel copyWith({
        String? id,
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
        String? analysisAndPlan,
        String? diseaseAndReviewBySystems,
    }) => 
        MedicalConsultationModel(
            id: id ?? this.id,
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
            background: background ?? this.background,
            temperature: temperature ?? this.temperature,
            paraclinical: paraclinical ?? this.paraclinical,
            analysisAndPlan: analysisAndPlan ?? this.analysisAndPlan,
            diseaseAndReviewBySystems: diseaseAndReviewBySystems ?? this.diseaseAndReviewBySystems,
        );

    factory MedicalConsultationModel.fromJson(Map<String, dynamic> json) => MedicalConsultationModel(
        id: json["id"],
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
        analysisAndPlan: json["analysis_and_plan"],
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
        "analysis_and_plan": analysisAndPlan,
        "created_at": createdAt.toUtc().toIso8601String(),
        "diseaseAnd_review_by_systems": diseaseAndReviewBySystems,
    };
}
