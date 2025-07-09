// To parse this JSON data, do
//
//     final buyOrRentPropertyModel = buyOrRentPropertyModelFromJson(jsonString);

import 'dart:convert';

BuyOrRentPropertyModel buyOrRentPropertyModelFromJson(String str) =>
    BuyOrRentPropertyModel.fromJson(json.decode(str));

String buyOrRentPropertyModelToJson(BuyOrRentPropertyModel data) =>
    json.encode(data.toJson());

class BuyOrRentPropertyModel {
  bool? status;
  String? message;
  Data? data;

  BuyOrRentPropertyModel({
    this.status,
    this.message,
    this.data,
  });

  factory BuyOrRentPropertyModel.fromJson(Map<String, dynamic> json) =>
      BuyOrRentPropertyModel(
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
  Properties? properties;

  Data({
    this.properties,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        properties: json["properties"] == null
            ? null
            : Properties.fromJson(json["properties"]),
      );

  Map<String, dynamic> toJson() => {
        "properties": properties?.toJson(),
      };
}

class Properties {
  int? currentPage;
  List<PropertyList>? data;
  String? firstPageUrl;
  int? from;
  int? lastPage;
  String? lastPageUrl;
  List<Link>? links;
  dynamic nextPageUrl;
  String? path;
  int? perPage;
  dynamic prevPageUrl;
  int? to;
  int? total;

  Properties({
    this.currentPage,
    this.data,
    this.firstPageUrl,
    this.from,
    this.lastPage,
    this.lastPageUrl,
    this.links,
    this.nextPageUrl,
    this.path,
    this.perPage,
    this.prevPageUrl,
    this.to,
    this.total,
  });

  factory Properties.fromJson(Map<String, dynamic> json) => Properties(
        currentPage: json["current_page"],
        data: json["data"] == null
            ? []
            : List<PropertyList>.from(
                json["data"]!.map((x) => PropertyList.fromJson(x))),
        firstPageUrl: json["first_page_url"],
        from: json["from"],
        lastPage: json["last_page"],
        lastPageUrl: json["last_page_url"],
        links: json["links"] == null
            ? []
            : List<Link>.from(json["links"]!.map((x) => Link.fromJson(x))),
        nextPageUrl: json["next_page_url"],
        path: json["path"],
        perPage: json["per_page"],
        prevPageUrl: json["prev_page_url"],
        to: json["to"],
        total: json["total"],
      );

  Map<String, dynamic> toJson() => {
        "current_page": currentPage,
        "data": data == null
            ? []
            : List<dynamic>.from(data!.map((x) => x.toJson())),
        "first_page_url": firstPageUrl,
        "from": from,
        "last_page": lastPage,
        "last_page_url": lastPageUrl,
        "links": links == null
            ? []
            : List<dynamic>.from(links!.map((x) => x.toJson())),
        "next_page_url": nextPageUrl,
        "path": path,
        "per_page": perPage,
        "prev_page_url": prevPageUrl,
        "to": to,
        "total": total,
      };
}

class PropertyList {
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

  PropertyList({
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

  factory PropertyList.fromJson(Map<String, dynamic> json) => PropertyList(
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

class Link {
  String? url;
  String? label;
  bool? active;

  Link({
    this.url,
    this.label,
    this.active,
  });

  factory Link.fromJson(Map<String, dynamic> json) => Link(
        url: json["url"],
        label: json["label"],
        active: json["active"],
      );

  Map<String, dynamic> toJson() => {
        "url": url,
        "label": label,
        "active": active,
      };
}
