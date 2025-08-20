import 'package:ghp_society_management/constants/dialog.dart';
import 'package:ghp_society_management/constants/export.dart';
import 'package:ghp_society_management/constants/simmer_loading.dart';
import 'package:ghp_society_management/view/resident/resident_profile/edit_profile_screen.dart';
import 'package:ghp_society_management/view/resident/resident_profile/resident_profile.dart';
import 'package:ghp_society_management/view/resident/setting/delete_account.dart';
import 'package:ghp_society_management/view/resident/setting/emergency_contact.dart';
import 'package:ghp_society_management/view/resident/setting/log_out_dialog.dart';
import 'package:ghp_society_management/view/resident/setting/notification_screen.dart';
import 'package:ghp_society_management/view/resident/setting/privacy_policy.dart';
import 'package:ghp_society_management/view/resident/setting/term_of_use.dart';
import 'package:ghp_society_management/view/select_society/select_society_screen.dart';

class SettingScreenMaintenanceStaff extends StatefulWidget {
  const SettingScreenMaintenanceStaff({super.key});

  @override
  State<SettingScreenMaintenanceStaff> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreenMaintenanceStaff> {
  int selectedValue = 0;

  List<String> settingListTitle2 = [
    'View Profile',
    'Notifications Settings',
    'Emergency Contacts',
    'Terms & Conditions',
    'Privacy policy',
    'Delete Account',
    'Log Out'
  ];

  List<IconData?> iconsListForStaff = [
    Icons.person,
    Icons.notification_add,
    Icons.emergency_share,
    Icons.privacy_tip_outlined,
    Icons.privacy_tip_rounded,
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
      NotificationScreen(),
      const EmergencyContactScreen(),
      const TermOfUseScreen(),
      const PrivacyPolicyScreen(),
      DeleteUserAccount(),
      const SizedBox() // Logout handled separately
    ];

    if (index == 6) {
      logOutPermissionDialog(context, isLogout: index == 6);
    } else {
      Navigator.of(context)
          .push(MaterialPageRoute(builder: (builder) => staffScreens[index]));
    }
  }

  Future onRefresh() async {
    context.read<UserProfileCubit>().fetchUserProfile();
    setState(() {});
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
                                                    'assets/images/profile_icon.png'),
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
                                                        'assets/images/profile_icon.png',
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
                                                    'assets/images/profile_icon.png'),
                                                image: AssetImage(''),
                                                imageErrorBuilder: (_, child,
                                                        st) =>
                                                    Image.asset(
                                                        'assets/images/profile_icon.png',
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
                                                  capitalizeWords(state
                                                          .userProfile
                                                          .first
                                                          .data!
                                                          .user!
                                                          .role
                                                          .toString())
                                                      .toString()
                                                      .replaceAll('_', ' '),
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
                                GestureDetector(
                                  onTap: () {
                                    Navigator.of(context).push(
                                        MaterialPageRoute(
                                            builder: (builder) =>
                                                EditProfileScreen()));
                                  },
                                  child: Container(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 10, vertical: 8),
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(30),
                                        color: AppTheme.primaryColor),
                                    child: Text(
                                      "Edit Profile",
                                      style: TextStyle(
                                          fontSize: 12, color: Colors.white),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          )),
                      ListView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: settingListTitle2.length,
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
                                          Icon(iconsListForStaff[index],
                                              color: index == 5
                                                  ? Colors.red
                                                  : index == 7
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
                                                Text(settingListTitle2[index],
                                                    style: GoogleFonts.nunitoSans(
                                                        textStyle: TextStyle(
                                                            color: index == 5
                                                                ? Colors.red
                                                                : index == 7
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
