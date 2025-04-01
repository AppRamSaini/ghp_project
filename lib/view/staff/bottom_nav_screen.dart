import 'package:ghp_app/constants/export.dart';
import 'package:ghp_app/controller/notification/notification_listing/notification_list_cubit.dart';
import 'package:ghp_app/view/resident/setting/log_out_dialog.dart';
import 'package:ghp_app/view/resident/setting/setting_screen.dart';
import 'package:ghp_app/view/staff/help_support_screen.dart';
import 'package:ghp_app/view/staff/home_screen.dart';
import 'package:ghp_app/view/staff/service/service_history_screen.dart';

class StaffDashboard extends StatefulWidget {
  const StaffDashboard({super.key});

  @override
  State<StaffDashboard> createState() => StaffDashboardState();
}

class StaffDashboardState extends State<StaffDashboard> {
  int currentIndex = 0;
  PageController? _pageController;

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
          body: SizedBox.expand(
            child: PageView(
              controller: _pageController,
              onPageChanged: (index) {
                setState(() => currentIndex = index);
              },
              children: <Widget>[
                const StaffHomeScreen(),
                const ServiceHistoryScreen(),
                const HelpSupportScreen(),
                // NotificationScreen(isStaffSide: true),
                SettingScreen()
                // const HelpSupportScreen(),
              ],
            ),
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
                      height: 18.h,
                      color: Colors.black,
                    ),
                  ),
                  activeColor: Colors.grey),
              BottomNavyBarItem(
                  title: Text(
                    'Service History',
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
                      ImageAssets.serviceHistoryImage,
                      height: 18.h,
                      color: Colors.black,
                    ),
                  ),
                  activeColor: Colors.grey),
              BottomNavyBarItem(
                  title: Text(
                    'Help & Support',
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
                      ImageAssets.headsetImage,
                      height: 18.h,
                      color: Colors.black,
                    ),
                  ),
                  activeColor: Colors.grey),
              BottomNavyBarItem(
                  title: Text(
                    'Setting',
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
                      ImageAssets.settingImage,
                      height: 18.h,
                      color: Colors.black,
                    ),
                  ),
                  activeColor: Colors.grey),
            ],
          ),
        ));
  }
}
