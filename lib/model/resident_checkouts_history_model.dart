// To parse this JSON data, do
//
//     final residentCheckoutsHistoryModal = residentCheckoutsHistoryModalFromJson(jsonString);

import 'dart:convert';

ResidentCheckoutsHistoryModal residentCheckoutsHistoryModalFromJson(
        String str) =>
    ResidentCheckoutsHistoryModal.fromJson(json.decode(str));

String residentCheckoutsHistoryModalToJson(
        ResidentCheckoutsHistoryModal data) =>
    json.encode(data.toJson());

class ResidentCheckoutsHistoryModal {
  bool? status;
  String? message;
  Data? data;

  ResidentCheckoutsHistoryModal({
    this.status,
    this.message,
    this.data,
  });

  factory ResidentCheckoutsHistoryModal.fromJson(Map<String, dynamic> json) =>
      ResidentCheckoutsHistoryModal(
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
  CheckinLogs? checkinLogs;

  Data({
    this.checkinLogs,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        checkinLogs: json["checkin_logs"] == null
            ? null
            : CheckinLogs.fromJson(json["checkin_logs"]),
      );

  Map<String, dynamic> toJson() => {
        "checkin_logs": checkinLogs?.toJson(),
      };
}

class CheckinLogs {
  int? currentPage;
  List<ResidentCheckoutsHistoryList>? data;
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

  CheckinLogs({
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

  factory CheckinLogs.fromJson(Map<String, dynamic> json) => CheckinLogs(
        currentPage: json["current_page"],
        data: json["data"] == null
            ? []
            : List<ResidentCheckoutsHistoryList>.from(json["data"]!
                .map((x) => ResidentCheckoutsHistoryList.fromJson(x))),
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

class Resident {
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
  int? societyId;
  int? staffId;
  String? imageUrl;
  ResidentCheckoutsHistoryList? lastCheckinDetail;
  Member? member;
  Staff? staff;

  Resident({
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

  factory Resident.fromJson(Map<String, dynamic> json) => Resident(
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
            : ResidentCheckoutsHistoryList.fromJson(
                json["last_checkin_detail"]),
        member: json["member"] == null ? null : Member.fromJson(json["member"]),
        staff: json["staff"] == null ? null : Staff.fromJson(json["staff"]),
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
        "staff": staff?.toJson(),
      };
}

class ResidentCheckoutsHistoryList {
  int? id;
  dynamic visitorId;
  Status? status;
  dynamic requestedAt;
  DateTime? checkinAt;
  String? checkinType;
  DateTime? checkoutAt;
  String? checkoutType;
  dynamic requestBy;
  int? checkinBy;
  int? checkoutBy;
  dynamic visitorOf;
  int? societyId;
  DateTime? createdAt;
  DateTime? updatedAt;
  dynamic parcelId;
  int? byResident;
  dynamic byDailyHelp;
  dynamic dailyHelpForMember;
  Resident? resident;
  CheckedBy? checkedInBy;
  CheckedBy? checkedOutBy;

  ResidentCheckoutsHistoryList({
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
    this.resident,
    this.checkedInBy,
    this.checkedOutBy,
  });

  factory ResidentCheckoutsHistoryList.fromJson(Map<String, dynamic> json) =>
      ResidentCheckoutsHistoryList(
        id: json["id"],
        visitorId: json["visitor_id"],
        status: statusValues.map[json["status"]]!,
        requestedAt: json["requested_at"],
        checkinAt: json["checkin_at"] == null
            ? null
            : DateTime.parse(json["checkin_at"]),
        checkinType: json["checkin_type"],
        checkoutAt: json["checkout_at"] == null
            ? null
            : DateTime.parse(json["checkout_at"]),
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
        resident: json["resident"] == null
            ? null
            : Resident.fromJson(json["resident"]),
        checkedInBy: json["checked_in_by"] == null
            ? null
            : CheckedBy.fromJson(json["checked_in_by"]),
        checkedOutBy: json["checked_out_by"] == null
            ? null
            : CheckedBy.fromJson(json["checked_out_by"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "visitor_id": visitorId,
        "status": statusValues.reverse[status],
        "requested_at": requestedAt,
        "checkin_at": checkinAt?.toIso8601String(),
        "checkin_type": checkinType,
        "checkout_at": checkoutAt?.toIso8601String(),
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
        "resident": resident?.toJson(),
        "checked_in_by": checkedInBy?.toJson(),
        "checked_out_by": checkedOutBy?.toJson(),
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

class Staff {
  int? id;
  String? role;
  dynamic complaintCategoryId;
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
  String? shiftFrom;
  String? shiftTo;
  String? offDays;
  dynamic emerName;
  dynamic emerRelation;
  dynamic emerPhone;
  dynamic dateOfJoin;
  dynamic contractEndDate;
  String? monthlySalary;
  int? dailyHelp;
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
    this.dailyHelp,
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
        dailyHelp: json["daily_help"],
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
        "daily_help": dailyHelp,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
        "deleted_at": deletedAt,
      };
}

class CheckedBy {
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

  CheckedBy({
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

  factory CheckedBy.fromJson(Map<String, dynamic> json) => CheckedBy(
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

enum Status { CHECKED_IN, CHECKED_OUT }

final statusValues = EnumValues(
    {"checked_in": Status.CHECKED_IN, "checked_out": Status.CHECKED_OUT});

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
