import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:ghp_society_management/constants/export.dart';
import 'package:ghp_society_management/main.dart';
import 'package:ghp_society_management/model/my_bill_model.dart';
import 'package:ghp_society_management/model/sos_history_model.dart';
import 'package:ghp_society_management/view/resident/complaint/comlaint_page.dart';
import 'package:ghp_society_management/view/resident/event/event_screen.dart';
import 'package:ghp_society_management/view/resident/member/members_screen.dart';
import 'package:ghp_society_management/view/resident/notice_board/notice_board_screen.dart';
import 'package:ghp_society_management/view/resident/parcel_flow/parcel_listing.dart';
import 'package:ghp_society_management/view/resident/polls/poll_screen.dart';
import 'package:ghp_society_management/view/resident/refer_property/refer_property_screen.dart';
import 'package:ghp_society_management/view/resident/rent/property_screens.dart';
import 'package:ghp_society_management/view/resident/service_provider/service_provider_screen.dart';
import 'package:ghp_society_management/view/resident/sos/sos_screen.dart';
import 'package:ghp_society_management/view/resident/visitors/visitor_screen.dart';

class ViewAllFeatures extends StatefulWidget {
  const ViewAllFeatures({super.key});

  @override
  State<ViewAllFeatures> createState() => _ViewAllFeaturesState();
}

class _ViewAllFeaturesState extends State<ViewAllFeatures> {
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
    AppTheme.color11,
  ];

  List dataList = [
    {"icon": ImageAssets.member1, "title": "Members"},
    {"icon": ImageAssets.complaint1, "title": "Complaints"},
    {"icon": ImageAssets.visitors1, "title": "Visitors"},
    {"icon": ImageAssets.parcel1, "title": "Parcels"},
    {"icon": ImageAssets.events1, "title": "Events"},
    {"icon": ImageAssets.sos1, "title": "SOS"},
    {"icon": ImageAssets.rent1, "title": "Rent/Sell"},
    {"icon": ImageAssets.refer1, "title": "Refer"},
    {"icon": ImageAssets.notice1, "title": "Notice Board"},
    {"icon": ImageAssets.service1, "title": "Service Provider"},
    {"icon": ImageAssets.polls1, "title": "Polls"},
  ];
  List pagesList = [
    MemberScreen(),
    ComplaintScreen(),
    VisitorScreen(),
    ParcelListingPage(),
    EventScreen(),
    SosScreen(),
    RentScreen(),
    ReferPropertyScreen(),
    NoticeBoardScreen(),
    ServiceProviderScreen(),
    PollScreen()
  ];



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('All Features',
            style: GoogleFonts.nunitoSans(
              textStyle: TextStyle(
                color: AppTheme.backgroundColor,
                fontSize: 18.sp,
                fontWeight: FontWeight.w600,
              ),
            )),
      ),
      body: MasonryGridView.count(
        crossAxisCount: 3,
        mainAxisSpacing: 10,
        crossAxisSpacing: 10,
        shrinkWrap: true,
        physics: BouncingScrollPhysics(),
        padding: const EdgeInsets.all(10),
        itemCount: dataList.length,
        itemBuilder: (context, index) {
          double height;

          height = size.height * 0.14; // optional for others

          return Column(
            children: [
              GestureDetector(
                onTap: () => Navigator.push(context,
                    MaterialPageRoute(builder: (_) => pagesList[index])),
                child: Container(
                    margin: EdgeInsets.only(bottom: 5),
                    height: height,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: colors[index % colors.length],
                        border: Border.all(
                            color: colors[index % colors.length], width: 2)),
                    child: Image.asset(dataList[index]['icon'])),
              ),
              Padding(
                padding: EdgeInsets.only(bottom: 5),
                child: Text(
                  dataList[index]['title'].toString(),
                  textAlign: TextAlign.center,
                  style: GoogleFonts.nunitoSans(
                    textStyle: TextStyle(
                      color: AppTheme.backgroundColor,
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
