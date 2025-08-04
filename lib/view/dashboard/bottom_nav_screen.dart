/*import 'package:ghp_society_management/constants/export.dart';
import 'package:ghp_society_management/controller/notification/notification_listing/notification_list_cubit.dart';
import 'package:ghp_society_management/controller/property_listing/property_listing_cubit.dart';
import 'package:ghp_society_management/controller/refer_property/refer_property_element/refer_property_element_cubit.dart';
import 'package:ghp_society_management/controller/sos_management/sos_element/sos_element_cubit.dart';
import 'package:ghp_society_management/controller/visitors/incoming_request/incoming_request_cubit.dart';
import 'package:ghp_society_management/model/incoming_visitors_request_model.dart';
import 'package:ghp_society_management/view/resident/documents/docuements_page.dart';
import 'package:ghp_society_management/view/resident/setting/log_out_dialog.dart';
import 'package:ghp_society_management/view/resident/setting/setting_screen.dart';
import 'package:ghp_society_management/view/resident/visitors/incomming_request.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => DashboardState();
}

class DashboardState extends State<Dashboard> {
  int currentIndex = 0;
  PageController? _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    context.read<PropertyListingCubit>().fetchPropertyList();
    context.read<NotificationListingCubit>().fetchNotifications();
  }

  @override
  void dispose() {
    _pageController!.dispose();
    super.dispose();
  }

  onChanged(int index) {
    setState(() => currentIndex = index);
    _pageController!.jumpToPage(1);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        exitPageConfirmationDialog(context);
        return true;
      },
      child: MultiBlocListener(
        listeners: [
          BlocListener<PropertyListingCubit, PropertyListingState>(
            listener: (context, state) {
              if (state is PropertyListingLoaded) {
                context.read<UserProfileCubit>().fetchUserProfile();
                context
                    .read<MyBillsCubit>()
                    .fetchMyBills(context: context, billTypes: "all");
              }
            },
          ),
          BlocListener<IncomingRequestCubit, IncomingRequestState>(
            listener: (context, state) {
              if (state is IncomingRequestLoaded) {
                print("IncomingRequestLoaded state triggered");
                IncomingVisitorsModel incomingVisitorsRequest =
                    state.incomingVisitorsRequest;
                if (incomingVisitorsRequest.lastCheckinDetail!.status ==
                    'requested') {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => VisitorsIncomingRequestPage(
                        incomingVisitorsRequest: incomingVisitorsRequest,
                        fromForegroundMsg: true,
                        setPageValue: (value) {},
                      ),
                    ),
                  );
                }
              }
            },
          ),
          BlocListener<VisitorsElementCubit, VisitorsElementState>(
            listener: (context, state) {
              if (state is VisitorsElementLogout) {
                sessionExpiredDialog(context);
              }
            },
          ),
          BlocListener<DocumentElementsCubit, DocumentElementsState>(
            listener: (context, state) {
              if (state is DocumentElementLogout) {
                sessionExpiredDialog(context);
              }
            },
          ),
          BlocListener<ReferPropertyElementCubit, ReferPropertyElementState>(
            listener: (context, state) {
              if (state is ReferPropertyElementLogout) {
                sessionExpiredDialog(context);
              }
            },
          ),
          BlocListener<SosElementCubit, SosElementState>(
              listener: (context, state) {
            if (state is SosElementLogout) {
              sessionExpiredDialog(context);
            }
          }),
          BlocListener<MembersElementCubit, MembersElementState>(
            listener: (context, state) {
              if (state is MembersElementLogout) {
                sessionExpiredDialog(context);
              }
            },
          ),
        ],
        child: Scaffold(
          body: PageView(
            controller: _pageController,
            onPageChanged: (index) {
              setState(() => currentIndex = index);
            },
            children: <Widget>[
              HomeScreen(onChanged: onChanged),
              const DocumentsScreen(),
              SettingScreen()
            ],
          ),
          bottomNavigationBar: BottomNavyBar(
            selectedIndex: currentIndex,
            onItemSelected: (index) {
              setState(() => currentIndex = index);
              _pageController!.jumpToPage(index);
            },
            items: <BottomNavyBarItem>[
              BottomNavyBarItem(
                  title: Text(
                    'Home',
                    style: GoogleFonts.nunitoSans(
                      textStyle: TextStyle(
                        color: Colors.black,
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  icon: Padding(
                    padding: const EdgeInsets.only(left: 5.0),
                    child: Image.asset(
                      ImageAssets.homeImage,
                      height: 16.h,
                      color: Colors.black,
                    ),
                  ),
                  activeColor: AppTheme.blueColor),
              // BottomNavyBarItem(
              //     title: Text(
              //       'Bills',
              //       style: GoogleFonts.nunitoSans(
              //         textStyle: TextStyle(
              //           color: Colors.black,
              //           fontSize: 14.sp,
              //           fontWeight: FontWeight.w500,
              //         ),
              //       ),
              //     ),
              //     icon: Padding(
              //       padding: const EdgeInsets.only(left: 5.0),
              //       child: Image.asset(
              //         ImageAssets.billImage,
              //         height: 18.h,
              //         color: Colors.black,
              //       ),
              //     ),
              //     activeColor: AppTheme.blueColor),
              BottomNavyBarItem(
                  title: Text(
                    'Documents',
                    style: GoogleFonts.nunitoSans(
                      textStyle: TextStyle(
                        color: Colors.black,
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  icon: Padding(
                    padding: const EdgeInsets.only(left: 5.0),
                    child: Image.asset(
                      ImageAssets.documentImage,
                      height: 16.h,
                      color: Colors.black,
                    ),
                  ),
                  activeColor: AppTheme.blueColor),
              BottomNavyBarItem(
                  textAlign: TextAlign.center,
                  title: Text('Settings',
                      style: GoogleFonts.nunitoSans(
                          textStyle: TextStyle(
                              color: Colors.black,
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w500))),
                  icon: Padding(
                      padding: const EdgeInsets.only(left: 5.0),
                      child: Image.asset(ImageAssets.settingImage,
                          height: 16.h, color: Colors.black)),
                  activeColor: AppTheme.blueColor),
            ],
          ),
        ),
      ),
    );
  }
}*/
import 'package:ghp_society_management/constants/export.dart';
import 'package:ghp_society_management/controller/property_listing/property_listing_cubit.dart';
import 'package:ghp_society_management/controller/refer_property/refer_property_element/refer_property_element_cubit.dart';
import 'package:ghp_society_management/controller/sos_management/sos_element/sos_element_cubit.dart';
import 'package:ghp_society_management/controller/visitors/incoming_request/incoming_request_cubit.dart';
import 'package:ghp_society_management/model/incoming_visitors_request_model.dart';
import 'package:ghp_society_management/view/resident/documents/docuements_page.dart';
import 'package:ghp_society_management/view/resident/setting/log_out_dialog.dart';
import 'package:ghp_society_management/view/resident/setting/setting_screen.dart';
import 'package:ghp_society_management/view/resident/visitors/incomming_request.dart';

import '../resident/daily_helps_member/daily_help_member_resident_side.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => DashboardState();
}

class DashboardState extends State<Dashboard> {
  int currentIndex = 0;
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    context.read<PropertyListingCubit>().fetchPropertyList();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void onChanged(int index) {
    setState(() => currentIndex = index);
    _pageController.jumpToPage(index);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        exitPageConfirmationDialog(context);
        return true;
      },
      child: MultiBlocListener(
        listeners: [
          BlocListener<PropertyListingCubit, PropertyListingState>(
            listener: (context, state) {
              if (state is PropertyListingLoaded) {
                context.read<UserProfileCubit>().fetchUserProfile();
                context
                    .read<MyBillsCubit>()
                    .fetchMyBills(context: context, billTypes: "all");
              }
            },
          ),
          BlocListener<IncomingRequestCubit, IncomingRequestState>(
            listener: (context, state) {
              if (state is IncomingRequestLoaded) {
                print("IncomingRequestLoaded state triggered");
                IncomingVisitorsModel incomingVisitorsRequest =
                    state.incomingVisitorsRequest;
                if (incomingVisitorsRequest.lastCheckinDetail!.status ==
                    'requested') {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => VisitorsIncomingRequestPage(
                        incomingVisitorsRequest: incomingVisitorsRequest,
                        fromForegroundMsg: true,
                        setPageValue: (value) {},
                      ),
                    ),
                  );
                }
              }
            },
          ),
          BlocListener<VisitorsElementCubit, VisitorsElementState>(
            listener: (context, state) {
              if (state is VisitorsElementLogout) {
                sessionExpiredDialog(context);
              }
            },
          ),
          BlocListener<DocumentElementsCubit, DocumentElementsState>(
            listener: (context, state) {
              if (state is DocumentElementLogout) {
                sessionExpiredDialog(context);
              }
            },
          ),
          BlocListener<ReferPropertyElementCubit, ReferPropertyElementState>(
            listener: (context, state) {
              if (state is ReferPropertyElementLogout) {
                sessionExpiredDialog(context);
              }
            },
          ),
          BlocListener<SosElementCubit, SosElementState>(
              listener: (context, state) {
            if (state is SosElementLogout) {
              sessionExpiredDialog(context);
            }
          }),
          BlocListener<MembersElementCubit, MembersElementState>(
            listener: (context, state) {
              if (state is MembersElementLogout) {
                sessionExpiredDialog(context);
              }
            },
          ),
        ],
        child: Scaffold(
          body: PageView(
              controller: _pageController,
              onPageChanged: (index) {
                setState(() => currentIndex = index);
              },
              children: [
                HomeScreen(onChanged: onChanged),
                const DocumentsScreen(),
                DailyHelpListingHistoryResidentSide(),
                SettingScreen()
              ]),
          bottomNavigationBar: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                decoration: const BoxDecoration(
                    color: Colors.white,
                    boxShadow: [BoxShadow(color: Colors.grey, blurRadius: 10)]),
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                        onTap: () {
                          currentIndex = 0;
                          _pageController.jumpToPage(0);
                          setState(() {});
                        },
                        child: bottomBarWidget(
                            ImageAssets.homeImage, "Home", currentIndex, 0)),
                    GestureDetector(
                        onTap: () {
                          currentIndex = 1;
                          _pageController.jumpToPage(1);
                          setState(() {});
                        },
                        child: bottomBarWidget(ImageAssets.documentImage,
                            "Documents", currentIndex, 1)),
                    GestureDetector(
                        onTap: () {
                          currentIndex = 2;
                          _pageController.jumpToPage(2);
                          setState(() {});
                        },
                        child: bottomBarWidget(ImageAssets.calendarImage,
                            "Daily Help", currentIndex, 2)),
                    GestureDetector(
                      onTap: () {
                        currentIndex = 3;
                        _pageController.jumpToPage(3);
                        setState(() {});
                      },
                      child: bottomBarWidget(
                          ImageAssets.settingImage, "Setting", currentIndex, 3),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget bottomBarWidget(
      String icon, String label, int currentIndex, int index) {
    return Column(
      children: [
        Image.asset(icon,
            color:
                currentIndex == index ? Colors.deepPurpleAccent : Colors.black,
            height: 18),
        Text(
          label,
          style: TextStyle(
            fontSize: 13,
            color:
                currentIndex == index ? Colors.deepPurpleAccent : Colors.black,
          ),
        ),
      ],
    );
  }
}
