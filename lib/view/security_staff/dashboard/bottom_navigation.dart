import 'package:ghp_society_management/constants/export.dart';
import 'package:ghp_society_management/controller/notification/notification_listing/notification_list_cubit.dart';
import 'package:ghp_society_management/controller/parcel/parcel_element/parcel_element_cubit.dart';
import 'package:ghp_society_management/controller/parcel/parcel_pending_counts/parcel_counts_cubit.dart';
import 'package:ghp_society_management/controller/parcel/receive_parcel/receive_parcel_cubit.dart';
import 'package:ghp_society_management/controller/sos_management/sos_element/sos_element_cubit.dart';
import 'package:ghp_society_management/view/resident/setting/log_out_dialog.dart';
import 'package:ghp_society_management/view/resident/setting/setting_screen.dart';
import 'package:ghp_society_management/view/security_staff/dashboard/home.dart';
import 'package:ghp_society_management/view/security_staff/parcel_flow_security_staff/parcel_listing.dart';
import 'package:ghp_society_management/view/security_staff/resident_checkouts/resident_checkouts.dart';
import 'package:ghp_society_management/view/security_staff/scan_qr.dart';

class SecurityGuardDashboard extends StatefulWidget {
  int? index = 0;

  SecurityGuardDashboard({super.key, this.index});

  @override
  State<SecurityGuardDashboard> createState() => SecurityGuardDashboardState();
}

class SecurityGuardDashboardState extends State<SecurityGuardDashboard> {
  int currentIndex = 0;
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    context.read<VisitorsElementCubit>().fetchVisitorsElement();
    context.read<NotificationListingCubit>().fetchNotifications();
    context.read<ParcelElementsCubit>().fetchParcelElement();
    _pageController = PageController();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (widget.index != null && widget.index! > 0) {
        _pageController.jumpToPage(widget.index!);
        setState(() {
          currentIndex = widget.index!;
        });
      }
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  final List<Widget> lst = [
    const SecurityGuardHome(),
    const ResidentsCheckoutsHistory(),
    QrCodeScanner(),
    const ParcelListingSecurityStaffSide(),
    SettingScreen(forStaffSide: true),
  ];

  @override
  Widget build(BuildContext context) {
    context.read<ParcelCountsCubit>().fetchParcelCounts();
    return WillPopScope(
      onWillPop: () async {
        exitPageConfirmationDialog(context);
        return true;
      },
      child: MultiBlocListener(
        listeners: [
          BlocListener<SosElementCubit, SosElementState>(
            listener: (context, state) {
              if (state is SosElementLogout) {
                sessionExpiredDialog(context);
              }
            },
          ),
          BlocListener<ReceiveParcelCubit, ReceiveParcelState>(
            listener: (context, state) {
              if (state is ReceiveParcelSuccess) {
                context.read<ParcelCountsCubit>().fetchParcelCounts();
                setState(() {});
              }
            },
          ),
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
            children: lst,
          ),
          bottomNavigationBar: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                decoration: const BoxDecoration(
                    color: Colors.white,
                    boxShadow: [BoxShadow(color: Colors.grey, blurRadius: 10)]),
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                        onTap: () {
                          currentIndex = 0;
                          _pageController.jumpToPage(0);

                          context
                              .read<ParcelCountsCubit>()
                              .fetchParcelCounts(); // Fetch latest count
                          setState(() {});
                        },
                        child: bottomBarWidget(
                            ImageAssets.homeImage, "Home", currentIndex, 0)),
                    GestureDetector(
                        onTap: () {
                          currentIndex = 1;
                          _pageController.jumpToPage(1);
                          context
                              .read<ParcelCountsCubit>()
                              .fetchParcelCounts(); // Fetch latest count
                          setState(() {});
                        },
                        child: bottomBarWidget(ImageAssets.documentImage,
                            "CheckOut", currentIndex, 1)),
                    FloatingActionButton(
                        backgroundColor: AppTheme.primaryColor,
                        heroTag: "hero1",
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(100)),
                        onPressed: () {
                          currentIndex = 2;
                          _pageController.jumpToPage(2);
                          context
                              .read<ParcelCountsCubit>()
                              .fetchParcelCounts(); // Fetch latest count

                          setState(() {});
                          // Navigator.push(context,
                          //     MaterialPageRoute(builder: (_) => QrCodeScanner()));
                        },
                        child: Image.asset('assets/images/qr.png',
                            color: Colors.white, height: 32)),
                    GestureDetector(
                      onTap: () {
                        currentIndex = 3;
                        _pageController.jumpToPage(3);
                        context
                            .read<ParcelCountsCubit>()
                            .fetchParcelCounts(); // Fetch latest count

                        setState(() {});
                      },
                      child: BlocBuilder<ParcelCountsCubit, ParcelCountsState>(
                        builder: (context, state) {
                          int parcelCount =
                              LocalStorage.localStorage.getInt('counts') ?? 0;
                          if (state is ParcelCountsLoaded) {
                            parcelCount =
                                state.count; // Use data from the cubit
                            LocalStorage.localStorage
                                .setInt('counts', parcelCount); // Save it
                          }
                          return Stack(
                            alignment: Alignment.topRight,
                            children: [
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 10),
                                child: bottomBarWidget(ImageAssets.parcelIcon,
                                    "Parcel", currentIndex, 3),
                              ),
                              parcelCount == 0
                                  ? const SizedBox()
                                  : Positioned(
                                      right: 0,
                                      top: 0,
                                      child: Container(
                                        padding: const EdgeInsets.all(5),
                                        decoration: const BoxDecoration(
                                            color: Colors.redAccent,
                                            shape: BoxShape.circle),
                                        constraints: const BoxConstraints(
                                            minWidth: 18, minHeight: 18),
                                        child: Text(
                                          parcelCount.toString(),
                                          style: const TextStyle(
                                              fontSize: 10,
                                              color: Colors.white),
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                    ),
                            ],
                          );
                        },
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        currentIndex = 4;
                        _pageController.jumpToPage(4);
                        setState(() {});
                      },
                      child: bottomBarWidget(
                          ImageAssets.settingImage, "Setting", currentIndex, 4),
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
