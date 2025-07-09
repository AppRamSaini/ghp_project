import 'dart:convert';

VisitorsListingModel visitorsListingModelFromJson(String str) =>
    VisitorsListingModel.fromJson(json.decode(str));

String visitorsListingModelToJson(VisitorsListingModel data) =>
    json.encode(data.toJson());

class VisitorsListingModel {
  final bool status;
  final String message;
  final Data data;

  VisitorsListingModel({
    required this.status,
    required this.message,
    required this.data,
  });

  factory VisitorsListingModel.fromJson(Map<String, dynamic> json) =>
      VisitorsListingModel(
        status: json["status"] ?? false,
        message: json["message"] ?? '',
        data: Data.fromJson(json["data"] ?? {}),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "data": data.toJson(),
      };
}

class Data {
  final int todayVisitorsCount;
  final int pastVisitorsCount;
  final Visitors visitors;

  Data({
    required this.todayVisitorsCount,
    required this.pastVisitorsCount,
    required this.visitors,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        todayVisitorsCount: json["today_visitors_count"] ?? 0,
        pastVisitorsCount: json["past_visitors_count"] ?? 0,
        visitors: Visitors.fromJson(json["visitors"] ?? {}),
      );

  Map<String, dynamic> toJson() => {
        "today_visitors_count": todayVisitorsCount,
        "past_visitors_count": pastVisitorsCount,
        "visitors": visitors.toJson(),
      };
}

class Visitors {
  final int currentPage;
  final List<VisitorsListing> data;
  final String firstPageUrl;
  final int? from;
  final int lastPage;
  final String lastPageUrl;
  final List<Link> links;
  final String? nextPageUrl;
  final String path;
  final int perPage;
  final String? prevPageUrl;
  final int? to;
  final int total;

  Visitors({
    required this.currentPage,
    required this.data,
    required this.firstPageUrl,
    this.from,
    required this.lastPage,
    required this.lastPageUrl,
    required this.links,
    this.nextPageUrl,
    required this.path,
    required this.perPage,
    this.prevPageUrl,
    this.to,
    required this.total,
  });

  factory Visitors.fromJson(Map<String, dynamic> json) => Visitors(
        currentPage: json["current_page"] ?? 0,
        data: (json["data"] as List<dynamic>?)
                ?.map((x) => VisitorsListing.fromJson(x))
                .toList() ??
            [],
        firstPageUrl: json["first_page_url"] ?? '',
        from: json["from"],
        lastPage: json["last_page"] ?? 0,
        lastPageUrl: json["last_page_url"] ?? '',
        links: (json["links"] as List<dynamic>?)
                ?.map((x) => Link.fromJson(x))
                .toList() ??
            [],
        nextPageUrl: json["next_page_url"],
        path: json["path"] ?? '',
        perPage: json["per_page"] ?? 0,
        prevPageUrl: json["prev_page_url"],
        to: json["to"],
        total: json["total"] ?? 0,
      );

  Map<String, dynamic> toJson() => {
        "current_page": currentPage,
        "data": data.map((x) => x.toJson()).toList(),
        "first_page_url": firstPageUrl,
        "from": from,
        "last_page": lastPage,
        "last_page_url": lastPageUrl,
        "links": links.map((x) => x.toJson()).toList(),
        "next_page_url": nextPageUrl,
        "path": path,
        "per_page": perPage,
        "prev_page_url": prevPageUrl,
        "to": to,
        "total": total,
      };
}

class VisitorsListing {
  final int id;
  final String typeOfVisitor;
  final String visitingFrequency;
  final String visitorName;
  final String phone;
  final int noOfVisitors;
  final DateTime date;
  final String time;
  final String vehicleNumber;
  final String purposeOfVisit;
  final String validTill;
  final String status;
  final String image;
  final int? userId; // Nullable
  final int addedBy;
  final String addedByRole;
  final int societyId;
  final DateTime createdAt;
  final DateTime updatedAt;
  final dynamic deletedAt;
  final String? visitorClassification;
  final List<dynamic> bulkVisitors;
  final Members? member; // Nullable
  final LastCheckinDetail lastCheckinDetail;
  final VisitorFeedback? visitorFeedback;

  VisitorsListing({
    required this.id,
    required this.typeOfVisitor,
    required this.visitingFrequency,
    required this.visitorName,
    required this.phone,
    required this.noOfVisitors,
    required this.date,
    required this.time,
    required this.vehicleNumber,
    required this.purposeOfVisit,
    required this.validTill,
    required this.status,
    required this.image,
    this.userId, // Nullable
    required this.addedBy,
    required this.addedByRole,
    required this.societyId,
    required this.createdAt,
    required this.updatedAt,
    this.deletedAt,
    this.visitorClassification,
    required this.bulkVisitors,
    this.member, // Nullable
    required this.lastCheckinDetail,
    this.visitorFeedback,
  });

  factory VisitorsListing.fromJson(Map<String, dynamic> json) =>
      VisitorsListing(
        id: json["id"] ?? 0,
        typeOfVisitor: json["type_of_visitor"] ?? '',
        visitingFrequency: json["visiting_frequency"] ?? '',
        visitorName: json["visitor_name"] ?? '',
        phone: json["phone"] ?? '',
        noOfVisitors: json["no_of_visitors"] ?? 0,
        date: DateTime.tryParse(json["date"] ?? "") ?? DateTime.now(),
        time: json["time"] ?? '',
        vehicleNumber: json["vehicle_number"] ?? '',
        purposeOfVisit: json["purpose_of_visit"] ?? '',
        validTill: json["valid_till"] ?? '',
        status: json["status"] ?? '',
        image: json["image"] ?? '',
        userId: json["user_id"] != null
            ? int.tryParse(json["user_id"].toString())
            : null,
        addedBy: json["added_by"] ?? 0,
        addedByRole: json["added_by_role"] ?? '',
        societyId: json["society_id"] ?? 0,
        createdAt:
            DateTime.tryParse(json["created_at"] ?? "") ?? DateTime.now(),
        updatedAt:
            DateTime.tryParse(json["updated_at"] ?? "") ?? DateTime.now(),
        deletedAt: json["deleted_at"],
        visitorClassification: json["visitor_classification"] ?? '',
        bulkVisitors: (json["bulk_visitors"] as List<dynamic>?) ?? [],
        member:
            json["member"] != null ? Members.fromJson(json["member"]) : null,
        lastCheckinDetail:
            LastCheckinDetail.fromJson(json["last_checkin_detail"] ?? {}),
        visitorFeedback: json["visitor_feedback"] != null
            ? VisitorFeedback.fromJson(json["visitor_feedback"])
            : null,
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "type_of_visitor": typeOfVisitor,
        "visiting_frequency": visitingFrequency,
        "visitor_name": visitorName,
        "phone": phone,
        "no_of_visitors": noOfVisitors,
        "date": date.toIso8601String(),
        "time": time,
        "vehicle_number": vehicleNumber,
        "purpose_of_visit": purposeOfVisit,
        "valid_till": validTill,
        "status": status,
        "image": image,
        "user_id": userId?.toString(), // Nullable field
        "added_by": addedBy,
        "added_by_role": addedByRole,
        "society_id": societyId,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
        "deleted_at": deletedAt,
        "visitor_classification": visitorClassification,
        "bulk_visitors": bulkVisitors,
        "member": member?.toJson(), // Nullable field
        "last_checkin_detail": lastCheckinDetail.toJson(),
        "visitor_feedback": visitorFeedback?.toJson(),
      };
}

class Members {
  final int userId;
  final String name;
  final String aprtNo;
  final String floorNumber;
  final String unitType;
  final String phone;
  final String blockName;

  Members({
    required this.userId,
    required this.name,
    required this.aprtNo,
    required this.floorNumber,
    required this.unitType,
    required this.phone,
    required this.blockName,
  });

  factory Members.fromJson(Map<String, dynamic> json) => Members(
        userId: json["user_id"] ?? 0,
        name: json["name"] ?? '',
        aprtNo: json["aprt_no"] ?? '',
        floorNumber: json["floor_number"] ?? 0,
        unitType: json["unit_type"] ?? '',
        phone: json["phone"] ?? '',
        blockName: json["block_name"] ?? '',
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

class LastCheckinDetail {
  final int id;
  final int visitorId;
  final String status;
  final dynamic requestedAt;
  final DateTime checkinAt;
  final DateTime? checkoutAt;
  final dynamic requestBy;
  final int checkinBy;
  final int? checkoutBy;
  final int visitorOf;
  final int societyId;
  final DateTime createdAt;
  final DateTime updatedAt;

  LastCheckinDetail({
    required this.id,
    required this.visitorId,
    required this.status,
    required this.requestedAt,
    required this.checkinAt,
    required this.checkoutAt,
    required this.requestBy,
    required this.checkinBy,
    required this.checkoutBy,
    required this.visitorOf,
    required this.societyId,
    required this.createdAt,
    required this.updatedAt,
  });

  factory LastCheckinDetail.fromJson(Map<String, dynamic> json) =>
      LastCheckinDetail(
        id: json["id"] ?? 0,
        visitorId: json["visitor_id"] ?? 0,
        status: json["status"] ?? '',
        requestedAt: json["requested_at"] ?? '',
        checkinAt:
            DateTime.parse(json["checkin_at"] ?? DateTime.now().toString()),
        checkoutAt:
            DateTime.parse(json["checkout_at"] ?? DateTime.now().toString()),
        requestBy: json["request_by"] ?? '',
        checkinBy: json["checkin_by"] ?? 0,
        checkoutBy: json["checkout_by"] ?? 0,
        visitorOf: json["visitor_of"] ?? 0,
        societyId: json["society_id"] ?? 0,
        createdAt:
            DateTime.parse(json["created_at"] ?? DateTime.now().toString()),
        updatedAt:
            DateTime.parse(json["updated_at"] ?? DateTime.now().toString()),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "visitor_id": visitorId,
        "status": status,
        "requested_at": requestedAt,
        "checkin_at": checkinAt.toIso8601String(),
        "checkout_at": checkoutAt?.toIso8601String(),
        "request_by": requestBy,
        "checkin_by": checkinBy,
        "checkout_by": checkoutBy,
        "visitor_of": visitorOf,
        "society_id": societyId,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
      };
}

// VisitorFeedback Model
class VisitorFeedback {
  final int id;
  final int visitorId;
  final int? rating;
  final String feedback;
  final int feedbackBy;
  final int societyId;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  VisitorFeedback({
    required this.id,
    required this.visitorId,
    this.rating,
    required this.feedback,
    required this.feedbackBy,
    required this.societyId,
    this.createdAt,
    this.updatedAt,
  });

  factory VisitorFeedback.fromJson(Map<String, dynamic> json) =>
      VisitorFeedback(
        id: json["id"] ?? 0,
        visitorId: json["visitor_id"] ?? 0,
        rating: json["rating"],
        feedback: json["feedback"] ?? "",
        feedbackBy: json["feedback_by"] ?? 0,
        societyId: json["society_id"] ?? 0,
        createdAt: json["created_at"] != null
            ? DateTime.tryParse(json["created_at"])
            : null,
        updatedAt: json["updated_at"] != null
            ? DateTime.tryParse(json["updated_at"])
            : null,
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

class Link {
  final String? url;
  final String label;
  final bool active;

  Link({
    this.url,
    required this.label,
    required this.active,
  });

  factory Link.fromJson(Map<String, dynamic> json) => Link(
        url: json["url"],
        label: json["label"] ?? '',
        active: json["active"] ?? false,
      );

  Map<String, dynamic> toJson() => {
        "url": url,
        "label": label,
        "active": active,
      };
}
