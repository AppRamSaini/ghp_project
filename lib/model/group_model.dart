import 'package:cloud_firestore/cloud_firestore.dart';

class GroupModel {
  String? id;
  String? name;
  String? description;
  String? profileUrl;
  List<dynamic>? members;
  List<dynamic>? userIds;

  String? createdAt;
  String? createdBy;
  String? status;
  String? lastMessage;
  String? lastMessageTime;
  String? lastMessageBy;
  int? unReadCount;
  Timestamp? timeStamp;

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

    createdAt = data["createdAt"];
    createdBy = data["createdBy"];
    status = data["status"];
    lastMessage = data["lastMessage"];
    lastMessageTime = data["lastMessageTime"];
    lastMessageBy = data["lastMessageBy"];
    unReadCount = data["unReadCount"];
    timeStamp = data["timeStamp"];
  }

  // New constructor to handle Map<String, dynamic> directly
  GroupModel.fromMap(Map<String, dynamic> data) {
    id = data["id"];
    name = data["name"];
    description = data["description"];
    profileUrl = data["profileUrl"];
    members = data["members"] ?? [];
    userIds = data["userIds"] ?? [];

    createdAt = data["createdAt"];
    createdBy = data["createdBy"];
    status = data["status"];
    lastMessage = data["lastMessage"];
    lastMessageTime = data["lastMessageTime"];
    lastMessageBy = data["lastMessageBy"];
    unReadCount = data["unReadCount"];
    timeStamp = data["timeStamp"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> _data = <String, dynamic>{};
    _data["id"] = id;
    _data["name"] = name;
    _data["description"] = description;
    _data["profileUrl"] = profileUrl;
    _data["members"] = members;
    _data["userIds"] = userIds;

    _data["createdAt"] = createdAt;
    _data["createdBy"] = createdBy;
    _data["status"] = status;
    _data["lastMessage"] = lastMessage;
    _data["lastMessageTime"] = lastMessageTime;
    _data["lastMessageBy"] = lastMessageBy;
    _data["unReadCount"] = unReadCount;
    _data["timeStamp"] = timeStamp;
    return _data;
  }
}
