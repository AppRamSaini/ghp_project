import 'dart:convert';

BillLedgerModel billLedgerModelFromJson(String str) =>
    BillLedgerModel.fromJson(json.decode(str));

String billLedgerModelToJson(BillLedgerModel data) =>
    json.encode(data.toJson());

class BillLedgerModel {
  bool? status;
  String? message;
  Data? data;

  BillLedgerModel({
    this.status,
    this.message,
    this.data,
  });

  factory BillLedgerModel.fromJson(Map<String, dynamic> json) =>
      BillLedgerModel(
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
  Ledger? ledger;

  Data({
    this.ledger,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        ledger: json["ledger"] == null ? null : Ledger.fromJson(json["ledger"]),
      );

  Map<String, dynamic> toJson() => {
        "ledger": ledger?.toJson(),
      };
}

class Ledger {
  int? currentPage;
  List<LedgerData>? data;
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

  Ledger({
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

  factory Ledger.fromJson(Map<String, dynamic> json) => Ledger(
        currentPage: json["current_page"],
        data: json["data"] == null
            ? []
            : List<LedgerData>.from(
                json["data"]!.map((x) => LedgerData.fromJson(x))),
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

class LedgerData {
  int? id;
  int? memberId;
  int? societyId;
  int? collectorId;
  String? transactionType;
  String? debit;
  String? credit;
  String? balance;
  String? paymentMode;
  DateTime? transactionDate;
  String? sourceType;
  int? sourceId;
  DateTime? createdAt;
  DateTime? updatedAt;
  dynamic deletedAt;
  Member? member;
  Society? society;
  Collector? collector;
  Source? source;

  LedgerData({
    this.id,
    this.memberId,
    this.societyId,
    this.collectorId,
    this.transactionType,
    this.debit,
    this.credit,
    this.balance,
    this.paymentMode,
    this.transactionDate,
    this.sourceType,
    this.sourceId,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
    this.member,
    this.society,
    this.collector,
    this.source,
  });

  factory LedgerData.fromJson(Map<String, dynamic> json) => LedgerData(
        id: json["id"],
        memberId: json["member_id"],
        societyId: json["society_id"],
        collectorId: json["collector_id"],
        transactionType: json["transaction_type"],
        debit: json["debit"],
        credit: json["credit"],
        balance: json["balance"],
        paymentMode: json["payment_mode"],
        transactionDate: json["transaction_date"] == null
            ? null
            : DateTime.parse(json["transaction_date"]),
        sourceType: json["source_type"],
        sourceId: json["source_id"],
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null
            ? null
            : DateTime.parse(json["updated_at"]),
        deletedAt: json["deleted_at"],
        member: json["member"] == null ? null : Member.fromJson(json["member"]),
        society:
            json["society"] == null ? null : Society.fromJson(json["society"]),
        collector: json["collector"] == null
            ? null
            : Collector.fromJson(json["collector"]),
        source: json["source"] == null ? null : Source.fromJson(json["source"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "member_id": memberId,
        "society_id": societyId,
        "collector_id": collectorId,
        "transaction_type": transactionType,
        "debit": debit,
        "credit": credit,
        "balance": balance,
        "payment_mode": paymentMode,
        "transaction_date":
            "${transactionDate!.year.toString().padLeft(4, '0')}-${transactionDate!.month.toString().padLeft(2, '0')}-${transactionDate!.day.toString().padLeft(2, '0')}",
        "source_type": sourceType,
        "source_id": sourceId,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
        "deleted_at": deletedAt,
        "member": member?.toJson(),
        "society": society?.toJson(),
        "collector": collector?.toJson(),
        "source": source?.toJson(),
      };
}

class Collector {
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
  dynamic deviceId;
  dynamic memberId;
  dynamic societyId;
  dynamic staffId;
  String? imageUrl;
  dynamic lastCheckinDetail;
  dynamic member;
  dynamic staff;

  Collector({
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

  factory Collector.fromJson(Map<String, dynamic> json) => Collector(
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
        lastCheckinDetail: json["last_checkin_detail"],
        member: json["member"],
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
        "last_checkin_detail": lastCheckinDetail,
        "member": member,
        "staff": staff,
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
  dynamic maintenanceBill;
  dynamic maintenanceBillDueDate;
  String? ownershipType;
  String? contructionType;
  String? occupancyStatus;
  String? ownerName;
  dynamic emerName;
  dynamic emerRelation;
  dynamic emerPhone;
  int? advancedPayment;
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
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
        "deleted_at": deletedAt,
      };
}

class Society {
  int? id;
  String? name;
  String? location;
  int? floors;
  String? status;
  int? floorUnits;
  dynamic memberId;
  DateTime? createdAt;
  DateTime? updatedAt;
  dynamic deletedAt;
  String? city;
  String? state;
  String? pin;
  String? contact;
  String? email;
  String? registrationNum;
  String? type;
  String? totalArea;
  int? totalTowers;
  String? amenities;

  Society({
    this.id,
    this.name,
    this.location,
    this.floors,
    this.status,
    this.floorUnits,
    this.memberId,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
    this.city,
    this.state,
    this.pin,
    this.contact,
    this.email,
    this.registrationNum,
    this.type,
    this.totalArea,
    this.totalTowers,
    this.amenities,
  });

  factory Society.fromJson(Map<String, dynamic> json) => Society(
        id: json["id"],
        name: json["name"],
        location: json["location"],
        floors: json["floors"],
        status: json["status"],
        floorUnits: json["floor_units"],
        memberId: json["member_id"],
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null
            ? null
            : DateTime.parse(json["updated_at"]),
        deletedAt: json["deleted_at"],
        city: json["city"],
        state: json["state"],
        pin: json["pin"],
        contact: json["contact"],
        email: json["email"],
        registrationNum: json["registration_num"],
        type: json["type"],
        totalArea: json["total_area"],
        totalTowers: json["total_towers"],
        amenities: json["amenities"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "location": location,
        "floors": floors,
        "status": status,
        "floor_units": floorUnits,
        "member_id": memberId,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
        "deleted_at": deletedAt,
        "city": city,
        "state": state,
        "pin": pin,
        "contact": contact,
        "email": email,
        "registration_num": registrationNum,
        "type": type,
        "total_area": totalArea,
        "total_towers": totalTowers,
        "amenities": amenities,
      };
}

class Source {
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
  int? collectorId;
  DateTime? createdAt;
  DateTime? updatedAt;
  int? dueDateRemainDays;
  int? dueDateDelayDays;
  List<Payment>? payments;

  Source({
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
    this.payments,
  });

  factory Source.fromJson(Map<String, dynamic> json) => Source(
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
        payments: json["payments"] == null
            ? []
            : List<Payment>.from(
                json["payments"]!.map((x) => Payment.fromJson(x))),
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
        "payments": payments == null
            ? []
            : List<dynamic>.from(payments!.map((x) => x.toJson())),
      };
}

class Payment {
  int? id;
  String? uuid;
  int? userId;
  dynamic collectorId;
  dynamic paymentDate;
  int? billId;
  String? txnId;
  dynamic orderId;
  String? amount;
  dynamic tax;
  dynamic fee;
  dynamic status;
  String? paymentMood;
  dynamic extraDetails;
  DateTime? createdAt;
  DateTime? updatedAt;
  dynamic deletedAt;

  Payment({
    this.id,
    this.uuid,
    this.userId,
    this.collectorId,
    this.paymentDate,
    this.billId,
    this.txnId,
    this.orderId,
    this.amount,
    this.tax,
    this.fee,
    this.status,
    this.paymentMood,
    this.extraDetails,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
  });

  factory Payment.fromJson(Map<String, dynamic> json) => Payment(
        id: json["id"],
        uuid: json["uuid"],
        userId: json["user_id"],
        collectorId: json["collector_id"],
        paymentDate: json["payment_date"],
        billId: json["bill_id"],
        txnId: json["txn_id"],
        orderId: json["orderId"],
        amount: json["amount"],
        tax: json["tax"],
        fee: json["fee"],
        status: json["status"],
        paymentMood: json["payment_mood"],
        extraDetails: json["extra_details"],
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
        "uuid": uuid,
        "user_id": userId,
        "collector_id": collectorId,
        "payment_date": paymentDate,
        "bill_id": billId,
        "txn_id": txnId,
        "orderId": orderId,
        "amount": amount,
        "tax": tax,
        "fee": fee,
        "status": status,
        "payment_mood": paymentMood,
        "extra_details": extraDetails,
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
