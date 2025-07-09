import 'dart:convert';

DailyHelpsMemberModal dailyHelpsMemberModalFromJson(String str) =>
    DailyHelpsMemberModal.fromJson(json.decode(str));

String dailyHelpsMemberModalToJson(DailyHelpsMemberModal data) =>
    json.encode(data.toJson());

class DailyHelpsMemberModal {
  bool? status;
  String? message;
  Data? data;

  DailyHelpsMemberModal({
    this.status,
    this.message,
    this.data,
  });

  factory DailyHelpsMemberModal.fromJson(Map<String, dynamic> json) =>
      DailyHelpsMemberModal(
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
  int? totalUnits;
  int? occupied;
  int? vacant;
  List<dynamic>? properties;
  dynamic admin;
  dynamic guards;
  List<DailyHelp>? dailyHelp;

  Data({
    this.totalUnits,
    this.occupied,
    this.vacant,
    this.properties,
    this.admin,
    this.guards,
    this.dailyHelp,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        totalUnits: json["total_units"],
        occupied: json["occupied"],
        vacant: json["vacant"],
        properties: json["properties"] == null
            ? []
            : List<dynamic>.from(json["properties"]!.map((x) => x)),
        admin: json["admin"],
        guards: json["guards"],
        dailyHelp: json["daily_help"] == null
            ? []
            : List<DailyHelp>.from(
                json["daily_help"]!.map((x) => DailyHelp.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "total_units": totalUnits,
        "occupied": occupied,
        "vacant": vacant,
        "properties": properties == null
            ? []
            : List<dynamic>.from(properties!.map((x) => x)),
        "admin": admin,
        "guards": guards,
        "daily_help": dailyHelp == null
            ? []
            : List<dynamic>.from(dailyHelp!.map((x) => x.toJson())),
      };
}

class DailyHelp {
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
  dynamic deviceId;
  dynamic memberId;
  dynamic societyId;
  int? staffId;
  dynamic imageUrl;
  LastCheckinDetail? lastCheckinDetail;
  List<AssignedDailyHelpMember>? assignedDailyHelpMembers;
  dynamic member;
  Staff? staff;

  DailyHelp({
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
    this.assignedDailyHelpMembers,
    this.member,
    this.staff,
  });

  factory DailyHelp.fromJson(Map<String, dynamic> json) => DailyHelp(
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
            : LastCheckinDetail.fromJson(json["last_checkin_detail"]),
        assignedDailyHelpMembers: json["assigned_daily_help_members"] == null
            ? []
            : List<AssignedDailyHelpMember>.from(
                json["assigned_daily_help_members"]!
                    .map((x) => AssignedDailyHelpMember.fromJson(x))),
        member: json["member"],
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
        "assigned_daily_help_members": assignedDailyHelpMembers == null
            ? []
            : List<dynamic>.from(
                assignedDailyHelpMembers!.map((x) => x.toJson())),
        "member": member,
        "staff": staff?.toJson(),
      };
}

class AssignedDailyHelpMember {
  int? staffUserId;
  int? memberUserId;
  String? shiftFrom;
  String? shiftTo;
  MemberUser? memberUser;

  AssignedDailyHelpMember({
    this.staffUserId,
    this.memberUserId,
    this.shiftFrom,
    this.shiftTo,
    this.memberUser,
  });

  factory AssignedDailyHelpMember.fromJson(Map<String, dynamic> json) =>
      AssignedDailyHelpMember(
        staffUserId: json["staff_user_id"],
        memberUserId: json["member_user_id"],
        shiftFrom: json["shift_from"],
        shiftTo: json["shift_to"],
        memberUser: json["member_user"] == null
            ? null
            : MemberUser.fromJson(json["member_user"]),
      );

  Map<String, dynamic> toJson() => {
        "staff_user_id": staffUserId,
        "member_user_id": memberUserId,
        "shift_from": shiftFrom,
        "shift_to": shiftTo,
        "member_user": memberUser?.toJson(),
      };
}

class MemberUser {
  int? id;
  String? role;
  String? name;
  String? email;
  String? phone;
  String? status;
  dynamic imageUrl;
  Member? member;

  MemberUser({
    this.id,
    this.role,
    this.name,
    this.email,
    this.phone,
    this.status,
    this.imageUrl,
    this.member,
  });

  factory MemberUser.fromJson(Map<String, dynamic> json) => MemberUser(
        id: json["id"],
        role: json["role"],
        name: json["name"],
        email: json["email"],
        phone: json["phone"],
        status: json["status"],
        imageUrl: json["image_url"],
        member: json["member"] == null ? null : Member.fromJson(json["member"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "role": role,
        "name": name,
        "email": email,
        "phone": phone,
        "status": status,
        "image_url": imageUrl,
        "member": member?.toJson(),
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

class LastCheckinDetail {
  int? id;
  dynamic visitorId;
  String? status;
  dynamic requestedAt;
  DateTime? checkinAt;
  dynamic checkoutAt;
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

  LastCheckinDetail({
    this.id,
    this.visitorId,
    this.status,
    this.requestedAt,
    this.checkinAt,
    this.checkoutAt,
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
  });

  factory LastCheckinDetail.fromJson(Map<String, dynamic> json) =>
      LastCheckinDetail(
        id: json["id"],
        visitorId: json["visitor_id"],
        status: json["status"],
        requestedAt: json["requested_at"],
        checkinAt: json["checkin_at"] == null
            ? null
            : DateTime.parse(json["checkin_at"]),
        checkoutAt: json["checkout_at"],
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
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "visitor_id": visitorId,
        "status": status,
        "requested_at": requestedAt,
        "checkin_at": checkinAt?.toIso8601String(),
        "checkout_at": checkoutAt,
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
  dynamic assignedArea;
  String? employeeId;
  String? shiftFrom;
  String? shiftTo;
  String? offDays;
  String? emerName;
  dynamic emerRelation;
  dynamic emerPhone;
  DateTime? dateOfJoin;
  DateTime? contractEndDate;
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
        dateOfJoin: json["date_of_join"] == null
            ? null
            : DateTime.parse(json["date_of_join"]),
        contractEndDate: json["contract_end_date"] == null
            ? null
            : DateTime.parse(json["contract_end_date"]),
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
        "date_of_join":
            "${dateOfJoin!.year.toString().padLeft(4, '0')}-${dateOfJoin!.month.toString().padLeft(2, '0')}-${dateOfJoin!.day.toString().padLeft(2, '0')}",
        "contract_end_date":
            "${contractEndDate!.year.toString().padLeft(4, '0')}-${contractEndDate!.month.toString().padLeft(2, '0')}-${contractEndDate!.day.toString().padLeft(2, '0')}",
        "monthly_salary": monthlySalary,
        "daily_help": dailyHelp,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
        "deleted_at": deletedAt,
      };
}
