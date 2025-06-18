import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ghp_society_management/constants/app_images.dart';
import 'package:ghp_society_management/constants/app_theme.dart';
import 'package:ghp_society_management/constants/snack_bar.dart';
import 'package:ghp_society_management/controller/chat/group_controller.dart';
import 'package:ghp_society_management/model/group_model.dart';
import 'package:ghp_society_management/view/chat/delete_chat_dialogue.dart';
import 'package:ghp_society_management/view/chat/messaging_screen.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class StaffChatScreen extends StatefulWidget {
  final String userId;
  final String userName;
  final String userImage;

  const StaffChatScreen(
      {super.key,
      required this.userId,
      required this.userName,
      required this.userImage});

  @override
  State<StaffChatScreen> createState() => _StaffChatScreenState();
}

class _StaffChatScreenState extends State<StaffChatScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text('Chats',
              style: GoogleFonts.nunitoSans(
                  textStyle: TextStyle(
                      color: Colors.black,
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600)))),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('groups')
            .where("userIds", arrayContains: widget.userId)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(
                child: Text('No groups available.',
                    style: TextStyle(color: Colors.deepPurpleAccent)));
          }

          List<GroupModel> groups = snapshot.data!.docs
              .map((doc) => GroupModel.fromMap(
                  doc.data() as Map<String, dynamic>))
              .toList();

          return ListView.separated(
            separatorBuilder: (_, index) =>
                Divider(color: Colors.grey.withOpacity(0.2), height: 0),
            itemCount: groups.length,
            itemBuilder: (context, index) {
              GroupModel group = groups[index];

              return StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('groups')
                    .doc(group.id!)
                    .collection('messages')
                    .orderBy('timestamp', descending: true)
                    .snapshots(),
                builder: (context, messageSnapshot) {
                  if (!messageSnapshot.hasData ||
                      messageSnapshot.data!.docs.isEmpty) {
                    return ListTile(
                      onLongPress: () {
                        deleteChatDialog(context, group.id!);
                      },
                      leading: Card(
                          elevation: 1,
                          margin: EdgeInsets.zero,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(100)),
                          child: group.members!.firstWhere(
                                    (member) =>
                                        member['uid'] != widget.userId,
                                    orElse: () => null,
                                  )['userImage'] ==
                                  null
                              ? Image.asset(ImageAssets.chatImage,
                                  height: 50.0)
                              : ClipRRect(
                                  borderRadius:
                                      BorderRadius.circular(25),
                                  child: FadeInImage(
                                    height: 50,
                                    width: 50,
                                    fit: BoxFit.cover,
                                    imageErrorBuilder:
                                        (_, child, stackTrash) =>
                                            Image.asset(
                                                ImageAssets.chatImage,
                                                height: 50.0),
                                    placeholder: const AssetImage(
                                        ImageAssets.chatImage),
                                    image: NetworkImage(
                                        group.members!.firstWhere(
                                      (member) =>
                                          member['uid'] !=
                                          widget.userId,
                                      orElse: () => null,
                                    )['userImage']),
                                  ),
                                )),
                      title: Text(
                        group.members!.firstWhere(
                              (member) =>
                                  member['uid'] != widget.userId,
                              orElse: () => null,
                            )['userName'] ??
                            'No other members',
                        style: GoogleFonts.nunitoSans(
                          textStyle: const TextStyle(
                            fontSize: 15.0,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      subtitle: const Text("No messages yet"),
                    );
                  }

                  var lastMessage = messageSnapshot.data!.docs.first;
                  String lastMessageText = lastMessage['message'] ?? '';
                  String senderId = lastMessage['senderId'] ?? '';
                  DateTime lastMessageTime =
                      (lastMessage['timestamp'] as Timestamp).toDate();
                  String formattedTime =
                      DateFormat('hh:mm a').format(lastMessageTime);

                  bool isReadByOthers = (lastMessage['readBy'] as List?)
                          ?.any((id) => id != widget.userId) ??
                      false;

                  return ListTile(
                    onLongPress: () {
                      deleteChatDialog(context, group.id!);
                    },
                    onTap: () {
                      context.read<GroupCubit>().markAllMessagesAsRead(
                          group.id!, widget.userId);
                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => MessagingScreen(
                          userImage: group.members!.firstWhere(
                                (member) =>
                                    member['uid'] != widget.userId,
                                orElse: () => null,
                              )['userImage'] ??
                              '',
                          groupId: group.id!,
                          userId: widget.userId,
                          userName: group.members!.firstWhere(
                                  (member) =>
                                      member['uid'] != widget.userId,
                                  orElse: () => null)['userName'] ??
                              'No other members',
                          userCategory: group.members!.firstWhere(
                                  (member) =>
                                      member['uid'] != widget.userId,
                                  orElse: () =>
                                      null)['serviceCategory'] ??
                              '',
                        ),
                      ));
                    },
                    leading: Card(
                        elevation: 1,
                        margin: EdgeInsets.zero,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(100)),
                        child: group.members!.firstWhere(
                                  (member) =>
                                      member['uid'] != widget.userId,
                                  orElse: () => null,
                                )['userImage'] ==
                                null
                            ? Image.asset(ImageAssets.chatImage,
                                height: 50.0)
                            : ClipRRect(
                                borderRadius: BorderRadius.circular(25),
                                child: FadeInImage(
                                  height: 50,
                                  width: 50,
                                  fit: BoxFit.cover,
                                  imageErrorBuilder: (_, child,
                                          stackTrash) =>
                                      Image.asset(ImageAssets.chatImage,
                                          height: 50.0),
                                  placeholder: const AssetImage(
                                      ImageAssets.chatImage),
                                  image: NetworkImage(
                                      group.members!.firstWhere(
                                    (member) =>
                                        member['uid'] != widget.userId,
                                    orElse: () => null,
                                  )['userImage']),
                                ),
                              )),
                    title: Text(
                      group.members!.firstWhere(
                            (member) => member['uid'] != widget.userId,
                            orElse: () => null,
                          )['userName'] ??
                          'No other members',
                      style: GoogleFonts.nunitoSans(
                        textStyle: const TextStyle(
                          fontSize: 15.0,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    subtitle: Text(lastMessageText,
                        maxLines: 1, overflow: TextOverflow.ellipsis),
                    trailing: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(formattedTime,
                            style: const TextStyle(color: Colors.grey)),
                        const SizedBox(height: 5.0),
                        if (senderId == widget.userId) ...[
                          isReadByOthers
                              ? Icon(Icons.done_all,
                                  size: 15.sp,
                                  color: AppTheme.primaryColor)
                              : Icon(Icons.done,
                                  size: 15.sp,
                                  color: AppTheme.primaryColor),
                        ],
                        StreamBuilder<int>(
                            stream: getUnreadMessagesCount(
                                group.id!, widget.userId),
                            builder: (context, snapshot) {
                              final unreadCount = snapshot.data ?? 0;
                              return unreadCount != 0
                                  ? Container(
                                      width: 25.0,
                                      height: 25.0,
                                      decoration: BoxDecoration(
                                          color: AppTheme.primaryColor,
                                          borderRadius:
                                              BorderRadius.circular(
                                                  100.0)),
                                      child: Center(
                                        child: Text(
                                          unreadCount.toString(),
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 12.0,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ),
                                    )
                                  : const SizedBox();
                            }),
                      ],
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}

Stream<int> getUnreadMessagesCount(String groupId, String userId) {
  return FirebaseFirestore.instance
      .collection('groups')
      .doc(groupId)
      .collection('messages')
      .snapshots()
      .map((snapshot) {
    int unreadCount = 0;
    for (var doc in snapshot.docs) {
      List<dynamic> readBy = doc['readBy'] ?? [];
      if (!readBy.contains(userId)) {
        unreadCount++;
      }
    }
    return unreadCount;
  });
}
