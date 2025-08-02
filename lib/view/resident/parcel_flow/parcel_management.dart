import 'package:ghp_society_management/constants/export.dart';
import 'package:ghp_society_management/controller/parcel/checkout_parcel/checkout_parcel_cubit.dart';
import 'package:ghp_society_management/controller/parcel/delete_parcel/delete_parcel_cubit.dart';
import 'package:ghp_society_management/controller/parcel/deliver_parcel/deliver_parcel_cubit.dart';
import 'package:ghp_society_management/model/parcel_listing_model.dart';
import 'package:ghp_society_management/view/resident/setting/log_out_dialog.dart';
import 'package:ghp_society_management/view/security_staff/parcel_flow_security_staff/parcel_details_page.dart';

List<Map<String, dynamic>> filterOptions = [
  {"menu": "All", "menu_id": 1},
  {"menu": "Pending", "menu_id": 2},
  {"menu": "Received", "menu_id": 3}
];
List<Map<String, dynamic>> filterOptions2 = [
  {"menu": "All", "menu_id": 1},
  {"menu": "Pending", "menu_id": 2},
  {"menu": "Delivered", "menu_id": 3}
];

List<Map<String, dynamic>> optionList = [
  {"icon": Icons.delete, "menu": "Delete", "menu_id": 1},
  {"icon": Icons.visibility, "menu": "View Details", "menu_id": 2},
  {"icon": Icons.description, "menu": "Receive Parcel", "menu_id": 3},
  {"icon": Icons.info_outline_rounded, "menu": "Create Complaint", "menu_id": 4}
];
List<Map<String, dynamic>> optionList0 = [
  {"icon": Icons.delete, "menu": "Delete", "menu_id": 1},
  {"icon": Icons.visibility, "menu": "View Details", "menu_id": 2},
  {"icon": Icons.info_outline_rounded, "menu": "Create Complaint", "menu_id": 4}
];
// for staff ide
List<Map<String, dynamic>> optionList2 = [
  {"icon": Icons.visibility, "menu": "View Details", "menu_id": 2},
  {"icon": Icons.delivery_dining, "menu": "Deliver to Resident", "menu_id": 3},
  {"icon": Icons.call, "menu": "Call to Resident", "menu_id": 0},
];
List<Map<String, dynamic>> optionList6 = [
  {"icon": Icons.visibility, "menu": "View Details", "menu_id": 2},
  {"icon": Icons.check_circle_outlined, "menu": "Check out", "menu_id": 5},
  {"icon": Icons.call, "menu": "Call to Resident", "menu_id": 0},
];
List<Map<String, dynamic>> optionList4 = [
  {"icon": Icons.visibility, "menu": "View Details", "menu_id": 1},
  {"icon": Icons.delivery_dining, "menu": "Receive Parcel", "menu_id": 2},
  {"icon": Icons.call, "menu": "Call to Resident", "menu_id": 0},
];
List<Map<String, dynamic>> optionList3 = [
  {"icon": Icons.visibility, "menu": "View Details", "menu_id": 2},
  {"icon": Icons.call, "menu": "Call to Resident", "menu_id": 0},
];

Widget popMenusForStaff(
    {bool isStaffSide = false,
    required List<Map<String, dynamic>> options,
    required BuildContext context,
    required ParcelListing requestData}) {
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
        if (value['menu_id'] == 0) {
          phoneCallLauncher(requestData.member!.phone.toString());
        } else if (value['menu_id'] == 1) {
          visitorsDeletePermissionDialog(context, () {
            Navigator.pop(context);
            context
                .read<ParcelDeletetCubit>()
                .deleteParcelApi(requestData.id.toString());
          });
        } else if (value['menu_id'] == 2) {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (_) => ParcelDetailsSecurityStaffSide(
                      isStaffSide: isStaffSide,
                      parcelId: requestData.id.toString())));
        } else if (value['menu_id'] == 3) {
          if (isStaffSide) {
            context
                .read<DeliverParcelCubit>()
                .deliverParcelAPI({"parcel_id": requestData.id.toString()});
          } else {
            parcelReceiveDialog(context, requestData);
          }
        } else if (value['menu_id'] == 5) {
          context
              .read<ParcelCheckoutCubit>()
              .checkoutParcelApi({"parcel_id": requestData.id.toString()});
        } else {
          if (requestData.parcelComplaint != null) {
            snackBar(context, "You have already created complaint!",
                Icons.warning, AppTheme.redColor);
          } else {
            parcelComplaintsDialog(context, requestData.id.toString());
          }
        }
      },
    ),
  );
}

// popup menu for staff side
Widget popMenusForResident(
    {required List<Map<String, dynamic>> options,
    required BuildContext context,
    required ParcelListing requestData}) {
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
        if (value['menu_id'] == 0) {
          phoneCallLauncher(requestData.member!.phone.toString());
        } else if (value['menu_id'] == 1) {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (_) => ParcelDetailsSecurityStaffSide(
                      isStaffSide: true, parcelId: requestData.id.toString())));
        } else if (value['menu_id'] == 2) {
          if (requestData.handoverStatus == 'pending') {
            parcelReceiveDialog(context, requestData);
          } else {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (_) => ParcelDetailsSecurityStaffSide(
                        isStaffSide: true,
                        parcelId: requestData.id.toString())));
          }
        } else if (value['menu_id'] == 3) {
          context
              .read<DeliverParcelCubit>()
              .deliverParcelAPI({"parcel_id": requestData.id.toString()});
        }
      },
    ),
  );
}
