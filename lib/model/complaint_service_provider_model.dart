
import 'dart:convert';

ComlaintsServiceProviderModel comlaintsServiceProviderModelFromJson(String str) => ComlaintsServiceProviderModel.fromJson(json.decode(str));

String comlaintsServiceProviderModelToJson(ComlaintsServiceProviderModel data) => json.encode(data.toJson());

class ComlaintsServiceProviderModel {
  bool status;
  String message;
  Data data;

  ComlaintsServiceProviderModel({
    required this.status,
    required this.message,
    required this.data,
  });

  factory ComlaintsServiceProviderModel.fromJson(Map<String, dynamic> json) => ComlaintsServiceProviderModel(
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
  List<ComplaintCategory> complaintCategories;

  Data({
    required this.complaintCategories,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    complaintCategories: List<ComplaintCategory>.from(json["complaint_categories"].map((x) => ComplaintCategory.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "complaint_categories": List<dynamic>.from(complaintCategories.map((x) => x.toJson())),
  };
}

class ComplaintCategory {
  int id;
  String name;

  ComplaintCategory({
    required this.id,
    required this.name,
  });

  factory ComplaintCategory.fromJson(Map<String, dynamic> json) => ComplaintCategory(
    id: json["id"],
    name: json["name"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
  };
}
