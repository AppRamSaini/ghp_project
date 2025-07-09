import 'dart:convert';

MyBillModel myBillModelFromJson(String str) =>
    MyBillModel.fromJson(json.decode(str));

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
  int? totalPaidAmount;
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
        data: json["data"] == null
            ? []
            : List<Datum>.from(json["data"]!.map((x) => Datum.fromJson(x))),
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

class Datum {
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
  Service? service;

  Datum({
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
    this.service,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
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
        service:
            json["service"] == null ? null : Service.fromJson(json["service"]),
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
        "service": service?.toJson(),
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
