import 'dart:convert';

IncomingVisitorsRequestModel visitorsDetailsModelFromJson(String str) =>
    IncomingVisitorsRequestModel.fromJson(json.decode(str));

String visitorsDetailsModelToJson(IncomingVisitorsRequestModel data) =>
    json.encode(data.toJson());

class IncomingVisitorsRequestModel {
  bool? status;
  String? message;
  Data? data;

  IncomingVisitorsRequestModel({
    this.status,
    this.message,
    this.data,
  });

  factory IncomingVisitorsRequestModel.fromJson(Map<String, dynamic> json) =>
      IncomingVisitorsRequestModel(
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
  List<IncomingVisitorsModel>? visitor;

  Data({
    this.visitor,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        visitor: json["visitor"] == null
            ? []
            : List<IncomingVisitorsModel>.from(
                json["visitor"]!.map((x) => IncomingVisitorsModel.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "visitor": visitor == null
            ? []
            : List<dynamic>.from(visitor!.map((x) => x.toJson())),
      };
}

class IncomingVisitorsModel {
  int? id;
  String? typeOfVisitor;
  String? visitingFrequency;
  String? visitorName;
  String? phone;
  int? noOfVisitors;
  DateTime? date;
  String? time;
  String? vehicleNumber;
  String? purposeOfVisit;
  String? validTill;
  String? status;
  String? image;
  int? userId;
  int? addedBy;
  String? addedByRole;
  int? societyId;
  DateTime? createdAt;
  DateTime? updatedAt;
  dynamic deletedAt;
  List<BulkVisitor>? bulkVisitors;
  Member? member;
  LastCheckinDetail? lastCheckinDetail;
  VisitorFeedback? visitorFeedback;

  IncomingVisitorsModel({
    this.id,
    this.typeOfVisitor,
    this.visitingFrequency,
    this.visitorName,
    this.phone,
    this.noOfVisitors,
    this.date,
    this.time,
    this.vehicleNumber,
    this.purposeOfVisit,
    this.validTill,
    this.status,
    this.image,
    this.userId,
    this.addedBy,
    this.addedByRole,
    this.societyId,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
    this.bulkVisitors,
    this.member,
    this.lastCheckinDetail,
    this.visitorFeedback,
  });

  factory IncomingVisitorsModel.fromJson(Map<String, dynamic> json) =>
      IncomingVisitorsModel(
        id: json["id"],
        typeOfVisitor: json["type_of_visitor"],
        visitingFrequency: json["visiting_frequency"],
        visitorName: json["visitor_name"],
        phone: json["phone"],
        noOfVisitors: json["no_of_visitors"],
        date: json["date"] == null ? null : DateTime.parse(json["date"]),
        time: json["time"],
        vehicleNumber: json["vehicle_number"],
        purposeOfVisit: json["purpose_of_visit"],
        validTill: json["valid_till"],
        status: json["status"] is String
            ? json["status"]
            : (json["status"]?.toString() ?? ''),
        image: json["image"],
        userId: json["user_id"],
        addedBy: json["added_by"],
        addedByRole: json["added_by_role"],
        societyId: json["society_id"],
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null
            ? null
            : DateTime.parse(json["updated_at"]),
        deletedAt: json["deleted_at"],
        bulkVisitors: json["bulk_visitors"] == null
            ? []
            : List<BulkVisitor>.from(
                json["bulk_visitors"]!.map((x) => BulkVisitor.fromJson(x))),
        member: json["member"] == null ? null : Member.fromJson(json["member"]),
        lastCheckinDetail: json["last_checkin_detail"] == null
            ? null
            : LastCheckinDetail.fromJson(json["last_checkin_detail"]),
        visitorFeedback: json["visitor_feedback"] == null
            ? null
            : VisitorFeedback.fromJson(json["visitor_feedback"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "type_of_visitor": typeOfVisitor,
        "visiting_frequency": visitingFrequency,
        "visitor_name": visitorName,
        "phone": phone,
        "no_of_visitors": noOfVisitors,
        "date":
            "${date!.year.toString().padLeft(4, '0')}-${date!.month.toString().padLeft(2, '0')}-${date!.day.toString().padLeft(2, '0')}",
        "time": time,
        "vehicle_number": vehicleNumber,
        "purpose_of_visit": purposeOfVisit,
        "valid_till": validTill,
        "status": status,
        "image": image,
        "user_id": userId,
        "added_by": addedBy,
        "added_by_role": addedByRole,
        "society_id": societyId,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
        "deleted_at": deletedAt,
        "bulk_visitors": bulkVisitors == null
            ? []
            : List<dynamic>.from(bulkVisitors!.map((x) => x.toJson())),
        "member": member?.toJson(),
        "last_checkin_detail": lastCheckinDetail?.toJson(),
        "visitor_feedback": visitorFeedback?.toJson(),
      };
}

class BulkVisitor {
  int? id;
  int? visitorId;
  String? name;
  String? phone;

  BulkVisitor({
    this.id,
    this.visitorId,
    this.name,
    this.phone,
  });

  factory BulkVisitor.fromJson(Map<String, dynamic> json) => BulkVisitor(
        id: json["id"],
        visitorId: json["visitor_id"],
        name: json["name"],
        phone: json["phone"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "visitor_id": visitorId,
        "name": name,
        "phone": phone,
      };
}

class LastCheckinDetail {
  int? id;
  int? visitorId;
  String? status;
  dynamic requestedAt;
  DateTime? checkinAt;
  dynamic checkoutAt;
  dynamic requestBy;
  int? checkinBy;
  dynamic checkoutBy;
  int? visitorOf;
  int? societyId;
  DateTime? createdAt;
  DateTime? updatedAt;
  dynamic parcelId;

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
      };
}

class Member {
  int? userId;
  String? name;
  String? aprtNo;
  String? floorNumber;
  String? unitType;
  String? phone;
  String? blockName;

  Member({
    this.userId,
    this.name,
    this.aprtNo,
    this.floorNumber,
    this.unitType,
    this.phone,
    this.blockName,
  });

  factory Member.fromJson(Map<String, dynamic> json) => Member(
        userId: json["user_id"],
        name: json["name"],
        aprtNo: json["aprt_no"],
        floorNumber: json["floor_number"],
        unitType: json["unit_type"],
        phone: json["phone"],
        blockName: json["block_name"],
      );

  Map<String, dynamic> toJson() => {
        "user_id": userId,
        "name": name,
        "aprt_no": aprtNo,
        "floor_number": floorNumber,
        "unit_type": unitType,
        "phone": phone,
        "block_name": blockName,
      };
}

class VisitorFeedback {
  int? id;
  int? visitorId;
  dynamic rating;
  String? feedback;
  int? feedbackBy;
  int? societyId;
  DateTime? createdAt;
  DateTime? updatedAt;

  VisitorFeedback({
    this.id,
    this.visitorId,
    this.rating,
    this.feedback,
    this.feedbackBy,
    this.societyId,
    this.createdAt,
    this.updatedAt,
  });

  factory VisitorFeedback.fromJson(Map<String, dynamic> json) =>
      VisitorFeedback(
        id: json["id"],
        visitorId: json["visitor_id"],
        rating: json["rating"],
        feedback: json["feedback"],
        feedbackBy: json["feedback_by"],
        societyId: json["society_id"],
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null
            ? null
            : DateTime.parse(json["updated_at"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "visitor_id": visitorId,
        "rating": rating,
        "feedback": feedback,
        "feedback_by": feedbackBy,
        "society_id": societyId,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
      };
}
