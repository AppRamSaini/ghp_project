import 'dart:convert';

IncomingDocumentModel incomingDocumentModelFromJson(String str) =>
    IncomingDocumentModel.fromJson(json.decode(str));

String incomingDocumentModelToJson(IncomingDocumentModel data) =>
    json.encode(data.toJson());

class IncomingDocumentModel {
  bool? status;
  String? message;
  Data? data;

  IncomingDocumentModel({
    this.status,
    this.message,
    this.data,
  });

  factory IncomingDocumentModel.fromJson(Map<String, dynamic> json) =>
      IncomingDocumentModel(
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
  IncomingRequests? incomingRequests;

  Data({
    this.incomingRequests,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        incomingRequests: json["incoming_requests"] == null
            ? null
            : IncomingRequests.fromJson(json["incoming_requests"]),
      );

  Map<String, dynamic> toJson() => {
        "incoming_requests": incomingRequests?.toJson(),
      };
}

class IncomingRequests {
  int? currentPage;
  List<IncomingRequestData>? data;
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

  IncomingRequests({
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

  factory IncomingRequests.fromJson(Map<String, dynamic> json) =>
      IncomingRequests(
        currentPage: json["current_page"],
        data: json["data"] == null
            ? []
            : List<IncomingRequestData>.from(
                json["data"]!.map((x) => IncomingRequestData.fromJson(x))),
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

class IncomingRequestData {
  int? id;
  int? requestTo;
  int? requestBy;
  String? requestByRole;
  dynamic uploadedBy;
  dynamic uploadedByRole;
  int? societyId;
  String? status;
  int? documentTypeId;
  dynamic fileType;
  String? subject;
  String? description;
  DateTime? createdAt;
  DateTime? updatedAt;
  String? documentType;
  List<dynamic>? files;
  RequestedBy? requestedBy;

  IncomingRequestData({
    this.id,
    this.requestTo,
    this.requestBy,
    this.requestByRole,
    this.uploadedBy,
    this.uploadedByRole,
    this.societyId,
    this.status,
    this.documentTypeId,
    this.fileType,
    this.subject,
    this.description,
    this.createdAt,
    this.updatedAt,
    this.documentType,
    this.files,
    this.requestedBy,
  });

  factory IncomingRequestData.fromJson(Map<String, dynamic> json) =>
      IncomingRequestData(
        id: json["id"],
        requestTo: json["request_to"],
        requestBy: json["request_by"],
        requestByRole: json["request_by_role"],
        uploadedBy: json["uploaded_by"],
        uploadedByRole: json["uploaded_by_role"],
        societyId: json["society_id"],
        status: json["status"],
        documentTypeId: json["document_type_id"],
        fileType: json["file_type"],
        subject: json["subject"],
        description: json["description"],
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null
            ? null
            : DateTime.parse(json["updated_at"]),
        documentType: json["document_type"],
        files: json["files"] == null
            ? []
            : List<dynamic>.from(json["files"]!.map((x) => x)),
        requestedBy: json["requested_by"] == null
            ? null
            : RequestedBy.fromJson(json["requested_by"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "request_to": requestTo,
        "request_by": requestBy,
        "request_by_role": requestByRole,
        "uploaded_by": uploadedBy,
        "uploaded_by_role": uploadedByRole,
        "society_id": societyId,
        "status": status,
        "document_type_id": documentTypeId,
        "file_type": fileType,
        "subject": subject,
        "description": description,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
        "document_type": documentType,
        "files": files == null ? [] : List<dynamic>.from(files!.map((x) => x)),
        "requested_by": requestedBy?.toJson(),
      };
}

class RequestedBy {
  int? id;
  String? uid;
  String? role;
  String? status;
  String? name;
  String? email;
  dynamic emailVerifiedAt;
  String? image;
  String? phone;
  dynamic createdAt;
  DateTime? updatedAt;
  String? deviceId;
  dynamic memberId;
  dynamic societyId;
  dynamic staffId;
  dynamic member;
  dynamic staff;

  RequestedBy({
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
    this.member,
    this.staff,
  });

  factory RequestedBy.fromJson(Map<String, dynamic> json) => RequestedBy(
        id: json["id"],
        uid: json["uid"],
        role: json["role"],
        status: json["status"],
        name: json["name"],
        email: json["email"],
        emailVerifiedAt: json["email_verified_at"],
        image: json["image"],
        phone: json["phone"],
        createdAt: json["created_at"],
        updatedAt: json["updated_at"] == null
            ? null
            : DateTime.parse(json["updated_at"]),
        deviceId: json["device_id"],
        memberId: json["member_id"],
        societyId: json["society_id"],
        staffId: json["staff_id"],
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
        "created_at": createdAt,
        "updated_at": updatedAt?.toIso8601String(),
        "device_id": deviceId,
        "member_id": memberId,
        "society_id": societyId,
        "staff_id": staffId,
        "member": member,
        "staff": staff,
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
