
import 'dart:convert';
GetSlidersModel getSlidersModelFromJson(String str) => GetSlidersModel.fromJson(json.decode(str));
String getSlidersModelToJson(GetSlidersModel data) => json.encode(data.toJson());
class GetSlidersModel {
  bool status;
  String message;
  Data data;

  GetSlidersModel({
    required this.status,
    required this.message,
    required this.data,
  });

  factory GetSlidersModel.fromJson(Map<String, dynamic> json) => GetSlidersModel(
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
  List<SliderList> sliders;

  Data({
    required this.sliders,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    sliders: List<SliderList>.from(json["sliders"].map((x) => SliderList.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "sliders": List<dynamic>.from(sliders.map((x) => x.toJson())),
  };
}

class SliderList {
  int id;
  String location;
  String title;
  String subTitle;
  String image;

  SliderList({
    required this.id,
    required this.location,
    required this.title,
    required this.subTitle,
    required this.image,
  });

  factory SliderList.fromJson(Map<String, dynamic> json) => SliderList(
    id: json["id"],
    location: json["location"],
    title: json["title"],
    subTitle: json["sub_title"],
    image: json["image"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "location": location,
    "title": title,
    "sub_title": subTitle,
    "image": image,
  };
}
