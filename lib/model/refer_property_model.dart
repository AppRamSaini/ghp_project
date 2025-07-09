// To parse this JSON data, do
//
//     final referPropertyModel = referPropertyModelFromJson(jsonString);

import 'dart:convert';

ReferPropertyModel referPropertyModelFromJson(String str) =>
    ReferPropertyModel.fromJson(json.decode(str));

String referPropertyModelToJson(ReferPropertyModel data) =>
    json.encode(data.toJson());

class ReferPropertyModel {
  bool status;
  dynamic message;
  Data data;

  ReferPropertyModel({
    required this.status,
    required this.message,
    required this.data,
  });

  factory ReferPropertyModel.fromJson(Map<String, dynamic> json) =>
      ReferPropertyModel(
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
  ReferProperties referProperties;

  Data({
    required this.referProperties,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        referProperties: ReferProperties.fromJson(json["refer_properties"]),
      );

  Map<String, dynamic> toJson() => {
        "refer_properties": referProperties.toJson(),
      };
}

class ReferProperties {
  int currentPage;
  List<ReferPropertyList> data;
  String firstPageUrl;
  int from;
  int lastPage;
  String lastPageUrl;
  List<Link> links;
  dynamic nextPageUrl;
  String path;
  int perPage;
  dynamic prevPageUrl;
  int to;
  int total;

  ReferProperties({
    required this.currentPage,
    required this.data,
    required this.firstPageUrl,
    required this.from,
    required this.lastPage,
    required this.lastPageUrl,
    required this.links,
    required this.nextPageUrl,
    required this.path,
    required this.perPage,
    required this.prevPageUrl,
    required this.to,
    required this.total,
  });

  factory ReferProperties.fromJson(Map<String, dynamic> json) =>
      ReferProperties(
        currentPage: json["current_page"],
        data: List<ReferPropertyList>.from(
            json["data"].map((x) => ReferPropertyList.fromJson(x))),
        firstPageUrl: json["first_page_url"],
        from: json["from"],
        lastPage: json["last_page"],
        lastPageUrl: json["last_page_url"],
        links: List<Link>.from(json["links"].map((x) => Link.fromJson(x))),
        nextPageUrl: json["next_page_url"],
        path: json["path"],
        perPage: json["per_page"],
        prevPageUrl: json["prev_page_url"],
        to: json["to"],
        total: json["total"],
      );

  Map<String, dynamic> toJson() => {
        "current_page": currentPage,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
        "first_page_url": firstPageUrl,
        "from": from,
        "last_page": lastPage,
        "last_page_url": lastPageUrl,
        "links": List<dynamic>.from(links.map((x) => x.toJson())),
        "next_page_url": nextPageUrl,
        "path": path,
        "per_page": perPage,
        "prev_page_url": prevPageUrl,
        "to": to,
        "total": total,
      };
}

class ReferPropertyList {
  int id;
  String name;
  String phone;
  String minBudget;
  String maxBudget;
  String location;
  String unitType;
  String bhk;
  String propertyStatus;
  String propertyFancing;
  String remark;
  int societyId;
  int userId;
  DateTime createdAt;
  DateTime updatedAt;
  dynamic deletedAt;

  ReferPropertyList({
    required this.id,
    required this.name,
    required this.phone,
    required this.minBudget,
    required this.maxBudget,
    required this.location,
    required this.unitType,
    required this.bhk,
    required this.propertyStatus,
    required this.propertyFancing,
    required this.remark,
    required this.societyId,
    required this.userId,
    required this.createdAt,
    required this.updatedAt,
    required this.deletedAt,
  });

  factory ReferPropertyList.fromJson(Map<String, dynamic> json) =>
      ReferPropertyList(
        id: json["id"],
        name: json["name"],
        phone: json["phone"],
        minBudget: json["min_budget"],
        maxBudget: json["max_budget"],
        location: json["location"],
        unitType: json["unit_type"],
        bhk: json["bhk"],
        propertyStatus: json["property_status"],
        propertyFancing: json["property_fancing"],
        remark: json["remark"],
        societyId: json["society_id"],
        userId: json["user_id"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
        deletedAt: json["deleted_at"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "phone": phone,
        "min_budget": minBudget,
        "max_budget": maxBudget,
        "location": location,
        "unit_type": unitType,
        "bhk": bhk,
        "property_status": propertyStatus,
        "property_fancing": propertyFancing,
        "remark": remark,
        "society_id": societyId,
        "user_id": userId,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
        "deleted_at": deletedAt,
      };
}

class Link {
  String? url;
  String label;
  bool active;

  Link({
    required this.url,
    required this.label,
    required this.active,
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
