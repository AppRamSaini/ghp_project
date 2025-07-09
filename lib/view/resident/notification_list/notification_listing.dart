import 'package:ghp_society_management/constants/export.dart';
import 'package:ghp_society_management/controller/notification/notification_listing/notification_list_cubit.dart';
import 'package:ghp_society_management/view/dashboard/bottom_nav_screen.dart';
import 'package:ghp_society_management/view/security_staff/dashboard/bottom_navigation.dart';
import 'package:ghp_society_management/view/staff/bottom_nav_screen.dart';
import 'package:intl/intl.dart';

class NotificationListing extends StatefulWidget {
  final int index;
  const NotificationListing({super.key, required this.index});

  @override
  State<NotificationListing> createState() => _NotificationListingState();
}

class _NotificationListingState extends State<NotificationListing> {
  final ScrollController _scrollController = ScrollController();
  late NotificationListingCubit _notificationListingCubit;

  @override
  void initState() {
    super.initState();
    _notificationListingCubit = NotificationListingCubit()
      ..fetchNotifications();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.extentAfter < 300) {
      _notificationListingCubit.loadMoreNotification();
    }
  }

  Future onRefresh() async {
    _notificationListingCubit.fetchNotifications();
    setState(() {});
  }

  Future<bool> onBack() async {
    List pagesList =  [
      Dashboard(),
      SecurityGuardDashboard(),
      StaffDashboard()
    ];
    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => pagesList[widget.index]),
        (route) => false);

    return true;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: onBack,
      child: Scaffold(
        appBar: AppBar(title: Text('Notifications',
            style: TextStyle(
                color: Colors.black,
                fontSize: 16.sp,
                fontWeight: FontWeight.w600))),
        body: RefreshIndicator(
          onRefresh: onRefresh,
          child: BlocBuilder<NotificationListingCubit,
              NotificationListingState>(
            bloc: _notificationListingCubit,
            builder: (context, state) {
              if (state is NotificationListingLoading &&
                  _notificationListingCubit
                      .notificationList.isEmpty) {
                return const Center(
                    child: CircularProgressIndicator.adaptive());
              }

              if (state is NotificationListingFailed) {
                return Center(
                    child: Text(state.errorMsg,
                        style: const TextStyle(
                            color: Colors.deepPurpleAccent)));
              }

              if (state is NotificationListingEmpty) {
                return const Center(
                    child: Text("No notifications found",
                        style: TextStyle(
                            color: Colors.deepPurpleAccent)));
              }
              if (state is NotificationListingInternetError) {
                return Center(
                    child: Text(state.errorMsg.toString(),
                        style: const TextStyle(color: Colors.red)));
              }

              if (state is NotificationListingLoaded) {
                _notificationListingCubit.readNotifications();
              }

              var documentsList =
                  _notificationListingCubit.notificationList;
              return ListView.builder(
                controller: _scrollController,
                itemCount: documentsList.length + 1,
                physics: const AlwaysScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  if (index == documentsList.length) {
                    return _notificationListingCubit.state
                            is NotificationListingLoadingMore
                        ? const Padding(
                            padding: EdgeInsets.all(16.0),
                            child: Center(
                                child: CircularProgressIndicator()))
                        : const SizedBox.shrink();
                  }

                  String formattedDate =
                      DateFormat('dd MMM yyyy hh:mm a')
                          .format(documentsList[index].createdAt!);

                  return Padding(
                    padding: const EdgeInsets.all(12),
                    child: Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          border:
                              Border.all(color: Colors.grey[300]!)),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment:
                              CrossAxisAlignment.start,
                          children: [
                            Row(children: [
                              CircleAvatar(
                                  child: Image.asset(
                                      "assets/images/bell.png",
                                      color: Colors.deepPurpleAccent,
                                      height: 22.h)),
                              SizedBox(width: 10.w),
                              Expanded(
                                  child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                    Text(
                                        documentsList[index]
                                            .notification!
                                            .title!
                                            .toString(),
                                        style: GoogleFonts.nunitoSans(
                                            textStyle: TextStyle(
                                                color: Colors.black,
                                                fontSize: 14,
                                                fontWeight: FontWeight
                                                    .w500))),
                                    Text(formattedDate,
                                        style: GoogleFonts.nunitoSans(
                                            textStyle: TextStyle(
                                          color: Colors.black,
                                          fontSize: 12,
                                          fontWeight: FontWeight.w400,
                                        )))
                                  ]))
                            ]),
                            const Divider(thickness: 0.3),
                            Text(
                                documentsList[index]
                                    .notification!
                                    .body
                                    .toString(),
                                style: GoogleFonts.nunitoSans(
                                  textStyle: TextStyle(
                                    color: Colors.black,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w400,
                                  ),
                                )),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              );
            },
          ),
        ),
      ),
    );
  }

  showAlertDialog(BuildContext context, title, time, description) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Padding(
          padding: EdgeInsets.all(15.w),
          child: AlertDialog(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            insetPadding: EdgeInsets.zero,
            backgroundColor: Colors.white,
            surfaceTintColor: Colors.white,
            content: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    Image.asset(ImageAssets.noticeBoardImage, height: 50.h),
                    SizedBox(width: 10.w),
                    Expanded(
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                          Text(title,
                              style: GoogleFonts.nunitoSans(
                                  textStyle: TextStyle(
                                      color: Colors.black,
                                      fontSize: 15.sp,
                                      fontWeight: FontWeight.w600))),
                          Text(time,
                              style: GoogleFonts.nunitoSans(
                                  textStyle: TextStyle(
                                      color: Colors.black,
                                      fontSize: 12.sp,
                                      fontWeight: FontWeight.w400)))
                        ])),
                    SizedBox(width: 10.w),
                    GestureDetector(
                      onTap: () {
                        Navigator.of(context).pop();
                      },
                      child: Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(1000.r),
                            color: AppTheme.greyColor),
                        child: const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Icon(
                            Icons.close,
                            color: Colors.grey,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const Divider(thickness: 0.3),
                Text(description,
                    style: GoogleFonts.nunitoSans(
                      textStyle: TextStyle(
                        color: Colors.black,
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w400,
                      ),
                    )),
              ],
            ),
          ),
        );
      },
    );
  }
}

showAlertDialog(BuildContext context, title, time, description) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return Padding(
        padding: EdgeInsets.all(15.w),
        child: AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          insetPadding: EdgeInsets.zero,
          backgroundColor: Colors.white,
          surfaceTintColor: Colors.white,
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  Image.asset(ImageAssets.noticeBoardImage, height: 50.h),
                  SizedBox(width: 10.w),
                  Expanded(
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                        Text(title,
                            style: GoogleFonts.nunitoSans(
                                textStyle: TextStyle(
                                    color: Colors.black,
                                    fontSize: 15.sp,
                                    fontWeight: FontWeight.w600))),
                        Text(time,
                            style: GoogleFonts.nunitoSans(
                                textStyle: TextStyle(
                                    color: Colors.black,
                                    fontSize: 12.sp,
                                    fontWeight: FontWeight.w400)))
                      ])),
                  SizedBox(width: 10.w),
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).pop();
                    },
                    child: Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(1000.r),
                          color: AppTheme.greyColor),
                      child: const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Icon(
                          Icons.close,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const Divider(thickness: 0.3),
              Text(description,
                  style: GoogleFonts.nunitoSans(
                    textStyle: TextStyle(
                      color: Colors.black,
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w400,
                    ),
                  )),
            ],
          ),
        ),
      );
    },
  );
}
