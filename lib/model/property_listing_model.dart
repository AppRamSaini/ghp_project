
import 'dart:convert';

PropertyListingModel propertyListingModelFromJson(String str) => PropertyListingModel.fromJson(json.decode(str));

String propertyListingModelToJson(PropertyListingModel data) => json.encode(data.toJson());

class PropertyListingModel {
  bool? status;
  String? message;
  List<PropertyList>? data;

  PropertyListingModel({
    this.status,
    this.message,
    this.data,
  });

  factory PropertyListingModel.fromJson(Map<String, dynamic> json) => PropertyListingModel(
    status: json["status"],
    message: json["message"],
    data: json["data"] == null ? [] : List<PropertyList>.from(json["data"]!.map((x) => PropertyList.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "message": message,
    "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x.toJson())),
  };
}

class PropertyList {
  int? id;
  String? name;
  String? aprtNo;
  String? floorNumber;
  String? unitType;
  String? phone;
  String? blockName;
  Society? society;

  PropertyList({
    this.id,
    this.name,
    this.aprtNo,
    this.floorNumber,
    this.unitType,
    this.phone,
    this.blockName,
    this.society,
  });

  factory PropertyList.fromJson(Map<String, dynamic> json) => PropertyList(
    id: json["id"],
    name: json["name"],
    aprtNo: json["aprt_no"],
    floorNumber: json["floor_number"],
    unitType: json["unit_type"],
    phone: json["phone"],
    blockName: json["block_name"],
    society: json["society"] == null ? null : Society.fromJson(json["society"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "aprt_no": aprtNo,
    "floor_number": floorNumber,
    "unit_type": unitType,
    "phone": phone,
    "block_name": blockName,
    "society": society?.toJson(),
  };
}

class Society {
  int? id;
  String? name;
  String? location;
  int? floors;
  String? status;
  int? floorUnits;
  dynamic memberId;
  DateTime? createdAt;
  DateTime? updatedAt;
  dynamic deletedAt;
  String? city;
  String? state;
  String? pin;
  String? contact;
  String? email;
  String? registrationNum;
  String? type;
  String? totalArea;
  int? totalTowers;
  String? amenities;

  Society({
    this.id,
    this.name,
    this.location,
    this.floors,
    this.status,
    this.floorUnits,
    this.memberId,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
    this.city,
    this.state,
    this.pin,
    this.contact,
    this.email,
    this.registrationNum,
    this.type,
    this.totalArea,
    this.totalTowers,
    this.amenities,
  });

  factory Society.fromJson(Map<String, dynamic> json) => Society(
    id: json["id"],
    name: json["name"],
    location: json["location"],
    floors: json["floors"],
    status: json["status"],
    floorUnits: json["floor_units"],
    memberId: json["member_id"],
    createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
    updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
    deletedAt: json["deleted_at"],
    city: json["city"],
    state: json["state"],
    pin: json["pin"],
    contact: json["contact"],
    email: json["email"],
    registrationNum: json["registration_num"],
    type: json["type"],
    totalArea: json["total_area"],
    totalTowers: json["total_towers"],
    amenities: json["amenities"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "location": location,
    "floors": floors,
    "status": status,
    "floor_units": floorUnits,
    "member_id": memberId,
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt?.toIso8601String(),
    "deleted_at": deletedAt,
    "city": city,
    "state": state,
    "pin": pin,
    "contact": contact,
    "email": email,
    "registration_num": registrationNum,
    "type": type,
    "total_area": totalArea,
    "total_towers": totalTowers,
    "amenities": amenities,
  };
}
