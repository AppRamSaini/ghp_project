class SelectSocietyModel {
  bool? status;
  String? message;
  Data? data;

  SelectSocietyModel({this.status, this.message, this.data});

  SelectSocietyModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class Data {
  Societies? societies;

  Data({this.societies});

  Data.fromJson(Map<String, dynamic> json) {
    societies = json['societies'] != null
        ? new Societies.fromJson(json['societies'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.societies != null) {
      data['societies'] = this.societies!.toJson();
    }
    return data;
  }
}

class Societies {
  int? currentPage;
  List<SocietyList>? data;
  String? firstPageUrl;
  int? from;
  int? lastPage;
  String? lastPageUrl;
  List<Links>? links;
  var nextPageUrl;
  String? path;
  int? perPage;
  var prevPageUrl;
  int? to;
  int? total;

  Societies(
      {this.currentPage,
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
      this.total});

  Societies.fromJson(Map<String, dynamic> json) {
    currentPage = json['current_page'];
    if (json['data'] != null) {
      data = <SocietyList>[];
      json['data'].forEach((v) {
        data!.add(SocietyList.fromJson(v));
      });
    }
    firstPageUrl = json['first_page_url'];
    from = json['from'];
    lastPage = json['last_page'];
    lastPageUrl = json['last_page_url'];
    if (json['links'] != null) {
      links = <Links>[];
      json['links'].forEach((v) {
        links!.add(new Links.fromJson(v));
      });
    }
    nextPageUrl = json['next_page_url'];
    path = json['path'];
    perPage = json['per_page'];
    prevPageUrl = json['prev_page_url'];
    to = json['to'];
    total = json['total'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['current_page'] = this.currentPage;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    data['first_page_url'] = this.firstPageUrl;
    data['from'] = this.from;
    data['last_page'] = this.lastPage;
    data['last_page_url'] = this.lastPageUrl;
    if (this.links != null) {
      data['links'] = this.links!.map((v) => v.toJson()).toList();
    }
    data['next_page_url'] = this.nextPageUrl;
    data['path'] = this.path;
    data['per_page'] = this.perPage;
    data['prev_page_url'] = this.prevPageUrl;
    data['to'] = this.to;
    data['total'] = this.total;
    return data;
  }
}

class SocietyList {
  int? id;
  String? name;
  String? location;
  int? floors;
  String? status;
  int? floorUnits;
  var memberId;
  String? createdAt;
  String? updatedAt;
  var deletedAt;
  String? city;
  String? state;
  String? pin;
  String? contact;
  String? email;
  String? registrationNum;
  String? type;
  String? totalArea;
  int? totalTowers;
  String? amenities;
  List<Blocks>? blocks;

  SocietyList(
      {this.id,
      this.name,
      this.location,
      this.floors,
      this.status,
      this.floorUnits,
      this.memberId,
      this.createdAt,
      this.updatedAt,
      this.deletedAt,
      this.city,
      this.state,
      this.pin,
      this.contact,
      this.email,
      this.registrationNum,
      this.type,
      this.totalArea,
      this.totalTowers,
      this.amenities,
      this.blocks});

  SocietyList.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    location = json['location'];
    floors = json['floors'];
    status = json['status'];
    floorUnits = json['floor_units'];
    memberId = json['member_id'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    deletedAt = json['deleted_at'];
    city = json['city'];
    state = json['state'];
    pin = json['pin'];
    contact = json['contact'];
    email = json['email'];
    registrationNum = json['registration_num'];
    type = json['type'];
    totalArea = json['total_area'];
    totalTowers = json['total_towers'];
    amenities = json['amenities'];
    if (json['blocks'] != null) {
      blocks = <Blocks>[];
      json['blocks'].forEach((v) {
        blocks!.add(new Blocks.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['location'] = this.location;
    data['floors'] = this.floors;
    data['status'] = this.status;
    data['floor_units'] = this.floorUnits;
    data['member_id'] = this.memberId;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['deleted_at'] = this.deletedAt;
    data['city'] = this.city;
    data['state'] = this.state;
    data['pin'] = this.pin;
    data['contact'] = this.contact;
    data['email'] = this.email;
    data['registration_num'] = this.registrationNum;
    data['type'] = this.type;
    data['total_area'] = this.totalArea;
    data['total_towers'] = this.totalTowers;
    data['amenities'] = this.amenities;
    if (this.blocks != null) {
      data['blocks'] = this.blocks!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Blocks {
  int? id;
  String? propertyNumber;
  String? floor;
  String? ownership;
  String? bhk;
  String? totalFloor;
  String? unitType;
  String? unitSize;
  int? unitQty;
  String? name;
  int? totalUnits;
  int? societyId;
  String? createdAt;
  String? updatedAt;
  var deletedAt;

  Blocks(
      {this.id,
      this.propertyNumber,
      this.floor,
      this.ownership,
      this.bhk,
      this.totalFloor,
      this.unitType,
      this.unitSize,
      this.unitQty,
      this.name,
      this.totalUnits,
      this.societyId,
      this.createdAt,
      this.updatedAt,
      this.deletedAt});

  Blocks.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    propertyNumber = json['property_number'];
    floor = json['floor'];
    ownership = json['ownership'];
    bhk = json['bhk'];
    totalFloor = json['total_floor'];
    unitType = json['unit_type'];
    unitSize = json['unit_size'];
    unitQty = json['unit_qty'];
    name = json['name'];
    totalUnits = json['total_units'];
    societyId = json['society_id'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    deletedAt = json['deleted_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['property_number'] = this.propertyNumber;
    data['floor'] = this.floor;
    data['ownership'] = this.ownership;
    data['bhk'] = this.bhk;
    data['total_floor'] = this.totalFloor;
    data['unit_type'] = this.unitType;
    data['unit_size'] = this.unitSize;
    data['unit_qty'] = this.unitQty;
    data['name'] = this.name;
    data['total_units'] = this.totalUnits;
    data['society_id'] = this.societyId;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['deleted_at'] = this.deletedAt;
    return data;
  }
}

class Links {
  String? url;
  String? label;
  bool? active;

  Links({this.url, this.label, this.active});

  Links.fromJson(Map<String, dynamic> json) {
    url = json['url'];
    label = json['label'];
    active = json['active'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['url'] = this.url;
    data['label'] = this.label;
    data['active'] = this.active;
    return data;
  }
}
