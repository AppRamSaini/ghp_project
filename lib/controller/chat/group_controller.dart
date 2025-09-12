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

    try {
      var chatId = DateTime.now().millisecondsSinceEpoch.toString();

      String? imageUrl;
      if (imageFile != null) {
        imageUrl = await uploadImageToFirebase(imageFile);
      }

      var newChat = ChatModel(
        id: chatId,
        message: message,
        imageUrl: imageUrl ?? '',
        senderId: userId,
        senderName: senderName,
        readBy: [userId],
        timestamp: FieldValue
            .serverTimestamp(), // ✅ dynamic, no cast (Firestore will convert)
      );

      // Save chat inside messages collection
      await db
          .collection("groups")
          .doc(groupId)
          .collection("messages")
          .doc(chatId)
          .set(newChat.toJson());

      // Update group doc with last message info
      await db.collection("groups").doc(groupId).update({
        "lastMessage": message.isEmpty ? "📷 Image" : message,
        "lastMessageBy": senderName,
        "timeStamp": Timestamp.now(), // ✅ for sorting groups
      });
    } catch (e) {
      print("Error sending group message: $e");
    } finally {
      isLoading = false;
    }
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

  Future createGroup(
    UserModel userData,
    String groupId,
    BuildContext context,
    String userId,
    String firstName,
    String userImage,
    String userCategory, {
    bool fromStaff = false,
  }) async {
    showLoadingDialog(context, (ctx) {
      dialogueContext = ctx;
    });

    isLoading = true;

    try {
      // 1. Check if existing group already created
      String? existingGroupId = await checkExistingGroup(userId, userData.uid!);

      if (existingGroupId != null) {
        if (dialogueContext != null) Navigator.of(dialogueContext!).pop();

        Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (builder) => MessagingScreen(
            groupId: existingGroupId,
            userId: userId,
            userImage: userData.userImage ?? '',
            userName: userData.userName!,
            userCategory: userCategory,
          ),
        ));
        return;
      }

      // 2. No existing group - create new
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
        "createdAt": DateTime.now().toIso8601String(),
        "timeStamp": Timestamp.now(), // ✅ group-level timestamp
        "userIds": [userId, userData.uid!],
      });

      await getGroups(userId);

      if (dialogueContext != null) Navigator.of(dialogueContext!).pop();

      Navigator.of(context).push(MaterialPageRoute(
        builder: (builder) => MessagingScreen(
          groupId: groupId,
          userId: userId,
          userImage: userData.userImage ?? '',
          userName: userData.userName!,
          userCategory: userCategory,
        ),
      ));
    } catch (e) {
      print("Error in createGroup: $e");
      if (dialogueContext != null) Navigator.of(dialogueContext!).pop();
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
    try {
      QuerySnapshot<Map<String, dynamic>> querySnapshot =
          await db.collection("groups").get();
      List<GroupModel> groups =
          querySnapshot.docs.map((doc) => GroupModel.fromJson(doc)).toList();

      groupList = groups
          .where((group) =>
              group.members!.any((member) => member['uid'] == userId))
          .toList();
    } catch (e) {
      print('Error fetching groups: $e');
    } finally {
      isLoading = false;
    }
  }

  Stream<List<ChatModel>> getGroupMessages(String groupId) {
    return db
        .collection("groups")
        .doc(groupId)
        .collection("messages")
        .orderBy("timestamp", descending: false) // ✅ chat ordered by timestamp
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => ChatModel.fromJson(doc.data()))
            .toList());
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
}
