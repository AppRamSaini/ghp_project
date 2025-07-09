import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/material.dart';
import 'package:ghp_society_management/constants/dialog.dart';
import 'package:ghp_society_management/model/chat_model.dart';
import 'package:ghp_society_management/model/group_model.dart';
import 'package:ghp_society_management/model/user_model.dart';
import 'package:ghp_society_management/view/chat/messaging_screen.dart';

import 'package:uuid/uuid.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

class GroupCubit extends Cubit<void> {
  final db = FirebaseFirestore.instance;
  final uuid = const Uuid();

  List<UserModel> groupMembers = [];
  List<GroupModel> groupList = [];
  String selectedImagePath = "";
  bool isLoading = false;

  int readCounter = 0;

  GroupCubit() : super(null);

  void selectMember(UserModel user) {
    if (!groupMembers.contains(user)) {
      groupMembers.add(user);
    }
  }

  BuildContext? dialogueContext;

  /*Future createGroup(UserModel userData, String groupId, BuildContext context,
      String userId, String firstName, String userImage, String userCategory,
      {bool fromStaff = false}) async {
    showLoadingDialog(context, (ctx) {
      dialogueContext = ctx;
    });
    isLoading = true;
    try {
      String? existingGroupId = await checkExistingGroup(userId, userData.uid!);
      if (existingGroupId != null) {
        if (!fromStaff) {
          Navigator.of(context).pop();
        }
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
          serviceCategory: '',
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
  }*/

  Future createGroup(UserModel userData, String groupId, BuildContext context,
      String userId, String firstName, String userImage, String userCategory,
      {bool fromStaff = false} // ये नया पैरामीटर ऐड किया गया है।
      ) async {
    showLoadingDialog(context, (ctx) {
      dialogueContext = ctx;
    });
    isLoading = true;

    try {
      // पहले से कोई ग्रुप है या नहीं, चेक करें
      String? existingGroupId = await checkExistingGroup(userId, userData.uid!);

      if (existingGroupId != null) {
        // अगर ग्रुप पहले से है, तो चैट स्क्रीन पर डायरेक्ट भेजें
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

      // नया ग्रुप बनाना है
      List<UserModel> selectedMembers = [
        UserModel(
          uid: userId,
          userName: firstName,
          serviceCategory: userCategory, // अब serviceCategory भी ऐड होगी
          userImage: userImage,
        ),
        userData, // दूसरा यूजर
      ];

      await db.collection("groups").doc(groupId).set({
        "id": groupId,
        "members": selectedMembers.map((e) => e.toMap()).toList(),
        "createdAt": DateTime.now().toString(),
        "timeStamp": Timestamp.now(),
        "userIds": [userId, userData.uid!]
      });

      // ग्रुप लिस्ट अपडेट करें
      await getGroups(userId);

      // अगर स्टाफ चैट शुरू कर रहा है, तो लॉजिक हैंडल करें
      if (!fromStaff) {
        Navigator.of(context).pop();
        Navigator.of(dialogueContext!).pop();
      }

      // चैट स्क्रीन पर रीडायरेक्ट करें
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
            return group.id; // Return the existing group ID if found
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

  Future<void> sendGroupMessage(
      String message, String groupId, String senderName, String userId) async {
    isLoading = true;
    var chatId = DateTime.now();

    var newChat = ChatModel(
      id: chatId.toString(),
      message: message,
      imageUrl:
          "https://freerangestock.com/sample/118824/people-and-chat-vector-icon.jpg",
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
    // Reference to the messages collection for the specific chat
    CollectionReference messagesRef =
        db.collection("groups").doc(chatId).collection("messages");

    // Get all messages in the chat
    QuerySnapshot snapshot = await messagesRef.get();

    // Loop through each message and update the readBy field
    for (QueryDocumentSnapshot doc in snapshot.docs) {
      DocumentReference messageRef = doc.reference;

      // Add the user's ID to the `readBy` array, if not already present
      await messageRef.update({
        "readBy": FieldValue.arrayUnion([userId]),
      });
    }
  }

  Stream<List<QueryDocumentSnapshot>> getAllMessagesStream(String chatId) {
    // Reference to the messages collection for the specific chat
    CollectionReference messagesRef =
        db.collection("groups").doc(chatId).collection("messages");

    // Listen to real-time updates from the messages collection
    return messagesRef.snapshots().map((snapshot) {
      // Return the entire list of messages in the chat
      return snapshot.docs;
    });
  }
}
