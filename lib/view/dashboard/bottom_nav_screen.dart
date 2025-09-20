
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
          resizeToAvoidBottomInset: true,
          body: PageView(
              controller: _pageController,
              onPageChanged: (index) {
                setState(() => currentIndex = index);
              },
              children: [
                ResidentHomePage(onChanged: onChanged),
                const DocumentsScreen(),
                DailyHelpListingHistoryResidentSide(),
                SettingScreen()
              ]),
          bottomNavigationBar: SafeArea(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border(
                          top: BorderSide(
                              color: Colors.grey.withOpacity(0.3),
                              width: 1.0))),
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
                        child: bottomBarWidget(ImageAssets.settingImage,
                            "Setting", currentIndex, 3),
                      ),
                    ],
                  ),
                ),
              ],
            ),
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
            height: 19),
        5.verticalSpace,
        Text(
          label,
          style: GoogleFonts.montserrat(
            fontSize: 13,
            fontWeight: FontWeight.w500,
            color:
                currentIndex == index ? Colors.deepPurpleAccent : Colors.black,
          ),
        ),
      ],
    );
  }
}
