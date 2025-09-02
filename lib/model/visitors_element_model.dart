import 'dart:convert';

VisitorElementModel visitorElementModelFromJson(String str) =>
    VisitorElementModel.fromJson(json.decode(str));

String visitorElementModelToJson(VisitorElementModel data) =>
    json.encode(data.toJson());

class VisitorElementModel {
  bool? status;
  String? message;
  Data? data;

  VisitorElementModel({
    this.status,
    this.message,
    this.data,
  });

  factory VisitorElementModel.fromJson(Map<String, dynamic> json) =>
      VisitorElementModel(
        status: json["status"],
        message: json["message"],
        data: json["data"] == null ? null : Data.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "data": data?.toJson(),
      };
}

class Data {
  List<Visitor>? visitorTypes;
  List<VisitingFrequency>? visitingFrequencies;
  List<Visitor>? visitorValidity;
  List<VisitorReason>? visitorReasons;

  Data({
    this.visitorTypes,
    this.visitingFrequencies,
    this.visitorValidity,
    this.visitorReasons,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        visitorTypes: json["visitor_types"] == null
            ? []
            : List<Visitor>.from(
                json["visitor_types"]!.map((x) => Visitor.fromJson(x))),
        visitingFrequencies: json["visiting_frequencies"] == null
            ? []
            : List<VisitingFrequency>.from(json["visiting_frequencies"]!
                .map((x) => VisitingFrequency.fromJson(x))),
        visitorValidity: json["visitor_validity"] == null
            ? []
            : List<Visitor>.from(
                json["visitor_validity"]!.map((x) => Visitor.fromJson(x))),
        visitorReasons: json["visitor_reasons"] == null
            ? []
            : List<VisitorReason>.from(
                json["visitor_reasons"]!.map((x) => VisitorReason.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "visitor_types": visitorTypes == null
            ? []
            : List<dynamic>.from(visitorTypes!.map((x) => x.toJson())),
        "visiting_frequencies": visitingFrequencies == null
            ? []
            : List<dynamic>.from(visitingFrequencies!.map((x) => x.toJson())),
        "visitor_validity": visitorValidity == null
            ? []
            : List<dynamic>.from(visitorValidity!.map((x) => x.toJson())),
        "visitor_reasons": visitorReasons == null
            ? []
            : List<dynamic>.from(visitorReasons!.map((x) => x.toJson())),
      };
}

class VisitingFrequency {
  String? frequency;

  VisitingFrequency({
    this.frequency,
  });

  factory VisitingFrequency.fromJson(Map<String, dynamic> json) =>
      VisitingFrequency(
        frequency: json["frequency"],
      );

  Map<String, dynamic> toJson() => {
        "frequency": frequency,
      };
}

class VisitorReason {
  String? reason;

  VisitorReason({
    this.reason,
  });

  factory VisitorReason.fromJson(Map<String, dynamic> json) => VisitorReason(
        reason: json["reason"],
      );

  Map<String, dynamic> toJson() => {
        "reason": reason,
      };
}

class Visitor {
  String? type;

  Visitor({
    this.type,
  });

  factory Visitor.fromJson(Map<String, dynamic> json) => Visitor(
        type: json["type"],
      );

  Map<String, dynamic> toJson() => {
        "type": type,
      };
}
