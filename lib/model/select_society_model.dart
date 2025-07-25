// To parse this JSON data, do
//
//     final selectSocietyModel = selectSocietyModelFromJson(jsonString);

import 'dart:convert';

SelectSocietyModel selectSocietyModelFromJson(String str) => SelectSocietyModel.fromJson(json.decode(str));

String selectSocietyModelToJson(SelectSocietyModel data) => json.encode(data.toJson());

class SelectSocietyModel {
  bool? status;
  String? message;
  Data? data;

  SelectSocietyModel({
    this.status,
    this.message,
    this.data,
  });

  factory SelectSocietyModel.fromJson(Map<String, dynamic> json) => SelectSocietyModel(
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
  Societies? societies;

  Data({
    this.societies,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    societies: json["societies"] == null ? null : Societies.fromJson(json["societies"]),
  );

  Map<String, dynamic> toJson() => {
    "societies": societies?.toJson(),
  };
}

class Societies {
  int? currentPage;
  List<SocietyList>? data;
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
    currentPage: json["current_page"],
    data: json["data"] == null ? [] : List<SocietyList>.from(json["data"]!.map((x) => SocietyList.fromJson(x))),
    firstPageUrl: json["first_page_url"],
    from: json["from"],
    lastPage: json["last_page"],
    lastPageUrl: json["last_page_url"],
    links: json["links"] == null ? [] : List<Link>.from(json["links"]!.map((x) => Link.fromJson(x))),
    nextPageUrl: json["next_page_url"],
    path: json["path"],
    perPage: json["per_page"],
    prevPageUrl: json["prev_page_url"],
    to: json["to"],
    total: json["total"],
  );

  Map<String, dynamic> toJson() => {
    "current_page": currentPage,
    "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x.toJson())),
    "first_page_url": firstPageUrl,
    "from": from,
    "last_page": lastPage,
    "last_page_url": lastPageUrl,
    "links": links == null ? [] : List<dynamic>.from(links!.map((x) => x.toJson())),
    "next_page_url": nextPageUrl,
    "path": path,
    "per_page": perPage,
    "prev_page_url": prevPageUrl,
    "to": to,
    "total": total,
  };
}

class SocietyList {
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
  Type? type;
  String? totalArea;
  int? totalTowers;
  String? amenities;
  List<Block>? blocks;

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
    createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
    updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
    deletedAt: json["deleted_at"],
    city: json["city"],
    state: json["state"],
    pin: json["pin"],
    contact: json["contact"],
    email: json["email"],
    registrationNum: json["registration_num"],
    type: typeValues.map[json["type"]]!,
    totalArea: json["total_area"],
    totalTowers: json["total_towers"],
    amenities: json["amenities"],
    blocks: json["blocks"] == null ? [] : List<Block>.from(json["blocks"]!.map((x) => Block.fromJson(x))),
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
    "blocks": blocks == null ? [] : List<dynamic>.from(blocks!.map((x) => x.toJson())),
  };
}

class Block {
  int? id;
  String? propertyNumber;
  String? floor;
  dynamic ownership;
  String? bhk;
  String? totalFloor;
  Type? unitType;
  String? unitSize;
  int? unitQty;
  Name? name;
  int? totalUnits;
  int? societyId;
  DateTime? createdAt;
  DateTime? updatedAt;
  dynamic deletedAt;

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
    unitType: typeValues.map[json["unit_type"]]!,
    unitSize: json["unit_size"],
    unitQty: json["unit_qty"],
    name: nameValues.map[json["name"]]!,
    totalUnits: json["total_units"],
    societyId: json["society_id"],
    createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
    updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
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
    "name": nameValues.reverse[name],
    "total_units": totalUnits,
    "society_id": societyId,
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt?.toIso8601String(),
    "deleted_at": deletedAt,
  };
}

enum Name {
  A,
  A_4,
  B,
  C,
  D,
  E,
  F,
  G,
  H,
  I,
  J,
  K,
  L,
  TEST123,
  TESTING_DUNNAY
}

final nameValues = EnumValues({
  "A": Name.A,
  "A-4": Name.A_4,
  "B": Name.B,
  "C": Name.C,
  "D": Name.D,
  "E": Name.E,
  "F": Name.F,
  "G": Name.G,
  "H": Name.H,
  "I": Name.I,
  "J": Name.J,
  "K": Name.K,
  "L": Name.L,
  "Test123": Name.TEST123,
  "Testing Dunnay": Name.TESTING_DUNNAY
});

enum Type {
  COMMERCIAL,
  MIXED,
  RESIDENTIAL
}

final typeValues = EnumValues({
  "commercial": Type.COMMERCIAL,
  "mixed": Type.MIXED,
  "residential": Type.RESIDENTIAL
});

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

class EnumValues<T> {
  Map<String, T> map;
  late Map<T, String> reverseMap;

  EnumValues(this.map);

  Map<T, String> get reverse {
    reverseMap = map.map((k, v) => MapEntry(v, k));
    return reverseMap;
  }
}
