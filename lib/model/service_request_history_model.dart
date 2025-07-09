// To parse this JSON data, do
//
//     final serviceRequestHistoryModel = serviceRequestHistoryModelFromJson(jsonString);

import 'dart:convert';

ServiceRequestHistoryModel serviceRequestHistoryModelFromJson(String str) =>
    ServiceRequestHistoryModel.fromJson(json.decode(str));

String serviceRequestHistoryModelToJson(ServiceRequestHistoryModel data) =>
    json.encode(data.toJson());

class ServiceRequestHistoryModel {
  bool? status;
  String? message;
  Data? data;

  ServiceRequestHistoryModel({
    this.status,
    this.message,
    this.data,
  });

  factory ServiceRequestHistoryModel.fromJson(Map<String, dynamic> json) =>
      ServiceRequestHistoryModel(
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
  ServiceRequests? serviceRequests;

  Data({
    this.serviceRequests,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        serviceRequests: json["service_requests"] == null
            ? null
            : ServiceRequests.fromJson(json["service_requests"]),
      );

  Map<String, dynamic> toJson() => {
        "service_requests": serviceRequests?.toJson(),
      };
}

class ServiceRequests {
  int? currentPage;
  List<ServiceHistoryModel>? data;
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

  ServiceRequests({
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

  factory ServiceRequests.fromJson(Map<String, dynamic> json) =>
      ServiceRequests(
        currentPage: json["current_page"],
        data: json["data"] == null
            ? []
            : List<ServiceHistoryModel>.from(
                json["data"]!.map((x) => ServiceHistoryModel.fromJson(x))),
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

class ServiceHistoryModel {
  int? id;
  int? complaintCategoryId;
  int? complaintBy;
  int? societyId;
  int? blockId;
  String? blockName;
  String? unitType;
  String? floorNumber;
  String? aprtNo;
  String? area;
  String? description;
  String? otp;
  String? status;
  int? assignedTo;
  dynamic assignedBy;
  DateTime? complaintAt;
  DateTime? assignedAt;
  DateTime? startAt;
  DateTime? resolvedOrCancelledAt;
  DateTime? createdAt;
  DateTime? updatedAt;
  ServiceCategory? serviceCategory;
  Member? member;

  ServiceHistoryModel({
    this.id,
    this.complaintCategoryId,
    this.complaintBy,
    this.societyId,
    this.blockId,
    this.blockName,
    this.unitType,
    this.floorNumber,
    this.aprtNo,
    this.area,
    this.description,
    this.otp,
    this.status,
    this.assignedTo,
    this.assignedBy,
    this.complaintAt,
    this.assignedAt,
    this.startAt,
    this.resolvedOrCancelledAt,
    this.createdAt,
    this.updatedAt,
    this.serviceCategory,
    this.member,
  });

  factory ServiceHistoryModel.fromJson(Map<String, dynamic> json) =>
      ServiceHistoryModel(
        id: json["id"],
        complaintCategoryId: json["complaint_category_id"],
        complaintBy: json["complaint_by"],
        societyId: json["society_id"],
        blockId: json["block_id"],
        blockName: json["block_name"],
        unitType: json["unit_type"],
        floorNumber: json["floor_number"],
        aprtNo: json["aprt_no"],
        area: json["area"],
        description: json["description"],
        otp: json["otp"],
        status: json["status"],
        assignedTo: json["assigned_to"],
        assignedBy: json["assigned_by"],
        complaintAt: json["complaint_at"] == null
            ? null
            : DateTime.parse(json["complaint_at"]),
        assignedAt: json["assigned_at"] == null
            ? null
            : DateTime.parse(json["assigned_at"]),
        startAt:
            json["start_at"] == null ? null : DateTime.parse(json["start_at"]),
        resolvedOrCancelledAt: json["resolved_or_cancelled_at"] == null
            ? null
            : DateTime.parse(json["resolved_or_cancelled_at"]),
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null
            ? null
            : DateTime.parse(json["updated_at"]),
        serviceCategory: json["service_category"] == null
            ? null
            : ServiceCategory.fromJson(json["service_category"]),
        member: json["member"] == null ? null : Member.fromJson(json["member"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "complaint_category_id": complaintCategoryId,
        "complaint_by": complaintBy,
        "society_id": societyId,
        "block_id": blockId,
        "block_name": blockName,
        "unit_type": unitType,
        "floor_number": floorNumber,
        "aprt_no": aprtNo,
        "area": area,
        "description": description,
        "otp": otp,
        "status": status,
        "assigned_to": assignedTo,
        "assigned_by": assignedBy,
        "complaint_at": complaintAt?.toIso8601String(),
        "assigned_at": assignedAt?.toIso8601String(),
        "start_at": startAt?.toIso8601String(),
        "resolved_or_cancelled_at": resolvedOrCancelledAt?.toIso8601String(),
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
        "service_category": serviceCategory?.toJson(),
        "member": member?.toJson(),
      };
}

class Member {
  int? userId;
  String? name;
  String? aprtNo;
  String? floorNumber;
  String? unitType;
  String? phone;
  String? blockName;

  Member({
    this.userId,
    this.name,
    this.aprtNo,
    this.floorNumber,
    this.unitType,
    this.phone,
    this.blockName,
  });

  factory Member.fromJson(Map<String, dynamic> json) => Member(
        userId: json["user_id"],
        name: json["name"],
        aprtNo: json["aprt_no"],
        floorNumber: json["floor_number"],
        unitType: json["unit_type"],
        phone: json["phone"],
        blockName: json["block_name"],
      );

  Map<String, dynamic> toJson() => {
        "user_id": userId,
        "name": name,
        "aprt_no": aprtNo,
        "floor_number": floorNumber,
        "unit_type": unitType,
        "phone": phone,
        "block_name": blockName,
      };
}

class ServiceCategory {
  int? id;
  String? name;

  ServiceCategory({
    this.id,
    this.name,
  });

  factory ServiceCategory.fromJson(Map<String, dynamic> json) =>
      ServiceCategory(
        id: json["id"],
        name: json["name"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
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
