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
  UserProfileData? data;

  UserProfileModel({
    this.status,
    this.message,
    this.data,
  });

  factory UserProfileModel.fromJson(Map<String, dynamic> json) =>
      UserProfileModel(
        status: json["status"],
        message: json["message"],
        data: json["data"] == null
            ? null
            : UserProfileData.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "data": data?.toJson(),
      };
}

class UserProfileData {
  User? user;
  List<UnpaidBill>? unpaidBills;

  UserProfileData({
    this.user,
    this.unpaidBills,
  });

  factory UserProfileData.fromJson(Map<String, dynamic> json) =>
      UserProfileData(
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
  int? memberId;
  int? serviceId;
  String? billType;
  String? installment;
  int? societyId;
  String? invoiceNumber;
  dynamic paymentLink;
  String? paymentStatus;
  String? status;
  String? amount;
  String? advanceAmount;
  String? prevMonthPending;
  DateTime? paymentDate;
  DateTime? dueDate;
  dynamic collectorId;
  DateTime? createdAt;
  DateTime? updatedAt;
  int? dueDateRemainDays;
  int? dueDateDelayDays;

  UnpaidBill({
    this.id,
    this.userId,
    this.memberId,
    this.serviceId,
    this.billType,
    this.installment,
    this.societyId,
    this.invoiceNumber,
    this.paymentLink,
    this.paymentStatus,
    this.status,
    this.amount,
    this.advanceAmount,
    this.prevMonthPending,
    this.paymentDate,
    this.dueDate,
    this.collectorId,
    this.createdAt,
    this.updatedAt,
    this.dueDateRemainDays,
    this.dueDateDelayDays,
  });

  factory UnpaidBill.fromJson(Map<String, dynamic> json) => UnpaidBill(
        id: json["id"],
        userId: json["user_id"],
        memberId: json["member_id"],
        serviceId: json["service_id"],
        billType: json["bill_type"],
        installment: json["installment"],
        societyId: json["society_id"],
        invoiceNumber: json["invoice_number"],
        paymentLink: json["payment_link"],
        paymentStatus: json["payment_status"],
        status: json["status"],
        amount: json["amount"],
        advanceAmount: json["advance_amount"],
        prevMonthPending: json["prev_month_pending"],
        paymentDate: json["payment_date"] == null
            ? null
            : DateTime.parse(json["payment_date"]),
        dueDate:
            json["due_date"] == null ? null : DateTime.parse(json["due_date"]),
        collectorId: json["collector_id"],
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null
            ? null
            : DateTime.parse(json["updated_at"]),
        dueDateRemainDays: json["due_date_remain_days"],
        dueDateDelayDays: json["due_date_delay_days"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "user_id": userId,
        "member_id": memberId,
        "service_id": serviceId,
        "bill_type": billType,
        "installment": installment,
        "society_id": societyId,
        "invoice_number": invoiceNumber,
        "payment_link": paymentLink,
        "payment_status": paymentStatus,
        "status": status,
        "amount": amount,
        "advance_amount": advanceAmount,
        "prev_month_pending": prevMonthPending,
        "payment_date": paymentDate?.toIso8601String(),
        "due_date":
            "${dueDate!.year.toString().padLeft(4, '0')}-${dueDate!.month.toString().padLeft(2, '0')}-${dueDate!.day.toString().padLeft(2, '0')}",
        "collector_id": collectorId,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
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
  String? aprtNo;
  Property? property;
  dynamic categoryName;
  dynamic categoryId;
  int? societyId;
  dynamic staffId;
  String? imageUrl;
  LastCheckinDetail? lastCheckinDetail;

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
    this.aprtNo,
    this.property,
    this.categoryName,
    this.categoryId,
    this.societyId,
    this.staffId,
    this.imageUrl,
    this.lastCheckinDetail,
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
        aprtNo: json["aprt_no"],
        property: json["property"] == null
            ? null
            : Property.fromJson(json["property"]),
        categoryName: json["category_name"],
        categoryId: json["category_id"],
        societyId: json["society_id"],
        staffId: json["staff_id"],
        imageUrl: json["image_url"],
        lastCheckinDetail: json["last_checkin_detail"] == null
            ? null
            : LastCheckinDetail.fromJson(json["last_checkin_detail"]),
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
        "aprt_no": aprtNo,
        "property": property?.toJson(),
        "category_name": categoryName,
        "category_id": categoryId,
        "society_id": societyId,
        "staff_id": staffId,
        "image_url": imageUrl,
        "last_checkin_detail": lastCheckinDetail?.toJson(),
      };
}

class LastCheckinDetail {
  int? id;
  dynamic visitorId;
  String? status;
  dynamic requestedAt;
  DateTime? checkinAt;
  String? checkinType;
  DateTime? checkoutAt;
  String? checkoutType;
  dynamic requestBy;
  int? checkinBy;
  int? checkoutBy;
  dynamic visitorOf;
  DateTime? createdAt;
  DateTime? updatedAt;
  dynamic parcelId;
  int? byResident;
  dynamic byDailyHelp;
  dynamic dailyHelpForMember;
  CheckedBy? checkedInBy;
  CheckedBy? checkedOutBy;

  LastCheckinDetail({
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
        checkinType: json["checkin_type"],
        checkoutAt: json["checkout_at"] == null
            ? null
            : DateTime.parse(json["checkout_at"]),
        checkoutType: json["checkout_type"],
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
            : CheckedBy.fromJson(json["checked_in_by"]),
        checkedOutBy: json["checked_out_by"] == null
            ? null
            : CheckedBy.fromJson(json["checked_out_by"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "visitor_id": visitorId,
        "status": status,
        "requested_at": requestedAt,
        "checkin_at": checkinAt?.toIso8601String(),
        "checkin_type": checkinType,
        "checkout_at": checkoutAt?.toIso8601String(),
        "checkout_type": checkoutType,
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
        "checked_out_by": checkedOutBy?.toJson(),
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
  dynamic image;
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

class Property {
  int? id;
  String? name;
  String? floorNumber;
  String? unitType;
  String? aprtNo;
  String? email;
  String? phone;
  int? blockId;
  String? blockName;
  String? bhk;
  String? unitSize;

  Property({
    this.id,
    this.name,
    this.floorNumber,
    this.unitType,
    this.aprtNo,
    this.email,
    this.phone,
    this.blockId,
    this.blockName,
    this.bhk,
    this.unitSize,
  });

  factory Property.fromJson(Map<String, dynamic> json) => Property(
        id: json["id"],
        name: json["name"],
        floorNumber: json["floor_number"],
        unitType: json["unit_type"],
        aprtNo: json["aprt_no"],
        email: json["email"],
        phone: json["phone"],
        blockId: json["block_id"],
        blockName: json["block_name"],
        bhk: json["bhk"],
        unitSize: json["unit_size"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "floor_number": floorNumber,
        "unit_type": unitType,
        "aprt_no": aprtNo,
        "email": email,
        "phone": phone,
        "block_id": blockId,
        "block_name": blockName,
        "bhk": bhk,
        "unit_size": unitSize,
      };
}
