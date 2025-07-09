import 'package:cloud_firestore/cloud_firestore.dart';

class ChatModel {
  String? id;
  String? message;
  String? senderName;
  String? senderId;
  String? receiverId;
  Timestamp? timestamp;
  String? imageUrl;
  List<String> readBy;

  ChatModel({
    this.id,
    this.message,
    this.senderName,
    this.senderId,
    this.receiverId,
    this.timestamp,
    this.imageUrl,
    this.readBy = const [],
  });

  // Named constructor to create a ChatModel instance from JSON
  ChatModel.fromJson(Map<String, dynamic> json)
      : id = json["id"] as String?,
        message = json["message"] as String?,
        senderName = json["senderName"] as String?,
        senderId = json["senderId"] as String?,
        receiverId = json["receiverId"] as String?,
        timestamp = json["timestamp"] as Timestamp?,
        imageUrl = json["imageUrl"] as String?,
        readBy = List<String>.from(json["readBy"] ?? []);

  // Method to convert ChatModel instance to JSON
  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "message": message,
      "senderName": senderName,
      "senderId": senderId,
      "receiverId": receiverId,
      "timestamp": timestamp,
      "imageUrl": imageUrl,
      "readBy": readBy,
    };
  }
}
