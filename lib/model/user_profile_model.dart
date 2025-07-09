// To parse this JSON data, do
//
//     final userProfileModel = userProfileModelFromJson(jsonString);

import 'dart:convert';

UserProfileModel userProfileModelFromJson(String str) =>
    UserProfileModel.fromJson(json.decode(str));

String userProfileModelToJson(UserProfileModel data) =>
    json.encode(data.toJson());

class UserProfileModel {
  bool? status;
  String? message;
  Data? data;

  UserProfileModel({
    this.status,
    this.message,
    this.data,
  });

  factory UserProfileModel.fromJson(Map<String, dynamic> json) =>
      UserProfileModel(
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
  User? user;
  List<UnpaidBill>? unpaidBills;

  Data({
    this.user,
    this.unpaidBills,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        user: json["user"] == null ? null : User.fromJson(json["user"]),
        unpaidBills: json["unpaid_bills"] == null
            ? []
            : List<UnpaidBill>.from(
                json["unpaid_bills"]!.map((x) => UnpaidBill.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "user": user?.toJson(),
        "unpaid_bills": unpaidBills == null
            ? []
            : List<dynamic>.from(unpaidBills!.map((x) => x.toJson())),
      };
}

class UnpaidBill {
  int? id;
  int? userId;
  int? serviceId;
  String? billType;
  String? amount;
  DateTime? dueDate;
  int? societyId;
  int? createdBy;
  String? invoiceNumber;
  String? status;
  DateTime? createdAt;
  DateTime? updatedAt;
  dynamic deletedAt;
  int? dueDateRemainDays;
  int? dueDateDelayDays;

  UnpaidBill({
    this.id,
    this.userId,
    this.serviceId,
    this.billType,
    this.amount,
    this.dueDate,
    this.societyId,
    this.createdBy,
    this.invoiceNumber,
    this.status,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
    this.dueDateRemainDays,
    this.dueDateDelayDays,
  });

  factory UnpaidBill.fromJson(Map<String, dynamic> json) => UnpaidBill(
        id: json["id"],
        userId: json["user_id"],
        serviceId: json["service_id"],
        billType: json["bill_type"],
        amount: json["amount"],
        dueDate:
            json["due_date"] == null ? null : DateTime.parse(json["due_date"]),
        societyId: json["society_id"],
        createdBy: json["created_by"],
        invoiceNumber: json["invoice_number"],
        status: json["status"],
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null
            ? null
            : DateTime.parse(json["updated_at"]),
        deletedAt: json["deleted_at"],
        dueDateRemainDays: json["due_date_remain_days"],
        dueDateDelayDays: json["due_date_delay_days"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "user_id": userId,
        "service_id": serviceId,
        "bill_type": billType,
        "amount": amount,
        "due_date":
            "${dueDate!.year.toString().padLeft(4, '0')}-${dueDate!.month.toString().padLeft(2, '0')}-${dueDate!.day.toString().padLeft(2, '0')}",
        "society_id": societyId,
        "created_by": createdBy,
        "invoice_number": invoiceNumber,
        "status": status,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
        "deleted_at": deletedAt,
        "due_date_remain_days": dueDateRemainDays,
        "due_date_delay_days": dueDateDelayDays,
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
  String? societyName;
  String? unitType;
  String? floorNumber;
  String? blockName;
  String? aprtNo;
  BlockInfo? blockInfo;
  dynamic categoryName;
  dynamic categoryId;
  int? memberId;
  int? societyId;
  dynamic staffId;
  String? imageUrl;
  LastCheckinDetail? lastCheckinDetail;
  List<UnpaidBill>? myUnpaidBills;

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
    this.societyName,
    this.unitType,
    this.floorNumber,
    this.blockName,
    this.aprtNo,
    this.blockInfo,
    this.categoryName,
    this.categoryId,
    this.memberId,
    this.societyId,
    this.staffId,
    this.imageUrl,
    this.lastCheckinDetail,
    this.myUnpaidBills,
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
        societyName: json["society_name"],
        unitType: json["unit_type"],
        floorNumber: json["floor_number"],
        blockName: json["block_name"],
        aprtNo: json["aprt_no"],
        blockInfo: json["block_info"] == null
            ? null
            : BlockInfo.fromJson(json["block_info"]),
        categoryName: json["category_name"],
        categoryId: json["category_id"],
        memberId: json["member_id"],
        societyId: json["society_id"],
        staffId: json["staff_id"],
        imageUrl: json["image_url"],
        lastCheckinDetail: json["last_checkin_detail"] == null
            ? null
            : LastCheckinDetail.fromJson(json["last_checkin_detail"]),
        myUnpaidBills: json["my_unpaid_bills"] == null
            ? []
            : List<UnpaidBill>.from(
                json["my_unpaid_bills"]!.map((x) => UnpaidBill.fromJson(x))),
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
        "society_name": societyName,
        "unit_type": unitType,
        "floor_number": floorNumber,
        "block_name": blockName,
        "aprt_no": aprtNo,
        "block_info": blockInfo?.toJson(),
        "category_name": categoryName,
        "category_id": categoryId,
        "member_id": memberId,
        "society_id": societyId,
        "staff_id": staffId,
        "image_url": imageUrl,
        "last_checkin_detail": lastCheckinDetail?.toJson(),
        "my_unpaid_bills": myUnpaidBills == null
            ? []
            : List<dynamic>.from(myUnpaidBills!.map((x) => x.toJson())),
      };
}

class BlockInfo {
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

  BlockInfo({
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

  factory BlockInfo.fromJson(Map<String, dynamic> json) => BlockInfo(
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
  DateTime? createdAt;
  DateTime? updatedAt;
  dynamic parcelId;
  int? byResident;
  dynamic byDailyHelp;
  dynamic dailyHelpForMember;
  CheckedInBy? checkedInBy;
  dynamic checkedOutBy;

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
    this.createdAt,
    this.updatedAt,
    this.parcelId,
    this.byResident,
    this.byDailyHelp,
    this.dailyHelpForMember,
    this.checkedInBy,
    this.checkedOutBy,
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
        "checkout_at": checkoutAt,
        "request_by": requestBy,
        "checkin_by": checkinBy,
        "checkout_by": checkoutBy,
        "visitor_of": visitorOf,
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
