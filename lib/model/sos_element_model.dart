// To parse this JSON data, do
//
//     final sosElementModel = sosElementModelFromJson(jsonString);

import 'dart:convert';

SosElementModel sosElementModelFromJson(String str) =>
    SosElementModel.fromJson(json.decode(str));

String sosElementModelToJson(SosElementModel data) =>
    json.encode(data.toJson());

class SosElementModel {
  bool status;
  String message;
  Data data;

  SosElementModel({
    required this.status,
    required this.message,
    required this.data,
  });

  factory SosElementModel.fromJson(Map<String, dynamic> json) =>
      SosElementModel(
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
  List<Area> areas;

  Data({
    required this.areas,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        areas: List<Area>.from(json["areas"].map((x) => Area.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "areas": List<dynamic>.from(areas.map((x) => x.toJson())),
      };
}

class Area {
  String name;

  Area({
    required this.name,
  });

  factory Area.fromJson(Map<String, dynamic> json) => Area(
        name: json["name"],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
      };
}
