import 'dart:convert';

TermsConditionsModel termsConditionsModelFromJson(String str) =>
    TermsConditionsModel.fromJson(json.decode(str));

String termsConditionsModelToJson(TermsConditionsModel data) =>
    json.encode(data.toJson());

class TermsConditionsModel {
  bool status;
  String message;
  TermsConditions data;

  TermsConditionsModel({
    required this.status,
    required this.message,
    required this.data,
  });

  factory TermsConditionsModel.fromJson(Map<String, dynamic> json) =>
      TermsConditionsModel(
        status: json["status"],
        message: json["message"],
        data: TermsConditions.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "data": data.toJson(),
      };
}

class TermsConditions {
  TermsOfUse? termsOfUse;

  TermsConditions({
    this.termsOfUse,
  });

  factory TermsConditions.fromJson(Map<String, dynamic> json) =>
      TermsConditions(
        termsOfUse: TermsOfUse.fromJson(json["terms_of_use"]),
      );

  Map<String, dynamic> toJson() => {
        "terms_of_use": termsOfUse!.toJson(),
      };
}

class TermsOfUse {
  int id;
  String name;
  String content;

  TermsOfUse({
    required this.id,
    required this.name,
    required this.content,
  });

  factory TermsOfUse.fromJson(Map<String, dynamic> json) => TermsOfUse(
        id: json["id"],
        name: json["name"],
        content: json["content"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "content": content,
      };
}
