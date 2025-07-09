import 'dart:convert';

MembersElementModel membersElementModelFromJson(String str) =>
    MembersElementModel.fromJson(json.decode(str));

String membersElementModelToJson(MembersElementModel data) =>
    json.encode(data.toJson());

class MembersElementModel {
  bool? status;
  String? message;
  Data? data;

  MembersElementModel({
    this.status,
    this.message,
    this.data,
  });

  factory MembersElementModel.fromJson(Map<String, dynamic> json) =>
      MembersElementModel(
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
  List<Block>? blocks;

  Data({
    this.blocks,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        blocks: json["blocks"] == null
            ? []
            : List<Block>.from(json["blocks"]!.map((x) => Block.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "blocks": blocks == null
            ? []
            : List<dynamic>.from(blocks!.map((x) => x.toJson())),
      };
}

class Block {
  String? name;
  List<Floor>? floors;

  Block({
    this.name,
    this.floors,
  });

  factory Block.fromJson(Map<String, dynamic> json) => Block(
        name: json["name"],
        floors: json["floors"] == null
            ? []
            : List<Floor>.from(json["floors"]!.map((x) => Floor.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "floors": floors == null
            ? []
            : List<dynamic>.from(floors!.map((x) => x.toJson())),
      };
}

class Floor {
  String? name;

  Floor({
    this.name,
  });

  factory Floor.fromJson(Map<String, dynamic> json) => Floor(
        name: json["name"],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
      };
}
