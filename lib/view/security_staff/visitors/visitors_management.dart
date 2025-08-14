import 'package:ghp_society_management/constants/export.dart';
import 'package:ghp_society_management/model/visitors_listing_model.dart';
import 'package:ghp_society_management/view/security_staff/visitors/visitors_details_page.dart';
import 'package:ghp_society_management/view/security_staff/visitors/visitors_tab.dart';

List<Map<String, dynamic>> optionList1 = [
  {"icon": Icons.visibility, "menu": "View Profile", "menu_id": 1},
  {"icon": Icons.check_circle_outlined, "menu": "Check IN", "menu_id": 2},
  {"icon": Icons.call, "menu": "Call to Resident", "menu_id": 3},
];
List<Map<String, dynamic>> optionList2 = [
  {"icon": Icons.visibility, "menu": "View Profile", "menu_id": 1},
  {"icon": Icons.call, "menu": "Call to Resident", "menu_id": 3},
];

Widget popMenusForStaffVisitors(
    {required List<Map<String, dynamic>> options,
    required BuildContext context,
    required VisitorsListing visitorsData}) {
  return CircleAvatar(
    backgroundColor: AppTheme.primaryColor.withOpacity(0.2),
    child: PopupMenuButton(
      elevation: 10,
      padding: EdgeInsets.zero,
      color: Colors.white,
      surfaceTintColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
      icon: const Icon(Icons.more_horiz_rounded,
          color: Colors.deepPurpleAccent, size: 18.0),
      offset: const Offset(0, 50),
      itemBuilder: (BuildContext bc) {
        return options
            .map(
              (selectedOption) => PopupMenuItem(
                padding: EdgeInsets.zero,
                value: selectedOption,
                child: Padding(
                  padding: EdgeInsets.only(left: 10.w, right: 30),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        children: [
                          Icon(selectedOption['icon']),
                          const SizedBox(width: 10),
                          Text(selectedOption['menu'] ?? "",
                              style: GoogleFonts.poppins(
                                  color: Colors.black,
                                  fontSize: 12.sp,
                                  fontWeight: FontWeight.w400))
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            )
            .toList();
      },
      onSelected: (value) async {
        if (value['menu_id'] == 1) {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (_) => VisitorsDetailsPage2(
                      visitorsId: {"visitor_id": visitorsData.id.toString()})));
        } else if (value['menu_id'] == 2) {
          VisitorActionsHandler actionsHandler = VisitorActionsHandler();
          String dateTime = getDateTime();
          actionsHandler.handleTap(
              context: context,
              status: "Check IN",
              visitorsData: visitorsData,
              dateTime: dateTime);
        } else if (value['menu_id'] == 3) {
          phoneCallLauncher(visitorsData.member == null
              ? visitorsData.phone.toString()
              : visitorsData.member!.phone.toString());
        }
      },
    ),
  );
}
