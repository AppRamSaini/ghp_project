import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:ghp_society_management/constants/dialog.dart';
import 'package:ghp_society_management/constants/export.dart';
import 'package:ghp_society_management/constants/simmer_loading.dart';
import 'package:ghp_society_management/controller/notification/notification_listing/notification_list_cubit.dart';
import 'package:ghp_society_management/controller/property_listing/property_listing_cubit.dart';
import 'package:ghp_society_management/controller/visitors/incoming_request/incoming_request_cubit.dart';
import 'package:ghp_society_management/main.dart';
import 'package:ghp_society_management/model/incoming_visitors_request_model.dart';
import 'package:ghp_society_management/model/user_profile_model.dart';
import 'package:ghp_society_management/view/dashboard/view_all_features.dart';
import 'package:ghp_society_management/view/resident/bills/home_bill_section.dart';
import 'package:ghp_society_management/view/resident/bills/my_bill_history.dart';
import 'package:ghp_society_management/view/resident/complaint/comlaint_page.dart';
import 'package:ghp_society_management/view/resident/notice_board/notice_board_screen.dart';
import 'package:ghp_society_management/view/resident/setting/log_out_dialog.dart';
import 'package:ghp_society_management/view/resident/visitors/incomming_request.dart';
import 'package:ghp_society_management/view/resident/visitors/visitor_screen.dart';
import 'package:ghp_society_management/view/select_society/select_society_screen.dart';
import 'package:showcaseview/showcaseview.dart';

import '../resident/parcel_flow/parcel_listing.dart';

/// Global key for the first showcase widget
final GlobalKey _firstShowcaseWidget = GlobalKey();

/// Global key for the last showcase widget
final GlobalKey _lastShowcaseWidget = GlobalKey();

class ResidentHomePage extends StatelessWidget {
  final Function(int index) onChanged;

  const ResidentHomePage({super.key, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ShowCaseWidget(
        hideFloatingActionWidgetForShowcase: [_lastShowcaseWidget],
        globalFloatingActionWidget: (showcaseContext) => FloatingActionWidget(
          left: 16,
          bottom: 16,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              onPressed: ShowCaseWidget.of(showcaseContext).dismiss,
              style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xffEE5366)),
              child: const Text(
                'Skip',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                ),
              ),
            ),
          ),
        ),
        onStart: (index, key) {},
        onComplete: (index, key) {
          if (index == 4) {
            SystemChrome.setSystemUIOverlayStyle(
              SystemUiOverlayStyle.light.copyWith(
                statusBarIconBrightness: Brightness.dark,
                statusBarColor: Colors.white,
              ),
            );
          }
        },
        blurValue: 1,
        autoPlayDelay: const Duration(seconds: 3),
        builder: (context) => HomeScreen(onChanged: onChanged),
        globalTooltipActionConfig: const TooltipActionConfig(
            position: TooltipActionPosition.inside,
            alignment: MainAxisAlignment.spaceBetween,
            actionGap: 20),
        globalTooltipActions: [
          TooltipActionButton(
              type: TooltipDefaultActionType.previous,
              textStyle: const TextStyle(color: Colors.white),
              hideActionWidgetForShowcase: [_firstShowcaseWidget]),
          TooltipActionButton(
            type: TooltipDefaultActionType.next,
            textStyle: const TextStyle(color: Colors.white),
            hideActionWidgetForShowcase: [_lastShowcaseWidget],
          ),
        ],
      ),
    );
  }
}

class HomeScreen extends StatefulWidget {
  final Function(int index) onChanged;

  const HomeScreen({super.key, required this.onChanged});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool showLess = true;
  late BuildContext dialogueContext;
  List colors = [
    AppTheme.color9,
    AppTheme.color2,
    AppTheme.color3,
    AppTheme.color4
  ];

  List dataList = [
    {"icon": ImageAssets.notice1, "title": "Notice Board"},
    {"icon": ImageAssets.complaint1, "title": "Complaints"},
    {"icon": ImageAssets.visitors1, "title": "Visitors"},
    {"icon": ImageAssets.parcel1, "title": "Parcels"},
  ];

  List pagesList = [
    NoticeBoardScreen(),
    ComplaintScreen(),
    VisitorScreen(),
    ParcelListingPage()
  ];

  Future fetchBill() async {
    context.read<UserProfileCubit>().fetchUserProfile();
    context
        .read<MyBillsCubit>()
        .fetchMyBills(context: context, billTypes: "all");
    context.read<NotificationListingCubit>().fetchNotifications();
    context.read<IncomingRequestCubit>().fetchIncomingRequest();
    setState(() {});
  }

  final GlobalKey _one = GlobalKey();
  final GlobalKey _two = GlobalKey();
  final GlobalKey _three = GlobalKey();
  final GlobalKey _four = GlobalKey();

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () async {
      bool seen = await hasSeenShowcase();
      if (!seen) {
        ShowCaseWidget.of(context).startShowCase([
          _firstShowcaseWidget,
          _one,
          _two,
          _three,
          _four,
          _lastShowcaseWidget
        ]);
        await setShowcaseSeen();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<IncomingRequestCubit, IncomingRequestState>(
          listener: (context, state) {
            if (state is IncomingRequestLoaded) {
              IncomingVisitorsModel incomingVisitorsRequest =
                  state.incomingVisitorsRequest;
              if (incomingVisitorsRequest.lastCheckinDetail?.status ==
                  'requested') {
                if (ModalRoute.of(context)?.isCurrent ?? false) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => VisitorsIncomingRequestPage(
                        incomingVisitorsRequest: incomingVisitorsRequest,
                        setPageValue: (value) {},
                      ),
                    ),
                  );
                }
              }
            }
          },
        ),
        BlocListener<LogoutCubit, LogoutState>(
          listener: (context, state) async {
            if (state is LogoutLoading) {
              showLoadingDialog(context, (ctx) {
                dialogueContext = ctx;
              });
            } else if (state is LogoutSuccessfully) {
              snackBar(context, 'User logout successfully', Icons.done,
                  AppTheme.guestColor);
              Navigator.of(dialogueContext).pop();
              Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(
                      builder: (builder) => const SelectSocietyScreen()),
                  (route) => false);
            } else if (state is LogoutFailed) {
              snackBar(context, 'User logout failed', Icons.warning,
                  AppTheme.redColor);

              Navigator.of(dialogueContext).pop();
            } else if (state is LogoutInternetError) {
              snackBar(context, 'Internet connection failed', Icons.wifi_off,
                  AppTheme.redColor);

              Navigator.of(dialogueContext).pop();
            } else if (state is LogoutSessionError) {
              Navigator.of(dialogueContext).pop();
              sessionExpiredDialog(context);
            }
          },
        ),
      ],
      child: Scaffold(
        floatingActionButton: Padding(
            padding: const EdgeInsets.only(top: 12, right: 5),
            child: Showcase(
                targetPadding: const EdgeInsets.all(5),
                key: _three,
                title: 'Bill Payment',
                description:
                    "Quick bill payments with a complete view of upcoming and due bills.",
                tooltipBackgroundColor: AppTheme.guestColor,
                textColor: Colors.white,
                titleTextStyle: customTitle(),
                descTextStyle: customDes(),
                floatingActionWidget: FloatingActionWidget(
                  left: 16,
                  bottom: 16,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xffEE5366)),
                      onPressed: ShowCaseWidget.of(context).dismiss,
                      child: const Text(
                        'Close Showcase',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 15,
                        ),
                      ),
                    ),
                  ),
                ),
                targetShapeBorder: const CircleBorder(),
                tooltipActionConfig: const TooltipActionConfig(
                  alignment: MainAxisAlignment.spaceBetween,
                  gapBetweenContentAndAction: 10,
                  position: TooltipActionPosition.outside,
                ),
                tooltipActions: const [
                  TooltipActionButton(
                    backgroundColor: Colors.transparent,
                    type: TooltipDefaultActionType.previous,
                    padding: EdgeInsets.symmetric(vertical: 4),
                    textStyle: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                  TooltipActionButton(
                    type: TooltipDefaultActionType.next,
                    backgroundColor: Colors.white,
                    textStyle: TextStyle(
                      color: Colors.pinkAccent,
                    ),
                  ),
                ],
                child: FloatingActionButton(
                    backgroundColor: Colors.green,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(50)),
                    onPressed: () async {
                      // FirebaseMessaging messaging = FirebaseMessaging.instance;
                      //
                      // // Push Notification की परमिशन पहले लें
                      // await messaging.requestPermission(
                      //   alert: true,
                      //   badge: true,
                      //   sound: true
                      // );
                      //
                      // String? token;
                      //
                      // if (Platform.isIOS) {
                      //   // iOS के लिए APNS Token प्राप्त करें
                      //   token = await messaging.getAPNSToken();
                      //   print("APNS Token: $token");
                      // } else {
                      //   // Android के लिए FCM Token प्राप्त करें
                      //   token = await messaging.getToken();
                      //   print("FCM Token: $token");
                      // }

                      Navigator.push(context,
                          MaterialPageRoute(builder: (_) => BillScreen()));
                    },
                    child: Image.asset('assets/images/pay_img.png')))),
        appBar: AppBar(
            leadingWidth: size.width * 0.6,
            bottom: PreferredSize(preferredSize: Size(0, 8), child: SizedBox()),
            leading: BlocBuilder<UserProfileCubit, UserProfileState>(
              builder: (context, state) {
                if (state is UserProfileLoaded) {
                  final image = state.userProfile.first.data!.user!.image;
                  final name = state.userProfile.first.data!.user!.name;
                  final userId = state.userProfile.first.data!.user!.id;
                  LocalStorage.localStorage
                      .setString('user_image', image.toString());
                  LocalStorage.localStorage
                      .setString('user_name', name.toString());
                  LocalStorage.localStorage
                      .setString('user_id', userId.toString());
                  Future.delayed(const Duration(milliseconds: 5), () {
                    List<UnpaidBill> billData =
                        state.userProfile.first.data!.unpaidBills!;
                    if (billData.isNotEmpty) {
                      checkPaymentReminder(
                          context: context,
                          myUnpaidBill:
                              state.userProfile.first.data!.unpaidBills!.first);
                    }
                  });
                  return ListTile(
                    dense: true,
                    leading: Showcase(
                        key: _firstShowcaseWidget,
                        title: "Profile Data",
                        description: 'Your personal details, all in one place.',
                        titleTextStyle: customTitle().copyWith(
                            color: Colors.black,
                            fontSize: 16,
                            fontWeight: FontWeight.w500),
                        descTextStyle: customDes()
                            .copyWith(color: AppTheme.blueColor, fontSize: 12),
                        onBarrierClick: () {
                          ShowCaseWidget.of(context)
                              .hideFloatingActionWidgetForKeys(
                                  [_firstShowcaseWidget, _lastShowcaseWidget]);
                        },
                        tooltipActionConfig: const TooltipActionConfig(
                            alignment: MainAxisAlignment.end,
                            position: TooltipActionPosition.outside,
                            gapBetweenContentAndAction: 10),
                        child: GestureDetector(
                            onTap: () => profileViewAlertDialog(
                                context, state.userProfile.first),
                            child: state.userProfile.first.data!.user!.image !=
                                    null
                                ? ClipRRect(
                                    borderRadius: BorderRadius.circular(100),
                                    child: FadeInImage(
                                        height: 50,
                                        width: 50,
                                        fit: BoxFit.fill,
                                        placeholder: AssetImage(
                                            'assets/images/profile_icon.png'),
                                        image: NetworkImage(state
                                            .userProfile.first.data!.user!.image
                                            .toString()),
                                        imageErrorBuilder: (_, child, st) =>
                                            Image.asset(
                                                'assets/images/profile_icon.png',
                                                height: 50,
                                                width: 50,
                                                fit: BoxFit.fill)),
                                  )
                                : ClipRRect(
                                    borderRadius: BorderRadius.circular(100),
                                    child: FadeInImage(
                                      height: 50,
                                      width: 50,
                                      fit: BoxFit.fill,
                                      placeholder: AssetImage(
                                          'assets/images/profile_icon.png'),
                                      image: AssetImage(''),
                                      imageErrorBuilder: (_, child, st) =>
                                          Image.asset(
                                              'assets/images/profile_icon.png',
                                              height: 50,
                                              width: 50,
                                              fit: BoxFit.fill),
                                    ),
                                  ))),
                    title: Text(
                      state.userProfile.first.data!.user!.name.toString(),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                      style: GoogleFonts.nunitoSans(
                        textStyle: const TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    subtitle: state.userProfile.first.data!.user!.property !=
                            null
                        ? Text(
                            'Property : ${state.userProfile.first.data!.user!.property!.aprtNo ?? 'NIL'}'
                                .toUpperCase(),
                            style: GoogleFonts.nunitoSans(
                                textStyle: TextStyle(
                                    color: Colors.white,
                                    fontSize: 10,
                                    fontWeight: FontWeight.w500)))
                        : SizedBox(),
                  );
                } else {
                  return ListTile(
                      dense: true,
                      leading: ClipRRect(
                        borderRadius: BorderRadius.circular(100),
                        child: FadeInImage(
                          height: 50,
                          width: 50,
                          fit: BoxFit.fill,
                          placeholder:
                              AssetImage('assets/images/profile_icon.png'),
                          image: AssetImage(""),
                          imageErrorBuilder: (_, child, st) => Image.asset(
                              'assets/images/profile_icon.png',
                              height: 50,
                              width: 50,
                              fit: BoxFit.fill),
                        ),
                      ),
                      title: Text("Loading...",
                          style: TextStyle(color: AppTheme.white)),
                      subtitle: Text("Loading...",
                          style: TextStyle(color: AppTheme.white)));
                }
              },
            ),
            actions: [
              Padding(
                  padding: const EdgeInsets.only(right: 10),
                  child: Stack(
                    alignment: Alignment.topRight,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(top: 12, right: 70),
                            child: Align(
                              alignment: Alignment.topLeft,
                              child: Showcase(
                                  targetPadding: const EdgeInsets.all(5),
                                  key: _one,
                                  title: 'Chat with Staffs',
                                  description:
                                      "Chat instantly with security staff or service providers anytime",
                                  tooltipBackgroundColor:
                                      Theme.of(context).primaryColor,
                                  textColor: Colors.white,
                                  titleTextStyle: customTitle(),
                                  descTextStyle: customDes(),
                                  floatingActionWidget: FloatingActionWidget(
                                    left: 16,
                                    bottom: 16,
                                    child: Padding(
                                      padding: const EdgeInsets.all(16.0),
                                      child: ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor:
                                              const Color(0xffEE5366),
                                        ),
                                        onPressed:
                                            ShowCaseWidget.of(context).dismiss,
                                        child: const Text(
                                          'Skip',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 15,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  targetShapeBorder: const CircleBorder(),
                                  tooltipActionConfig:
                                      const TooltipActionConfig(
                                    alignment: MainAxisAlignment.spaceBetween,
                                    gapBetweenContentAndAction: 10,
                                    position: TooltipActionPosition.outside,
                                  ),
                                  tooltipActions: const [
                                    TooltipActionButton(
                                      backgroundColor: Colors.transparent,
                                      type: TooltipDefaultActionType.previous,
                                      padding: EdgeInsets.symmetric(
                                        vertical: 4,
                                      ),
                                      textStyle: TextStyle(
                                        color: Colors.white,
                                      ),
                                    ),
                                    TooltipActionButton(
                                      type: TooltipDefaultActionType.next,
                                      backgroundColor: Colors.white,
                                      textStyle: TextStyle(
                                        color: Colors.pinkAccent,
                                      ),
                                    ),
                                  ],
                                  child: Container(
                                    width: 30,
                                    height: 30,
                                  )),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 12, right: 5),
                            child: Align(
                              alignment: Alignment.topRight,
                              child: Showcase(
                                  targetPadding: const EdgeInsets.all(5),
                                  key: _two,
                                  title: 'Property Selector',
                                  description:
                                      "In the app, you can click on this property select icon to choose another property.",
                                  tooltipBackgroundColor:
                                      Theme.of(context).primaryColor,
                                  textColor: Colors.white,
                                  titleTextStyle: customTitle(),
                                  descTextStyle: customDes(),
                                  floatingActionWidget: FloatingActionWidget(
                                    left: 16,
                                    bottom: 16,
                                    child: Padding(
                                      padding: const EdgeInsets.all(16.0),
                                      child: ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor:
                                              const Color(0xffEE5366),
                                        ),
                                        onPressed:
                                            ShowCaseWidget.of(context).dismiss,
                                        child: const Text(
                                          'Close Showcase',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 15,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  targetShapeBorder: const CircleBorder(),
                                  tooltipActionConfig:
                                      const TooltipActionConfig(
                                    alignment: MainAxisAlignment.spaceBetween,
                                    gapBetweenContentAndAction: 10,
                                    position: TooltipActionPosition.outside,
                                  ),
                                  tooltipActions: const [
                                    TooltipActionButton(
                                      backgroundColor: Colors.transparent,
                                      type: TooltipDefaultActionType.previous,
                                      padding: EdgeInsets.symmetric(
                                        vertical: 4,
                                      ),
                                      textStyle: TextStyle(
                                        color: Colors.white,
                                      ),
                                    ),
                                    TooltipActionButton(
                                      type: TooltipDefaultActionType.next,
                                      backgroundColor: Colors.white,
                                      textStyle: TextStyle(
                                        color: Colors.pinkAccent,
                                      ),
                                    ),
                                  ],
                                  child: Container(
                                    width: 30,
                                    height: 30,
                                  )),
                            ),
                          ),
                        ],
                      ),
                      residentSideHeader(context),
                    ],
                  ))
            ]),
        body: RefreshIndicator(
          onRefresh: fetchBill,
          child: BlocBuilder<PropertyListingCubit, PropertyListingState>(
              builder: (context, state) {
            if (state is PropertyListingLoading) {
              return dashboardSimmerLoading(context, forHomePage: true);
            }

            return BlocBuilder<UserProfileCubit, UserProfileState>(
              builder: (context, state) {
                if (state is UserProfileLoading) {
                  return dashboardSimmerLoading(context, forHomePage: true);
                }
                if (state is UserProfileLoaded) {
                  return SingleChildScrollView(
                    child: Column(
                      children: [
                        SizedBox(height: 10.h),
                        const SlidersManagement(),
                        SizedBox(height: 10.h),
                        MyBillsPage(types: 'all'),
                        SizedBox(height: 10.h),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(left: 12.0),
                              child: Text('All Features',
                                  style: GoogleFonts.nunito(
                                    textStyle: TextStyle(
                                      color: Colors.black,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  )),
                            ),
                            GestureDetector(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (_) => ViewAllFeatures()));
                              },
                              child: Padding(
                                padding: const EdgeInsets.all(12.0),
                                child: Container(
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(20),
                                      border: Border.all(
                                          color: AppTheme.blueColor)),
                                  child: Padding(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 12.w, vertical: 5),
                                    child: Center(
                                      child: Text(
                                        'View All',
                                        style: GoogleFonts.nunitoSans(
                                          textStyle: TextStyle(
                                            color: AppTheme.blueColor,
                                            fontSize: 12,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        MasonryGridView.count(
                          crossAxisCount: 2,
                          mainAxisSpacing: 10,
                          crossAxisSpacing: 10,
                          shrinkWrap: true,
                          physics: BouncingScrollPhysics(),
                          padding: const EdgeInsets.all(10),
                          itemCount: 4,
                          itemBuilder: (context, index) {
                            double height;
                            // Define heights based on index
                            if (index % 3 == 0) {
                              height = size.height * 0.2; // 0, 3, 6...
                            } else if (index % 3 == 1) {
                              height = size.height * 0.26; // 1, 4, 7...
                            } else if (index % 3 == 2) {
                              height = size.height * 0.26; // 1, 4, 7...
                            } else {
                              height = size.height * 0.2; // optional for others
                            }

                            return GestureDetector(
                              onTap: () => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (_) => pagesList[index])),
                              child: Container(
                                height: height,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: colors[index % colors.length],
                                    border: Border.all(
                                        color: colors[index % colors.length],
                                        width: 2)),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Image.asset(dataList[index]['icon']),
                                    Text(
                                      dataList[index]['title'].toString(),
                                      textAlign: TextAlign.center,
                                      style: GoogleFonts.nunitoSans(
                                        textStyle: TextStyle(
                                          color: AppTheme.backgroundColor,
                                          fontSize: 14,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                        SizedBox(height: size.height * 0.1),
                        // Row(
                        //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        //   children: [
                        //     Padding(
                        //       padding: const EdgeInsets.only(left: 12.0),
                        //       child: Text('Upcoming Bills',
                        //           style: GoogleFonts.cormorant(
                        //             textStyle: TextStyle(
                        //               color: Colors.black,
                        //               fontSize: 18.sp,
                        //               fontWeight: FontWeight.w600,
                        //             ),
                        //           )),
                        //     ),
                        //     GestureDetector(
                        //       onTap: () {
                        //         widget.onChanged(1);
                        //       },
                        //       child: Padding(
                        //         padding: const EdgeInsets.all(12.0),
                        //         child: Container(
                        //           decoration: BoxDecoration(
                        //               borderRadius: BorderRadius.circular(20),
                        //               border: Border.all(color: AppTheme.blueColor)),
                        //           child: Padding(
                        //             padding: EdgeInsets.symmetric(
                        //                 horizontal: 12.w, vertical: 5),
                        //             child: Center(
                        //               child: Text(
                        //                 'View All',
                        //                 style: GoogleFonts.nunitoSans(
                        //                   textStyle: TextStyle(
                        //                     color: AppTheme.blueColor,
                        //                     fontSize: 12,
                        //                     fontWeight: FontWeight.w600,
                        //                   ),
                        //                 ),
                        //               ),
                        //             ),
                        //           ),
                        //         ),
                        //       ),
                        //     ),
                        //   ],
                        // ),
                      ],
                    ),
                  );
                } else {
                  return dashboardSimmerLoading(context, forHomePage: true);
                }
              },
            );
          }),
        ),
      ),
    );
  }
}

//
