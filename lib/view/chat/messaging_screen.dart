import 'package:ghp_society_management/constants/export.dart';
import 'package:ghp_society_management/main.dart';
import 'package:intl/intl.dart';

class MessagingScreen extends StatefulWidget {
  final String groupId;
  final String userId;
  final String userName;
  final String userCategory;
  final String userImage;

  const MessagingScreen({
    super.key,
    required this.groupId,
    required this.userId,
    required this.userCategory,
    required this.userName,
    required this.userImage,
  });

  @override
  State<MessagingScreen> createState() => _MessagingScreenState();
}

class _MessagingScreenState extends State<MessagingScreen> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToBottom());
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
    }
  }

  void _sendMessage() {
    final messageText = _messageController.text.trim();
    if (messageText.isNotEmpty) {
      context.read<GroupCubit>().sendGroupMessage(
            messageText,
            widget.groupId,
            widget.userName,
            widget.userId,
          );
      _messageController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leadingWidth: size.width * 0.28,
        leading: widget.userImage.isEmpty
            ? Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: Icon(Icons.arrow_back)),
                  Image.asset(ImageAssets.chatImage,
                      height: 50, color: AppTheme.white),
                ],
              )
            : Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: Icon(Icons.arrow_back)),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(100),
                    child: FadeInImage.assetNetwork(
                        placeholder: ImageAssets.chatImage,
                        image: widget.userImage,
                        imageErrorBuilder: (_, __, ___) => Image.asset(
                            ImageAssets.chatImage,
                            height: 50,
                            color: AppTheme.white)),
                  ),
                ],
              ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              capitalizeWords(widget.userName),
              style: GoogleFonts.nunitoSans(
                textStyle: TextStyle(
                  color: Colors.white,
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            Text(
              widget.userCategory.isEmpty
                  ? "Resident"
                  : capitalizeWords(widget.userCategory.replaceAll("_", ' ')),
              style: GoogleFonts.nunitoSans(
                textStyle: TextStyle(
                  color: Colors.red,
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: StreamBuilder(
                stream:
                    context.read<GroupCubit>().getGroupMessages(widget.groupId),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  final messages = snapshot.data;

                  if (messages == null || messages.isEmpty) {
                    return const Center(child: Text("No messages available"));
                  }

                  WidgetsBinding.instance
                      .addPostFrameCallback((_) => _scrollToBottom());

                  context.read<GroupCubit>().markAllMessagesAsRead(
                        widget.groupId,
                        widget.userId,
                      );

                  return ListView.builder(
                    controller: _scrollController,
                    itemCount: messages.length,
                    itemBuilder: (context, index) {
                      final message = messages[index];
                      final isMe = message.senderId == widget.userId;

                      return Align(
                        alignment:
                            isMe ? Alignment.centerRight : Alignment.centerLeft,
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
                                  color:
                                      isMe ? Colors.grey : Colors.grey.shade200,
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(isMe ? 0 : 20),
                                    topRight: const Radius.circular(20),
                                    bottomLeft: const Radius.circular(20),
                                    bottomRight: Radius.circular(isMe ? 20 : 0),
                                  ),
                                ),
                                child: Column(
                                  crossAxisAlignment: isMe
                                      ? CrossAxisAlignment.end
                                      : CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      message.message ?? '',
                                      style: TextStyle(
                                        fontSize: 16,
                                        color:
                                            isMe ? Colors.white : Colors.black,
                                      ),
                                    ),
                                    const SizedBox(height: 5),
                                    Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Text(
                                          _formatDate(
                                              message.timestamp!.toDate()),
                                          style: TextStyle(
                                            fontSize: 8,
                                            color: isMe
                                                ? Colors.white
                                                : Colors.black,
                                          ),
                                        ),
                                        SizedBox(width: 5.w),
                                        if (isMe) ...[
                                          Icon(
                                            message.readBy.any(
                                                    (id) => id != widget.userId)
                                                ? Icons.done_all
                                                : Icons.done,
                                            size: 15.sp,
                                            color: message.readBy.any(
                                                    (id) => id != widget.userId)
                                                ? Colors.blue
                                                : Colors.white,
                                          )
                                        ],
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
                },
              ),
            ),
            Container(
              color: Colors.grey.withOpacity(0.2),
              padding:
                  const EdgeInsets.only(left: 15, right: 15, bottom: 5, top: 8),
              child: Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _messageController,
                      style: GoogleFonts.nunitoSans(
                          fontSize: 15.sp,
                          fontWeight: FontWeight.w500,
                          color: Colors.white),
                      decoration: InputDecoration(
                        isDense: true,
                        filled: true,
                        hintText: "Type here..",
                        fillColor: AppTheme.primaryColor,
                        hintStyle: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w400,
                          color: Colors.white,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                          borderSide: BorderSide.none,
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                            vertical: 10, horizontal: 20),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  GestureDetector(
                    onTap: _sendMessage,
                    child: CircleAvatar(
                      backgroundColor: AppTheme.primaryColor,
                      child: Image.asset(
                        ImageAssets.sendMessageImage,
                        height: 40,
                        width: 40,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime dateTime) {
    return DateFormat('h:mm a').format(dateTime);
  }
}
