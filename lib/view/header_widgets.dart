import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ghp_society_management/constants/export.dart';
import 'package:ghp_society_management/model/group_model.dart';
import 'package:ghp_society_management/view/chat/chat_screen.dart';
import 'package:ghp_society_management/view/maintenance_staff/chat_screen.dart';
import 'package:ghp_society_management/view/manage_property/resident_property.dart';
import 'package:ghp_society_management/view/resident/notification_list/notification_listing.dart';
import 'package:rxdart/rxdart.dart';

/// SECURITY STAFF HEADER
Widget securityStaffHeaderWidget(
    BuildContext context, String userId, String userName, String userImage) {
  final int counts = LocalStorage.localStorage.getInt('counts') ?? 0;

  return Row(
    mainAxisAlignment: MainAxisAlignment.end,
    mainAxisSize: MainAxisSize.min,
    children: [
      /// 📩 Chat Icon with Total Unread Count
      StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('groups')
            .where("userIds", arrayContains: userId)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return chatIcon(0, context, userId, userImage, userName, 'staff');
          }

          List<GroupModel> groups = snapshot.data!.docs
              .map((doc) =>
                  GroupModel.fromMap(doc.data() as Map<String, dynamic>))
              .toList();

          return StreamBuilder<List<int>>(
            stream: getTotalUnreadCounts(groups, userId),
            builder: (context, unreadSnapshot) {
              int totalUnread =
                  unreadSnapshot.data?.fold(0, (a, b) => a! + b) ?? 0;
              return chatIcon(
                  totalUnread, context, userId, userImage, userName, 'staff');
            },
          );
        },
      ),
      const SizedBox(width: 10),
      Stack(
        alignment: Alignment.topRight,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: GestureDetector(
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (_) => const NotificationListing(index: 1)),
              ),
              child: CircleAvatar(
                backgroundColor: AppTheme.white.withOpacity(0.5),
                child: Image.asset(ImageAssets.bellImage,
                    height: 20.h, color: AppTheme.resolvedButtonColor),
              ),
            ),
          ),
          if (counts > 0)
            Positioned(
              right: 0,
              top: 0,
              child: Container(
                padding: const EdgeInsets.all(5),
                decoration: const BoxDecoration(
                    color: Colors.redAccent, shape: BoxShape.circle),
                constraints: const BoxConstraints(minWidth: 18, minHeight: 18),
                child: Text(
                  counts.toString(),
                  style: const TextStyle(fontSize: 10, color: Colors.white),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
        ],
      ),

      //
      // const SizedBox(width: 10),
      //
      // /// 🚪 Logout Icon
      // GestureDetector(
      //   onTap: () => logOutPermissionDialog(context, isLogout: true),
      //   child: CircleAvatar(
      //     backgroundColor: AppTheme.resolvedButtonColor.withOpacity(0.2),
      //     child: Image.asset(ImageAssets.staffLogoutImage,
      //         height: 20.h, color: AppTheme.resolvedButtonColor),
      //   ),
      // ),
    ],
  );
}

/// SECURITY STAFF HEADER
Widget securityStaffHeaderLoading(BuildContext context) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.end,
    mainAxisSize: MainAxisSize.min,
    children: [
      Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: CircleAvatar(
              backgroundColor: AppTheme.white.withOpacity(0.5),
              child: Image.asset(ImageAssets.messageImage,
                  height: 20.h, color: AppTheme.resolvedButtonColor))),
      const SizedBox(width: 10),
      Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: GestureDetector(
          onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (_) => const NotificationListing(index: 1))),
          child: CircleAvatar(
            backgroundColor: AppTheme.white.withOpacity(0.5),
            child: Image.asset(ImageAssets.bellImage,
                height: 20.h, color: AppTheme.resolvedButtonColor),
          ),
        ),
      ),

      //
      // const SizedBox(width: 10),
      //
      // /// 🚪 Logout Icon
      // GestureDetector(
      //   onTap: () => logOutPermissionDialog(context, isLogout: true),
      //   child: CircleAvatar(
      //     backgroundColor: AppTheme.resolvedButtonColor.withOpacity(0.2),
      //     child: Image.asset(ImageAssets.staffLogoutImage,
      //         height: 20.h, color: AppTheme.resolvedButtonColor),
      //   ),
      // ),
    ],
  );
}

/// 📩 Chat Icon Widget
Widget chatIcon(int unreadCount, BuildContext context, String userId,
    String userImage, String userName, String forType,
    {bool isDemo = false}) {
  return GestureDetector(
    onTap: () {
      if (!isDemo) {
        Navigator.of(context).push(MaterialPageRoute(
            builder: (builder) => forType == 'resident'
                ? ChatScreen(
                    userImage: userImage, userId: userId, userName: userName)
                : forType == 'staff'
                    ? StaffChatScreen(
                        userImage: userImage,
                        userId: userId,
                        userName: userName)
                    : StaffChatScreen(
                        userImage: userImage,
                        userId: userId,
                        userName: userName)));
      }
    },
    child: Stack(
      alignment: Alignment.topRight,
      children: [
        Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: CircleAvatar(
                backgroundColor: AppTheme.white.withOpacity(0.5),
                child: Image.asset(ImageAssets.messageImage,
                    height: 20.h, color: AppTheme.resolvedButtonColor))),
        if (unreadCount > 0)
          Positioned(
            right: 0,
            top: 0,
            child: Container(
              padding: const EdgeInsets.all(5),
              decoration: const BoxDecoration(
                  color: Colors.redAccent, shape: BoxShape.circle),
              constraints: const BoxConstraints(minWidth: 18, minHeight: 18),
              child: Text(
                unreadCount.toString(),
                style: const TextStyle(fontSize: 10, color: Colors.white),
                textAlign: TextAlign.center,
              ),
            ),
          ),
      ],
    ),
  );
}

/// 🔢 Get Total Unread Messages Count for All Groups
Stream<List<int>> getTotalUnreadCounts(List<GroupModel> groups, String userId) {
  List<Stream<int>> unreadStreams = groups.map((group) {
    return getUnreadMessagesCount(group.id!, userId);
  }).toList();

  return Rx.combineLatest(unreadStreams, (values) => values.cast<int>());
}

/// SERVICE PROVIDER HEADER WIDGET
Widget serviceProviderHeaderWidget(
    BuildContext context, userId, userName, userImage) {
  final int counts = LocalStorage.localStorage.getInt('counts') ?? 0;
  return Row(
    mainAxisSize: MainAxisSize.min,
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      /// 📩 Chat Icon with Total Unread Count
      StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('groups')
            .where("userIds", arrayContains: userId)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return chatIcon(
                0, context, userId, userImage, userName, 'service_provider');
          }

          List<GroupModel> groups = snapshot.data!.docs
              .map((doc) =>
                  GroupModel.fromMap(doc.data() as Map<String, dynamic>))
              .toList();

          return StreamBuilder<List<int>>(
            stream: getTotalUnreadCounts(groups, userId),
            builder: (context, unreadSnapshot) {
              int totalUnread =
                  unreadSnapshot.data?.fold(0, (a, b) => a! + b) ?? 0;
              return chatIcon(totalUnread, context, userId, userImage, userName,
                  'service_provider');
            },
          );
        },
      ),
      const SizedBox(width: 8),
      Stack(
        alignment: Alignment.topRight,
        children: [
          Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: GestureDetector(
                  onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => const NotificationListing(index: 2))),
                  child: CircleAvatar(
                      backgroundColor: AppTheme.white.withOpacity(0.5),
                      child: Image.asset(ImageAssets.bellImage,
                          height: 20.h, color: AppTheme.resolvedButtonColor)))),
          counts > 0
              ? Positioned(
                  right: 0,
                  top: 0,
                  child: Container(
                    padding: const EdgeInsets.all(5),
                    decoration: const BoxDecoration(
                        color: Colors.redAccent, shape: BoxShape.circle),
                    constraints:
                        const BoxConstraints(minWidth: 18, minHeight: 18),
                    child: Text(
                      counts.toString(),
                      style: const TextStyle(fontSize: 10, color: Colors.white),
                      textAlign: TextAlign.center,
                    ),
                  ),
                )
              : SizedBox.fromSize()
        ],
      ),

      // const SizedBox(width: 8),
      // GestureDetector(
      //   onTap: () {
      //     logOutPermissionDialog(context, isLogout: true);
      //   },
      //   child: CircleAvatar(
      //     backgroundColor: AppTheme.resolvedButtonColor.withOpacity(0.2),
      //     child: Image.asset(
      //       ImageAssets.staffLogoutImage,
      //       height: 20.h,
      //       color: AppTheme.resolvedButtonColor,
      //     ),
      //   ),
      // ),
    ],
  );
}

/// RESIDENCE HEADER WIDGETS
Widget headerWidget(BuildContext context, userId, userName, userImage,
    {bool isDemo = false}) {
  final int counts = LocalStorage.localStorage.getInt('counts') ?? 0;
  return Row(
    mainAxisAlignment: MainAxisAlignment.end,
    mainAxisSize: MainAxisSize.min,
    children: [
      // StreamBuilder<QuerySnapshot>(
      //   stream: FirebaseFirestore.instance
      //       .collection('groups')
      //       .where("userIds", arrayContains: userId)
      //       .snapshots(),
      //   builder: (context, snapshot) {
      //     if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
      //       return chatIcon(
      //           0, context, userId, userImage, userName, 'resident');
      //     }
      //
      //     List<GroupModel> groups = snapshot.data!.docs
      //         .map((doc) =>
      //             GroupModel.fromMap(doc.data() as Map<String, dynamic>))
      //         .toList();
      //
      //     return StreamBuilder<List<int>>(
      //       stream: getTotalUnreadCounts(groups, userId),
      //       builder: (context, unreadSnapshot) {
      //         int totalUnread =
      //             unreadSnapshot.data?.fold(0, (a, b) => a! + b) ?? 0;
      //         return chatIcon(
      //             totalUnread, context, userId, userImage, userName, 'resident',
      //             isDemo: isDemo);
      //       },
      //     );
      //   },
      // ),
      // const SizedBox(width: 10),
      Stack(
        alignment: Alignment.topRight,
        children: [
          Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: GestureDetector(
                  onTap: () {
                    if (!isDemo) {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => NotificationListing(index: 0)));
                    }
                  },
                  child: CircleAvatar(
                      backgroundColor: AppTheme.primaryColor.withOpacity(0.2),
                      child: Image.asset(ImageAssets.bellImage,
                          height: 20.h, color: AppTheme.resolvedButtonColor)))),
          counts > 0
              ? Positioned(
                  right: 0,
                  top: 0,
                  child: Container(
                      padding: const EdgeInsets.all(5),
                      decoration: const BoxDecoration(
                          color: Colors.redAccent, shape: BoxShape.circle),
                      constraints:
                          const BoxConstraints(minWidth: 18, minHeight: 18),
                      child: Text(counts.toString(),
                          style: const TextStyle(
                              fontSize: 10, color: Colors.white),
                          textAlign: TextAlign.center)))
              : SizedBox.fromSize()
        ],
      ),

      const SizedBox(width: 10),

      ManageProperty()
      // GestureDetector(
      //   onTap: () {
      //     if (!isDemo) {
      //       logOutPermissionDialog(context, isLogout: true);
      //     }
      //   },
      //   child: CircleAvatar(
      //     backgroundColor: AppTheme.primaryColor.withOpacity(0.2),
      //     child: Image.asset(
      //       ImageAssets.staffLogoutImage,
      //       height: 20.h,
      //       color: AppTheme.resolvedButtonColor,
      //     ),
      //   ),
      // ),
    ],
  );
}

/// RESIDENCE HEADER WIDGETS
Widget residentSideHeader(BuildContext context) {
  final int counts = LocalStorage.localStorage.getInt('counts') ?? 0;

  return Row(
    mainAxisAlignment: MainAxisAlignment.end,
    mainAxisSize: MainAxisSize.min,
    children: [
      BlocBuilder<UserProfileCubit, UserProfileState>(
          builder: (context, state) {
        if (state is UserProfileLoaded) {
          final user = state.userProfile.first.data?.user;
          return StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection('groups')
                .where("userIds", arrayContains: user!.id)
                .snapshots(),
            builder: (context, snapshot) {
              if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                return chatIcon(0, context, user.id.toString(),
                    user.image.toString(), user.name.toString(), 'resident');
              }

              List<GroupModel> groups = snapshot.data!.docs
                  .map((doc) =>
                      GroupModel.fromMap(doc.data() as Map<String, dynamic>))
                  .toList();
              return StreamBuilder<List<int>>(
                stream: getTotalUnreadCounts(groups, user.id.toString()),
                builder: (context, unreadSnapshot) {
                  int totalUnread =
                      unreadSnapshot.data?.fold(0, (a, b) => a! + b) ?? 0;
                  return chatIcon(totalUnread, context, user.id.toString(),
                      user.image.toString(), user.name.toString(), 'resident');
                },
              );
            },
          );
        } else {
          return chatIcon(0, context, '', '', '', '');
        }
      }),
      const SizedBox(width: 10),
      Stack(
        alignment: Alignment.topRight,
        children: [
          Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => NotificationListing(index: 0)));
                  },
                  child: CircleAvatar(
                      backgroundColor: AppTheme.white.withOpacity(0.5),
                      child: Image.asset(ImageAssets.bellImage,
                          height: 20.h, color: AppTheme.resolvedButtonColor)))),
          counts > 0
              ? Positioned(
                  right: 0,
                  top: 0,
                  child: Container(
                      padding: const EdgeInsets.all(5),
                      decoration: const BoxDecoration(
                          color: Colors.redAccent, shape: BoxShape.circle),
                      constraints:
                          const BoxConstraints(minWidth: 18, minHeight: 18),
                      child: Text(counts.toString(),
                          style: const TextStyle(
                              fontSize: 10, color: Colors.white),
                          textAlign: TextAlign.center)))
              : SizedBox.fromSize()
        ],
      ),
      const SizedBox(width: 10),
      //
      // /// 🚪 Logout Icon
      // GestureDetector(
      //   onTap: () => logOutPermissionDialog(context, isLogout: true),
      //   child: CircleAvatar(
      //     backgroundColor: AppTheme.white.withOpacity(0.5),
      //     child: Image.asset(ImageAssets.staffLogoutImage,
      //         height: 20.h, color: AppTheme.resolvedButtonColor),
      //   ),
      // ),
      // const SizedBox(width: 10),
      ManageProperty()
    ],
  );
}
