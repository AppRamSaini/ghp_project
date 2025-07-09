import 'dart:convert';

ParcelElementModel parcelElementModelFromJson(String str) =>
    ParcelElementModel.fromJson(json.decode(str));

String parcelElementModelToJson(ParcelElementModel data) =>
    json.encode(data.toJson());

class ParcelElementModel {
  bool? status;
  String? message;
  Data? data;

  ParcelElementModel({
    this.status,
    this.message,
    this.data,
  });

  factory ParcelElementModel.fromJson(Map<String, dynamic> json) =>
      ParcelElementModel(
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
  List<ParcelType>? parcelTypes;

  Data({
    this.parcelTypes,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        parcelTypes: json["parcel_types"] == null
            ? []
            : List<ParcelType>.from(
                json["parcel_types"]!.map((x) => ParcelType.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "parcel_types": parcelTypes == null
            ? []
            : List<dynamic>.from(parcelTypes!.map((x) => x.toJson())),
      };
}

class ParcelType {
  String? name;

  ParcelType({
    this.name,
  });

  factory ParcelType.fromJson(Map<String, dynamic> json) => ParcelType(
        name: json["name"],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
      };
}
