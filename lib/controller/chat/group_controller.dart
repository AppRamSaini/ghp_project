import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ghp_society_management/constants/dialog.dart';
import 'package:ghp_society_management/model/chat_model.dart';
import 'package:ghp_society_management/model/group_model.dart';
import 'package:ghp_society_management/model/user_model.dart';
import 'package:ghp_society_management/view/chat/messaging_screen.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';

class GroupCubit extends Cubit<void> {
  final db = FirebaseFirestore.instance;
  final uuid = const Uuid();
  List<UserModel> groupMembers = [];
  List<GroupModel> groupList = [];
  String selectedImagePath = "";
  bool isLoading = false;
  int readCounter = 0;
  BuildContext? dialogueContext;

  GroupCubit() : super(null);

  void selectMember(UserModel user) {
    if (!groupMembers.contains(user)) {
      groupMembers.add(user);
    }
  }

  Future<String?> uploadImageToFirebase(File imageFile) async {
    try {
      String fileName = DateTime.now().millisecondsSinceEpoch.toString();
      Reference ref =
          FirebaseStorage.instance.ref().child('chat_images/$fileName');
      UploadTask uploadTask = ref.putFile(imageFile);
      TaskSnapshot snapshot = await uploadTask.whenComplete(() {});
      String downloadUrl = await snapshot.ref.getDownloadURL();
      return downloadUrl;
    } catch (e) {
      print("Image upload error: $e");
      return null;
    }
  }

  Future<void> sendGroupMessage(
    String message,
    String groupId,
    String senderName,
    String userId, {
    File? imageFile,
  }) async {
    isLoading = true;
    var chatId = DateTime.now();

    String? imageUrl;
    if (imageFile != null) {
      imageUrl = await uploadImageToFirebase(imageFile);
    }

    var newChat = ChatModel(
      id: chatId.toString(),
      message: message,
      imageUrl: imageUrl ?? '',
      senderId: userId,
      senderName: senderName,
      readBy: [userId],
      timestamp: Timestamp.now(),
    );

    await db
        .collection("groups")
        .doc(groupId)
        .collection("messages")
        .doc(chatId.toString())
        .set(newChat.toJson());

    isLoading = false;
  }

  Future<void> pickImageAndSendMessage(
      String groupId, String senderName, String userId) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      File imageFile = File(pickedFile.path);
      await sendGroupMessage('', groupId, senderName, userId,
          imageFile: imageFile);
    }
  }

  Future createGroup(UserModel userData, String groupId, BuildContext context,
      String userId, String firstName, String userImage, String userCategory,
      {bool fromStaff = false}) async {
    showLoadingDialog(context, (ctx) {
      dialogueContext = ctx;
    });
    isLoading = true;

    try {
      String? existingGroupId = await checkExistingGroup(userId, userData.uid!);

      if (existingGroupId != null) {
        Navigator.of(context).pop();
        Navigator.of(dialogueContext!).pop();
        Navigator.of(context).push(MaterialPageRoute(
            builder: (builder) => MessagingScreen(
                groupId: existingGroupId,
                userId: userId,
                userImage: userData.userImage ?? '',
                userName: userData.userName!,
                userCategory: userCategory)));
        return;
      }

      List<UserModel> selectedMembers = [
        UserModel(
          uid: userId,
          userName: firstName,
          serviceCategory: userCategory,
          userImage: userImage,
        ),
        userData,
      ];

      await db.collection("groups").doc(groupId).set({
        "id": groupId,
        "members": selectedMembers.map((e) => e.toMap()).toList(),
        "createdAt": DateTime.now().toString(),
        "timeStamp": Timestamp.now(),
        "userIds": [userId, userData.uid!]
      });

      await getGroups(userId);

      if (!fromStaff) {
        Navigator.of(context).pop();
        Navigator.of(dialogueContext!).pop();
      }

      Navigator.of(context).push(MaterialPageRoute(
          builder: (builder) => MessagingScreen(
              groupId: groupId,
              userId: userId,
              userImage: userData.userImage ?? '',
              userName: userData.userName!,
              userCategory: userCategory)));

      Navigator.of(dialogueContext!).pop();
    } catch (e) {
      print("Error in createGroup: $e");
      Navigator.of(dialogueContext!).pop();
    } finally {
      isLoading = false;
    }
  }

  Future<String?> checkExistingGroup(String userId, String otherUserId) async {
    try {
      QuerySnapshot<Map<String, dynamic>> querySnapshot =
          await db.collection("groups").get();
      List<GroupModel> groups =
          querySnapshot.docs.map((doc) => GroupModel.fromJson(doc)).toList();
      groups = groups
          .where((group) =>
              group.members!.any((member) => member['uid'] == userId))
          .toList();

      for (var group in groups) {
        if (group.members!.length > 1) {
          bool containsUserId =
              group.members!.any((member) => member['uid'] == userId);
          bool containsOtherUserId =
              group.members!.any((member) => member['uid'] == otherUserId);

          if (containsUserId && containsOtherUserId) {
            print('Group already exists with both users: ${group.id}');
            return group.id;
          }
        }
      }
      return null;
    } catch (e) {
      print('Error fetching groups: $e');
      return null;
    }
  }

  Future<void> getGroups(String userId) async {
    isLoading = true;
    List<GroupModel> tempGroup = [];

    try {
      QuerySnapshot<Map<String, dynamic>> querySnapshot =
          await db.collection("groups").get();
      List<GroupModel> groups =
          querySnapshot.docs.map((doc) => GroupModel.fromJson(doc)).toList();

      tempGroup = groups
          .where((group) =>
              group.members!.any((member) => member['uid'] == userId))
          .toList();
      groupList = tempGroup;
    } catch (e) {
      print('Error fetching groups: $e');
    } finally {
      isLoading = false;
    }
  }

  Stream<List<GroupModel>> getGroupsStream(String userId) {
    isLoading = true;
    return db.collection('groups').snapshots().map((snapshot) {
      List<GroupModel> tempGroup =
          snapshot.docs.map((doc) => GroupModel.fromJson(doc)).toList();
      groupList = tempGroup
          .where((group) =>
              group.members!.any((member) => member['uid'] == userId))
          .toList();
      isLoading = false;
      return groupList;
    });
  }

  Stream<List<ChatModel>> getGroupMessages(String groupId) {
    return db
        .collection("groups")
        .doc(groupId)
        .collection("messages")
        .orderBy("timestamp", descending: false)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map((doc) => ChatModel.fromJson(doc.data()))
              .toList(),
        );
  }

  Stream<List<ChatModel>> getLastMessage(String groupId) {
    return db
        .collection("groups")
        .doc(groupId)
        .collection("messages")
        .orderBy("timestamp", descending: true)
        .limit(1)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map((doc) => ChatModel.fromJson(doc.data()))
              .toList(),
        );
  }

  Future<void> markAllMessagesAsRead(String chatId, String userId) async {
    CollectionReference messagesRef =
        db.collection("groups").doc(chatId).collection("messages");

    QuerySnapshot snapshot = await messagesRef.get();

    for (QueryDocumentSnapshot doc in snapshot.docs) {
      DocumentReference messageRef = doc.reference;
      await messageRef.update({
        "readBy": FieldValue.arrayUnion([userId]),
      });
    }
  }

  Stream<List<QueryDocumentSnapshot>> getAllMessagesStream(String chatId) {
    CollectionReference messagesRef =
        db.collection("groups").doc(chatId).collection("messages");

    return messagesRef.snapshots().map((snapshot) {
      return snapshot.docs;
    });
  }
}
