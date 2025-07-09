// To parse this JSON data, do
//
//     final noticeDetailModel = noticeDetailModelFromJson(jsonString);

import 'dart:convert';

NoticeDetailModel noticeDetailModelFromJson(String str) =>
    NoticeDetailModel.fromJson(json.decode(str));

String noticeDetailModelToJson(NoticeDetailModel data) =>
    json.encode(data.toJson());

class NoticeDetailModel {
  bool status;
  dynamic message;
  Data data;

  NoticeDetailModel({
    required this.status,
    required this.message,
    required this.data,
  });

  factory NoticeDetailModel.fromJson(Map<String, dynamic> json) =>
      NoticeDetailModel(
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
  List<Notice> notice;

  Data({
    required this.notice,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        notice:
            List<Notice>.from(json["notice"].map((x) => Notice.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "notice": List<dynamic>.from(notice.map((x) => x.toJson())),
      };
}

class Notice {
  int id;
  String title;
  DateTime date;
  String time;
  String description;
  String status;
  int societyId;
  int createdBy;
  DateTime createdAt;
  DateTime updatedAt;
  dynamic deletedAt;

  Notice({
    required this.id,
    required this.title,
    required this.date,
    required this.time,
    required this.description,
    required this.status,
    required this.societyId,
    required this.createdBy,
    required this.createdAt,
    required this.updatedAt,
    required this.deletedAt,
  });

  factory Notice.fromJson(Map<String, dynamic> json) => Notice(
        id: json["id"],
        title: json["title"],
        date: DateTime.parse(json["date"]),
        time: json["time"],
        description: json["description"],
        status: json["status"],
        societyId: json["society_id"],
        createdBy: json["created_by"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
        deletedAt: json["deleted_at"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "date":
            "${date.year.toString().padLeft(4, '0')}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}",
        "time": time,
        "description": description,
        "status": status,
        "society_id": societyId,
        "created_by": createdBy,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
        "deleted_at": deletedAt,
      };
}
