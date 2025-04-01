import 'package:ghp_app/constants/dialog.dart';
import 'package:ghp_app/constants/export.dart';
import 'package:ghp_app/view/resident/daily_helps_member/daily_help_member_resident_side.dart';
import 'package:ghp_app/view/resident/residents_checkouts/resident_checkouts_history_details.dart';
import 'package:ghp_app/view/resident/resident_profile/edit_profile_screen.dart';
import 'package:ghp_app/view/resident/resident_profile/resident_gatepass.dart';
import 'package:ghp_app/view/resident/resident_profile/resident_profile.dart';
import 'package:ghp_app/view/resident/setting/emergency_contact.dart';
import 'package:ghp_app/view/resident/setting/log_out_dialog.dart';
import 'package:ghp_app/view/resident/setting/notification_screen.dart';
import 'package:ghp_app/view/resident/setting/privacy_policy.dart';
import 'package:ghp_app/view/resident/setting/term_of_use.dart';
import 'package:ghp_app/view/security_staff/daliy_help/daily_helps_members.dart';
import 'package:ghp_app/view/society/select_society_screen.dart';

class SettingScreen extends StatefulWidget {
  bool forStaffSide;

  SettingScreen({super.key, this.forStaffSide = false});

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  int selectedValue = 0;
  List<String> settingListTitle = [
    'View Profile',
    'Daily Help',
    'Change Society',
    'Notifications Settings',
    'Privacy Policy',
    'Terms Of Use',
    'Emergency Contacts',
    'Check-out History',
    'Log Out'
  ];

  List<String> settingListTitle2 = [
    'View Profile',
    'Daily Help',
    'Change Society',
    'Notifications Settings',
    'Emergency Contacts',
    'Log Out'
  ];

  late BuildContext dialogueContext;

  @override
  void initState() {
    context.read<UserProfileCubit>().fetchUserProfile();
    super.initState();
  }

  void handleTap(BuildContext context, int index) {
    List<Widget> staffScreens = [
      ResidentProfileDetails(),
      const DailyHelpListingHistory(),
      const SizedBox(),
      NotificationScreen(),
      const EmergencyContactScreen(),
      const SizedBox() // Logout handled separately
    ];

    List<Widget> residentScreens = [
      ResidentProfileDetails(),
      const DailyHelpListingHistoryResidentSide(),
      const SizedBox(), // Logout handled separately
      NotificationScreen(),
      const PrivacyPolicyScreen(),
      const TermOfUseScreen(),
      const EmergencyContactScreen(),
      ResidentCheckoutsHistoryDetails(forResident: true, userId: ''),
      const SizedBox() // Logout handled separately
    ];

    if (widget.forStaffSide) {
      if (index == 2) {
        logOutPermissionDialog(context, isLogout: false);
      } else if (index == 5) {
        logOutPermissionDialog(context);
      } else {
        Navigator.of(context)
            .push(MaterialPageRoute(builder: (builder) => staffScreens[index]));
      }
    } else {
      if (index == 2 || index == 8) {
        logOutPermissionDialog(context, isLogout: index == 8);
      } else {
        Navigator.of(context).push(
            MaterialPageRoute(builder: (builder) => residentScreens[index]));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<LogoutCubit, LogoutState>(
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
          snackBar(
              context, 'User logout failed', Icons.warning, AppTheme.redColor);

          Navigator.of(dialogueContext).pop();
        } else if (state is LogoutInternetError) {
          snackBar(context, 'Internet connection failed', Icons.wifi_off,
              AppTheme.redColor);

          Navigator.of(dialogueContext).pop();
        } else if (state is LogoutSessionError) {
          sessionExpiredDialog(context);
        }
      },
      child: Scaffold(
        backgroundColor: AppTheme.backgroundColor,
        body: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                  padding: EdgeInsets.only(top: 15.h, left: 12.h, bottom: 20.h),
                  child: Text('Settings',
                      style: GoogleFonts.nunitoSans(
                          textStyle: TextStyle(
                              color: Colors.white,
                              fontSize: 18.sp,
                              fontWeight: FontWeight.w600)))),
              Expanded(
                child: Container(
                  width: double.infinity,
                  decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(20),
                          topRight: Radius.circular(20))),
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        BlocBuilder<UserProfileCubit, UserProfileState>(
                          builder: (context, state) {
                            if (state is UserProfileLoaded) {
                              return Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 12),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: Row(
                                        children: [
                                          state.userProfile.first.data!.user!
                                                      .image !=
                                                  null
                                              ? CircleAvatar(
                                                  radius: 32.h,
                                                  backgroundImage: NetworkImage(
                                                      state.userProfile.first
                                                          .data!.user!.image
                                                          .toString()))
                                              : const CircleAvatar(
                                                  radius: 32,
                                                  backgroundImage: AssetImage(
                                                      'assets/images/default.jpg')),
                                          const SizedBox(width: 10),
                                          Expanded(
                                            child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                      state.userProfile.first
                                                          .data!.user!.name
                                                          .toString(),
                                                      style: GoogleFonts
                                                          .nunitoSans(
                                                        textStyle: TextStyle(
                                                          color: Colors.black,
                                                          fontSize: 16.sp,
                                                          fontWeight:
                                                              FontWeight.w600,
                                                        ),
                                                      )),
                                                  Text(
                                                      "+91 ${state.userProfile.first.data!.user!.phone.toString()}",
                                                      style: GoogleFonts.nunitoSans(
                                                          textStyle: TextStyle(
                                                              color: Colors
                                                                  .black87,
                                                              fontSize: 13.sp,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500))),
                                                  Text(
                                                      widget.forStaffSide
                                                          ? capitalizeWords(state
                                                                  .userProfile
                                                                  .first
                                                                  .data!
                                                                  .user!
                                                                  .role
                                                                  .toString())
                                                              .toString()
                                                              .replaceAll(
                                                                  '_', ' ')
                                                          : "${state.userProfile.first.data!.user!.blockName.toString()} - ${state.userProfile.first.data!.user!.aprtNo.toString()}",
                                                      style: GoogleFonts.nunitoSans(
                                                          textStyle: TextStyle(
                                                              color: Colors
                                                                  .black87,
                                                              fontSize: 13.sp,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500)))
                                                ]),
                                          ),
                                        ],
                                      ),
                                    ),
                                    widget.forStaffSide
                                        ? const SizedBox(height: 100)
                                        : GestureDetector(
                                            onTap: () => Navigator.of(context)
                                                .push(MaterialPageRoute(
                                                    builder: (builder) =>
                                                        ResidentGatePass(
                                                            residentModel: state
                                                                .userProfile
                                                                .first
                                                                .data!
                                                                .user!))),
                                            child: SizedBox(
                                                height: 100,
                                                width: 80,
                                                child: Image.asset(
                                                    'assets/images/qr-image.png')),
                                          )
                                  ],
                                ),
                              );
                            } else if (state is UserProfileLoading) {
                              return const CircularProgressIndicator();
                            } else {
                              return Text('Hello User',
                                  style: GoogleFonts.nunitoSans(
                                      textStyle: TextStyle(
                                          color: Colors.black,
                                          fontSize: 16.sp,
                                          fontWeight: FontWeight.w600)));
                            }
                          },
                        ),
                        ListView.builder(
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: widget.forStaffSide
                                ? settingListTitle2.length
                                : settingListTitle.length,
                            shrinkWrap: true,
                            itemBuilder: ((context, index) {
                              return Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 5),
                                child: GestureDetector(
                                  onTap: () => handleTap(context, index),
                                  child: Container(
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(8),
                                        border: Border.all(
                                            color: Colors.grey[100]!)),
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Column(
                                        children: [
                                          Row(
                                            children: [
                                              Image.asset(
                                                  ImageAssets.settingLogo,
                                                  height: 40.h),
                                              SizedBox(width: 10.w),
                                              Expanded(
                                                  child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                    Text(
                                                        widget.forStaffSide
                                                            ? settingListTitle2[
                                                                index]
                                                            : settingListTitle[
                                                                index],
                                                        style: GoogleFonts.nunitoSans(
                                                            textStyle: TextStyle(
                                                                color: Colors
                                                                    .black,
                                                                fontSize: 14.sp,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600)))
                                                  ])),
                                              SizedBox(width: 10.w),
                                              index == 0
                                                  ? MaterialButton(
                                                      onPressed: () => Navigator
                                                              .of(context)
                                                          .push(MaterialPageRoute(
                                                              builder: (builder) =>
                                                                  const EditProfileScreen())),
                                                      shape: RoundedRectangleBorder(
                                                          borderRadius:
                                                              BorderRadius.circular(
                                                                  30)),
                                                      color:
                                                          AppTheme.primaryColor,
                                                      child: const Text(
                                                          "Edit Profile",
                                                          style: TextStyle(
                                                              color: Colors
                                                                  .white)))
                                                  : Container(
                                                      decoration: BoxDecoration(
                                                          color: AppTheme
                                                              .greyColor,
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      1000.r)),
                                                      child: const Padding(
                                                        padding:
                                                            EdgeInsets.all(8.0),
                                                        child: Icon(
                                                          Icons.navigate_next,
                                                          color: Colors.black54,
                                                        ),
                                                      ),
                                                    ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            }))
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
