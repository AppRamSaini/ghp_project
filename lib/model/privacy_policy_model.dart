
import 'dart:convert';

PrivacyPolicyModel privacyPolicyModelFromJson(String str) => PrivacyPolicyModel.fromJson(json.decode(str));

String privacyPolicyModelToJson(PrivacyPolicyModel data) => json.encode(data.toJson());

class PrivacyPolicyModel {
  bool status;
  String message;
  Data data;

  PrivacyPolicyModel({
    required this.status,
    required this.message,
    required this.data,
  });

  factory PrivacyPolicyModel.fromJson(Map<String, dynamic> json) => PrivacyPolicyModel(
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
  PrivacyPolicy privacyPolicy;

  Data({
    required this.privacyPolicy,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    privacyPolicy: PrivacyPolicy.fromJson(json["privacy_policy"]),
  );

  Map<String, dynamic> toJson() => {
    "privacy_policy": privacyPolicy.toJson(),
  };
}

class PrivacyPolicy {
  int id;
  String name;
  String content;

  PrivacyPolicy({
    required this.id,
    required this.name,
    required this.content,
  });

  factory PrivacyPolicy.fromJson(Map<String, dynamic> json) => PrivacyPolicy(
    id: json["id"],
    name: json["name"],
    content: json["content"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "content": content,
  };
}
