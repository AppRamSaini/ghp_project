class SosHistoryModal {
  bool? status;
  String? message;
  Data? data;

  SosHistoryModal({this.status, this.message, this.data});

  SosHistoryModal.fromJson(Map<String, dynamic> json) {
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
  Sos? sos;

  Data({this.sos});

  Data.fromJson(Map<String, dynamic> json) {
    sos = json['sos'] != null ? new Sos.fromJson(json['sos']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.sos != null) {
      data['sos'] = this.sos!.toJson();
    }
    return data;
  }
}

class Sos {
  int? currentPage;
  List<Data>? data;
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

  Sos(
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

  Sos.fromJson(Map<String, dynamic> json) {
    currentPage = json['current_page'];
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add(new Data.fromJson(v));
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

class SosHistoryList {
  int? id;
  int? sosCategoryId;
  int? alertBy;
  int? societyId;
  int? blockId;
  String? area;
  String? description;
  String? phone;
  String? floor;
  String? unitNo;
  String? unitType;
  String? date;
  String? time;
  String? status;
  String? createdAt;
  String? updatedAt;
  var deletedAt;
  String? acknowledgedAt;
  AcknowledgedBy? acknowledgedBy;
  SosCategory? sosCategory;
  User? user;
  SosCategory? society;
  Block? block;

  SosHistoryList(
      {this.id,
      this.sosCategoryId,
      this.alertBy,
      this.societyId,
      this.blockId,
      this.area,
      this.description,
      this.phone,
      this.floor,
      this.unitNo,
      this.unitType,
      this.date,
      this.time,
      this.status,
      this.createdAt,
      this.updatedAt,
      this.deletedAt,
      this.acknowledgedAt,
      this.acknowledgedBy,
      this.sosCategory,
      this.user,
      this.society,
      this.block});

  SosHistoryList.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    sosCategoryId = json['sos_category_id'];
    alertBy = json['alert_by'];
    societyId = json['society_id'];
    blockId = json['block_id'];
    area = json['area'];
    description = json['description'];
    phone = json['phone'];
    floor = json['floor'];
    unitNo = json['unit_no'];
    unitType = json['unit_type'];
    date = json['date'];
    time = json['time'];
    status = json['status'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    deletedAt = json['deleted_at'];
    acknowledgedAt = json['acknowledged_at'];
    acknowledgedBy = json['acknowledged_by'] != null
        ? new AcknowledgedBy.fromJson(json['acknowledged_by'])
        : null;
    sosCategory = json['sos_category'] != null
        ? new SosCategory.fromJson(json['sos_category'])
        : null;
    user = json['user'] != null ? new User.fromJson(json['user']) : null;
    society = json['society'] != null
        ? new SosCategory.fromJson(json['society'])
        : null;
    block = json['block'] != null ? new Block.fromJson(json['block']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['sos_category_id'] = this.sosCategoryId;
    data['alert_by'] = this.alertBy;
    data['society_id'] = this.societyId;
    data['block_id'] = this.blockId;
    data['area'] = this.area;
    data['description'] = this.description;
    data['phone'] = this.phone;
    data['floor'] = this.floor;
    data['unit_no'] = this.unitNo;
    data['unit_type'] = this.unitType;
    data['date'] = this.date;
    data['time'] = this.time;
    data['status'] = this.status;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['deleted_at'] = this.deletedAt;
    data['acknowledged_at'] = this.acknowledgedAt;
    if (this.acknowledgedBy != null) {
      data['acknowledged_by'] = this.acknowledgedBy!.toJson();
    }
    if (this.sosCategory != null) {
      data['sos_category'] = this.sosCategory!.toJson();
    }
    if (this.user != null) {
      data['user'] = this.user!.toJson();
    }
    if (this.society != null) {
      data['society'] = this.society!.toJson();
    }
    if (this.block != null) {
      data['block'] = this.block!.toJson();
    }
    return data;
  }
}

class AcknowledgedBy {
  int? id;
  String? role;
  String? name;
  String? phone;
  String? image;
  var memberId;
  int? societyId;
  int? staffId;
  var member;
  Staff? staff;

  AcknowledgedBy(
      {this.id,
      this.role,
      this.name,
      this.phone,
      this.image,
      this.memberId,
      this.societyId,
      this.staffId,
      this.member,
      this.staff});

  AcknowledgedBy.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    role = json['role'];
    name = json['name'];
    phone = json['phone'];
    image = json['image'];
    memberId = json['member_id'];
    societyId = json['society_id'];
    staffId = json['staff_id'];
    member = json['member'];
    staff = json['staff'] != null ? new Staff.fromJson(json['staff']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['role'] = this.role;
    data['name'] = this.name;
    data['phone'] = this.phone;
    data['image'] = this.image;
    data['member_id'] = this.memberId;
    data['society_id'] = this.societyId;
    data['staff_id'] = this.staffId;
    data['member'] = this.member;
    if (this.staff != null) {
      data['staff'] = this.staff!.toJson();
    }
    return data;
  }
}

class Staff {
  int? id;
  String? role;
  var complaintCategoryId;
  String? name;
  String? status;
  String? phone;
  String? email;
  String? address;
  String? cardType;
  String? cardNumber;
  String? cardFile;
  int? userId;
  int? societyId;
  String? gender;
  String? dob;
  String? assignedArea;
  String? employeeId;
  String? shiftFrom;
  String? shiftTo;
  String? offDays;
  var emerName;
  var emerRelation;
  var emerPhone;
  String? dateOfJoin;
  String? contractEndDate;
  String? monthlySalary;
  String? createdAt;
  String? updatedAt;
  var deletedAt;

  Staff(
      {this.id,
      this.role,
      this.complaintCategoryId,
      this.name,
      this.status,
      this.phone,
      this.email,
      this.address,
      this.cardType,
      this.cardNumber,
      this.cardFile,
      this.userId,
      this.societyId,
      this.gender,
      this.dob,
      this.assignedArea,
      this.employeeId,
      this.shiftFrom,
      this.shiftTo,
      this.offDays,
      this.emerName,
      this.emerRelation,
      this.emerPhone,
      this.dateOfJoin,
      this.contractEndDate,
      this.monthlySalary,
      this.createdAt,
      this.updatedAt,
      this.deletedAt});

  Staff.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    role = json['role'];
    complaintCategoryId = json['complaint_category_id'];
    name = json['name'];
    status = json['status'];
    phone = json['phone'];
    email = json['email'];
    address = json['address'];
    cardType = json['card_type'];
    cardNumber = json['card_number'];
    cardFile = json['card_file'];
    userId = json['user_id'];
    societyId = json['society_id'];
    gender = json['gender'];
    dob = json['dob'];
    assignedArea = json['assigned_area'];
    employeeId = json['employee_id'];
    shiftFrom = json['shift_from'];
    shiftTo = json['shift_to'];
    offDays = json['off_days'];
    emerName = json['emer_name'];
    emerRelation = json['emer_relation'];
    emerPhone = json['emer_phone'];
    dateOfJoin = json['date_of_join'];
    contractEndDate = json['contract_end_date'];
    monthlySalary = json['monthly_salary'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    deletedAt = json['deleted_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['role'] = this.role;
    data['complaint_category_id'] = this.complaintCategoryId;
    data['name'] = this.name;
    data['status'] = this.status;
    data['phone'] = this.phone;
    data['email'] = this.email;
    data['address'] = this.address;
    data['card_type'] = this.cardType;
    data['card_number'] = this.cardNumber;
    data['card_file'] = this.cardFile;
    data['user_id'] = this.userId;
    data['society_id'] = this.societyId;
    data['gender'] = this.gender;
    data['dob'] = this.dob;
    data['assigned_area'] = this.assignedArea;
    data['employee_id'] = this.employeeId;
    data['shift_from'] = this.shiftFrom;
    data['shift_to'] = this.shiftTo;
    data['off_days'] = this.offDays;
    data['emer_name'] = this.emerName;
    data['emer_relation'] = this.emerRelation;
    data['emer_phone'] = this.emerPhone;
    data['date_of_join'] = this.dateOfJoin;
    data['contract_end_date'] = this.contractEndDate;
    data['monthly_salary'] = this.monthlySalary;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['deleted_at'] = this.deletedAt;
    return data;
  }
}

class SosCategory {
  int? id;
  String? name;

  SosCategory({this.id, this.name});

  SosCategory.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    return data;
  }
}

class User {
  int? id;
  String? name;
  String? phone;
  int? memberId;
  var societyId;
  int? staffId;
  Member? member;
  UserStaff? staff;

  User(
      {this.id,
      this.name,
      this.phone,
      this.memberId,
      this.societyId,
      this.staffId,
      this.member,
      this.staff});

  User.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    phone = json['phone'];
    memberId = json['member_id'];
    societyId = json['society_id'];
    staffId = json['staff_id'];
    member = json['member'] != null ? Member.fromJson(json['member']) : null;
    staff = json['staff'] != null ? UserStaff.fromJson(json['staff']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['phone'] = this.phone;
    data['member_id'] = this.memberId;
    data['society_id'] = this.societyId;
    data['staff_id'] = this.staffId;
    if (this.member != null) {
      data['member'] = this.member!.toJson();
    }
    if (this.staff != null) {
      data['staff'] = this.staff!.toJson();
    }
    return data;
  }
}

class Member {
  int? id;
  String? name;
  String? role;
  String? phone;
  String? email;
  String? status;
  int? userId;
  int? societyId;
  int? blockId;
  String? floorNumber;
  String? unitType;
  String? aprtNo;
  String? ownershipType;
  var ownerName;
  var emerName;
  var emerRelation;
  var emerPhone;
  String? createdAt;
  String? updatedAt;
  var deletedAt;

  Member(
      {this.id,
      this.name,
      this.role,
      this.phone,
      this.email,
      this.status,
      this.userId,
      this.societyId,
      this.blockId,
      this.floorNumber,
      this.unitType,
      this.aprtNo,
      this.ownershipType,
      this.ownerName,
      this.emerName,
      this.emerRelation,
      this.emerPhone,
      this.createdAt,
      this.updatedAt,
      this.deletedAt});

  Member.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    role = json['role'];
    phone = json['phone'];
    email = json['email'];
    status = json['status'];
    userId = json['user_id'];
    societyId = json['society_id'];
    blockId = json['block_id'];
    floorNumber = json['floor_number'];
    unitType = json['unit_type'];
    aprtNo = json['aprt_no'];
    ownershipType = json['ownership_type'];
    ownerName = json['owner_name'];
    emerName = json['emer_name'];
    emerRelation = json['emer_relation'];
    emerPhone = json['emer_phone'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    deletedAt = json['deleted_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['role'] = this.role;
    data['phone'] = this.phone;
    data['email'] = this.email;
    data['status'] = this.status;
    data['user_id'] = this.userId;
    data['society_id'] = this.societyId;
    data['block_id'] = this.blockId;
    data['floor_number'] = this.floorNumber;
    data['unit_type'] = this.unitType;
    data['aprt_no'] = this.aprtNo;
    data['ownership_type'] = this.ownershipType;
    data['owner_name'] = this.ownerName;
    data['emer_name'] = this.emerName;
    data['emer_relation'] = this.emerRelation;
    data['emer_phone'] = this.emerPhone;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['deleted_at'] = this.deletedAt;
    return data;
  }
}

class UserStaff {
  int? id;
  String? role;
  var complaintCategoryId;
  String? name;
  String? status;
  String? phone;
  String? email;
  String? address;
  String? cardType;
  String? cardNumber;
  String? cardFile;
  int? userId;
  int? societyId;
  String? gender;
  String? dob;
  String? assignedArea;
  String? employeeId;
  String? shiftFrom;
  String? shiftTo;
  String? offDays;
  var emerName;
  var emerRelation;
  var emerPhone;
  var dateOfJoin;
  var contractEndDate;
  String? monthlySalary;
  String? createdAt;
  String? updatedAt;
  var deletedAt;

  UserStaff(
      {this.id,
      this.role,
      this.complaintCategoryId,
      this.name,
      this.status,
      this.phone,
      this.email,
      this.address,
      this.cardType,
      this.cardNumber,
      this.cardFile,
      this.userId,
      this.societyId,
      this.gender,
      this.dob,
      this.assignedArea,
      this.employeeId,
      this.shiftFrom,
      this.shiftTo,
      this.offDays,
      this.emerName,
      this.emerRelation,
      this.emerPhone,
      this.dateOfJoin,
      this.contractEndDate,
      this.monthlySalary,
      this.createdAt,
      this.updatedAt,
      this.deletedAt});

  UserStaff.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    role = json['role'];
    complaintCategoryId = json['complaint_category_id'];
    name = json['name'];
    status = json['status'];
    phone = json['phone'];
    email = json['email'];
    address = json['address'];
    cardType = json['card_type'];
    cardNumber = json['card_number'];
    cardFile = json['card_file'];
    userId = json['user_id'];
    societyId = json['society_id'];
    gender = json['gender'];
    dob = json['dob'];
    assignedArea = json['assigned_area'];
    employeeId = json['employee_id'];
    shiftFrom = json['shift_from'];
    shiftTo = json['shift_to'];
    offDays = json['off_days'];
    emerName = json['emer_name'];
    emerRelation = json['emer_relation'];
    emerPhone = json['emer_phone'];
    dateOfJoin = json['date_of_join'];
    contractEndDate = json['contract_end_date'];
    monthlySalary = json['monthly_salary'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    deletedAt = json['deleted_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['role'] = this.role;
    data['complaint_category_id'] = this.complaintCategoryId;
    data['name'] = this.name;
    data['status'] = this.status;
    data['phone'] = this.phone;
    data['email'] = this.email;
    data['address'] = this.address;
    data['card_type'] = this.cardType;
    data['card_number'] = this.cardNumber;
    data['card_file'] = this.cardFile;
    data['user_id'] = this.userId;
    data['society_id'] = this.societyId;
    data['gender'] = this.gender;
    data['dob'] = this.dob;
    data['assigned_area'] = this.assignedArea;
    data['employee_id'] = this.employeeId;
    data['shift_from'] = this.shiftFrom;
    data['shift_to'] = this.shiftTo;
    data['off_days'] = this.offDays;
    data['emer_name'] = this.emerName;
    data['emer_relation'] = this.emerRelation;
    data['emer_phone'] = this.emerPhone;
    data['date_of_join'] = this.dateOfJoin;
    data['contract_end_date'] = this.contractEndDate;
    data['monthly_salary'] = this.monthlySalary;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['deleted_at'] = this.deletedAt;
    return data;
  }
}

class Block {
  int? id;
  String? name;
  String? floor;
  String? propertyNumber;
  String? unitType;

  Block({this.id, this.name, this.floor, this.propertyNumber, this.unitType});

  Block.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    floor = json['floor'];
    propertyNumber = json['property_number'];
    unitType = json['unit_type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['floor'] = this.floor;
    data['property_number'] = this.propertyNumber;
    data['unit_type'] = this.unitType;
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
