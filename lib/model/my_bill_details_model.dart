
import 'dart:convert';

BillDetailsModel billDetailsModelFromJson(String str) => BillDetailsModel.fromJson(json.decode(str));

String billDetailsModelToJson(BillDetailsModel data) => json.encode(data.toJson());

class BillDetailsModel {
  bool status;
  String message;
  Data data;

  BillDetailsModel({
    required this.status,
    required this.message,
    required this.data,
  });

  factory BillDetailsModel.fromJson(Map<String, dynamic> json) => BillDetailsModel(
    status: json["status"],
    message: json["message"],
    data: Data.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "message": message,
    "data": data.toJson(),
  };
}

class Data {
  List<Bill> bill;

  Data({
    required this.bill,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    bill: List<Bill>.from(json["bill"].map((x) => Bill.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "bill": List<dynamic>.from(bill.map((x) => x.toJson())),
  };
}

class Bill {
  int id;
  int userId;
  int serviceId;
  String billType;
  String amount;
  DateTime dueDate;
  int societyId;
  int createdBy;
  String invoiceNumber;
  String status;
  DateTime createdAt;
  DateTime updatedAt;
  dynamic deletedAt;
  int dueDateRemainDays;
  int dueDateDelayDays;
  Service service;

  Bill({
    required this.id,
    required this.userId,
    required this.serviceId,
    required this.billType,
    required this.amount,
    required this.dueDate,
    required this.societyId,
    required this.createdBy,
    required this.invoiceNumber,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
    required this.deletedAt,
    required this.dueDateRemainDays,
    required this.dueDateDelayDays,
    required this.service,
  });

  factory Bill.fromJson(Map<String, dynamic> json) => Bill(
    id: json["id"],
    userId: json["user_id"],
    serviceId: json["service_id"],
    billType: json["bill_type"],
    amount: json["amount"],
    dueDate: DateTime.parse(json["due_date"]),
    societyId: json["society_id"],
    createdBy: json["created_by"],
    invoiceNumber: json["invoice_number"],
    status: json["status"],
    createdAt: DateTime.parse(json["created_at"]),
    updatedAt: DateTime.parse(json["updated_at"]),
    deletedAt: json["deleted_at"],
    dueDateRemainDays: json["due_date_remain_days"],
    dueDateDelayDays: json["due_date_delay_days"],
    service: Service.fromJson(json["service"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "user_id": userId,
    "service_id": serviceId,
    "bill_type": billType,
    "amount": amount,
    "due_date": "${dueDate.year.toString().padLeft(4, '0')}-${dueDate.month.toString().padLeft(2, '0')}-${dueDate.day.toString().padLeft(2, '0')}",
    "society_id": societyId,
    "created_by": createdBy,
    "invoice_number": invoiceNumber,
    "status": status,
    "created_at": createdAt.toIso8601String(),
    "updated_at": updatedAt.toIso8601String(),
    "deleted_at": deletedAt,
    "due_date_remain_days": dueDateRemainDays,
    "due_date_delay_days": dueDateDelayDays,
    "service": service.toJson(),
  };
}

class Service {
  String name;

  Service({
    required this.name,
  });

  factory Service.fromJson(Map<String, dynamic> json) => Service(
    name: json["name"],
  );

  Map<String, dynamic> toJson() => {
    "name": name,
  };
}
