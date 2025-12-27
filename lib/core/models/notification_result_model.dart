enum StatusNotification { ERROR, SUCCESS, ALERT, WARNING }

class NotificationResultModel {
  final String message;
  final StatusNotification status;
  final DateTime createdAt;

  NotificationResultModel({required this.message, required this.status, required this.createdAt});

  NotificationResultModel copyWith({
    String? message,
    StatusNotification? status,
    DateTime? createdAt,
  }) => NotificationResultModel(
    message: message ?? this.message,
    status: status ?? this.status,
    createdAt: createdAt ?? this.createdAt,
  );

  factory NotificationResultModel.fromJson(Map<String, dynamic> json) =>
      NotificationResultModel(
        message: json["message"],
        status: json["status"],
        createdAt: DateTime.parse(json["createdAt"]),
      );

  Map<String, dynamic> toJson() => {
    "message": message,
    "status": status,
    "createdAt": createdAt.toIso8601String(),
  };
}
