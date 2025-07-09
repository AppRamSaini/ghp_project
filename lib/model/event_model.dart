// To parse this JSON data, do
//
//     final eventModel = eventModelFromJson(jsonString);

import 'dart:convert';

EventModel eventModelFromJson(String str) =>
    EventModel.fromJson(json.decode(str));

String eventModelToJson(EventModel data) => json.encode(data.toJson());

class EventModel {
  bool status;
  dynamic message;
  Data data;

  EventModel({
    required this.status,
    required this.message,
    required this.data,
  });

  factory EventModel.fromJson(Map<String, dynamic> json) => EventModel(
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
  Events events;

  Data({
    required this.events,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        events: Events.fromJson(json["events"]),
      );

  Map<String, dynamic> toJson() => {
        "events": events.toJson(),
      };
}

class Events {
  int currentPage;
  List<EventsListing> data;
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

  Events({
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

  factory Events.fromJson(Map<String, dynamic> json) => Events(
        currentPage: json["current_page"],
        data: List<EventsListing>.from(
            json["data"].map((x) => EventsListing.fromJson(x))),
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

class EventsListing {
  int id;
  String title;
  String subTitle;
  DateTime date;
  String time;
  String image;
  String description;
  String status;
  int societyId;
  int createdBy;
  dynamic createdAt;
  dynamic updatedAt;
  dynamic deletedAt;

  EventsListing({
    required this.id,
    required this.title,
    required this.subTitle,
    required this.date,
    required this.time,
    required this.image,
    required this.description,
    required this.status,
    required this.societyId,
    required this.createdBy,
    required this.createdAt,
    required this.updatedAt,
    required this.deletedAt,
  });

  factory EventsListing.fromJson(Map<String, dynamic> json) => EventsListing(
        id: json["id"],
        title: json["title"],
        subTitle: json["sub_title"],
        date: DateTime.parse(json["date"]),
        time: json["time"],
        image: json["image"],
        description: json["description"],
        status: json["status"],
        societyId: json["society_id"],
        createdBy: json["created_by"],
        createdAt: json["created_at"],
        updatedAt: json["updated_at"],
        deletedAt: json["deleted_at"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "sub_title": subTitle,
        "date":
            "${date.year.toString().padLeft(4, '0')}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}",
        "time": time,
        "image": image,
        "description": description,
        "status": status,
        "society_id": societyId,
        "created_by": createdBy,
        "created_at": createdAt,
        "updated_at": updatedAt,
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
