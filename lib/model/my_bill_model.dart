
import 'dart:convert';
MyBillModel myBillModelFromJson(String str) => MyBillModel.fromJson(json.decode(str));
String myBillModelToJson(MyBillModel data) => json.encode(data.toJson());

class MyBillModel {
  bool? status;
  String? message;
  Data? data;

  MyBillModel({
    this.status,
    this.message,
    this.data,
  });

  factory MyBillModel.fromJson(Map<String, dynamic> json) => MyBillModel(
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
  String? totalUnpaidAmount;
  String? totalPaidAmount;
  Bills? bills;

  Data({
    this.totalUnpaidAmount,
    this.totalPaidAmount,
    this.bills,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    totalUnpaidAmount: json["total_unpaid_amount"],
    totalPaidAmount: json["total_paid_amount"],
    bills: json["bills"] == null ? null : Bills.fromJson(json["bills"]),
  );

  Map<String, dynamic> toJson() => {
    "total_unpaid_amount": totalUnpaidAmount,
    "total_paid_amount": totalPaidAmount,
    "bills": bills?.toJson(),
  };
}

class Bills {
  int? currentPage;
  List<Datum>? data;
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

  Bills({
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

  factory Bills.fromJson(Map<String, dynamic> json) => Bills(
    currentPage: json["current_page"],
    data: json["data"] == null ? [] : List<Datum>.from(json["data"]!.map((x) => Datum.fromJson(x))),
    firstPageUrl: json["first_page_url"],
    from: json["from"],
    lastPage: json["last_page"],
    lastPageUrl: json["last_page_url"],
    links: json["links"] == null ? [] : List<Link>.from(json["links"]!.map((x) => Link.fromJson(x))),
    nextPageUrl: json["next_page_url"],
    path: json["path"],
    perPage: json["per_page"],
    prevPageUrl: json["prev_page_url"],
    to: json["to"],
    total: json["total"],
  );

  Map<String, dynamic> toJson() => {
    "current_page": currentPage,
    "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x.toJson())),
    "first_page_url": firstPageUrl,
    "from": from,
    "last_page": lastPage,
    "last_page_url": lastPageUrl,
    "links": links == null ? [] : List<dynamic>.from(links!.map((x) => x.toJson())),
    "next_page_url": nextPageUrl,
    "path": path,
    "per_page": perPage,
    "prev_page_url": prevPageUrl,
    "to": to,
    "total": total,
  };
}

class Datum {
  int? id;
  int? userId;
  int? memberId;
  int? serviceId;
  String? billType;
  dynamic installment;
  int? societyId;
  String? invoiceNumber;
  dynamic paymentLink;
  String? paymentStatus;
  String? status;
  String? amount;
  String? advanceAmount;
  String? prevMonthPending;
  dynamic paymentDate;
  DateTime? dueDate;
  dynamic collectorId;
  int? dueDateRemainDays;
  int? dueDateDelayDays;
  Service? service;
  Property? property;

  Datum({
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
    this.dueDateRemainDays,
    this.dueDateDelayDays,
    this.service,
    this.property,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
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
    paymentDate: json["payment_date"],
    dueDate: json["due_date"] == null ? null : DateTime.parse(json["due_date"]),
    collectorId: json["collector_id"],
    dueDateRemainDays: json["due_date_remain_days"],
    dueDateDelayDays: json["due_date_delay_days"],
    service: json["service"] == null ? null : Service.fromJson(json["service"]),
    property: json["property"] == null ? null : Property.fromJson(json["property"]),
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
    "payment_date": paymentDate,
    "due_date": "${dueDate!.year.toString().padLeft(4, '0')}-${dueDate!.month.toString().padLeft(2, '0')}-${dueDate!.day.toString().padLeft(2, '0')}",
    "collector_id": collectorId,
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
  int? maintenanceBill;
  DateTime? maintenanceBillDueDate;
  String? ownershipType;
  String? contructionType;
  String? occupancyStatus;
  dynamic ownerName;
  dynamic emerName;
  dynamic emerRelation;
  dynamic emerPhone;
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
    maintenanceBillDueDate: json["maintenance_bill_due_date"] == null ? null : DateTime.parse(json["maintenance_bill_due_date"]),
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
    "maintenance_bill_due_date": "${maintenanceBillDueDate!.year.toString().padLeft(4, '0')}-${maintenanceBillDueDate!.month.toString().padLeft(2, '0')}-${maintenanceBillDueDate!.day.toString().padLeft(2, '0')}",
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
