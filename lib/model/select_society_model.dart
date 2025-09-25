import 'dart:convert';

SelectSocietyModel selectSocietyModelFromJson(String str) =>
    SelectSocietyModel.fromJson(json.decode(str));

String selectSocietyModelToJson(SelectSocietyModel data) =>
    json.encode(data.toJson());

class SelectSocietyModel {
  final bool? status;
  final String? message;
  final Data? data;

  SelectSocietyModel({
    this.status,
    this.message,
    this.data,
  });

  factory SelectSocietyModel.fromJson(Map<String, dynamic> json) =>
      SelectSocietyModel(
        status: json["status"] as bool?,
        message: json["message"] as String?,
        data: json["data"] != null ? Data.fromJson(json["data"]) : null,
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "data": data?.toJson(),
      };
}

class Data {
  final Societies? societies;

  Data({this.societies});

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        societies: json["societies"] != null
            ? Societies.fromJson(json["societies"])
            : null,
      );

  Map<String, dynamic> toJson() => {
        "societies": societies?.toJson(),
      };
}

class Societies {
  final int? currentPage;
  final List<SocietyList>? data;
  final String? firstPageUrl;
  final int? from;
  final int? lastPage;
  final String? lastPageUrl;
  final List<Link>? links;
  final dynamic nextPageUrl;
  final String? path;
  final int? perPage;
  final dynamic prevPageUrl;
  final int? to;
  final int? total;

  Societies({
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

  factory Societies.fromJson(Map<String, dynamic> json) => Societies(
        currentPage: json["current_page"] as int?,
        data: (json["data"] as List<dynamic>?)
            ?.map((e) => SocietyList.fromJson(e))
            .toList(),
        firstPageUrl: json["first_page_url"] as String?,
        from: json["from"] as int?,
        lastPage: json["last_page"] as int?,
        lastPageUrl: json["last_page_url"] as String?,
        links: (json["links"] as List<dynamic>?)
            ?.map((e) => Link.fromJson(e))
            .toList(),
        nextPageUrl: json["next_page_url"],
        path: json["path"] as String?,
        perPage: json["per_page"] is String
            ? int.tryParse(json["per_page"])
            : json["per_page"] as int?,
        prevPageUrl: json["prev_page_url"],
        to: json["to"] as int?,
        total: json["total"] as int?,
      );

  Map<String, dynamic> toJson() => {
        "current_page": currentPage,
        "data": data?.map((e) => e.toJson()).toList(),
        "first_page_url": firstPageUrl,
        "from": from,
        "last_page": lastPage,
        "last_page_url": lastPageUrl,
        "links": links?.map((e) => e.toJson()).toList(),
        "next_page_url": nextPageUrl,
        "path": path,
        "per_page": perPage,
        "prev_page_url": prevPageUrl,
        "to": to,
        "total": total,
      };
}

class SocietyList {
  final int? id;
  final String? name;
  final String? location;
  final int? floors;
  final String? status;
  final int? floorUnits;
  final dynamic memberId;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final dynamic deletedAt;
  final String? city;
  final String? state;
  final String? pin;
  final String? contact;
  final String? email;
  final String? registrationNum;
  final Type? type;
  final String? totalArea;
  final int? totalTowers;
  final String? amenities;
  final List<Block>? blocks;

  SocietyList({
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
    this.blocks,
  });

  factory SocietyList.fromJson(Map<String, dynamic> json) => SocietyList(
        id: json["id"],
        name: json["name"],
        location: json["location"],
        floors: json["floors"],
        status: json["status"],
        floorUnits: json["floor_units"],
        memberId: json["member_id"],
        createdAt: json["created_at"] != null
            ? DateTime.parse(json["created_at"])
            : null,
        updatedAt: json["updated_at"] != null
            ? DateTime.parse(json["updated_at"])
            : null,
        deletedAt: json["deleted_at"],
        city: json["city"],
        state: json["state"],
        pin: json["pin"],
        contact: json["contact"],
        email: json["email"],
        registrationNum: json["registration_num"],
        type: typeValues.map[json["type"]],
        totalArea: json["total_area"],
        totalTowers: json["total_towers"],
        amenities: json["amenities"],
        blocks: json["blocks"] != null
            ? List<Block>.from(json["blocks"].map((x) => Block.fromJson(x)))
            : [],
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
        "type": typeValues.reverse[type],
        "total_area": totalArea,
        "total_towers": totalTowers,
        "amenities": amenities,
        "blocks": blocks?.map((x) => x.toJson()).toList() ?? [],
      };
}

class Block {
  final int? id;
  final String? propertyNumber;
  final String? floor;
  final dynamic ownership;
  final String? bhk;
  final String? totalFloor;
  final Type? unitType;
  final String? unitSize;
  final int? unitQty;
  final String? name;
  final int? totalUnits;
  final int? societyId;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final dynamic deletedAt;

  Block({
    this.id,
    this.propertyNumber,
    this.floor,
    this.ownership,
    this.bhk,
    this.totalFloor,
    this.unitType,
    this.unitSize,
    this.unitQty,
    this.name,
    this.totalUnits,
    this.societyId,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
  });

  factory Block.fromJson(Map<String, dynamic> json) => Block(
        id: json["id"],
        propertyNumber: json["property_number"],
        floor: json["floor"],
        ownership: json["ownership"],
        bhk: json["bhk"],
        totalFloor: json["total_floor"],
        unitType: typeValues.map[json["unit_type"]],
        unitSize: json["unit_size"],
        unitQty: json["unit_qty"],
        name: json["name"],
        totalUnits: json["total_units"],
        societyId: json["society_id"],
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null
            ? null
            : DateTime.parse(json["updated_at"]),
        deletedAt: json["deleted_at"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "property_number": propertyNumber,
        "floor": floor,
        "ownership": ownership,
        "bhk": bhk,
        "total_floor": totalFloor,
        "unit_type": typeValues.reverse[unitType],
        "unit_size": unitSize,
        "unit_qty": unitQty,
        "name": name,
        "total_units": totalUnits,
        "society_id": societyId,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
        "deleted_at": deletedAt,
      };
}

class Link {
  final String? url;
  final String? label;
  final bool? active;

  Link({this.url, this.label, this.active});

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

enum Type { FLAT, VILLA, STUDIO }

final typeValues = EnumValues({
  "flat": Type.FLAT,
  "villa": Type.VILLA,
  "studio": Type.STUDIO,
});

class EnumValues<T> {
  final Map<String, T> map;
  late final Map<T, String> reverseMap;

  EnumValues(this.map) {
    reverseMap = map.map((k, v) => MapEntry(v, k));
  }

  Map<T, String> get reverse => reverseMap;
}
