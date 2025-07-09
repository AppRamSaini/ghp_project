// To parse this JSON data, do
//
//     final visitorElementModel = visitorElementModelFromJson(jsonString);

import 'dart:convert';

VisitorElementModel visitorElementModelFromJson(String str) =>
    VisitorElementModel.fromJson(json.decode(str));

String visitorElementModelToJson(VisitorElementModel data) =>
    json.encode(data.toJson());

class VisitorElementModel {
  bool status;
  dynamic message;
  Data data;

  VisitorElementModel({
    required this.status,
    required this.message,
    required this.data,
  });

  factory VisitorElementModel.fromJson(Map<String, dynamic> json) =>
      VisitorElementModel(
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
  List<Visitor> visitorTypes;
  List<VisitingFrequency> visitingFrequencies;
  List<Visitor> visitorValidity;

  Data({
    required this.visitorTypes,
    required this.visitingFrequencies,
    required this.visitorValidity,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        visitorTypes: List<Visitor>.from(
            json["visitor_types"].map((x) => Visitor.fromJson(x))),
        visitingFrequencies: List<VisitingFrequency>.from(
            json["visiting_frequencies"]
                .map((x) => VisitingFrequency.fromJson(x))),
        visitorValidity: List<Visitor>.from(
            json["visitor_validity"].map((x) => Visitor.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "visitor_types":
            List<dynamic>.from(visitorTypes.map((x) => x.toJson())),
        "visiting_frequencies":
            List<dynamic>.from(visitingFrequencies.map((x) => x.toJson())),
        "visitor_validity":
            List<dynamic>.from(visitorValidity.map((x) => x.toJson())),
      };
}

class VisitingFrequency {
  String frequency;

  VisitingFrequency({
    required this.frequency,
  });

  factory VisitingFrequency.fromJson(Map<String, dynamic> json) =>
      VisitingFrequency(
        frequency: json["frequency"],
      );

  Map<String, dynamic> toJson() => {
        "frequency": frequency,
      };
}

class Visitor {
  String type;

  Visitor({
    required this.type,
  });

  factory Visitor.fromJson(Map<String, dynamic> json) => Visitor(
        type: json["type"],
      );

  Map<String, dynamic> toJson() => {
        "type": type,
      };
}
