import 'dart:convert';

SosCategoryModel sosCategoryModelFromJson(String str) => SosCategoryModel.fromJson(json.decode(str));

String sosCategoryModelToJson(SosCategoryModel data) => json.encode(data.toJson());

class SosCategoryModel {
  final bool status;
  final String message;
  final Data? data;

  SosCategoryModel({
    required this.status,
    required this.message,
    this.data,
  });

  factory SosCategoryModel.fromJson(Map<String, dynamic> json) => SosCategoryModel(
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
  final List<SosCategory> sosCategories;

  Data({
    required this.sosCategories,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    sosCategories: json["sos_categories"] != null
        ? List<SosCategory>.from(
        json["sos_categories"].map((x) => SosCategory.fromJson(x)))
        : [],
  );

  Map<String, dynamic> toJson() => {
    "sos_categories": List<dynamic>.from(sosCategories.map((x) => x.toJson())),
  };
}

class SosCategory {
  final int id;
  final String name;
  final String image;
  final EmergencyDetails? emergencyDetails;

  SosCategory({
    required this.id,
    required this.name,
    required this.image,
    this.emergencyDetails,
  });

  factory SosCategory.fromJson(Map<String, dynamic> json) => SosCategory(
    id: json["id"] ?? 0,
    name: json["name"] ?? '',
    image: json["image"] ?? '',
    emergencyDetails: json["emergency_details"] != null
        ? EmergencyDetails.fromJson(json["emergency_details"])
        : null,
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "image": image,
    "emergency_details": emergencyDetails?.toJson(),
  };
}

class EmergencyDetails {
  final List<Action> actions;
  final List<Action> contacts;

  EmergencyDetails({
    required this.actions,
    required this.contacts,
  });

  factory EmergencyDetails.fromJson(Map<String, dynamic> json) => EmergencyDetails(
    actions: json["actions"] != null
        ? List<Action>.from(json["actions"].map((x) => Action.fromJson(x)))
        : [],
    contacts: json["contacts"] != null
        ? List<Action>.from(json["contacts"].map((x) => Action.fromJson(x)))
        : [],
  );

  Map<String, dynamic> toJson() => {
    "actions": List<dynamic>.from(actions.map((x) => x.toJson())),
    "contacts": List<dynamic>.from(contacts.map((x) => x.toJson())),
  };
}

class Action {
  final int id;
  final String name;
  final String type;
  final int sosCategoryId;
  final int societyId;
  final String? phone;

  Action({
    required this.id,
    required this.name,
    required this.type,
    required this.sosCategoryId,
    required this.societyId,
    this.phone,
  });

  factory Action.fromJson(Map<String, dynamic> json) => Action(
    id: json["id"] ?? 0,
    name: json["name"] ?? '',
    type: json["type"] ?? '',
    sosCategoryId: json["sos_category_id"] ?? 0,
    societyId: json["society_id"] ?? 0,
    phone: json["phone"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "type": type,
    "sos_category_id": sosCategoryId,
    "society_id": societyId,
    "phone": phone,
  };
}
