// To parse this JSON data, do
//
//     final propertyElementModel = propertyElementModelFromJson(jsonString);

import 'dart:convert';

PropertyElementModel propertyElementModelFromJson(String str) => PropertyElementModel.fromJson(json.decode(str));

String propertyElementModelToJson(PropertyElementModel data) => json.encode(data.toJson());

class PropertyElementModel {
  bool status;
  String message;
  PropertyElement data;

  PropertyElementModel({
    required this.status,
    required this.message,
    required this.data,
  });

  factory PropertyElementModel.fromJson(Map<String, dynamic> json) => PropertyElementModel(
    status: json["status"],
    message: json["message"],
    data: PropertyElement.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "message": message,
    "data": data.toJson(),
  };
}

class PropertyElement {
  List<Block> blocks;
  List<Floor> floors;
  List<Amenity> unitType;
  List<Amenity> bhks;
  List<Amenity> amenities;

  PropertyElement({
    required this.blocks,
    required this.floors,
    required this.unitType,
    required this.bhks,
    required this.amenities,
  });

  factory PropertyElement.fromJson(Map<String, dynamic> json) => PropertyElement(
    blocks: List<Block>.from(json["blocks"].map((x) => Block.fromJson(x))),
    floors: List<Floor>.from(json["floors"].map((x) => Floor.fromJson(x))),
    unitType: List<Amenity>.from(json["unit_type"].map((x) => Amenity.fromJson(x))),
    bhks: List<Amenity>.from(json["bhks"].map((x) => Amenity.fromJson(x))),
    amenities: List<Amenity>.from(json["amenities"].map((x) => Amenity.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "blocks": List<dynamic>.from(blocks.map((x) => x.toJson())),
    "floors": List<dynamic>.from(floors.map((x) => x.toJson())),
    "unit_type": List<dynamic>.from(unitType.map((x) => x.toJson())),
    "bhks": List<dynamic>.from(bhks.map((x) => x.toJson())),
    "amenities": List<dynamic>.from(amenities.map((x) => x.toJson())),
  };
}

class Amenity {
  String name;

  Amenity({
    required this.name,
  });

  factory Amenity.fromJson(Map<String, dynamic> json) => Amenity(
    name: json["name"],
  );

  Map<String, dynamic> toJson() => {
    "name": name,
  };
}

class Block {
  int id;
  String name;

  Block({
    required this.id,
    required this.name,
  });

  factory Block.fromJson(Map<String, dynamic> json) => Block(
    id: json["id"],
    name: json["name"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
  };
}

class Floor {
  int name;

  Floor({
    required this.name,
  });

  factory Floor.fromJson(Map<String, dynamic> json) => Floor(
    name: json["name"],
  );

  Map<String, dynamic> toJson() => {
    "name": name,
  };
}
