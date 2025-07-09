import 'dart:convert';

StaffModel staffModelFromJson(String str) =>
    StaffModel.fromJson(json.decode(str));

String staffModelToJson(StaffModel data) => json.encode(data.toJson());

class StaffModel {
  final bool status;
  final String message;
  final Data data;

  StaffModel({
    required this.status,
    required this.message,
    required this.data,
  });

  factory StaffModel.fromJson(Map<String, dynamic> json) => StaffModel(
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
  final Staffs staffs;

  Data({
    required this.staffs,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        staffs: Staffs.fromJson(json["staffs"] ?? {}),
      );

  Map<String, dynamic> toJson() => {
        "staffs": staffs.toJson(),
      };
}

class Staffs {
  final int currentPage;
  final List<Datum> data;
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

  Staffs({
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

  factory Staffs.fromJson(Map<String, dynamic> json) => Staffs(
        currentPage: json["current_page"] ?? 0,
        data: List<Datum>.from(
            (json["data"] ?? []).map((x) => Datum.fromJson(x))),
        firstPageUrl: json["first_page_url"] ?? '',
        from: json["from"],
        lastPage: json["last_page"] ?? 0,
        lastPageUrl: json["last_page_url"] ?? '',
        links:
            List<Link>.from((json["links"] ?? []).map((x) => Link.fromJson(x))),
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

class Datum {
  final int id;
  final String role;
  final int? complaintCategoryId;
  final String name;
  final String status;
  final String phone;
  final String email;
  final String address;
  final String cardType;
  final String cardNumber;
  final int userId;
  final int societyId;
  final DateTime createdAt;
  final DateTime updatedAt;
  final dynamic deletedAt;
  final String? image;
  final StaffCategory? staffCategory;

  Datum({
    required this.id,
    required this.role,
    this.complaintCategoryId,
    required this.name,
    required this.status,
    required this.phone,
    required this.email,
    required this.address,
    required this.cardType,
    required this.cardNumber,
    required this.userId,
    required this.societyId,
    required this.createdAt,
    required this.updatedAt,
    this.deletedAt,
    this.image,
    this.staffCategory,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
      id: json["id"] ?? 0,
      role: json["role"] ?? '',
      complaintCategoryId: json["complaint_category_id"],
      name: json["name"] ?? '',
      status: json["status"] ?? '',
      phone: json["phone"] ?? '',
      email: json["email"] ?? '',
      address: json["address"] ?? '',
      cardType: json["card_type"] ?? '',
      cardNumber: json["card_number"] ?? '',
      userId: json["user_id"] ?? 0,
      societyId: json["society_id"] ?? 0,
      createdAt: DateTime.parse(
          json["created_at"] ?? DateTime.now().toIso8601String()),
      updatedAt: DateTime.parse(
          json["updated_at"] ?? DateTime.now().toIso8601String()),
      deletedAt: json["deleted_at"],
      image: json["image"],
      staffCategory: StaffCategory.fromJson(json["staff_category"] ?? {}));

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
        "user_id": userId,
        "society_id": societyId,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
        "deleted_at": deletedAt,
        "image": image,
        "staff_category": staffCategory?.toJson(),
      };
}

class StaffCategory {
  final int id;
  final String name;

  StaffCategory({required this.id, required this.name});

  factory StaffCategory.fromJson(Map<String, dynamic> json) =>
      StaffCategory(id: json["id"] ?? 0, name: json["name"] ?? '');

  Map<String, dynamic> toJson() => {"id": id, "name": name};
}

class Link {
  final String? url;
  final String label;
  final bool active;

  Link({this.url, required this.label, required this.active});

  factory Link.fromJson(Map<String, dynamic> json) => Link(
      url: json["url"],
      label: json["label"] ?? '',
      active: json["active"] ?? false);

  Map<String, dynamic> toJson() =>
      {"url": url, "label": label, "active": active};
}
