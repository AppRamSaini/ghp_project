// To parse this JSON data, do
//
//     final soscietyContactsModel = soscietyContactsModelFromJson(jsonString);

import 'dart:convert';

SoscietyContactsModel soscietyContactsModelFromJson(String str) =>
    SoscietyContactsModel.fromJson(json.decode(str));

String soscietyContactsModelToJson(SoscietyContactsModel data) =>
    json.encode(data.toJson());

class SoscietyContactsModel {
  bool status;
  String message;
  Data data;

  SoscietyContactsModel({
    required this.status,
    required this.message,
    required this.data,
  });

  factory SoscietyContactsModel.fromJson(Map<String, dynamic> json) =>
      SoscietyContactsModel(
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
  List<Contact> contacts;

  Data({
    required this.contacts,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        contacts: List<Contact>.from(
            json["contacts"].map((x) => Contact.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "contacts": List<dynamic>.from(contacts.map((x) => x.toJson())),
      };
}

class Contact {
  int id;
  String name;
  String designation;
  String phone;
  int societyId;
  DateTime createdAt;
  DateTime updatedAt;
  dynamic deletedAt;

  Contact({
    required this.id,
    required this.name,
    required this.designation,
    required this.phone,
    required this.societyId,
    required this.createdAt,
    required this.updatedAt,
    required this.deletedAt,
  });

  factory Contact.fromJson(Map<String, dynamic> json) => Contact(
        id: json["id"],
        name: json["name"],
        designation: json["designation"],
        phone: json["phone"],
        societyId: json["society_id"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
        deletedAt: json["deleted_at"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "designation": designation,
        "phone": phone,
        "society_id": societyId,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
        "deleted_at": deletedAt,
      };
}
