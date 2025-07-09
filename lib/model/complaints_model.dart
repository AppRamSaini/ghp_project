// To parse this JSON data, do
//
//     final getAllComplaintsModel = getAllComplaintsModelFromJson(jsonString);

import 'dart:convert';

GetAllComplaintsModel getAllComplaintsModelFromJson(String str) =>
    GetAllComplaintsModel.fromJson(json.decode(str));

String getAllComplaintsModelToJson(GetAllComplaintsModel data) =>
    json.encode(data.toJson());

class GetAllComplaintsModel {
  bool? status;
  String? message;
  Data? data;

  GetAllComplaintsModel({
    this.status,
    this.message,
    this.data,
  });

  factory GetAllComplaintsModel.fromJson(Map<String, dynamic> json) =>
      GetAllComplaintsModel(
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
  Complaints? complaints;

  Data({
    this.complaints,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        complaints: json["complaints"] == null
            ? null
            : Complaints.fromJson(json["complaints"]),
      );

  Map<String, dynamic> toJson() => {
        "complaints": complaints?.toJson(),
      };
}

class Complaints {
  int? currentPage;
  List<ComplaintList>? data;
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

  Complaints({
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

  factory Complaints.fromJson(Map<String, dynamic> json) => Complaints(
        currentPage: json["current_page"],
        data: json["data"] == null
            ? []
            : List<ComplaintList>.from(
                json["data"]!.map((x) => ComplaintList.fromJson(x))),
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

class ComplaintList {
  int? id;
  int? complaintCategoryId;
  AssignedTo? complaintBy;
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
  AssignedTo? assignedTo;
  int? assignedBy;
  DateTime? complaintAt;
  DateTime? assignedAt;
  dynamic startAt;
  dynamic resolvedOrCancelledAt;
  DateTime? createdAt;
  DateTime? updatedAt;

  ComplaintList({
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
  });

  factory ComplaintList.fromJson(Map<String, dynamic> json) => ComplaintList(
        id: json["id"],
        complaintCategoryId: json["complaint_category_id"],
        complaintBy: json["complaint_by"] == null
            ? null
            : AssignedTo.fromJson(json["complaint_by"]),
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
        assignedTo: json["assigned_to"] == null
            ? null
            : AssignedTo.fromJson(json["assigned_to"]),
        assignedBy: json["assigned_by"],
        complaintAt: json["complaint_at"] == null
            ? null
            : DateTime.parse(json["complaint_at"]),
        assignedAt: json["assigned_at"] == null
            ? null
            : DateTime.parse(json["assigned_at"]),
        startAt: json["start_at"],
        resolvedOrCancelledAt: json["resolved_or_cancelled_at"],
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null
            ? null
            : DateTime.parse(json["updated_at"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "complaint_category_id": complaintCategoryId,
        "complaint_by": complaintBy?.toJson(),
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
        "assigned_to": assignedTo?.toJson(),
        "assigned_by": assignedBy,
        "complaint_at": complaintAt?.toIso8601String(),
        "assigned_at": assignedAt?.toIso8601String(),
        "start_at": startAt,
        "resolved_or_cancelled_at": resolvedOrCancelledAt,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
      };
}

class AssignedTo {
  int? id;
  String? uid;
  String? role;
  String? status;
  String? name;
  String? email;
  dynamic emailVerifiedAt;
  dynamic image;
  String? phone;
  DateTime? createdAt;
  DateTime? updatedAt;
  String? deviceId;
  int? memberId;
  int? societyId;
  int? staffId;
  Staff? staff;
  Member? member;

  AssignedTo({
    this.id,
    this.uid,
    this.role,
    this.status,
    this.name,
    this.email,
    this.emailVerifiedAt,
    this.image,
    this.phone,
    this.createdAt,
    this.updatedAt,
    this.deviceId,
    this.memberId,
    this.societyId,
    this.staffId,
    this.staff,
    this.member,
  });

  factory AssignedTo.fromJson(Map<String, dynamic> json) => AssignedTo(
        id: json["id"],
        uid: json["uid"],
        role: json["role"],
        status: json["status"],
        name: json["name"],
        email: json["email"],
        emailVerifiedAt: json["email_verified_at"],
        image: json["image"],
        phone: json["phone"],
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null
            ? null
            : DateTime.parse(json["updated_at"]),
        deviceId: json["device_id"],
        memberId: json["member_id"],
        societyId: json["society_id"],
        staffId: json["staff_id"],
        staff: json["staff"] == null ? null : Staff.fromJson(json["staff"]),
        member: json["member"] == null ? null : Member.fromJson(json["member"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "uid": uid,
        "role": role,
        "status": status,
        "name": name,
        "email": email,
        "email_verified_at": emailVerifiedAt,
        "image": image,
        "phone": phone,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
        "device_id": deviceId,
        "member_id": memberId,
        "society_id": societyId,
        "staff_id": staffId,
        "staff": staff?.toJson(),
        "member": member?.toJson(),
      };
}

class Member {
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

  Member({
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
  });

  factory Member.fromJson(Map<String, dynamic> json) => Member(
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
      };
}

class Staff {
  int? id;
  String? role;
  int? complaintCategoryId;
  String? name;
  String? status;
  String? phone;
  String? email;
  String? address;
  String? cardType;
  String? cardNumber;
  String? cardFile;
  int? userId;
  int? societyId;
  String? gender;
  DateTime? dob;
  String? assignedArea;
  String? employeeId;
  dynamic shiftFrom;
  dynamic shiftTo;
  dynamic offDays;
  dynamic emerName;
  dynamic emerRelation;
  dynamic emerPhone;
  dynamic dateOfJoin;
  dynamic contractEndDate;
  dynamic monthlySalary;
  DateTime? createdAt;
  DateTime? updatedAt;
  dynamic deletedAt;

  Staff({
    this.id,
    this.role,
    this.complaintCategoryId,
    this.name,
    this.status,
    this.phone,
    this.email,
    this.address,
    this.cardType,
    this.cardNumber,
    this.cardFile,
    this.userId,
    this.societyId,
    this.gender,
    this.dob,
    this.assignedArea,
    this.employeeId,
    this.shiftFrom,
    this.shiftTo,
    this.offDays,
    this.emerName,
    this.emerRelation,
    this.emerPhone,
    this.dateOfJoin,
    this.contractEndDate,
    this.monthlySalary,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
  });

  factory Staff.fromJson(Map<String, dynamic> json) => Staff(
        id: json["id"],
        role: json["role"],
        complaintCategoryId: json["complaint_category_id"],
        name: json["name"],
        status: json["status"],
        phone: json["phone"],
        email: json["email"],
        address: json["address"],
        cardType: json["card_type"],
        cardNumber: json["card_number"],
        cardFile: json["card_file"],
        userId: json["user_id"],
        societyId: json["society_id"],
        gender: json["gender"],
        dob: json["dob"] == null ? null : DateTime.parse(json["dob"]),
        assignedArea: json["assigned_area"],
        employeeId: json["employee_id"],
        shiftFrom: json["shift_from"],
        shiftTo: json["shift_to"],
        offDays: json["off_days"],
        emerName: json["emer_name"],
        emerRelation: json["emer_relation"],
        emerPhone: json["emer_phone"],
        dateOfJoin: json["date_of_join"],
        contractEndDate: json["contract_end_date"],
        monthlySalary: json["monthly_salary"],
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
        "role": role,
        "complaint_category_id": complaintCategoryId,
        "name": name,
        "status": status,
        "phone": phone,
        "email": email,
        "address": address,
        "card_type": cardType,
        "card_number": cardNumber,
        "card_file": cardFile,
        "user_id": userId,
        "society_id": societyId,
        "gender": gender,
        "dob":
            "${dob!.year.toString().padLeft(4, '0')}-${dob!.month.toString().padLeft(2, '0')}-${dob!.day.toString().padLeft(2, '0')}",
        "assigned_area": assignedArea,
        "employee_id": employeeId,
        "shift_from": shiftFrom,
        "shift_to": shiftTo,
        "off_days": offDays,
        "emer_name": emerName,
        "emer_relation": emerRelation,
        "emer_phone": emerPhone,
        "date_of_join": dateOfJoin,
        "contract_end_date": contractEndDate,
        "monthly_salary": monthlySalary,
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
