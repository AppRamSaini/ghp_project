import 'dart:convert';

ViewVisitorsModel viewVisitorsModelFromJson(String str) =>
    ViewVisitorsModel.fromJson(json.decode(str));
String viewVisitorsModelToJson(ViewVisitorsModel data) =>
    json.encode(data.toJson());

class ViewVisitorsModel {
  bool status;
  String message;
  Data data;

  ViewVisitorsModel({
    required this.status,
    required this.message,
    required this.data,
  });

  factory ViewVisitorsModel.fromJson(Map<String, dynamic> json) =>
      ViewVisitorsModel(
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
  Visitors visitors;

  Data({
    required this.visitors,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        visitors: Visitors.fromJson(json["visitors"]),
      );

  Map<String, dynamic> toJson() => {
        "visitors": visitors.toJson(),
      };
}

class Visitors {
  int currentPage;
  List<VisitorViewList> data;
  String firstPageUrl;
  int from;
  int lastPage;
  String lastPageUrl;
  List<Link> links;
  dynamic nextPageUrl;
  String path;
  int perPage;
  dynamic prevPageUrl;
  int to;
  int total;

  Visitors({
    required this.currentPage,
    required this.data,
    required this.firstPageUrl,
    required this.from,
    required this.lastPage,
    required this.lastPageUrl,
    required this.links,
    required this.nextPageUrl,
    required this.path,
    required this.perPage,
    required this.prevPageUrl,
    required this.to,
    required this.total,
  });

  factory Visitors.fromJson(Map<String, dynamic> json) => Visitors(
        currentPage: json["current_page"],
        data: List<VisitorViewList>.from(
            json["data"].map((x) => VisitorViewList.fromJson(x))),
        firstPageUrl: json["first_page_url"],
        from: json["from"],
        lastPage: json["last_page"],
        lastPageUrl: json["last_page_url"],
        links: List<Link>.from(json["links"].map((x) => Link.fromJson(x))),
        nextPageUrl: json["next_page_url"],
        path: json["path"],
        perPage: json["per_page"],
        prevPageUrl: json["prev_page_url"],
        to: json["to"],
        total: json["total"],
      );

  Map<String, dynamic> toJson() => {
        "current_page": currentPage,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
        "first_page_url": firstPageUrl,
        "from": from,
        "last_page": lastPage,
        "last_page_url": lastPageUrl,
        "links": List<dynamic>.from(links.map((x) => x.toJson())),
        "next_page_url": nextPageUrl,
        "path": path,
        "per_page": perPage,
        "prev_page_url": prevPageUrl,
        "to": to,
        "total": total,
      };
}

class VisitorViewList {
  int id;
  String typeOfVisitor;
  String visitingFrequency;
  String visitorName;
  String phone;
  int noOfVisitors;
  DateTime date;
  String time;
  String? vehicleNumber;
  String purposeOfVisit;
  String validTill;
  String status;
  String? image;
  int userId;
  int addedBy;
  String addedByRole;
  int societyId;
  DateTime createdAt;
  DateTime updatedAt;
  dynamic deletedAt;

  VisitorViewList({
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
    required this.userId,
    required this.addedBy,
    required this.addedByRole,
    required this.societyId,
    required this.createdAt,
    required this.updatedAt,
    required this.deletedAt,
  });

  factory VisitorViewList.fromJson(Map<String, dynamic> json) =>
      VisitorViewList(
        id: json["id"],
        typeOfVisitor: json["type_of_visitor"],
        visitingFrequency: json["visiting_frequency"],
        visitorName: json["visitor_name"],
        phone: json["phone"],
        noOfVisitors: json["no_of_visitors"],
        date: DateTime.parse(json["date"]),
        time: json["time"],
        vehicleNumber: json["vehicle_number"],
        purposeOfVisit: json["purpose_of_visit"],
        validTill: json["valid_till"],
        status: json["status"],
        image: json["image"],
        userId: json["user_id"],
        addedBy: json["added_by"],
        addedByRole: json["added_by_role"],
        societyId: json["society_id"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
        deletedAt: json["deleted_at"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "type_of_visitor": typeOfVisitor,
        "visiting_frequency": visitingFrequency,
        "visitor_name": visitorName,
        "phone": phone,
        "no_of_visitors": noOfVisitors,
        "date":
            "${date.year.toString().padLeft(4, '0')}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}",
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
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
        "deleted_at": deletedAt,
      };
}

class Link {
  String? url;
  String label;
  bool active;

  Link({
    required this.url,
    required this.label,
    required this.active,
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
