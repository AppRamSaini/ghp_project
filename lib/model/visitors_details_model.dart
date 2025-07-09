import 'dart:convert';

VisitorsDetailsModel visitorsDetailsModelFromJson(String str) =>
    VisitorsDetailsModel.fromJson(json.decode(str));

String visitorsDetailsModelToJson(VisitorsDetailsModel data) =>
    json.encode(data.toJson());

class VisitorsDetailsModel {
  bool? status;
  String? message;
  Data? data;

  VisitorsDetailsModel({
    this.status,
    this.message,
    this.data,
  });

  factory VisitorsDetailsModel.fromJson(Map<String, dynamic> json) =>
      VisitorsDetailsModel(
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
  List<VisitorsDetails>? visitor;

  Data({
    this.visitor,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        visitor: json["visitor"] == null
            ? []
            : List<VisitorsDetails>.from(
                json["visitor"]!.map((x) => VisitorsDetails.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "visitor": visitor == null
            ? []
            : List<dynamic>.from(visitor!.map((x) => x.toJson())),
      };
}

class VisitorsDetails {
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
  String? visitorClassification;
  List<BulkVisitor>? bulkVisitors;
  Member? member;
  LastCheckinDetail? lastCheckinDetail;
  VisitorFeedback? visitorFeedback;

  VisitorsDetails({
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
    this.visitorClassification,
    this.bulkVisitors,
    this.member,
    this.lastCheckinDetail,
    this.visitorFeedback,
  });

  factory VisitorsDetails.fromJson(Map<String, dynamic> json) {
    return VisitorsDetails(
      id: json["id"] as int?,
      typeOfVisitor: json["type_of_visitor"] as String?,
      visitingFrequency: json["visiting_frequency"] as String?,
      visitorName: json["visitor_name"] as String?,
      phone: json["phone"] as String?,
      noOfVisitors: json["no_of_visitors"] as int?,
      date: json["date"] != null ? DateTime.tryParse(json["date"]) : null,
      time: json["time"] as String?,
      vehicleNumber: json["vehicle_number"] as String?,
      purposeOfVisit: json["purpose_of_visit"] as String?,
      validTill: json["valid_till"] as String?,
      status: json["status"] as String?,
      image: json["image"] as String?,
      userId: json["user_id"] != null
          ? int.tryParse(json["user_id"].toString())
          : null,
      addedBy: json["added_by"] as int?,
      addedByRole: json["added_by_role"] as String?,
      societyId: json["society_id"] as int?,
      createdAt: json["created_at"] != null
          ? DateTime.tryParse(json["created_at"])
          : null,
      updatedAt: json["updated_at"] != null
          ? DateTime.tryParse(json["updated_at"])
          : null,
      deletedAt: json["deleted_at"],
      visitorClassification: json["visitor_classification"] as String?,
      bulkVisitors: json["bulk_visitors"] != null
          ? List<BulkVisitor>.from((json["bulk_visitors"] as List)
              .map((x) => BulkVisitor.fromJson(x)))
          : [],
      member: json["member"] != null ? Member.fromJson(json["member"]) : null,
      lastCheckinDetail: json["last_checkin_detail"] != null
          ? LastCheckinDetail.fromJson(json["last_checkin_detail"])
          : null,
      visitorFeedback: json["visitor_feedback"] != null
          ? VisitorFeedback.fromJson(json["visitor_feedback"])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "type_of_visitor": typeOfVisitor,
      "visiting_frequency": visitingFrequency,
      "visitor_name": visitorName,
      "phone": phone,
      "no_of_visitors": noOfVisitors,
      "date": date?.toIso8601String(), // Nullable date
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
      "visitor_classification": visitorClassification,
      "bulk_visitors": bulkVisitors != null
          ? bulkVisitors!.map((x) => x.toJson()).toList()
          : [],
      "member": member?.toJson(),
      "last_checkin_detail": lastCheckinDetail?.toJson(),
      "visitor_feedback": visitorFeedback?.toJson(),
    };
  }
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
