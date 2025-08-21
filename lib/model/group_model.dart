import 'package:cloud_firestore/cloud_firestore.dart';

class GroupModel {
  String? id;
  String? name;
  String? description;
  String? profileUrl;
  List<dynamic>? members;
  List<dynamic>? userIds;

  DateTime? createdAt; // ⬅️ Timestamp को DateTime में बदला
  String? createdBy;
  String? status;
  String? lastMessage;
  DateTime? lastMessageTime; // ⬅️ भी DateTime
  String? lastMessageBy;
  int? unReadCount;
  DateTime? timeStamp; // ⬅️ Timestamp भी safe convert

  GroupModel({
    this.id,
    this.name,
    this.description,
    this.profileUrl,
    this.members,
    this.createdAt,
    this.userIds,
    this.createdBy,
    this.status,
    this.lastMessage,
    this.lastMessageTime,
    this.lastMessageBy,
    this.unReadCount,
    this.timeStamp,
  });

  GroupModel.fromJson(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    id = data["id"];
    name = data["name"];
    description = data["description"];
    profileUrl = data["profileUrl"];
    members = data["members"] ?? [];
    userIds = data["userIds"] ?? [];

    createdAt = _convertToDateTime(data["createdAt"]);
    createdBy = data["createdBy"];
    status = data["status"];
    lastMessage = data["lastMessage"];
    lastMessageTime = _convertToDateTime(data["lastMessageTime"]);
    lastMessageBy = data["lastMessageBy"];
    unReadCount = data["unReadCount"] ?? 0;
    timeStamp = _convertToDateTime(data["timeStamp"]);
  }

  GroupModel.fromMap(Map<String, dynamic> data) {
    id = data["id"];
    name = data["name"];
    description = data["description"];
    profileUrl = data["profileUrl"];
    members = data["members"] ?? [];
    userIds = data["userIds"] ?? [];

    createdAt = _convertToDateTime(data["createdAt"]);
    createdBy = data["createdBy"];
    status = data["status"];
    lastMessage = data["lastMessage"];
    lastMessageTime = _convertToDateTime(data["lastMessageTime"]);
    lastMessageBy = data["lastMessageBy"];
    unReadCount = data["unReadCount"] ?? 0;
    timeStamp = _convertToDateTime(data["timeStamp"]);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> _data = <String, dynamic>{};
    _data["id"] = id;
    _data["name"] = name;
    _data["description"] = description;
    _data["profileUrl"] = profileUrl;
    _data["members"] = members;
    _data["userIds"] = userIds;

    _data["createdAt"] =
        createdAt != null ? Timestamp.fromDate(createdAt!) : null;
    _data["createdBy"] = createdBy;
    _data["status"] = status;
    _data["lastMessage"] = lastMessage;
    _data["lastMessageTime"] =
        lastMessageTime != null ? Timestamp.fromDate(lastMessageTime!) : null;
    _data["lastMessageBy"] = lastMessageBy;
    _data["unReadCount"] = unReadCount;
    _data["timeStamp"] =
        timeStamp != null ? Timestamp.fromDate(timeStamp!) : null;
    return _data;
  }

  /// ✅ Helper method to safely convert Firestore Timestamp or String to DateTime
  DateTime? _convertToDateTime(dynamic value) {
    if (value == null) return null;
    if (value is Timestamp) return value.toDate();
    if (value is String) return DateTime.tryParse(value);
    return null;
  }
}
