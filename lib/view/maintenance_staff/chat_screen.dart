import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ghp_society_management/constants/export.dart';
import 'package:ghp_society_management/constants/simmer_loading.dart';
import 'package:ghp_society_management/model/group_model.dart';
import 'package:ghp_society_management/view/chat/delete_chat_dialogue.dart';
import 'package:ghp_society_management/view/chat/messaging_screen.dart';
import 'package:intl/intl.dart';

class StaffChatScreen extends StatefulWidget {
  final String userId;
  final String userName;
  final String userImage;

  const StaffChatScreen({
    super.key,
    required this.userId,
    required this.userName,
    required this.userImage,
  });

  @override
  State<StaffChatScreen> createState() => _StaffChatScreenState();
}

class _StaffChatScreenState extends State<StaffChatScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appbarWidget(title: 'Chat'),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('groups')
            .where("userIds", arrayContains: widget.userId)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return notificationShimmerLoading();
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(
              child: Text(
                'Data Not Available!',
                style: TextStyle(color: Colors.deepPurpleAccent),
              ),
            );
          }

          List<GroupModel> groups = snapshot.data!.docs
              .map((doc) =>
                  GroupModel.fromMap(doc.data() as Map<String, dynamic>))
              .toList();

          // अब हम हर group का lastMessageTime निकालेंगे और sort करेंगे
          return StreamBuilder<List<Map<String, dynamic>>>(
            stream: _getGroupsWithLastMessage(groups),
            builder: (context, groupSnapshot) {
              if (!groupSnapshot.hasData) {
                return const Center(child: CircularProgressIndicator());
              }

              var sortedGroups = groupSnapshot.data!;

              return ListView.separated(
                separatorBuilder: (_, __) =>
                    Divider(color: Colors.grey.withOpacity(0.2), height: 0),
                itemCount: sortedGroups.length,
                itemBuilder: (context, index) {
                  var groupData = sortedGroups[index];
                  GroupModel group = groupData['group'];
                  var lastMessage = groupData['lastMessage'];
                  DateTime lastMessageTime = groupData['lastMessageTime'];

                  String lastMessageText =
                      lastMessage?['message'] ?? 'No messages yet';
                  String senderId = lastMessage?['senderId'] ?? '';
                  String formattedTime = lastMessageTime.year == 1970
                      ? ''
                      : DateFormat('hh:mm a').format(lastMessageTime);

                  bool isReadByOthers = (lastMessage?['readBy'] as List?)
                          ?.any((id) => id != widget.userId) ??
                      false;

                  var otherMember = group.members!.firstWhere(
                    (m) => m['uid'] != widget.userId,
                    orElse: () => null,
                  );

                  if (otherMember == null) return const SizedBox();

                  return Card(
                    color: Colors.white,
                    child: ListTile(
                      onLongPress: () => deleteChatDialog(context, group.id!),
                      onTap: () async {
                        await context
                            .read<GroupCubit>()
                            .markAllMessagesAsRead(group.id!, widget.userId);
                        Navigator.of(context).push(MaterialPageRoute(
                          builder: (_) => MessagingScreen(
                            groupId: group.id!,
                            userId: widget.userId,
                            userName: otherMember['userName'] ?? 'Unknown',
                            userImage: otherMember['userImage'] ?? '',
                            userCategory: "Resident",
                          ),
                        ));

                        // setState(() {});
                      },
                      leading: CircleAvatar(
                        radius: 25,
                        backgroundImage:
                            (otherMember['userImage'] ?? '').isEmpty
                                ? AssetImage(ImageAssets.chatImage)
                                : NetworkImage(otherMember['userImage'])
                                    as ImageProvider,
                      ),
                      title: Text(
                        otherMember['userName'] ?? 'Unknown',
                        style: GoogleFonts.nunitoSans(
                            fontSize: 15, fontWeight: FontWeight.w600),
                      ),
                      subtitle: Text(lastMessageText,
                          maxLines: 1, overflow: TextOverflow.ellipsis),
                      trailing: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          if (formattedTime.isNotEmpty)
                            Text(formattedTime,
                                style: const TextStyle(color: Colors.grey)),
                          const SizedBox(height: 5),
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              if (senderId == widget.userId)
                                Icon(
                                    isReadByOthers
                                        ? Icons.done_all
                                        : Icons.done,
                                    size: 15.sp,
                                    color: isReadByOthers
                                        ? AppTheme.blueColor
                                        : AppTheme.primaryColor),
                              SizedBox(width: 5),
                              StreamBuilder<int>(
                                stream: getUnreadMessagesCount(
                                    group.id!, widget.userId),
                                builder: (_, unreadSnap) {
                                  int unreadCount = unreadSnap.data ?? 0;
                                  return unreadCount > 0
                                      ? Container(
                                          width: 25,
                                          height: 25,
                                          decoration: BoxDecoration(
                                            color: AppTheme.primaryColor,
                                            shape: BoxShape.circle,
                                          ),
                                          alignment: Alignment.center,
                                          child: Text(
                                            unreadCount.toString(),
                                            style: const TextStyle(
                                              fontSize: 12,
                                              fontWeight: FontWeight.w600,
                                              color: Colors.white,
                                            ),
                                          ),
                                        )
                                      : const SizedBox();
                                },
                              ),
                            ],
                          ),
                        ],
                      ),
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

  /// helper function -> get lastMessage for each group and sort
  Stream<List<Map<String, dynamic>>> _getGroupsWithLastMessage(
      List<GroupModel> groups) async* {
    while (true) {
      List<Map<String, dynamic>> list = [];
      for (var group in groups) {
        var snap = await FirebaseFirestore.instance
            .collection('groups')
            .doc(group.id!)
            .collection('messages')
            .orderBy('timestamp', descending: true)
            .limit(1)
            .get();

        if (snap.docs.isEmpty) {
          list.add({
            'group': group,
            'lastMessage': null,
            'lastMessageTime': DateTime(1970),
          });
        } else {
          var lastMsg = snap.docs.first.data();
          DateTime time = (lastMsg['timestamp'] as Timestamp).toDate();

          list.add({
            'group': group,
            'lastMessage': lastMsg,
            'lastMessageTime': time,
          });
        }
      }

      list.sort((a, b) => (b['lastMessageTime'] as DateTime)
          .compareTo(a['lastMessageTime'] as DateTime));

      yield list;
      await Future.delayed(const Duration(seconds: 1));
    }
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
      if (doc['senderId'] != userId && !readBy.contains(userId)) {
        unreadCount++;
      }
    }
    return unreadCount;
  });
}
