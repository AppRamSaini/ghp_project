// To parse this JSON data, do
//
//     final referPropertyElementModel = referPropertyElementModelFromJson(jsonString);

import 'dart:convert';

ReferPropertyElementModel referPropertyElementModelFromJson(String str) =>
    ReferPropertyElementModel.fromJson(json.decode(str));

String referPropertyElementModelToJson(ReferPropertyElementModel data) =>
    json.encode(data.toJson());

class ReferPropertyElementModel {
  bool status;
  dynamic message;
  Data data;

  ReferPropertyElementModel({
    required this.status,
    required this.message,
    required this.data,
  });

  factory ReferPropertyElementModel.fromJson(Map<String, dynamic> json) =>
      ReferPropertyElementModel(
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
  List<Bhk> minBudgetOptions;
  List<Bhk> maxBudgetOptions;
  List<Bhk> bhks;
  List<Bhk> unitTypes;
  List<Bhk> propertyStatus;
  List<Bhk> propertyFencing;

  Data({
    required this.minBudgetOptions,
    required this.maxBudgetOptions,
    required this.bhks,
    required this.unitTypes,
    required this.propertyStatus,
    required this.propertyFencing,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        minBudgetOptions: List<Bhk>.from(
            json["minBudgetOptions"].map((x) => Bhk.fromJson(x))),
        maxBudgetOptions: List<Bhk>.from(
            json["maxBudgetOptions"].map((x) => Bhk.fromJson(x))),
        bhks: List<Bhk>.from(json["bhks"].map((x) => Bhk.fromJson(x))),
        unitTypes:
            List<Bhk>.from(json["unitTypes"].map((x) => Bhk.fromJson(x))),
        propertyStatus:
            List<Bhk>.from(json["propertyStatus"].map((x) => Bhk.fromJson(x))),
        propertyFencing:
            List<Bhk>.from(json["propertyFencing"].map((x) => Bhk.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "minBudgetOptions":
            List<dynamic>.from(minBudgetOptions.map((x) => x.toJson())),
        "maxBudgetOptions":
            List<dynamic>.from(maxBudgetOptions.map((x) => x.toJson())),
        "bhks": List<dynamic>.from(bhks.map((x) => x.toJson())),
        "unitTypes": List<dynamic>.from(unitTypes.map((x) => x.toJson())),
        "propertyStatus":
            List<dynamic>.from(propertyStatus.map((x) => x.toJson())),
        "propertyFencing":
            List<dynamic>.from(propertyFencing.map((x) => x.toJson())),
      };
}

class Bhk {
  String name;

  Bhk({
    required this.name,
  });

  factory Bhk.fromJson(Map<String, dynamic> json) => Bhk(
        name: json["name"],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
      };
}
