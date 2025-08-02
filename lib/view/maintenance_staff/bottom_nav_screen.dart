import 'package:ghp_society_management/constants/export.dart';
import 'package:ghp_society_management/controller/notification/notification_listing/notification_list_cubit.dart';
import 'package:ghp_society_management/view/maintenance_staff/help_support_screen.dart';
import 'package:ghp_society_management/view/maintenance_staff/home_screen.dart';
import 'package:ghp_society_management/view/maintenance_staff/service_history_screen.dart';
import 'package:ghp_society_management/view/maintenance_staff/settings.dart';
import 'package:ghp_society_management/view/resident/setting/log_out_dialog.dart';

class StaffDashboard extends StatefulWidget {
  const StaffDashboard({super.key});

  @override
  State<StaffDashboard> createState() => StaffDashboardState();
}

class StaffDashboardState extends State<StaffDashboard> {
  int currentIndex = 0;
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    context.read<NotificationListingCubit>().fetchNotifications();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        exitPageConfirmationDialog(context);
        return true;
      },
      child: Scaffold(
        body: PageView(
            controller: _pageController,
            onPageChanged: (index) {
              setState(() => currentIndex = index);
            },
            children: [
              const StaffHomeScreen(),
              const ServiceHistoryScreen(),
              const HelpSupportScreen(),
              SettingScreenMaintenanceStaff()
            ]),
        bottomNavigationBar: Padding(
          padding: globalBottomPadding(context),
          child: Column(
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
                        child: bottomBarWidget(ImageAssets.serviceHistoryImage,
                            "Service History", currentIndex, 1)),
                    GestureDetector(
                        onTap: () {
                          currentIndex = 2;
                          _pageController.jumpToPage(2);
                          setState(() {});
                        },
                        child: bottomBarWidget(ImageAssets.headsetImage,
                            "Help & Support", currentIndex, 2)),
                    GestureDetector(
                      onTap: () {
                        currentIndex = 3;
                        _pageController.jumpToPage(3);
                        setState(() {});
                      },
                      child: bottomBarWidget(ImageAssets.settingImage,
                          "Settings", currentIndex, 3),
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
