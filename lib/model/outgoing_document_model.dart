import 'dart:convert';

OutgoingDocumentModel outgoingDocumentModelFromJson(String str) =>
    OutgoingDocumentModel.fromJson(json.decode(str));

String outgoingDocumentModelToJson(OutgoingDocumentModel data) =>
    json.encode(data.toJson());

class OutgoingDocumentModel {
  bool status;
  String message;
  Data? data;

  OutgoingDocumentModel(
      {required this.status, required this.message, this.data});

  factory OutgoingDocumentModel.fromJson(Map<String, dynamic> json) =>
      OutgoingDocumentModel(
        status: json["status"] ?? false,
        message: json["message"] ?? '',
        data: json["data"] != null ? Data.fromJson(json["data"]) : null,
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "data": data?.toJson(),
      };
}

class Data {
  OutgoingRequests? outgoingRequests;

  Data({this.outgoingRequests});

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        outgoingRequests: json["outgoing_requests"] != null
            ? OutgoingRequests.fromJson(json["outgoing_requests"])
            : null,
      );

  Map<String, dynamic> toJson() => {
        "outgoing_requests": outgoingRequests?.toJson(),
      };
}

class OutgoingRequests {
  int? currentPage;
  List<RequestData>? data;
  String? firstPageUrl;
  int? from;
  int? lastPage;
  String? lastPageUrl;
  List<Link>? links;
  String? nextPageUrl;
  String? path;
  int? perPage;
  String? prevPageUrl;
  int? to;
  int? total;

  OutgoingRequests({
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

  factory OutgoingRequests.fromJson(Map<String, dynamic> json) =>
      OutgoingRequests(
        currentPage: json["current_page"],
        data: json["data"] != null
            ? List<RequestData>.from(
                json["data"].map((x) => RequestData.fromJson(x)))
            : [],
        firstPageUrl: json["first_page_url"],
        from: json["from"],
        lastPage: json["last_page"],
        lastPageUrl: json["last_page_url"],
        links: json["links"] != null
            ? List<Link>.from(json["links"].map((x) => Link.fromJson(x)))
            : [],
        nextPageUrl: json["next_page_url"],
        path: json["path"],
        perPage: json["per_page"],
        prevPageUrl: json["prev_page_url"],
        to: json["to"],
        total: json["total"],
      );

  Map<String, dynamic> toJson() => {
        "current_page": currentPage,
        "data": data != null
            ? List<dynamic>.from(data!.map((x) => x.toJson()))
            : [],
        "first_page_url": firstPageUrl,
        "from": from,
        "last_page": lastPage,
        "last_page_url": lastPageUrl,
        "links": links != null
            ? List<dynamic>.from(links!.map((x) => x.toJson()))
            : [],
        "next_page_url": nextPageUrl,
        "path": path,
        "per_page": perPage,
        "prev_page_url": prevPageUrl,
        "to": to,
        "total": total,
      };
}

class RequestData {
  int? id;
  dynamic requestTo;
  int? requestBy;
  String? requestByRole;
  int? uploadedBy;
  String? uploadedByRole;
  int? societyId;
  String? status;
  String? documentType;
  int? documentTypeId;
  dynamic fileType;
  String? subject;
  String? description;
  DateTime? createdAt;
  DateTime? updatedAt;
  List<FileElement>? files;
  RequestedBy? requestedBy;

  RequestData({
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
    this.files,
    this.documentType,
    this.requestedBy,
  });

  factory RequestData.fromJson(Map<String, dynamic> json) => RequestData(
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
        documentType: json["document_type"],
        description: json["description"],
        createdAt: json["created_at"] != null
            ? DateTime.parse(json["created_at"])
            : null,
        updatedAt: json["updated_at"] != null
            ? DateTime.parse(json["updated_at"])
            : null,
        files: json["files"] != null
            ? List<FileElement>.from(
                json["files"].map((x) => FileElement.fromJson(x)))
            : [],
        requestedBy: json["requested_by"] != null
            ? RequestedBy.fromJson(json["requested_by"])
            : null,
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
        "document_type": documentType,
        "description": description,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
        "files": files != null
            ? List<dynamic>.from(files!.map((x) => x.toJson()))
            : [],
        "requested_by": requestedBy?.toJson(),
      };
}

class FileElement {
  int? id;
  int? documentId;
  String? name;
  String? path;

  FileElement({this.id, this.documentId, this.name, this.path});

  factory FileElement.fromJson(Map<String, dynamic> json) => FileElement(
        id: json["id"],
        documentId: json["document_id"],
        name: json["name"],
        path: json["path"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "document_id": documentId,
        "name": name,
        "path": path,
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
  int? memberId;
  int? societyId;
  dynamic staffId;
  Member? member;
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
        updatedAt: json["updated_at"] != null
            ? DateTime.parse(json["updated_at"])
            : null,
        memberId: json["member_id"],
        societyId: json["society_id"],
        staffId: json["staff_id"],
        member: json["member"] != null ? Member.fromJson(json["member"]) : null,
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
        "member_id": memberId,
        "society_id": societyId,
        "staff_id": staffId,
        "member": member?.toJson(),
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
  dynamic createdAt;
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
        createdAt: json["created_at"],
        updatedAt: json["updated_at"] != null
            ? DateTime.parse(json["updated_at"])
            : null,
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
        "created_at": createdAt,
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
