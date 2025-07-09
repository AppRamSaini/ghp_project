import 'dart:convert';

SearchMemberModel searchMemberModelFromJson(String str) =>
    SearchMemberModel.fromJson(json.decode(str));

String searchMemberModelToJson(SearchMemberModel data) =>
    json.encode(data.toJson());

class SearchMemberModel {
  bool? status;
  String? message;
  Data? data;

  SearchMemberModel({
    this.status,
    this.message,
    this.data,
  });

  factory SearchMemberModel.fromJson(Map<String, dynamic> json) =>
      SearchMemberModel(
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
  Members? members;

  Data({
    this.members,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        members:
            json["members"] == null ? null : Members.fromJson(json["members"]),
      );

  Map<String, dynamic> toJson() => {
        "members": members?.toJson(),
      };
}

class Members {
  int? currentPage;
  List<SearchMemberInfo>? data;
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

  Members({
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

  factory Members.fromJson(Map<String, dynamic> json) => Members(
        currentPage: json["current_page"],
        data: json["data"] == null
            ? []
            : List<SearchMemberInfo>.from(
                json["data"]!.map((x) => SearchMemberInfo.fromJson(x))),
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

class SearchMemberInfo {
  int? id;
  String? name;
  String? role;
  String? phone;
  String? email;
  String? status;
  int? userId;
  int? societyId;
  int? blockId;
  String? floorNumber;
  String? unitType;
  String? aprtNo;
  String? ownershipType;
  dynamic ownerName;
  String? emerName;
  String? emerRelation;
  String? emerPhone;
  DateTime? createdAt;
  DateTime? updatedAt;
  dynamic deletedAt;
  String? image;
  Block? block;

  SearchMemberInfo({
    this.id,
    this.name,
    this.role,
    this.phone,
    this.email,
    this.status,
    this.userId,
    this.societyId,
    this.blockId,
    this.floorNumber,
    this.unitType,
    this.aprtNo,
    this.ownershipType,
    this.ownerName,
    this.emerName,
    this.emerRelation,
    this.emerPhone,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
    this.image,
    this.block,
  });

  factory SearchMemberInfo.fromJson(Map<String, dynamic> json) =>
      SearchMemberInfo(
        id: json["id"],
        name: json["name"],
        role: json["role"],
        phone: json["phone"],
        email: json["email"],
        status: json["status"],
        userId: json["user_id"],
        societyId: json["society_id"],
        blockId: json["block_id"],
        floorNumber: json["floor_number"],
        unitType: json["unit_type"],
        aprtNo: json["aprt_no"],
        ownershipType: json["ownership_type"],
        ownerName: json["owner_name"],
        emerName: json["emer_name"],
        emerRelation: json["emer_relation"],
        emerPhone: json["emer_phone"],
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null
            ? null
            : DateTime.parse(json["updated_at"]),
        deletedAt: json["deleted_at"],
        image: json["image"],
        block: json["block"] == null ? null : Block.fromJson(json["block"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "role": role,
        "phone": phone,
        "email": email,
        "status": status,
        "user_id": userId,
        "society_id": societyId,
        "block_id": blockId,
        "floor_number": floorNumber,
        "unit_type": unitType,
        "aprt_no": aprtNo,
        "ownership_type": ownershipType,
        "owner_name": ownerName,
        "emer_name": emerName,
        "emer_relation": emerRelation,
        "emer_phone": emerPhone,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
        "deleted_at": deletedAt,
        "image": image,
        "block": block?.toJson(),
      };
}

class Block {
  int? id;
  String? propertyNumber;
  String? floor;
  String? ownership;
  String? bhk;
  String? totalFloor;
  String? unitType;
  String? unitSize;
  int? unitQty;
  String? name;
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
        unitType: json["unit_type"],
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
        "unit_type": unitType,
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
