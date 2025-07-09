import 'dart:convert';

ParcelListingModel parcelListingModelFromJson(String str) =>
    ParcelListingModel.fromJson(json.decode(str));

String parcelListingModelToJson(ParcelListingModel data) =>
    json.encode(data.toJson());

class ParcelListingModel {
  bool? status;
  String? message;
  Data? data;

  ParcelListingModel({
    this.status,
    this.message,
    this.data,
  });

  factory ParcelListingModel.fromJson(Map<String, dynamic> json) =>
      ParcelListingModel(
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
  Parcels? parcels;

  Data({
    this.parcels,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        parcels:
            json["parcels"] == null ? null : Parcels.fromJson(json["parcels"]),
      );

  Map<String, dynamic> toJson() => {
        "parcels": parcels?.toJson(),
      };
}

class Parcels {
  int? currentPage;
  List<ParcelListing>? data;
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

  Parcels({
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

  factory Parcels.fromJson(Map<String, dynamic> json) => Parcels(
        currentPage: json["current_page"],
        data: json["data"] == null
            ? []
            : List<ParcelListing>.from(
                json["data"]!.map((x) => ParcelListing.fromJson(x))),
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

class ParcelListing {
  int? id;
  String? parcelid;
  String? parcelName;
  int? noOfParcel;
  String? parcelType;
  DateTime? date;
  String? time;
  String? deliveryName;
  String? deliveryPhone;
  String? parcelCompanyName;
  String? deliveryAgentImage;
  int? parcelOf;
  int? entryBy;
  String? entryByRole;
  DateTime? entryAt;
  String? deliveryOption;
  String? receivedByRole;
  int? receivedBy;
  DateTime? receivedAt;
  String? handoverStatus;
  dynamic handoverTo;
  dynamic handoverAt;
  int? societyId;
  DateTime? createdAt;
  DateTime? updatedAt;
  Member? member;
  CheckinDetail? checkinDetail;
  ParcelComplaint? parcelComplaint;

  ParcelListing({
    this.id,
    this.parcelid,
    this.parcelName,
    this.noOfParcel,
    this.parcelType,
    this.date,
    this.time,
    this.deliveryName,
    this.deliveryPhone,
    this.deliveryAgentImage,
    this.parcelCompanyName,
    this.parcelOf,
    this.entryBy,
    this.entryByRole,
    this.entryAt,
    this.deliveryOption,
    this.receivedByRole,
    this.receivedBy,
    this.receivedAt,
    this.handoverStatus,
    this.handoverTo,
    this.handoverAt,
    this.societyId,
    this.createdAt,
    this.updatedAt,
    this.member,
    this.checkinDetail,
    this.parcelComplaint,
  });

  factory ParcelListing.fromJson(Map<String, dynamic> json) => ParcelListing(
        id: json["id"],
        parcelid: json["parcelid"],
        parcelName: json["parcel_name"],
        noOfParcel: json["no_of_parcel"],
        parcelType: json["parcel_type"],
        date: json["date"] == null ? null : DateTime.parse(json["date"]),
        time: json["time"],
        deliveryName: json["delivery_name"],
        deliveryPhone: json["delivery_phone"],
        deliveryAgentImage: json["delivery_agent_image"],
        parcelCompanyName: json["parcel_company_name"],
        parcelOf: json["parcel_of"],
        entryBy: json["entry_by"],
        entryByRole: json["entry_by_role"],
        entryAt:
            json["entry_at"] == null ? null : DateTime.parse(json["entry_at"]),
        deliveryOption: json["delivery_option"],
        receivedByRole: json["received_by_role"],
        receivedBy: json["received_by"],
        receivedAt: json["received_at"] == null
            ? null
            : DateTime.parse(json["received_at"]),
        handoverStatus: json["handover_status"],
        handoverTo: json["handover_to"],
        handoverAt: json["handover_at"],
        societyId: json["society_id"],
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null
            ? null
            : DateTime.parse(json["updated_at"]),
        member: json["member"] == null ? null : Member.fromJson(json["member"]),
        checkinDetail: json["checkin_detail"] == null
            ? null
            : CheckinDetail.fromJson(json["checkin_detail"]),
        parcelComplaint: json["parcel_complaint"] == null
            ? null
            : ParcelComplaint.fromJson(json["parcel_complaint"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "parcelid": parcelid,
        "parcel_name": parcelName,
        "no_of_parcel": noOfParcel,
        "parcel_type": parcelType,
        "date":
            "${date!.year.toString().padLeft(4, '0')}-${date!.month.toString().padLeft(2, '0')}-${date!.day.toString().padLeft(2, '0')}",
        "time": time,
        "delivery_name": deliveryName,
        "delivery_phone": deliveryPhone,
        "parcel_company_name": parcelCompanyName,
        "delivery_agent_image": deliveryAgentImage,
        "parcel_of": parcelOf,
        "entry_by": entryBy,
        "entry_by_role": entryByRole,
        "entry_at": entryAt?.toIso8601String(),
        "delivery_option": deliveryOption,
        "received_by_role": receivedByRole,
        "received_by": receivedBy,
        "received_at": receivedAt?.toIso8601String(),
        "handover_status": handoverStatus,
        "handover_to": handoverTo,
        "handover_at": handoverAt,
        "society_id": societyId,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
        "member": member?.toJson(),
        "checkin_detail": checkinDetail?.toJson(),
        "parcel_complaint": parcelComplaint?.toJson(),
      };
}

class CheckinDetail {
  int? id;
  dynamic visitorId;
  String? status;
  dynamic requestedAt;
  DateTime? checkinAt;
  DateTime? checkoutAt;
  dynamic requestBy;
  int? checkinBy;
  dynamic checkoutBy;
  int? visitorOf;
  int? societyId;
  DateTime? createdAt;
  DateTime? updatedAt;
  int? parcelId;

  CheckinDetail({
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

  factory CheckinDetail.fromJson(Map<String, dynamic> json) => CheckinDetail(
        id: json["id"],
        visitorId: json["visitor_id"],
        status: json["status"],
        requestedAt: json["requested_at"],
        checkinAt: json["checkin_at"] == null
            ? null
            : DateTime.parse(json["checkin_at"]),
        checkoutAt: json["checkout_at"] == null
            ? null
            : DateTime.parse(json["checkout_at"]),
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
        "checkout_at": checkoutAt?.toIso8601String(),
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

class ParcelComplaint {
  int? id;
  int? parcelId;
  DateTime? date;
  String? time;
  String? description;
  int? complainOf;
  int? societyId;
  DateTime? createdAt;
  DateTime? updatedAt;

  ParcelComplaint({
    this.id,
    this.parcelId,
    this.date,
    this.time,
    this.description,
    this.complainOf,
    this.societyId,
    this.createdAt,
    this.updatedAt,
  });

  factory ParcelComplaint.fromJson(Map<String, dynamic> json) =>
      ParcelComplaint(
        id: json["id"],
        parcelId: json["parcel_id"],
        date: json["date"] == null ? null : DateTime.parse(json["date"]),
        time: json["time"],
        description: json["description"],
        complainOf: json["complain_of"],
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
        "parcel_id": parcelId,
        "date":
            "${date!.year.toString().padLeft(4, '0')}-${date!.month.toString().padLeft(2, '0')}-${date!.day.toString().padLeft(2, '0')}",
        "time": time,
        "description": description,
        "complain_of": complainOf,
        "society_id": societyId,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
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
