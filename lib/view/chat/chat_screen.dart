import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ghp_society_management/constants/export.dart';
import 'package:ghp_society_management/constants/simmer_loading.dart';
import 'package:ghp_society_management/model/group_model.dart';
import 'package:ghp_society_management/view/chat/create_chat_screen.dart';
import 'package:ghp_society_management/view/chat/delete_chat_dialogue.dart';
import 'package:ghp_society_management/view/chat/messaging_screen.dart';
import 'package:intl/intl.dart';

class ChatScreen extends StatefulWidget {
  final String userId;
  final String userName;
  final String userImage;

  const ChatScreen({
    super.key,
    required this.userId,
    required this.userName,
    required this.userImage,
  });

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appbarWidget(title: 'Chat'),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppTheme.primaryColor,
        onPressed: () {
          Navigator.of(context).push(MaterialPageRoute(
            builder: (_) => CreateChatScreen(
              userId: widget.userId,
              userName: widget.userName,
              userImage: widget.userImage,
            ),
          ));
        },
        child: const Icon(Icons.add, color: Colors.white),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: StreamBuilder<QuerySnapshot>(
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
                  'No data available.',
                  style: TextStyle(color: Colors.deepPurpleAccent),
                ),
              );
            }

            // convert groups
            List<GroupModel> groups = snapshot.data!.docs
                .map((doc) =>
                    GroupModel.fromMap(doc.data() as Map<String, dynamic>))
                .toList();

            return StreamBuilder<List<Map<String, dynamic>>>(
              stream: _getGroupsWithLastMessage(groups),
              builder: (context, groupSnapshot) {
                if (!groupSnapshot.hasData) {
                  return const Center(
                    child: CircularProgressIndicator.adaptive(),
                  );
                }

                var sortedGroups = groupSnapshot.data!;

                return ListView.builder(
                  itemCount: sortedGroups.length,
                  itemBuilder: (context, index) {
                    var groupData = sortedGroups[index];
                    GroupModel group = groupData['group'];
                    DateTime timestamp = groupData['lastMessageTimestamp'];
                    String formattedTime =
                        timestamp.year == 1970 // no message yet
                            ? ''
                            : DateFormat('hh:mm a').format(timestamp);

                    var lastMessage = groupData['lastMessage'];
                    String lastMessageText =
                        lastMessage?['message'] ?? 'No messages yet';
                    String senderId = lastMessage?['senderId'] ?? '';

                    var otherMember = group.members!.firstWhere(
                        (m) => m['uid'] != widget.userId,
                        orElse: () => null);

                    if (otherMember == null) return const SizedBox();

                    return Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Card(
                        color: Colors.white,
                        margin: EdgeInsets.zero,
                        child: ListTile(
                          onLongPress: () =>
                              deleteChatDialog(context, group.id!),
                          onTap: () {
                            context.read<GroupCubit>().markAllMessagesAsRead(
                                group.id!, widget.userId);
                            Navigator.of(context).push(MaterialPageRoute(
                              builder: (_) => MessagingScreen(
                                groupId: group.id!,
                                userId: widget.userId,
                                userName: otherMember['userName'] ?? 'Unknown',
                                userImage: otherMember['userImage'] ?? '',
                                userCategory:
                                    otherMember['serviceCategory'] ?? '',
                              ),
                            ));
                          },
                          contentPadding:
                              const EdgeInsets.symmetric(horizontal: 5),
                          dense: true,
                          leading: CircleAvatar(
                            radius: 24,
                            child: otherMember['userImage'] == null ||
                                    otherMember['userImage'] == ''
                                ? Icon(Icons.person,
                                    color: AppTheme.remainingColor)
                                : ClipOval(
                                    child: FadeInImage(
                                    placeholder:
                                        AssetImage(ImageAssets.chatImage),
                                    image:
                                        NetworkImage(otherMember['userImage']),
                                    imageErrorBuilder: (_, v, s) => Image.asset(
                                      ImageAssets.chatImage,
                                      fit: BoxFit.cover,
                                      width: 48,
                                      height: 48,
                                    ),
                                  )),
                          ),
                          title: Text(
                            otherMember['userName'] ?? 'Unknown',
                            style: GoogleFonts.nunitoSans(
                              fontWeight: FontWeight.w600,
                              fontSize: 15,
                            ),
                          ),
                          subtitle: Text(
                            lastMessageText,
                            style: GoogleFonts.nunitoSans(
                              fontSize: 12,
                              fontWeight: FontWeight.w400,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          trailing: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              if (formattedTime.isNotEmpty)
                                Text(
                                  formattedTime,
                                  style: GoogleFonts.nunitoSans(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.grey,
                                  ),
                                ),
                              const SizedBox(height: 5),
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  if (senderId == widget.userId)
                                    Icon(
                                        (lastMessage?['readBy'] as List?)?.any(
                                                    (id) =>
                                                        id != widget.userId) ??
                                                false
                                            ? Icons.done_all
                                            : Icons.done,
                                        size: 15.sp,
                                        color: (lastMessage?['readBy'] as List?)
                                                    ?.any((id) =>
                                                        id != widget.userId) ??
                                                false
                                            ? AppTheme.blueColor
                                            : AppTheme.primaryColor),
                                  const SizedBox(width: 10),
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
                                                style: GoogleFonts.nunitoSans(
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
                      ),
                    );
                  },
                );
              },
            );
          },
        ),
      ),
    );
  }

  /// Real-time sorted groups with last message
  Stream<List<Map<String, dynamic>>> _getGroupsWithLastMessage(
      List<GroupModel> groups) {
    return Stream.periodic(const Duration(seconds: 1)).asyncMap((_) async {
      List<Map<String, dynamic>> list = [];
      for (var group in groups) {
        var messageSnapshot = await FirebaseFirestore.instance
            .collection('groups')
            .doc(group.id!)
            .collection('messages')
            .orderBy('timestamp', descending: true)
            .limit(1)
            .get();

        if (messageSnapshot.docs.isEmpty) {
          list.add({
            'group': group,
            'lastMessage': null,
            'lastMessageTimestamp': DateTime(1970),
          });
        } else {
          var lastMessage = messageSnapshot.docs.first.data();
          DateTime lastMessageTimestamp =
              (lastMessage['timestamp'] as Timestamp).toDate();

          list.add({
            'group': group,
            'lastMessage': lastMessage,
            'lastMessageTimestamp': lastMessageTimestamp,
          });
        }
      }

      list.sort((a, b) => (b['lastMessageTimestamp'] as DateTime)
          .compareTo(a['lastMessageTimestamp'] as DateTime));
      return list;
    });
  }

  /// Count unread messages in the group for the current user
  Stream<int> getUnreadMessagesCount(String groupId, String userId) {
    return FirebaseFirestore.instance
        .collection('groups')
        .doc(groupId)
        .collection('messages')
        .snapshots()
        .map((snapshot) {
      int count = 0;
      for (var doc in snapshot.docs) {
        List<dynamic> readBy = doc['readBy'] ?? [];
        if (!readBy.contains(userId)) count++;
      }
      return count;
    });
  }
}
