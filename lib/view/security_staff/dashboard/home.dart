import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:ghp_society_management/constants/app_images.dart';
import 'package:ghp_society_management/constants/app_theme.dart';
import 'package:ghp_society_management/constants/dialog.dart';
import 'package:ghp_society_management/constants/snack_bar.dart';
import 'package:ghp_society_management/controller/logout/logout_cubit.dart';
import 'package:ghp_society_management/controller/user_profile/user_profile_cubit.dart';
import 'package:ghp_society_management/main.dart';
import 'package:ghp_society_management/view/dashboard/bottom_nav_screen.dart';
import 'package:ghp_society_management/view/header_widgets.dart';
import 'package:ghp_society_management/view/resident/event/event_screen.dart';
import 'package:ghp_society_management/view/resident/member/members_screen.dart';
import 'package:ghp_society_management/view/resident/notice_board/notice_board_screen.dart';
import 'package:ghp_society_management/view/resident/setting/log_out_dialog.dart';
import 'package:ghp_society_management/view/resident/sos/sos_screen.dart';
import 'package:ghp_society_management/view/resident/visitors/add_visitor_screen.dart';
import 'package:ghp_society_management/view/security_staff/visitors/visitors_tab.dart';
import 'package:ghp_society_management/view/session_dialogue.dart';
import 'package:ghp_society_management/view/select_society/select_society_screen.dart';
import 'package:google_fonts/google_fonts.dart';

class SecurityGuardHome extends StatefulWidget {
  const SecurityGuardHome({super.key});

  @override
  State<SecurityGuardHome> createState() => _SecurityGuardHomeState();
}

class _SecurityGuardHomeState extends State<SecurityGuardHome> {
  bool showLess = true;

  late BuildContext dialogueContext;
  DashboardState homePageState = DashboardState();

  @override
  void initState() {
    super.initState();
    context.read<UserProfileCubit>().fetchUserProfile();
  }

  List colors = [
    AppTheme.color1,
    AppTheme.color2,
    AppTheme.color3,
    AppTheme.color4,
    AppTheme.color5,
    AppTheme.color6,
    AppTheme.color7,
    AppTheme.color8,
    AppTheme.color9,
    AppTheme.color10,
  ];

  List dataList = [
    {"icon": ImageAssets.member1, "title": "Members"},
    {"icon": ImageAssets.events1, "title": "Events"},
    {"icon": ImageAssets.sos1, "title": "SOS"},
    {"icon": ImageAssets.notice1, "title": "Notice Board"},
  ];
  List pagesList = [
    MemberScreen(),
    EventScreen(),
    SosScreen(),
    NoticeBoardScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<UserProfileCubit, UserProfileState>(
          listener: (context, state) {
            if (state is UserProfileLogout) {
              sessionExpiredDialog(context);
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
        appBar: AppBar(
            leadingWidth: double.infinity,
            leading: BlocBuilder<UserProfileCubit, UserProfileState>(
              builder: (context, state) {
                if (state is UserProfileLoaded) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              GestureDetector(
                                  onTap: () {
                                    // Future.delayed(Duration.zero,
                                    //     () => overDueBillAlertDialog(context));
                                    profileViewAlertDialog(
                                        context, state.userProfile.first);
                                  },
                                  child: state.userProfile.first.data!.user!
                                              .image !=
                                          null
                                      ? CircleAvatar(
                                          radius: 22.h,
                                          backgroundImage: NetworkImage(state
                                              .userProfile
                                              .first
                                              .data!
                                              .user!
                                              .image
                                              .toString()))
                                      : const CircleAvatar(
                                          radius: 22,
                                          backgroundImage: AssetImage(
                                              'assets/images/default.jpg'))),
                              const SizedBox(width: 10),
                              Flexible(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                        state.userProfile.first.data!.user!.name
                                            .toString(),
                                        style: GoogleFonts.nunitoSans(
                                            textStyle: TextStyle(
                                                color: Colors.black,
                                                fontSize: 15.sp,
                                                fontWeight: FontWeight.w600,
                                                overflow:
                                                    TextOverflow.ellipsis))),
                                    const SizedBox(height: 3),
                                    Text('Security Staff',
                                        style: GoogleFonts.nunitoSans(
                                            textStyle: TextStyle(
                                                color: Colors.black,
                                                fontSize: 10.sp,
                                                fontWeight: FontWeight.w500)))
                                  ],
                                ),
                              ),
                              const SizedBox(width: 10),
                            ],
                          ),
                        ),
                        securityStaffHeaderWidget(
                            context,
                            state.userProfile.first.data!.user!.id.toString(),
                            state.userProfile.first.data!.user!.name.toString(),
                            state.userProfile.first.data!.user!.image ?? '')
                      ],
                    ),
                  );
                } else {
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              const CircleAvatar(
                                  radius: 22,
                                  backgroundImage:
                                      AssetImage('assets/images/default.jpg')),
                              const SizedBox(width: 10),
                              Flexible(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text("Loading...",
                                        style: GoogleFonts.nunitoSans(
                                            textStyle: TextStyle(
                                                color: Colors.white,
                                                fontSize: 15.sp,
                                                fontWeight: FontWeight.w600,
                                                overflow:
                                                    TextOverflow.ellipsis))),
                                    const SizedBox(height: 3),
                                    Text('TOWER LOADING...',
                                        style: GoogleFonts.nunitoSans(
                                            textStyle: TextStyle(
                                                color: Colors.white,
                                                fontSize: 11.sp,
                                                fontWeight: FontWeight.w500)))
                                  ],
                                ),
                              ),
                              const SizedBox(width: 10)
                            ],
                          ),
                        ),
                        headerWidget(context, '', '', '', isDemo: true)
                      ],
                    ),
                  );
                }
              },
            )),
        floatingActionButton: FloatingActionButton(
            heroTag: "hero2",
            backgroundColor: AppTheme.primaryColor,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(100)),
            onPressed: () => Navigator.push(
                context, MaterialPageRoute(builder: (_) => AddVisitorScreen())),
            child: const Icon(Icons.add, color: Colors.white)),
        body: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: size.width * 0.035),
            child: Column(
              children: [
                SizedBox(height: 20.h),
                MasonryGridView.count(
                  crossAxisCount: 4,
                  mainAxisSpacing: 10,
                  crossAxisSpacing: 10,
                  shrinkWrap: true,
                  physics: BouncingScrollPhysics(),
                  padding: EdgeInsets.zero,
                  itemCount: dataList.length,
                  itemBuilder: (context, index) {
                    double height;
                    height = size.height * 0.09; // optional for others
                    return Column(
                      children: [
                        GestureDetector(
                          onTap: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (_) => pagesList[index])),
                          child: Container(
                              margin: EdgeInsets.only(bottom: 5),
                              height: height,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: colors[index % colors.length],
                                  border: Border.all(
                                      color: colors[index % colors.length],
                                      width: 2)),
                              child: Image.asset(dataList[index]['icon'])),
                        ),
                        Padding(
                          padding: EdgeInsets.only(bottom: 5),
                          child: Text(
                            dataList[index]['title'].toString(),
                            textAlign: TextAlign.center,
                            overflow: TextOverflow.ellipsis,
                            style: GoogleFonts.nunitoSans(
                              textStyle: TextStyle(
                                color: AppTheme.backgroundColor,
                                fontSize: 12.sp,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                ),
                SizedBox(height: size.height * 0.02),
                const Expanded(
                  child: VisitorsTabBar(),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// VISITORS CARD WIDGETS
Widget visitorsCardWidget(
        {String? counts, String? names, void Function()? onTap}) =>
    Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
          decoration: BoxDecoration(
              color: AppTheme.primaryColor,
              borderRadius: BorderRadius.circular(10)),
          child: Column(
            children: [
              Text(counts.toString(),
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 26.sp,
                      fontWeight: FontWeight.w600)),
              Text('$names'.toUpperCase(),
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 15.sp,
                      fontWeight: FontWeight.w600))
            ],
          ),
        ),
      ),
    );
