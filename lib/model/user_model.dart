import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String? uid;

  final String? userName;
  final String? userImage;

  final String? serviceCategory;

  UserModel({
    required this.uid,
    required this.userName,
    required this.userImage,
    required this.serviceCategory,
  });

  factory UserModel.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return UserModel(
      uid: data['uid'] ?? '',
      userName: data['userName'] ?? '',
      userImage: data['userImage'] ?? '',
      serviceCategory: data['serviceCategory'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'userName': userName,
      'userImage': userImage,
      'serviceCategory': serviceCategory,
    };
  }
}
