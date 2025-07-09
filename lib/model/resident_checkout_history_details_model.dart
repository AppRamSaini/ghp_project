// To parse this JSON data, do
//
//     final residentCheckoutsHistoryDetailsModal = residentCheckoutsHistoryDetailsModalFromJson(jsonString);

import 'dart:convert';

ResidentCheckoutsHistoryDetailsModal
    residentCheckoutsHistoryDetailsModalFromJson(String str) =>
        ResidentCheckoutsHistoryDetailsModal.fromJson(json.decode(str));

String residentCheckoutsHistoryDetailsModalToJson(
        ResidentCheckoutsHistoryDetailsModal data) =>
    json.encode(data.toJson());

class ResidentCheckoutsHistoryDetailsModal {
  bool? status;
  String? message;
  ResidentCheckoutsHistoryDetailsData? data;

  ResidentCheckoutsHistoryDetailsModal({
    this.status,
    this.message,
    this.data,
  });

  factory ResidentCheckoutsHistoryDetailsModal.fromJson(
          Map<String, dynamic> json) =>
      ResidentCheckoutsHistoryDetailsModal(
        status: json["status"],
        message: json["message"],
        data: json["data"] == null
            ? null
            : ResidentCheckoutsHistoryDetailsData.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "data": data?.toJson(),
      };
}

class ResidentCheckoutsHistoryDetailsData {
  User? user;
  List<Log>? logs;

  ResidentCheckoutsHistoryDetailsData({
    this.user,
    this.logs,
  });

  factory ResidentCheckoutsHistoryDetailsData.fromJson(
          Map<String, dynamic> json) =>
      ResidentCheckoutsHistoryDetailsData(
        user: json["user"] == null ? null : User.fromJson(json["user"]),
        logs: json["logs"] == null
            ? []
            : List<Log>.from(json["logs"]!.map((x) => Log.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "user": user?.toJson(),
        "logs": logs == null
            ? []
            : List<dynamic>.from(logs!.map((x) => x.toJson())),
      };
}

class Log {
  int? id;
  dynamic visitorId;
  String? status;
  dynamic requestedAt;
  DateTime? checkinAt;
  String? checkinType;
  dynamic checkoutAt;
  dynamic checkoutType;
  dynamic requestBy;
  int? checkinBy;
  dynamic checkoutBy;
  dynamic visitorOf;
  int? societyId;
  DateTime? createdAt;
  DateTime? updatedAt;
  dynamic parcelId;
  int? byResident;
  dynamic byDailyHelp;
  dynamic dailyHelpForMember;
  CheckedInBy? checkedInBy;
  dynamic checkedOutBy;

  Log({
    this.id,
    this.visitorId,
    this.status,
    this.requestedAt,
    this.checkinAt,
    this.checkinType,
    this.checkoutAt,
    this.checkoutType,
    this.requestBy,
    this.checkinBy,
    this.checkoutBy,
    this.visitorOf,
    this.societyId,
    this.createdAt,
    this.updatedAt,
    this.parcelId,
    this.byResident,
    this.byDailyHelp,
    this.dailyHelpForMember,
    this.checkedInBy,
    this.checkedOutBy,
  });

  factory Log.fromJson(Map<String, dynamic> json) => Log(
        id: json["id"],
        visitorId: json["visitor_id"],
        status: json["status"],
        requestedAt: json["requested_at"],
        checkinAt: json["checkin_at"] == null
            ? null
            : DateTime.parse(json["checkin_at"]),
        checkinType: json["checkin_type"],
        checkoutAt: json["checkout_at"],
        checkoutType: json["checkout_type"],
        requestBy: json["request_by"],
        checkinBy: json["checkin_by"],
        checkoutBy: json["checkout_by"],
        visitorOf: json["visitor_of"],
        societyId: json["society_id"],
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null
            ? null
            : DateTime.parse(json["updated_at"]),
        parcelId: json["parcel_id"],
        byResident: json["by_resident"],
        byDailyHelp: json["by_daily_help"],
        dailyHelpForMember: json["daily_help_for_member"],
        checkedInBy: json["checked_in_by"] == null
            ? null
            : CheckedInBy.fromJson(json["checked_in_by"]),
        checkedOutBy: json["checked_out_by"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "visitor_id": visitorId,
        "status": status,
        "requested_at": requestedAt,
        "checkin_at": checkinAt?.toIso8601String(),
        "checkin_type": checkinType,
        "checkout_at": checkoutAt,
        "checkout_type": checkoutType,
        "request_by": requestBy,
        "checkin_by": checkinBy,
        "checkout_by": checkoutBy,
        "visitor_of": visitorOf,
        "society_id": societyId,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
        "parcel_id": parcelId,
        "by_resident": byResident,
        "by_daily_help": byDailyHelp,
        "daily_help_for_member": dailyHelpForMember,
        "checked_in_by": checkedInBy?.toJson(),
        "checked_out_by": checkedOutBy,
      };
}

class CheckedInBy {
  int? id;
  String? uid;
  String? role;
  String? status;
  String? name;
  String? email;
  dynamic emailVerifiedAt;
  String? image;
  String? phone;
  DateTime? createdAt;
  DateTime? updatedAt;
  String? deviceId;
  String? imageUrl;

  CheckedInBy({
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
    this.imageUrl,
  });

  factory CheckedInBy.fromJson(Map<String, dynamic> json) => CheckedInBy(
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
        imageUrl: json["image_url"],
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
        "image_url": imageUrl,
      };
}

class User {
  int? id;
  String? uid;
  String? role;
  String? status;
  String? name;
  String? email;
  dynamic emailVerifiedAt;
  String? image;
  String? phone;
  DateTime? createdAt;
  DateTime? updatedAt;
  String? deviceId;
  int? memberId;
  dynamic societyId;
  dynamic staffId;
  String? imageUrl;
  Log? lastCheckinDetail;
  Member? member;
  dynamic staff;

  User({
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
    this.imageUrl,
    this.lastCheckinDetail,
    this.member,
    this.staff,
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
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
        imageUrl: json["image_url"],
        lastCheckinDetail: json["last_checkin_detail"] == null
            ? null
            : Log.fromJson(json["last_checkin_detail"]),
        member: json["member"] == null ? null : Member.fromJson(json["member"]),
        staff: json["staff"],
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
        "image_url": imageUrl,
        "last_checkin_detail": lastCheckinDetail?.toJson(),
        "member": member?.toJson(),
        "staff": staff,
      };
}

class Member {
  int? id;
  int? userId;
  String? name;
  String? aprtNo;
  String? floorNumber;
  String? unitType;
  String? phone;
  String? blockName;

  Member({
    this.id,
    this.userId,
    this.name,
    this.aprtNo,
    this.floorNumber,
    this.unitType,
    this.phone,
    this.blockName,
  });

  factory Member.fromJson(Map<String, dynamic> json) => Member(
        id: json["id"],
        userId: json["user_id"],
        name: json["name"],
        aprtNo: json["aprt_no"],
        floorNumber: json["floor_number"],
        unitType: json["unit_type"],
        phone: json["phone"],
        blockName: json["block_name"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "user_id": userId,
        "name": name,
        "aprt_no": aprtNo,
        "floor_number": floorNumber,
        "unit_type": unitType,
        "phone": phone,
        "block_name": blockName,
      };
}
