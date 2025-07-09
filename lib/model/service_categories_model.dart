// To parse this JSON data, do
//
//     final serviceCategoriesModel = serviceCategoriesModelFromJson(jsonString);

import 'dart:convert';

ServiceCategoriesModel serviceCategoriesModelFromJson(String str) =>
    ServiceCategoriesModel.fromJson(json.decode(str));

String serviceCategoriesModelToJson(ServiceCategoriesModel data) =>
    json.encode(data.toJson());

class ServiceCategoriesModel {
  bool status;
  String message;
  Data data;

  ServiceCategoriesModel({
    required this.status,
    required this.message,
    required this.data,
  });

  factory ServiceCategoriesModel.fromJson(Map<String, dynamic> json) =>
      ServiceCategoriesModel(
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
  List<ServiceCategory> serviceCategories;

  Data({
    required this.serviceCategories,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        serviceCategories: List<ServiceCategory>.from(
            json["service_categories"].map((x) => ServiceCategory.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "service_categories":
            List<dynamic>.from(serviceCategories.map((x) => x.toJson())),
      };
}

class ServiceCategory {
  int id;
  String name;
  String image;

  ServiceCategory({
    required this.id,
    required this.name,
    required this.image,
  });

  factory ServiceCategory.fromJson(Map<String, dynamic> json) =>
      ServiceCategory(
        id: json["id"],
        name: json["name"],
        image: json["image"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "image": image,
      };
}
