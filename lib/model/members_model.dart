import 'dart:convert';

SocietyMembersModel societyMembersModelFromJson(String str) =>
    SocietyMembersModel.fromJson(json.decode(str));

String societyMembersModelToJson(SocietyMembersModel data) =>
    json.encode(data.toJson());

class SocietyMembersModel {
  bool? status;
  String? message;
  SocietyData? data;

  SocietyMembersModel({
    this.status,
    this.message,
    this.data,
  });

  factory SocietyMembersModel.fromJson(Map<String, dynamic> json) =>
      SocietyMembersModel(
        status: json["status"],
        message: json["message"],
        data: json["data"] == null ? null : SocietyData.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "data": data?.toJson(),
      };
}

class SocietyData {
  int? totalUnits;
  int? occupied;
  int? vacant;
  List<Property>? properties;
  List<Admin>? admin;
  List<Admin>? guards;

  SocietyData({
    this.totalUnits,
    this.occupied,
    this.vacant,
    this.properties,
    this.admin,
    this.guards,
  });

  factory SocietyData.fromJson(Map<String, dynamic> json) => SocietyData(
        totalUnits: json["total_units"],
        occupied: json["occupied"],
        vacant: json["vacant"],
        properties: json["properties"] == null
            ? []
            : List<Property>.from(
                json["properties"]!.map((x) => Property.fromJson(x))),
        admin: json["admin"] == null
            ? []
            : List<Admin>.from(json["admin"]!.map((x) => Admin.fromJson(x))),
        guards: json["guards"] == null
            ? []
            : List<Admin>.from(json["guards"]!.map((x) => Admin.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "total_units": totalUnits,
        "occupied": occupied,
        "vacant": vacant,
        "properties": properties == null
            ? []
            : List<dynamic>.from(properties!.map((x) => x.toJson())),
        "admin": admin == null
            ? []
            : List<dynamic>.from(admin!.map((x) => x.toJson())),
        "guards": guards == null
            ? []
            : List<dynamic>.from(guards!.map((x) => x.toJson())),
      };
}

class Admin {
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
  Member? member;
  Staff? staff;

  Admin({
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
    this.member,
    this.staff,
  });

  factory Admin.fromJson(Map<String, dynamic> json) => Admin(
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
        "member": member?.toJson(),
        "staff": staff?.toJson(),
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
  DateTime? dateOfJoin;
  DateTime? contractEndDate;
  String? monthlySalary;
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
        dateOfJoin: json["date_of_join"] == null
            ? null
            : DateTime.parse(json["date_of_join"]),
        contractEndDate: json["contract_end_date"] == null
            ? null
            : DateTime.parse(json["contract_end_date"]),
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
        "date_of_join":
            "${dateOfJoin!.year.toString().padLeft(4, '0')}-${dateOfJoin!.month.toString().padLeft(2, '0')}-${dateOfJoin!.day.toString().padLeft(2, '0')}",
        "contract_end_date":
            "${contractEndDate!.year.toString().padLeft(4, '0')}-${contractEndDate!.month.toString().padLeft(2, '0')}-${contractEndDate!.day.toString().padLeft(2, '0')}",
        "monthly_salary": monthlySalary,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
        "deleted_at": deletedAt,
      };
}

class Property {
  String? floor;
  List<PropertyNumber>? propertyNumbers;
  int? totalUnits;
  int? occupied;
  int? vacant;

  Property({
    this.floor,
    this.propertyNumbers,
    this.totalUnits,
    this.occupied,
    this.vacant,
  });

  factory Property.fromJson(Map<String, dynamic> json) => Property(
        floor: json["floor"],
        propertyNumbers: json["property_numbers"] == null
            ? []
            : List<PropertyNumber>.from(json["property_numbers"]!
                .map((x) => PropertyNumber.fromJson(x))),
        totalUnits: json["total_units"],
        occupied: json["occupied"],
        vacant: json["vacant"],
      );

  Map<String, dynamic> toJson() => {
        "floor": floor,
        "property_numbers": propertyNumbers == null
            ? []
            : List<dynamic>.from(propertyNumbers!.map((x) => x.toJson())),
        "total_units": totalUnits,
        "occupied": occupied,
        "vacant": vacant,
      };
}

class PropertyNumber {
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
  Member? memberInfo;

  PropertyNumber({
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
    this.memberInfo,
  });

  factory PropertyNumber.fromJson(Map<String, dynamic> json) => PropertyNumber(
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
        memberInfo: json["member_info"] == null
            ? null
            : Member.fromJson(json["member_info"]),
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
        "member_info": memberInfo?.toJson(),
      };
}
