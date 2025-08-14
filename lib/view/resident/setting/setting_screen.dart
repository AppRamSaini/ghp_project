import 'package:ghp_society_management/constants/export.dart';
import 'package:ghp_society_management/constants/simmer_loading.dart';
import 'package:ghp_society_management/view/resident/resident_profile/edit_profile_screen.dart';
import 'package:ghp_society_management/view/resident/resident_profile/resident_gatepass.dart';
import 'package:ghp_society_management/view/resident/resident_profile/resident_profile.dart';
import 'package:ghp_society_management/view/resident/residents_checkouts/resident_checkouts_history_details.dart';
import 'package:ghp_society_management/view/resident/setting/delete_account.dart';
import 'package:ghp_society_management/view/resident/setting/emergency_contact.dart';
import 'package:ghp_society_management/view/resident/setting/log_out_dialog.dart';
import 'package:ghp_society_management/view/resident/setting/notification_screen.dart';
import 'package:ghp_society_management/view/resident/setting/privacy_policy.dart';
import 'package:ghp_society_management/view/resident/setting/term_of_use.dart';
import 'package:ghp_society_management/view/security_staff/daliy_help/daily_helps_members.dart';

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
    'Edit Profile',
    // 'Daily Help',
    // 'Change Society',
    'Notifications Settings',
    'Emergency Contacts',
    'Check-out History',
    'Terms Of Use',
    'Privacy Policy',
    'Delete Account',
    'Log Out'
  ];

  List<String> settingListTitle2 = [
    'View Profile',
    'Edit Profile',
    'Daily Help History',
    'Notifications Settings',
    'Emergency Contacts',
    'Delete Account',
    'Log Out'
  ];

  List<IconData?> iconsList = [
    Icons.person,
    Icons.edit,
    // Icons.history,
    Icons.notification_add,
    Icons.emergency_share,
    Icons.check_circle_outline,
    Icons.private_connectivity,
    Icons.privacy_tip,
    Icons.delete_forever,
    Icons.logout,
  ];
  List<IconData?> iconsListForStaff = [
    Icons.person,
    Icons.edit,
    Icons.history,
    Icons.notification_add,
    Icons.emergency_share,
    Icons.delete_forever,
    Icons.logout,
  ];

  late BuildContext dialogueContext;

  @override
  void initState() {
    context.read<UserProfileCubit>().fetchUserProfile();
    super.initState();
  }

  void handleTap(BuildContext context, int index) {
    List<Widget> staffScreens = [
      ResidentProfileDetails(forDetails: true, forResident: false),
      EditProfileScreen(),
      DailyHelpListingHistory(),
      NotificationScreen(),
      const EmergencyContactScreen(),
      DeleteUserAccount(),
      const SizedBox() // Logout handled separately
    ];

    List<Widget> residentScreens = [
      ResidentProfileDetails(forDetails: true),
      EditProfileScreen(),
      // const DailyHelpListingHistoryResidentSide(),
      NotificationScreen(),
      const EmergencyContactScreen(),
      ResidentCheckoutsHistoryDetails(forResident: true, userId: ''),
      const TermOfUseScreen(),
      const PrivacyPolicyScreen(),
      DeleteUserAccount(),
      const SizedBox() // Logout handled separately
    ];

    if (widget.forStaffSide) {
      if (index == 6) {
        logOutPermissionDialog(context);
      } else {
        Navigator.of(context)
            .push(MaterialPageRoute(builder: (builder) => staffScreens[index]));
      }
    } else {
      if (index == 8) {
        logOutPermissionDialog(context, isLogout: index == 8);
      } else {
        Navigator.of(context).push(
            MaterialPageRoute(builder: (builder) => residentScreens[index]));
      }
    }
  }

  Future onRefresh() async {
    context.read<UserProfileCubit>().fetchUserProfile();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<UserProfileCubit, UserProfileState>(
      listener: (context, state) {
        if (state is UserProfileLogout) {
          sessionExpiredDialog(context);
        }
      },
      child: Scaffold(
        appBar: appbarWidget(title: 'Settings'),
        body: RefreshIndicator(
          onRefresh: onRefresh,
          child: BlocBuilder<UserProfileCubit, UserProfileState>(
            builder: (context, state) {
              if (state is UserProfileLoaded) {
                return SingleChildScrollView(
                  physics: AlwaysScrollableScrollPhysics(),
                  child: Column(
                    children: [
                      Container(
                          margin: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(7),
                              border: Border.all(
                                  color: Colors.grey.withOpacity(0.15))),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 5, vertical: 0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Row(
                                    children: [
                                      state.userProfile.first.data!.user!
                                                  .image !=
                                              null
                                          ? ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              child: FadeInImage(
                                                height: 70,
                                                width: 70,
                                                fit: BoxFit.fill,
                                                placeholder: AssetImage(
                                                    'assets/images/default.jpg'),
                                                image: NetworkImage(state
                                                    .userProfile
                                                    .first
                                                    .data!
                                                    .user!
                                                    .image
                                                    .toString()),
                                                imageErrorBuilder: (_, child,
                                                        st) =>
                                                    Image.asset(
                                                        'assets/images/default.jpg',
                                                        height: 70,
                                                        width: 70,
                                                        fit: BoxFit.fill),
                                              ),
                                            )
                                          : ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              child: FadeInImage(
                                                height: 70,
                                                width: 70,
                                                fit: BoxFit.fill,
                                                placeholder: AssetImage(
                                                    'assets/images/default.jpg'),
                                                image: AssetImage(''),
                                                imageErrorBuilder: (_, child,
                                                        st) =>
                                                    Image.asset(
                                                        'assets/images/default.jpg',
                                                        height: 70,
                                                        width: 70,
                                                        fit: BoxFit.fill),
                                              ),
                                            ),
                                      const SizedBox(width: 10),
                                      Expanded(
                                        child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                  capitalizeWords(state
                                                      .userProfile
                                                      .first
                                                      .data!
                                                      .user!
                                                      .name
                                                      .toString()),
                                                  style: GoogleFonts.nunitoSans(
                                                    textStyle: TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 18,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                    ),
                                                  )),
                                              Text(
                                                  "+91 ${state.userProfile.first.data!.user!.phone.toString()}",
                                                  style: GoogleFonts.nunitoSans(
                                                      textStyle: TextStyle(
                                                          color: Colors.black87,
                                                          fontSize: 12,
                                                          fontWeight: FontWeight
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
                                                          .replaceAll('_', ' ')
                                                      : "Tower/Block: ${state.userProfile.first.data!.user!.property!.blockName.toString()}, Property No : ${state.userProfile.first.data!.user!.aprtNo.toString()}",
                                                  style: GoogleFonts.nunitoSans(
                                                      textStyle: TextStyle(
                                                          color: Colors.black87,
                                                          fontSize: 12,
                                                          fontWeight:
                                                              FontWeight.w500)))
                                            ]),
                                      ),
                                    ],
                                  ),
                                ),
                                widget.forStaffSide
                                    ? const SizedBox(height: 80)
                                    : GestureDetector(
                                        onTap: () => Navigator.of(context).push(
                                            MaterialPageRoute(
                                                builder: (builder) =>
                                                    ResidentGatePass(
                                                        residentModel: state
                                                            .userProfile
                                                            .first
                                                            .data!
                                                            .user!))),
                                        child: Image.asset(
                                          'assets/images/qr-image.png',
                                          height: 80,
                                          width: 80,
                                        ),
                                      )
                              ],
                            ),
                          )),
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
                                    border:
                                        Border.all(color: Colors.grey[100]!)),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    children: [
                                      Row(
                                        children: [
                                          Icon(
                                              widget.forStaffSide
                                                  ? iconsListForStaff[index]
                                                  : iconsList[index],
                                              color: widget.forStaffSide &&
                                                      index == 5
                                                  ? Colors.red
                                                  : !widget.forStaffSide &&
                                                          index == 7
                                                      ? Colors.red
                                                      : AppTheme.primaryColor
                                                          .withOpacity(0.8)),
                                          // Image.asset(ImageAssets.settingLogo,
                                          //     color: widget.forStaffSide &&
                                          //             index == 5
                                          //         ? Colors.red
                                          //         : !widget.forStaffSide &&
                                          //                 index == 8
                                          //             ? Colors.red
                                          //             : null,
                                          //     height: 35.h),

                                          SizedBox(width: 10.w),
                                          Expanded(
                                              child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                Text(
                                                    widget.forStaffSide
                                                        ? settingListTitle2[
                                                            index]
                                                        : settingListTitle[
                                                            index],
                                                    style: GoogleFonts.nunitoSans(
                                                        textStyle: TextStyle(
                                                            color: widget.forStaffSide && index == 5
                                                                ? Colors.red
                                                                : !widget.forStaffSide && index == 7
                                                                    ? Colors.red
                                                                    : Colors.black,
                                                            fontSize: 14.sp,
                                                            fontWeight: FontWeight.w600)))
                                              ])),
                                          SizedBox(width: 10.w),
                                          Container(
                                            decoration: BoxDecoration(
                                                color: AppTheme.greyColor,
                                                borderRadius:
                                                    BorderRadius.circular(
                                                        1000.r)),
                                            child: const Padding(
                                              padding: EdgeInsets.all(8.0),
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
                        }),
                      ),
                      SizedBox(height: 30),
                    ],
                  ),
                );
              } else if (state is UserProfileLoading) {
                return notificationShimmerLoading();
              } else if (state is UserProfileInternetError) {
                return Center(
                    child: const Text("Internet connection error!",
                        style: TextStyle(fontSize: 16, color: Colors.red)));
              } else if (state is UserProfileFailed) {
                return notificationShimmerLoading();
              } else {
                return notificationShimmerLoading();
              }
            },
          ),
        ),
      ),
    );
  }
}
