import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:ghp_society_management/constants/dialog.dart';
import 'package:ghp_society_management/constants/export.dart';
import 'package:ghp_society_management/main.dart';
import 'package:ghp_society_management/model/user_profile_model.dart';
import 'package:ghp_society_management/view/dashboard/view_all_features.dart';
import 'package:ghp_society_management/view/manage_property/resident_property.dart';
import 'package:ghp_society_management/view/resident/bills/bill_screen.dart';
import 'package:ghp_society_management/view/resident/bills/my_bills.dart';
import 'package:ghp_society_management/view/resident/complaint/comlaint_page.dart';
import 'package:ghp_society_management/view/resident/member/members_screen.dart';
import 'package:ghp_society_management/view/resident/notice_board/notice_board_screen.dart';
import 'package:ghp_society_management/view/resident/setting/log_out_dialog.dart';
import 'package:ghp_society_management/view/resident/visitors/visitor_screen.dart';
import 'package:ghp_society_management/view/select_society/select_society_screen.dart';
import 'package:searchbar_animation/const/colours.dart';
import '../resident/parcel_flow/parcel_listing.dart';

class HomeScreen extends StatefulWidget {
  final Function(int index) onChanged;
  const HomeScreen({super.key, required this.onChanged});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool showLess = true;
  late BuildContext dialogueContext;
  @override
  void initState() {
    super.initState();
    // context.read<UserProfileCubit>().fetchUserProfile();
  }

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

  late MyBillsCubit _myBillsCubit;
  fetchBill() {
    context.read<UserProfileCubit>().fetchUserProfile();
    _myBillsCubit = MyBillsCubit()
      ..fetchMyBills(context: context, billTypes: "all");

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        // BlocListener<UserProfileCubit, UserProfileState>(
        //     listener: (context, state) {
        //   if (state is UserProfileLoaded) {
        //     String status = checkBillStatus(
        //         context, state.userProfile.first.data!.unpaidBills!.first);
        //   }

        // }),
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
        floatingActionButton: FloatingActionButton(
            backgroundColor: Colors.green,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
            onPressed: () => Navigator.push(
                context, MaterialPageRoute(builder: (_) => BillScreen())),
            child: Image.asset('assets/images/pay_img.png')),
        appBar: AppBar(
            leadingWidth: double.infinity,
            // bottom: PreferredSize(
            //     preferredSize: Size.fromHeight(35),
            //     child: BlocBuilder<UserProfileCubit, UserProfileState>(
            //         builder: (context, state) {
            //       if (state is UserProfileLoaded) {
            //         Future.delayed(const Duration(milliseconds: 5), () {
            //           List<UnpaidBill> billData =
            //               state.userProfile.first.data!.unpaidBills!;
            //           if (billData.isNotEmpty) {
            //             checkPaymentReminder(
            //                 context: context,
            //                 myUnpaidBill: state
            //                     .userProfile.first.data!.unpaidBills!.first);
            //           }
            //         });
            //         return Padding(
            //           padding:
            //               const EdgeInsets.only(right: 10, bottom: 5, top: 5),
            //           child: Row(
            //             mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //             children: [
            //               ManageProperty(),
            //               Text(
            //                   state.userProfile.first.data!.user!.societyName!
            //                       .toUpperCase(),
            //                   style: GoogleFonts.nunitoSans(
            //                       textStyle: TextStyle(
            //                           color: Colors.black87,
            //                           fontSize: 16,
            //                           fontWeight: FontWeight.w600))),
            //             ],
            //           ),
            //         );
            //       } else {
            //         return Row(
            //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //           children: [
            //             ManageProperty(),
            //             Text("Loading....",
            //                 style: GoogleFonts.nunitoSans(
            //                     textStyle: TextStyle(
            //                         color: Colors.black87,
            //                         fontSize: 16,
            //                         fontWeight: FontWeight.w600))),
            //           ],
            //         );
            //       }
            //     })),
            leading: BlocBuilder<UserProfileCubit, UserProfileState>(
              builder: (context, state) {
                if (state is UserProfileLoaded) {
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
                                  onTap: () => profileViewAlertDialog(
                                      context, state.userProfile.first),
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
                                                color: Colors.black87,
                                                fontSize: 14,
                                                fontWeight: FontWeight.w600,
                                                overflow:
                                                    TextOverflow.ellipsis))),
                                    const SizedBox(height: 3),
                                    Text(
                                        '${state.userProfile.first.data!.user!.blockName} - FLOOR ${state.userProfile.first.data!.user!.floorNumber ?? ''}'
                                            .toUpperCase(),
                                        style: GoogleFonts.nunitoSans(
                                            textStyle: TextStyle(
                                                color: Colors.black87,
                                                fontSize: 10,
                                                fontWeight: FontWeight.w500)))
                                  ],
                                ),
                              ),
                              const SizedBox(width: 10),
                            ],
                          ),
                        ),
                        headerWidget(
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
                                                color: Colors.black87,
                                                fontSize: 14,
                                                fontWeight: FontWeight.w600,
                                                overflow:
                                                    TextOverflow.ellipsis))),
                                    const SizedBox(height: 3),
                                    Text('TOWER LOADING...',
                                        style: GoogleFonts.nunitoSans(
                                            textStyle: TextStyle(
                                                color: Colors.black87,
                                                fontSize: 10,
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
        body: RefreshIndicator(
          onRefresh: () async {
            fetchBill();
          },
          child: SingleChildScrollView(
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
                          style: GoogleFonts.cormorant(
                            textStyle: TextStyle(
                              color: Colors.black,
                              fontSize: 18.sp,
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
                              border: Border.all(color: AppTheme.blueColor)),
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
                      onTap: () => Navigator.push(context,
                          MaterialPageRoute(builder: (_) => pagesList[index])),
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
                SizedBox(height: 10.h),
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
          ),
        ),
      ),
    );
  }
}
