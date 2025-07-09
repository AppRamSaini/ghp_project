// To parse this JSON data, do
//
//     final documentElementModel = documentElementModelFromJson(jsonString);

import 'dart:convert';

DocumentElementModel documentElementModelFromJson(String str) =>
    DocumentElementModel.fromJson(json.decode(str));

String documentElementModelToJson(DocumentElementModel data) =>
    json.encode(data.toJson());

class DocumentElementModel {
  bool status;
  dynamic message;
  Data data;

  DocumentElementModel({
    required this.status,
    required this.message,
    required this.data,
  });

  factory DocumentElementModel.fromJson(Map<String, dynamic> json) =>
      DocumentElementModel(
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
  List<DocumentsType> documentsTypes;

  Data({
    required this.documentsTypes,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        documentsTypes: List<DocumentsType>.from(
            json["documents_types"].map((x) => DocumentsType.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "documents_types":
            List<dynamic>.from(documentsTypes.map((x) => x.toJson())),
      };
}

class DocumentsType {
  int id;
  String type;

  DocumentsType({
    required this.type,
    required this.id,
  });

  factory DocumentsType.fromJson(Map<String, dynamic> json) =>
      DocumentsType(type: json["type"], id: json['id']);

  Map<String, dynamic> toJson() => {"type": type, 'id': id};
}
