import 'dart:convert';

BillDetailsModel billDetailsModelFromJson(String str) =>
    BillDetailsModel.fromJson(json.decode(str));

String billDetailsModelToJson(BillDetailsModel data) =>
    json.encode(data.toJson());

class BillDetailsModel {
  bool? status;
  String? message;
  Data? data;

  BillDetailsModel({
    this.status,
    this.message,
    this.data,
  });

  factory BillDetailsModel.fromJson(Map<String, dynamic> json) =>
      BillDetailsModel(
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
  List<Bill>? bill;

  Data({
    this.bill,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        bill: json["bill"] == null
            ? []
            : List<Bill>.from(json["bill"]!.map((x) => Bill.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "bill": bill == null
            ? []
            : List<dynamic>.from(bill!.map((x) => x.toJson())),
      };
}

class Bill {
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
  Service? service;
  Property? property;

  Bill({
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
    this.service,
    this.property,
  });

  factory Bill.fromJson(Map<String, dynamic> json) => Bill(
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
        service:
            json["service"] == null ? null : Service.fromJson(json["service"]),
        property: json["property"] == null
            ? null
            : Property.fromJson(json["property"]),
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
        "service": service?.toJson(),
        "property": property?.toJson(),
      };
}

class Property {
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
  dynamic maintenanceBill;
  dynamic maintenanceBillDueDate;
  String? ownershipType;
  String? contructionType;
  String? occupancyStatus;
  dynamic ownerName;
  String? emerName;
  String? emerRelation;
  String? emerPhone;
  int? advancedPayment;
  dynamic createdAt;
  dynamic updatedAt;
  dynamic deletedAt;

  Property({
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
    this.maintenanceBill,
    this.maintenanceBillDueDate,
    this.ownershipType,
    this.contructionType,
    this.occupancyStatus,
    this.ownerName,
    this.emerName,
    this.emerRelation,
    this.emerPhone,
    this.advancedPayment,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
  });

  factory Property.fromJson(Map<String, dynamic> json) => Property(
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
        maintenanceBill: json["maintenance_bill"],
        maintenanceBillDueDate: json["maintenance_bill_due_date"],
        ownershipType: json["ownership_type"],
        contructionType: json["contruction_type"],
        occupancyStatus: json["occupancy_status"],
        ownerName: json["owner_name"],
        emerName: json["emer_name"],
        emerRelation: json["emer_relation"],
        emerPhone: json["emer_phone"],
        advancedPayment: json["advanced_payment"],
        createdAt: json["created_at"],
        updatedAt: json["updated_at"],
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
        "maintenance_bill": maintenanceBill,
        "maintenance_bill_due_date": maintenanceBillDueDate,
        "ownership_type": ownershipType,
        "contruction_type": contructionType,
        "occupancy_status": occupancyStatus,
        "owner_name": ownerName,
        "emer_name": emerName,
        "emer_relation": emerRelation,
        "emer_phone": emerPhone,
        "advanced_payment": advancedPayment,
        "created_at": createdAt,
        "updated_at": updatedAt,
        "deleted_at": deletedAt,
      };
}

class Service {
  String? name;

  Service({
    this.name,
  });

  factory Service.fromJson(Map<String, dynamic> json) => Service(
        name: json["name"],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
      };
}
