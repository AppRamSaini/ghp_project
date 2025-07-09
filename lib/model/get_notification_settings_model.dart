
import 'dart:convert';
GetNotificationSettingsModel getNotificationSettingsModelFromJson(String str) => GetNotificationSettingsModel.fromJson(json.decode(str));
String getNotificationSettingsModelToJson(GetNotificationSettingsModel data) => json.encode(data.toJson());

class GetNotificationSettingsModel {
  bool status;
  String message;
  Data data;

  GetNotificationSettingsModel({
    required this.status,
    required this.message,
    required this.data,
  });

  factory GetNotificationSettingsModel.fromJson(Map<String, dynamic> json) => GetNotificationSettingsModel(
    status: json["status"],
    message: json["message"],
    data: Data.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "message": message,
    "data": data.toJson(),
  };
}

class Data {
  List<NotificationSetting> notificationSettings;

  Data({
    required this.notificationSettings,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    notificationSettings: List<NotificationSetting>.from(json["notification_settings"].map((x) => NotificationSetting.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "notification_settings": List<dynamic>.from(notificationSettings.map((x) => x.toJson())),
  };
}

class NotificationSetting {
  int id;
  String name;
  String status;
  int userId;

  NotificationSetting({
    required this.id,
    required this.name,
    required this.status,
    required this.userId,
  });

  factory NotificationSetting.fromJson(Map<String, dynamic> json) => NotificationSetting(
    id: json["id"],
    name: json["name"],
    status: json["status"],
    userId: json["user_id"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "status": status,
    "user_id": userId,
  };
}
