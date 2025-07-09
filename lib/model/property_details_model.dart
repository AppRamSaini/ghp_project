// To parse this JSON data, do
//
//     final propertyDetailsModel = propertyDetailsModelFromJson(jsonString);

import 'dart:convert';

PropertyDetailsModel propertyDetailsModelFromJson(String str) =>
    PropertyDetailsModel.fromJson(json.decode(str));

String propertyDetailsModelToJson(PropertyDetailsModel data) =>
    json.encode(data.toJson());

class PropertyDetailsModel {
  bool? status;
  String? message;
  Data? data;

  PropertyDetailsModel({
    this.status,
    this.message,
    this.data,
  });

  factory PropertyDetailsModel.fromJson(Map<String, dynamic> json) =>
      PropertyDetailsModel(
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
  List<Property>? property;

  Data({
    this.property,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        property: json["property"] == null
            ? []
            : List<Property>.from(
                json["property"]!.map((x) => Property.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "property": property == null
            ? []
            : List<dynamic>.from(property!.map((x) => x.toJson())),
      };
}

class Property {
  int? id;
  int? blockId;
  String? floor;
  String? type;
  String? unitType;
  String? unitNumber;
  String? bhk;
  String? area;
  String? rentPerMonth;
  String? securityDeposit;
  dynamic housePrice;
  dynamic upfront;
  DateTime? availableFromDate;
  List<Amenity>? amenities;
  String? name;
  String? phone;
  String? email;
  int? societyId;
  int? createdBy;
  DateTime? createdAt;
  DateTime? updatedAt;
  String? blockName;
  List<FileElement>? files;

  Property({
    this.id,
    this.blockId,
    this.floor,
    this.type,
    this.unitType,
    this.unitNumber,
    this.bhk,
    this.area,
    this.rentPerMonth,
    this.securityDeposit,
    this.housePrice,
    this.upfront,
    this.availableFromDate,
    this.amenities,
    this.name,
    this.phone,
    this.email,
    this.societyId,
    this.createdBy,
    this.createdAt,
    this.updatedAt,
    this.blockName,
    this.files,
  });

  factory Property.fromJson(Map<String, dynamic> json) => Property(
        id: json["id"],
        blockId: json["block_id"],
        floor: json["floor"],
        type: json["type"],
        unitType: json["unit_type"],
        unitNumber: json["unit_number"],
        bhk: json["bhk"],
        area: json["area"],
        rentPerMonth: json["rent_per_month"],
        securityDeposit: json["security_deposit"],
        housePrice: json["house_price"],
        upfront: json["upfront"],
        availableFromDate: json["available_from_date"] == null
            ? null
            : DateTime.parse(json["available_from_date"]),
        amenities: json["amenities"] == null
            ? []
            : List<Amenity>.from(
                json["amenities"]!.map((x) => Amenity.fromJson(x))),
        name: json["name"],
        phone: json["phone"],
        email: json["email"],
        societyId: json["society_id"],
        createdBy: json["created_by"],
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null
            ? null
            : DateTime.parse(json["updated_at"]),
        blockName: json["block_name"],
        files: json["files"] == null
            ? []
            : List<FileElement>.from(
                json["files"]!.map((x) => FileElement.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "block_id": blockId,
        "floor": floor,
        "type": type,
        "unit_type": unitType,
        "unit_number": unitNumber,
        "bhk": bhk,
        "area": area,
        "rent_per_month": rentPerMonth,
        "security_deposit": securityDeposit,
        "house_price": housePrice,
        "upfront": upfront,
        "available_from_date":
            "${availableFromDate!.year.toString().padLeft(4, '0')}-${availableFromDate!.month.toString().padLeft(2, '0')}-${availableFromDate!.day.toString().padLeft(2, '0')}",
        "amenities": amenities == null
            ? []
            : List<dynamic>.from(amenities!.map((x) => x.toJson())),
        "name": name,
        "phone": phone,
        "email": email,
        "society_id": societyId,
        "created_by": createdBy,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
        "block_name": blockName,
        "files": files == null
            ? []
            : List<dynamic>.from(files!.map((x) => x.toJson())),
      };
}

class Amenity {
  String? name;

  Amenity({
    this.name,
  });

  factory Amenity.fromJson(Map<String, dynamic> json) => Amenity(
        name: json["name"],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
      };
}

class FileElement {
  int? id;
  int? tradePropertyId;
  String? file;

  FileElement({
    this.id,
    this.tradePropertyId,
    this.file,
  });

  factory FileElement.fromJson(Map<String, dynamic> json) => FileElement(
        id: json["id"],
        tradePropertyId: json["trade_property_id"],
        file: json["file"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "trade_property_id": tradePropertyId,
        "file": file,
      };
}
