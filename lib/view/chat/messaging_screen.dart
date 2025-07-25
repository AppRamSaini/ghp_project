import 'package:ghp_society_management/constants/export.dart';
import 'package:intl/intl.dart';

class MessagingScreen extends StatefulWidget {
  final String groupId;
  final String userId;
  final String userName;
  final String userCategory;
  final String userImage;

  MessagingScreen(
      {super.key,
      required this.groupId,
      required this.userId,
      required this.userCategory,
      required this.userName,
      required this.userImage});

  @override
  State<MessagingScreen> createState() => _MessagingScreenState();
}

class _MessagingScreenState extends State<MessagingScreen> {
  final TextEditingController messagingController = TextEditingController();

  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToBottom();
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            leading: widget.userImage.isEmpty
                ? Image.asset(ImageAssets.chatImage, height: 50)
                : CircleAvatar(
                    radius: 25.r,
                    backgroundColor: Colors.transparent,
                    backgroundImage: NetworkImage(widget.userImage)),
            title:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(capitalizeWords(widget.userName.toString()),
                  style: GoogleFonts.nunitoSans(
                      textStyle: TextStyle(
                          color: Colors.white,
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w600))),
              Text(
                  widget.userCategory.isEmpty || widget.userCategory == null
                      ? "Resident"
                      : capitalizeWords(
                          widget.userCategory.toString().replaceAll("_", ' ')),
                  style: GoogleFonts.nunitoSans(
                      textStyle: TextStyle(
                          color: Colors.red,
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w600)))
            ])),
        body: Column(
          children: [
            Expanded(
              child: StreamBuilder(
                  stream: context
                      .read<GroupCubit>()
                      .getGroupMessages(widget.groupId),
                  builder: (context, snapshot) {
                    print(widget.groupId);
                    if (snapshot.data == null || snapshot.data!.isEmpty) {
                      return const Center(child: Text("No messages available"));
                    } else {
                      WidgetsBinding.instance
                          .addPostFrameCallback((_) => _scrollToBottom());
                      context
                          .read<GroupCubit>()
                          .markAllMessagesAsRead(widget.groupId, widget.userId);

                      var messages = snapshot.data!;
                      return ListView.builder(
                        controller: _scrollController,
                        shrinkWrap: true,
                        itemCount: messages.length,
                        itemBuilder: (context, index) {
                          final message = messages[index];
                          final isMe = message.senderId == widget.userId;
                          return Align(
                            alignment: isMe
                                ? Alignment.centerRight
                                : Alignment.centerLeft,
                            child: Padding(
                              padding: const EdgeInsets.all(12),
                              child: Column(
                                crossAxisAlignment: isMe
                                    ? CrossAxisAlignment.end
                                    : CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 5, horizontal: 15),
                                    decoration: BoxDecoration(
                                        color: isMe
                                            ? Colors.grey
                                            : Colors.grey[200],
                                        borderRadius: BorderRadius.only(
                                            topLeft:
                                                Radius.circular(isMe ? 0 : 20),
                                            topRight: const Radius.circular(20),
                                            bottomLeft:
                                                const Radius.circular(20),
                                            bottomRight: Radius.circular(
                                                isMe ? 20 : 0))),
                                    child: Column(
                                      crossAxisAlignment: isMe
                                          ? CrossAxisAlignment.end
                                          : CrossAxisAlignment.start,
                                      children: [
                                        Text(messages[index].message!,
                                            style: TextStyle(
                                                fontSize: 16,
                                                color: isMe
                                                    ? Colors.white
                                                    : Colors.black)),
                                        const SizedBox(height: 5),
                                        Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Text(
                                                _formatDate(message.timestamp!
                                                    .toDate()),
                                                style: TextStyle(
                                                    fontSize: 8,
                                                    color: isMe
                                                        ? Colors.white
                                                        : Colors.black)),
                                            SizedBox(width: 5.w),
                                            if (isMe) ...[
                                              message.readBy.any((id) =>
                                                      id != widget.userId)
                                                  ? Icon(Icons.done_all,
                                                      size: 15.sp,
                                                      color: Colors.white)
                                                  : Icon(Icons.done,
                                                      size: 15.sp,
                                                      color: Colors.white),
                                            ]
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      );
                    }
                  }),
            ),
            Container(
                color: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: ListTile(
                    contentPadding: EdgeInsets.zero,
                    title: TextFormField(
                      style: GoogleFonts.nunitoSans(
                          color: Colors.black,
                          fontSize: 15.sp,
                          fontWeight: FontWeight.w500),
                      controller: messagingController,
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                        isDense: true,
                        filled: true,
                        hintText: "Type here..",
                        hintStyle: TextStyle(
                            color: Colors.grey,
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w400),
                        fillColor: AppTheme.greyColor,
                        errorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30.0),
                          borderSide: BorderSide(
                            color: AppTheme.greyColor,
                          ),
                        ),
                        focusedErrorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30.0),
                          borderSide: BorderSide(
                            color: AppTheme.greyColor,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30.0),
                          borderSide: BorderSide(
                            color: AppTheme.greyColor,
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30.0),
                          borderSide: BorderSide(
                            color: AppTheme.greyColor,
                          ),
                        ),
                      ),
                    ),
                    trailing: GestureDetector(
                        onTap: () {
                          if (messagingController.text.isNotEmpty) {
                            context.read<GroupCubit>().sendGroupMessage(
                                messagingController.text,
                                widget.groupId,
                                widget.userName,
                                widget.userId);
                            messagingController.clear();
                          }
                        },
                        child: Image.asset(ImageAssets.sendMessageImage,
                            fit: BoxFit.cover,
                            color: Colors.deepPurpleAccent)))),
          ],
        ));
  }

  String _formatDate(DateTime dateTime) {
    return DateFormat('h:mm a').format(dateTime);
  }
}

class Message {
  final String sender;
  final String content;
  final DateTime timestamp;

  Message({
    required this.sender,
    required this.content,
    required this.timestamp,
  });
}
