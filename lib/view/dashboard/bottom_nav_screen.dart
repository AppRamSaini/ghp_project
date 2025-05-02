import 'package:ghp_society_management/constants/export.dart';
import 'package:ghp_society_management/controller/notification/notification_listing/notification_list_cubit.dart';
import 'package:ghp_society_management/controller/refer_property/refer_property_element/refer_property_element_cubit.dart';
import 'package:ghp_society_management/controller/sos_management/sos_element/sos_element_cubit.dart';
import 'package:ghp_society_management/controller/visitors/incoming_request/incoming_request_cubit.dart';
import 'package:ghp_society_management/model/incoming_visitors_request_model.dart';
import 'package:ghp_society_management/view/resident/bills/bill_screen.dart';
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
    context.read<IncomingRequestCubit>().fetchIncomingRequest();
    context.read<VisitorsElementCubit>().fetchVisitorsElement();
    context.read<DocumentElementsCubit>().fetchDocumentElement();
    context.read<ReferPropertyElementCubit>().fetchReferPropetyElement();
    context.read<SosElementCubit>().fetchSosElement();
    context.read<MembersElementCubit>().fetchMembersElement();
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
    context.read<NotificationListingCubit>().fetchNotifications();

    return WillPopScope(
      onWillPop: () async {
        exitPageConfirmationDialog(context);
        return true;
      },
      child: MultiBlocListener(
        listeners: [
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
          body: SizedBox.expand(
            child: PageView(
              controller: _pageController,
              onPageChanged: (index) {
                setState(() => currentIndex = index);
              },
              children: <Widget>[
                HomeScreen(onChanged: onChanged),
                const BillScreen(),
                const DocumentsScreen(),
                SettingScreen()
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
                  activeColor: AppTheme.blueColor),
              BottomNavyBarItem(
                  title: Text(
                    'Bills',
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
                      ImageAssets.billImage,
                      height: 18.h,
                      color: Colors.black,
                    ),
                  ),
                  activeColor: AppTheme.blueColor),
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
                      height: 18.h,
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
                          height: 18.h, color: Colors.black)),
                  activeColor: AppTheme.blueColor),
            ],
          ),
        ),
      ),
    );
  }
}
