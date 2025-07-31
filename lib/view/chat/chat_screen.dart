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

  const ChatScreen(
      {super.key,
      required this.userId,
      required this.userName,
      required this.userImage});

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
                builder: (builder) => CreateChatScreen(
                    userId: widget.userId,
                    userName: widget.userName,
                    userImage: widget.userImage)));
          },
          child: const Icon(Icons.add, color: Colors.white)),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection('groups')
              .where("userIds",
                  arrayContains: widget.userId) // Filter groups by userId
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return notificationShimmerLoading();
            }
            if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
              return const Center(
                  child: Text('No data available.',
                      style: TextStyle(color: Colors.deepPurpleAccent)));
            }

            List<GroupModel> groups = snapshot.data!.docs
                .map((doc) =>
                    GroupModel.fromMap(doc.data() as Map<String, dynamic>))
                .toList();

            List<Future<Map<String, dynamic>>> lastMessagesFutures =
                groups.map((group) {
              return FirebaseFirestore.instance
                  .collection('groups')
                  .doc(group.id!)
                  .collection('messages')
                  .orderBy('timestamp', descending: true)
                  .get()
                  .then((messageSnapshot) {
                if (messageSnapshot.docs.isEmpty) {
                  return {
                    'group': group,
                    'lastMessageTimestamp': DateTime.now()
                  };
                }

                var lastMessage = messageSnapshot.docs.first.data();
                DateTime lastMessageTimestamp =
                    (lastMessage['timestamp'] as Timestamp).toDate();
                return {
                  'group': group,
                  'lastMessageTimestamp': lastMessageTimestamp
                };
              });
            }).toList();
            return FutureBuilder<List<Map<String, dynamic>>>(
              future: Future.wait(lastMessagesFutures),
              builder: (context, messagesSnapshot) {
                if (messagesSnapshot.connectionState ==
                    ConnectionState.waiting) {
                  return const Center(
                      child: CircularProgressIndicator.adaptive(
                          backgroundColor: Colors.deepPurpleAccent));
                }
                if (messagesSnapshot.hasError || !messagesSnapshot.hasData) {
                  return const Center(
                      child: Text('Error loading groups or messages.',
                          style: TextStyle(color: Colors.deepPurpleAccent)));
                }
                // Sort groups by the timestamp of the last message (descending)
                List<Map<String, dynamic>> groupsWithLastMessages =
                    messagesSnapshot.data!;
                groupsWithLastMessages.sort((a, b) {
                  DateTime timestampA = a['lastMessageTimestamp'] as DateTime;
                  DateTime timestampB = b['lastMessageTimestamp'] as DateTime;
                  return timestampB.compareTo(timestampA);
                });
                return ListView.builder(
                  // separatorBuilder: (_, index) =>
                  //     const Divider(thickness: 0.5),
                  itemCount: groupsWithLastMessages.length,
                  itemBuilder: (context, index) {
                    var groupData = groupsWithLastMessages[index];
                    GroupModel group = groupData['group'];
                    DateTime timestamp = groupData['lastMessageTimestamp'];
                    String formattedTime =
                        DateFormat('hh:mm a').format(timestamp);
                    return StreamBuilder<QuerySnapshot>(
                      stream: FirebaseFirestore.instance
                          .collection('groups')
                          .doc(group.id!)
                          .collection('messages')
                          .orderBy('timestamp', descending: true)
                          .limit(1)
                          .snapshots(),
                      builder: (context, messageSnapshot) {
                        if (!messageSnapshot.hasData) {
                          return notificationShimmerLoading();
                        }

                        print("------------>>>>${messageSnapshot.data!.docs}");

                        // if (messageSnapshot.data!.docs.isEmpty) {
                        //   return Center(
                        //       child: Text('Error loading groups or messages.',
                        //           style: TextStyle(
                        //               color: Colors.deepPurpleAccent)));
                        // }
                        var lastMessage = messageSnapshot.data!.docs.first
                            .data() as Map<String, dynamic>;
                        String lastMessageText = lastMessage['message'] ?? '';
                        String senderId = lastMessage['senderId'] ?? '';
                        bool isReadByOthers = (lastMessage['readBy'] as List?)
                                ?.any((id) => id != widget.userId) ??
                            false;
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 8),
                          child: Card(
                            color: Colors.white,
                            margin: EdgeInsets.zero,
                            child: ListTile(
                              onLongPress: () {
                                deleteChatDialog(context, group.id!);
                              },
                              onTap: () {
                                context
                                    .read<GroupCubit>()
                                    .markAllMessagesAsRead(
                                        group.id!, widget.userId);
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) => MessagingScreen(
                                        userImage: group.members!.firstWhere(
                                              (member) =>
                                                  member['uid'] !=
                                                  widget.userId,
                                              orElse: () => null,
                                            )['userImage'] ??
                                            '',
                                        groupId: group.id!,
                                        userId: widget.userId,
                                        userName: group.members!.firstWhere(
                                              (member) =>
                                                  member['uid'] !=
                                                  widget.userId,
                                              orElse: () => null,
                                            )['userName'] ??
                                            'No other members',
                                        userCategory: group.members!.firstWhere(
                                              (member) =>
                                                  member['uid'] !=
                                                  widget.userId,
                                              orElse: () => null,
                                            )['serviceCategory'] ??
                                            '')));
                              },
                              contentPadding:
                                  EdgeInsets.symmetric(horizontal: 5),
                              dense: true,
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
                                      : CircleAvatar(
                                          radius: 25,
                                          backgroundColor: Colors.transparent,
                                          backgroundImage: NetworkImage(
                                              group.members!.firstWhere(
                                            (member) =>
                                                member['uid'] != widget.userId,
                                            orElse: () => null,
                                          )['userImage']))),
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
                                          fontWeight: FontWeight.w600))),
                              subtitle: Text(lastMessageText,
                                  style: GoogleFonts.nunitoSans(
                                      textStyle: const TextStyle(
                                          color: Colors.black,
                                          fontSize: 12.0,
                                          fontWeight: FontWeight.w400)),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis),
                              trailing: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(formattedTime,
                                      style: GoogleFonts.nunitoSans(
                                          textStyle: const TextStyle(
                                              color: Colors.grey,
                                              fontSize: 12.0,
                                              fontWeight: FontWeight.w600))),
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
                                                    color:
                                                        AppTheme.primaryColor,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            100.0)),
                                                child: Center(
                                                    child: Text(
                                                        unreadCount.toString(),
                                                        style: GoogleFonts.nunitoSans(
                                                            textStyle: const TextStyle(
                                                                color: Colors
                                                                    .white,
                                                                fontSize: 12.0,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600)))))
                                            : const SizedBox();
                                      }),
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
            );
          },
        ),
      ),
    );
  }

  // This method listens for all messages in a group and calculates the unread count for a specific user
  Stream<int> getUnreadMessagesCount(String groupId, String userId) {
    // Listen to changes in the messages subcollection of the given groupId
    return FirebaseFirestore.instance
        .collection('groups')
        .doc(groupId)
        .collection('messages')
        .snapshots() // Listen to snapshot of messages
        .map((snapshot) {
      int unreadCount = 0;

      // Iterate through each message and check if the current user has read it
      for (var doc in snapshot.docs) {
        List<dynamic> readBy = doc['readBy'] ?? [];
        // If the readBy list doesn't contain the userId, it's unread
        if (!readBy.contains(userId)) {
          unreadCount++;
        }
      }
      return unreadCount;
    });
  }
}
