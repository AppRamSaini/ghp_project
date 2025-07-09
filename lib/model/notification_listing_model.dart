// To parse this JSON data, do
//
//     final notificationListingModel = notificationListingModelFromJson(jsonString);

import 'dart:convert';

NotificationListingModel notificationListingModelFromJson(String str) =>
    NotificationListingModel.fromJson(json.decode(str));

String notificationListingModelToJson(NotificationListingModel data) =>
    json.encode(data.toJson());

class NotificationListingModel {
  bool? status;
  String? message;
  NotificationListingModelData? data;

  NotificationListingModel({
    this.status,
    this.message,
    this.data,
  });

  factory NotificationListingModel.fromJson(Map<String, dynamic> json) =>
      NotificationListingModel(
        status: json["status"],
        message: json["message"],
        data: json["data"] == null
            ? null
            : NotificationListingModelData.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "data": data?.toJson(),
      };
}

class NotificationListingModelData {
  Notifications? notifications;
  int? totalUnreadNotifications;

  NotificationListingModelData({
    this.notifications,
    this.totalUnreadNotifications,
  });

  factory NotificationListingModelData.fromJson(Map<String, dynamic> json) =>
      NotificationListingModelData(
        notifications: json["notifications"] == null
            ? null
            : Notifications.fromJson(json["notifications"]),
        totalUnreadNotifications: json["total_unread_notifications"],
      );

  Map<String, dynamic> toJson() => {
        "notifications": notifications?.toJson(),
        "total_unread_notifications": totalUnreadNotifications,
      };
}

class Notifications {
  int? currentPage;
  List<NotificationList>? data;
  String? firstPageUrl;
  int? from;
  int? lastPage;
  String? lastPageUrl;
  List<Link>? links;
  String? nextPageUrl;
  String? path;
  int? perPage;
  dynamic prevPageUrl;
  int? to;
  int? total;

  Notifications({
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

  factory Notifications.fromJson(Map<String, dynamic> json) => Notifications(
        currentPage: json["current_page"],
        data: json["data"] == null
            ? []
            : List<NotificationList>.from(
                json["data"]!.map((x) => NotificationList.fromJson(x))),
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

class NotificationList {
  String? id;
  DateTime? readAt;
  Type? type;
  Notification? notification;
  DateTime? createdAt;

  NotificationList({
    this.id,
    this.readAt,
    this.type,
    this.notification,
    this.createdAt,
  });

  factory NotificationList.fromJson(Map<String, dynamic> json) =>
      NotificationList(
        id: json["id"],
        readAt:
            json["read_at"] == null ? null : DateTime.parse(json["read_at"]),
        type: typeValues.map[json["type"]]!,
        notification: json["notification"] == null
            ? null
            : Notification.fromJson(json["notification"]),
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "read_at": readAt?.toIso8601String(),
        "type": typeValues.reverse[type],
        "notification": notification?.toJson(),
        "created_at": createdAt?.toIso8601String(),
      };
}

class Notification {
  String? title;
  String? body;
  dynamic data;

  Notification({
    this.title,
    this.body,
    this.data,
  });

  factory Notification.fromJson(Map<String, dynamic> json) => Notification(
        title: json["title"],
        body: json["body"],
        data: json["data"],
      );

  Map<String, dynamic> toJson() => {
        "title": title,
        "body": body,
        "data": data,
      };
}

class DataData {
  String? type;
  String? name;
  String? mob;
  int? visitorId;
  dynamic img;
  String? time;

  DataData({
    this.type,
    this.name,
    this.mob,
    this.visitorId,
    this.img,
    this.time,
  });

  factory DataData.fromJson(Map<String, dynamic> json) => DataData(
        type: json["type"],
        name: json["name"],
        mob: json["mob"],
        visitorId: json["visitor_id"],
        img: json["img"],
        time: json["time"],
      );

  Map<String, dynamic> toJson() => {
        "type": type,
        "name": name,
        "mob": mob,
        "visitor_id": visitorId,
        "img": img,
        "time": time,
      };
}

enum Type { PUSH_NOTIFICATION }

final typeValues = EnumValues({"pushNotification": Type.PUSH_NOTIFICATION});

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

class EnumValues<T> {
  Map<String, T> map;
  late Map<T, String> reverseMap;

  EnumValues(this.map);

  Map<T, String> get reverse {
    reverseMap = map.map((k, v) => MapEntry(v, k));
    return reverseMap;
  }
}
