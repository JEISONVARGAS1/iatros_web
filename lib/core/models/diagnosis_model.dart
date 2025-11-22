class DiagnosisModel {
    final String id;
    final String name;
    final String code;

    DiagnosisModel({
        required this.id,
        required this.name,
        required this.code,
    });

    DiagnosisModel copyWith({
        String? id,
        String? name,
        String? code,
    }) => 
        DiagnosisModel(
            id: id ?? this.id,
            name: name ?? this.name,
            code: code ?? this.code,
        );

    factory DiagnosisModel.fromJson(Map<String, dynamic> json) => DiagnosisModel(
        id: json["Uid"] ?? "",
        name: json["Nombre"] ?? "",
        code: json["Codigo"] ?? "",
    );

    Map<String, dynamic> toJson() => {
        "Uid": id,
        "Nombre": name,
        "Codigo": code,
    };
}
