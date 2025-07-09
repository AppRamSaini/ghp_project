// To parse this JSON data, do
//
//     final serviceProvidersModel = serviceProvidersModelFromJson(jsonString);

import 'dart:convert';

ServiceProvidersModel serviceProvidersModelFromJson(String str) =>
    ServiceProvidersModel.fromJson(json.decode(str));

String serviceProvidersModelToJson(ServiceProvidersModel data) =>
    json.encode(data.toJson());

class ServiceProvidersModel {
  bool status;
  String message;
  Data data;

  ServiceProvidersModel({
    required this.status,
    required this.message,
    required this.data,
  });

  factory ServiceProvidersModel.fromJson(Map<String, dynamic> json) =>
      ServiceProvidersModel(
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
  ServiceProviders serviceProviders;

  Data({
    required this.serviceProviders,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        serviceProviders: ServiceProviders.fromJson(json["service_providers"]),
      );

  Map<String, dynamic> toJson() => {
        "service_providers": serviceProviders.toJson(),
      };
}

class ServiceProviders {
  int currentPage;
  List<Datum> data;
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

  ServiceProviders({
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

  factory ServiceProviders.fromJson(Map<String, dynamic> json) =>
      ServiceProviders(
        currentPage: json["current_page"],
        data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
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

class Datum {
  int id;
  int serviceCategoryId;
  String name;
  String phone;
  String email;
  String address;
  int userId;
  int societyId;
  DateTime createdAt;
  DateTime updatedAt;

  Datum({
    required this.id,
    required this.serviceCategoryId,
    required this.name,
    required this.phone,
    required this.email,
    required this.address,
    required this.userId,
    required this.societyId,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        id: json["id"],
        serviceCategoryId: json["service_category_id"],
        name: json["name"],
        phone: json["phone"],
        email: json["email"],
        address: json["address"],
        userId: json["user_id"],
        societyId: json["society_id"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "service_category_id": serviceCategoryId,
        "name": name,
        "phone": phone,
        "email": email,
        "address": address,
        "user_id": userId,
        "society_id": societyId,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
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
