import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter_html/flutter_html.dart';
import 'package:ghp_society_management/constants/crop_image.dart';
import 'package:ghp_society_management/constants/export.dart';
import 'package:ghp_society_management/constants/simmer_loading.dart';
import 'package:ghp_society_management/controller/parcel/parcel_complaint/parcel_complaint_cubit.dart';
import 'package:ghp_society_management/controller/parcel/receive_parcel/receive_parcel_cubit.dart';
import 'package:ghp_society_management/controller/visitors/visitors_feedback/visitors_feedback_cubit.dart';
import 'package:ghp_society_management/model/members_model.dart';
import 'package:ghp_society_management/model/parcel_listing_model.dart';
import 'package:ghp_society_management/model/refer_property_model.dart';
import 'package:ghp_society_management/model/user_profile_model.dart';
import 'package:ghp_society_management/model/visitors_listing_model.dart';
import 'package:ghp_society_management/payment_gateway_service.dart';
import 'package:ghp_society_management/view/resident/resident_profile/resident_gatepass.dart';
import 'package:ghp_society_management/view/select_society/select_society_screen.dart';
import 'package:http/http.dart' as http;
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart' as picker;
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:qr_flutter/qr_flutter.dart';

/// LOG OUT DIALOG
void logOutPermissionDialog(BuildContext context, {bool isLogout = true}) =>
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (ctx) {
        return Dialog(
          backgroundColor: Colors.white,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          child: Padding(
            padding: const EdgeInsets.all(15),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                isLogout
                    ? const Text(
                        'Are you sure you want to logout this society!',
                        style: TextStyle(color: Colors.black, fontSize: 16))
                    : const Text('Are you sure you want to change society!',
                        style: TextStyle(color: Colors.black, fontSize: 16)),
                const SizedBox(height: 15),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: const Text('CANCEL',
                          style: TextStyle(
                              color: Colors.red,
                              fontSize: 14,
                              fontWeight: FontWeight.w500)),
                    ),
                    const SizedBox(width: 20),
                    GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                        LocalStorage.localStorage.clear();
                        // context.read<LogoutCubit>().logout();

                        Navigator.of(context).pushAndRemoveUntil(
                            MaterialPageRoute(
                                builder: (builder) =>
                                    const SelectSocietyScreen()),
                            (route) => false);
                      },
                      child: Text(
                        isLogout ? 'LOGOUT' : 'YES , CHANGE',
                        style: const TextStyle(
                            color: Colors.deepPurpleAccent,
                            fontSize: 14,
                            fontWeight: FontWeight.w500),
                      ),
                    )
                  ],
                )
              ],
            ),
          ),
        );
      },
    );

/// delete account

void deleteAccountPermissionDialog(BuildContext context) => showDialog(
      barrierDismissible: false,
      context: context,
      builder: (ctx) {
        return Dialog(
          backgroundColor: Colors.white,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          child: Padding(
            padding: const EdgeInsets.all(15),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text('Are you sure you want to delete your account!',
                    style: TextStyle(color: Colors.black, fontSize: 16)),
                const SizedBox(height: 15),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: const Text('CANCEL',
                          style: TextStyle(
                              color: Colors.red,
                              fontSize: 14,
                              fontWeight: FontWeight.w500)),
                    ),
                    const SizedBox(width: 20),
                    GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                        context.read<LogoutCubit>().logout();
                      },
                      child: Text(
                        'DELETE',
                        style: const TextStyle(
                            color: Colors.deepPurpleAccent,
                            fontSize: 14,
                            fontWeight: FontWeight.w500),
                      ),
                    )
                  ],
                )
              ],
            ),
          ),
        );
      },
    );

/// visitors dialog
void visitorsDeletePermissionDialog(
        BuildContext context, Function()? onDelete) =>
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (ctx) {
        return Dialog(
          backgroundColor: Colors.white,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          child: Padding(
            padding: const EdgeInsets.all(15),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Text(
                  'Are you sure you want to delete this',
                  style: GoogleFonts.nunitoSans(
                    color: Colors.black,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 15, left: 15, top: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      GestureDetector(
                          onTap: () => Navigator.pop(context),
                          child: const Text('CANCEL',
                              style: TextStyle(
                                  color: Colors.red,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500))),
                      const SizedBox(width: 20),
                      GestureDetector(
                        onTap: onDelete,
                        child: const Text(
                          'DELETE',
                          style: TextStyle(
                              color: Colors.deepPurpleAccent,
                              fontSize: 14,
                              fontWeight: FontWeight.w500),
                        ),
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
        );
      },
    );

/// VISITORS DESCRIPTION DIALOG
void visitorsFeedbackDialog(BuildContext context, VisitorsListing visitors) {
  TextEditingController controller = TextEditingController();
  final key = GlobalKey<FormState>();
  showDialog(
    barrierDismissible: false,
    context: context,
    builder: (ctx) {
      return Scaffold(
        backgroundColor: Colors.transparent,
        body: Form(
          key: key,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                margin: const EdgeInsets.all(25),
                padding: const EdgeInsets.all(5),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15)),
                width: MediaQuery.sizeOf(context).width,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    ListTile(
                        contentPadding: EdgeInsets.zero,
                        leading: ClipRRect(
                            borderRadius: BorderRadius.circular(100),
                            child: FadeInImage(
                                placeholder: const AssetImage(
                                    "assets/images/default.jpg"),
                                imageErrorBuilder:
                                    (context, error, stackTrace) {
                                  return Image.asset(
                                      "assets/images/default.jpg",
                                      height: 60,
                                      width: 60,
                                      fit: BoxFit.cover);
                                },
                                image: NetworkImage(visitors.image.toString()),
                                fit: BoxFit.cover,
                                height: 60,
                                width: 60)),
                        title: Text(visitors.visitorName.toString(),
                            style: GoogleFonts.nunitoSans(
                                color: Colors.black,
                                fontSize: 16.sp,
                                fontWeight: FontWeight.w500)),
                        subtitle: Text("+91 ${visitors.phone.toString()}",
                            style: GoogleFonts.nunitoSans(
                                color: Colors.black,
                                fontSize: 14,
                                fontWeight: FontWeight.w500)),
                        trailing: IconButton(
                            onPressed: () => Navigator.pop(context),
                            icon:
                                const Icon(Icons.clear, color: Colors.black))),
                    Padding(
                        padding: EdgeInsets.only(
                            top: 10.w, left: 10.w, right: 10.w, bottom: 10.h),
                        child: Text('Description',
                            style: GoogleFonts.nunitoSans(
                                color: Colors.black,
                                fontSize: 16.sp,
                                fontWeight: FontWeight.w500))),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: TextFormField(
                        controller: controller,
                        style: GoogleFonts.nunitoSans(
                            color: Colors.black,
                            fontSize: 14,
                            fontWeight: FontWeight.w500),
                        validator: (text) {
                          if (text == null || text.isEmpty) {
                            return 'Describe feedback here...';
                          }
                          return null;
                        },
                        maxLines: 5,
                        minLines: null,
                        keyboardType: TextInputType.multiline,
                        decoration: InputDecoration(
                          counter: const SizedBox(),
                          hintText: 'Describe feedback here...',
                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 12),
                          filled: true,
                          hintStyle: TextStyle(
                              color: Colors.grey,
                              fontSize: 14,
                              fontWeight: FontWeight.w400),
                          fillColor: Colors.transparent,
                          errorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(
                              color: AppTheme.greyColor,
                            ),
                          ),
                          focusedErrorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(
                              color: AppTheme.greyColor,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(
                              color: AppTheme.greyColor,
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(
                              color: AppTheme.greyColor,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(15),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          GestureDetector(
                            onTap: () {
                              if (key.currentState!.validate()) {
                                Navigator.pop(context);
                                var feedbacks = {
                                  "visitor_id": visitors.id.toString(),
                                  "feedback": controller.text.toString()
                                };
                                context
                                    .read<VisitorsFeedBackCubit>()
                                    .visitorsFeedBackAPI(statusBody: feedbacks);
                              }
                            },
                            child: const Text(
                              'SUBMIT',
                              style: TextStyle(
                                  color: Colors.deepPurpleAccent,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500),
                            ),
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    },
  );
}

/// BLOCK / UNBLOCK DIALOG
void acceptIncomingRequestDialog(BuildContext context, {bool isAccept = true}) {
  TextEditingController controller = TextEditingController();
  final key = GlobalKey<FormState>();
  showDialog(
    barrierDismissible: false,
    context: context,
    builder: (ctx) {
      return Scaffold(
        backgroundColor: Colors.transparent,
        body: Form(
          key: key,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                margin: const EdgeInsets.all(25),
                padding: const EdgeInsets.all(5),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15)),
                width: MediaQuery.sizeOf(context).width,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                      padding:
                          EdgeInsets.only(top: 10.w, left: 10.w, right: 10.w),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("Incoming Request",
                              style: GoogleFonts.nunitoSans(
                                  color: Colors.black,
                                  fontSize: 20.sp,
                                  fontWeight: FontWeight.w600)),
                          GestureDetector(
                              onTap: () {
                                Navigator.of(context).pop();
                              },
                              child: const Icon(Icons.close)),
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                          top: 10.w, left: 10.w, right: 10.w, bottom: 10.h),
                      child: Text(
                        'Are you sure you want to ${isAccept ? "accept" : 'reject'} this request!',
                        style: GoogleFonts.nunitoSans(
                          color: Colors.black,
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    !isAccept
                        ? Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: EdgeInsets.only(
                                    top: 10.w,
                                    left: 10.w,
                                    right: 10.w,
                                    bottom: 10.h),
                                child: Text(
                                  'Reason',
                                  style: GoogleFonts.nunitoSans(
                                    color: Colors.black,
                                    fontSize: 16.sp,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 10),
                                child: TextFormField(
                                  controller: controller,
                                  style: GoogleFonts.nunitoSans(
                                      color: Colors.black,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500),
                                  validator: (text) {
                                    if (text == null || text.isEmpty) {
                                      return 'Describe reason here...';
                                    }
                                    return null;
                                  },
                                  maxLines: 3,
                                  minLines: null,
                                  keyboardType: TextInputType.multiline,
                                  decoration: InputDecoration(
                                    counter: const SizedBox(),
                                    hintText: 'Describe reason here...',
                                    contentPadding: const EdgeInsets.symmetric(
                                        horizontal: 10, vertical: 12),
                                    filled: true,
                                    hintStyle: TextStyle(
                                        color: Colors.grey,
                                        fontSize: 14,
                                        fontWeight: FontWeight.w400),
                                    fillColor: Colors.transparent,
                                    errorBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                      borderSide: BorderSide(
                                        color: AppTheme.greyColor,
                                      ),
                                    ),
                                    focusedErrorBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                      borderSide: BorderSide(
                                        color: AppTheme.greyColor,
                                      ),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                      borderSide: BorderSide(
                                        color: AppTheme.greyColor,
                                      ),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                      borderSide: BorderSide(
                                        color: AppTheme.greyColor,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          )
                        : const SizedBox(),
                    Padding(
                      padding: const EdgeInsets.all(15),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          GestureDetector(
                              onTap: () => Navigator.pop(context),
                              child: const Text('CANCEL',
                                  style: TextStyle(
                                      color: Colors.red,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500))),
                          const SizedBox(width: 20),
                          GestureDetector(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: Text(
                              isAccept ? 'YES , ACCEPT' : 'YES , REJECT',
                              style: const TextStyle(
                                  color: Colors.deepPurpleAccent,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500),
                            ),
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    },
  );
}

/// VIEW MEMBER DETAILS DIALOG
void memberDetailsDialog(BuildContext context, PropertyNumber members) {
  showDialog(
    barrierDismissible: false,
    context: context,
    builder: (ctx) {
      return Scaffold(
        backgroundColor: Colors.transparent,
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              margin: const EdgeInsets.all(15),
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                  color: Colors.white, borderRadius: BorderRadius.circular(8)),
              width: MediaQuery.sizeOf(context).width,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  ListTile(
                      contentPadding: EdgeInsets.zero,
                      title: Text('Members Details',
                          style: GoogleFonts.nunitoSans(
                              color: Colors.black,
                              fontSize: 18.sp,
                              fontWeight: FontWeight.w500)),
                      trailing: IconButton(
                          onPressed: () => Navigator.pop(ctx),
                          icon: const Icon(Icons.clear, color: Colors.black))),
                  Divider(height: 0, color: Colors.grey.withOpacity(0.1)),
                  ListTile(
                      contentPadding: EdgeInsets.zero,
                      leading: ClipRRect(
                          borderRadius: BorderRadius.circular(100),
                          child: FadeInImage(
                              placeholder:
                                  const AssetImage("assets/images/default.jpg"),
                              imageErrorBuilder: (context, error, stackTrace) {
                                return Image.asset("assets/images/default.jpg",
                                    height: 50, width: 50, fit: BoxFit.cover);
                              },
                              image: NetworkImage(''),
                              fit: BoxFit.cover,
                              height: 50,
                              width: 50)),
                      title: Text(members.memberInfo!.name.toString(),
                          style: GoogleFonts.nunitoSans(
                              color: Colors.black,
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w500)),
                      subtitle: Text(
                          '+91 ${members.memberInfo!.phone.toString()}',
                          style: GoogleFonts.nunitoSans(
                              color: Colors.black,
                              fontSize: 14,
                              fontWeight: FontWeight.w500)),
                      trailing: CircleAvatar(
                          backgroundColor: Colors.blue,
                          child: IconButton(
                              onPressed: () async {
                                Navigator.pop(context);

                                await phoneCallLauncher(
                                    members.memberInfo!.phone.toString());
                              },
                              icon: const Icon(Icons.call,
                                  color: Colors.white)))),
                  Divider(color: Colors.grey.withOpacity(0.1)),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(members.name.toString(),
                                  style: const TextStyle(
                                      color: Colors.black,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600)),
                              const Text('Tower Name',
                                  style: TextStyle(
                                      color: Colors.black45, fontSize: 14))
                            ]),
                        Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(members.memberInfo!.aprtNo.toString(),
                                  style: const TextStyle(
                                      color: Colors.black,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600)),
                              const Text('Property Number',
                                  style: TextStyle(
                                    color: Colors.black45,
                                    fontSize: 14,
                                  ))
                            ]),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(members.memberInfo!.floorNumber.toString(),
                                style: const TextStyle(
                                    color: Colors.black,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600)),
                            const Text(
                              'Floor',
                              style: TextStyle(
                                  color: Colors.black45, fontSize: 14),
                            )
                          ],
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      );
    },
  );
}

/// CANCEL COMPLAINTS  DIALOG
void deleteComplaintPermissionDialog(
        BuildContext context, Function()? onCancel) =>
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (ctx) {
        return Dialog(
          backgroundColor: Colors.white,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          child: Padding(
            padding: const EdgeInsets.all(15),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text('Are you sure you want to cancel this complaint!',
                    style: TextStyle(color: Colors.black, fontSize: 16)),
                const SizedBox(height: 15),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: const Text('NO',
                          style: TextStyle(
                              color: Colors.red,
                              fontSize: 16,
                              fontWeight: FontWeight.w500)),
                    ),
                    const SizedBox(width: 30),
                    GestureDetector(
                      onTap: onCancel,
                      child: const Text(
                        'YES, CANCEL',
                        style: TextStyle(
                            color: Colors.deepPurpleAccent,
                            fontSize: 16,
                            fontWeight: FontWeight.w500),
                      ),
                    )
                  ],
                )
              ],
            ),
          ),
        );
      },
    );

/// PARCEL COMPLAINTS
void parcelComplaintsDialog(BuildContext context, String parcelId) {
  TextEditingController controller = TextEditingController();
  final key = GlobalKey<FormState>();
  showDialog(
    barrierDismissible: false,
    context: context,
    builder: (ctx) {
      return Scaffold(
        backgroundColor: Colors.transparent,
        body: Form(
          key: key,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                margin: const EdgeInsets.all(25),
                padding: const EdgeInsets.all(5),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15)),
                width: MediaQuery.sizeOf(context).width,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    ListTile(
                        dense: true,
                        contentPadding:
                            const EdgeInsets.symmetric(horizontal: 10),
                        title: Text('Parcel Complaint',
                            style: GoogleFonts.nunitoSans(
                                color: Colors.black,
                                fontSize: 16.sp,
                                fontWeight: FontWeight.w600)),
                        trailing: GestureDetector(
                            onTap: () => Navigator.pop(context),
                            child:
                                const Icon(Icons.clear, color: Colors.black))),
                    Padding(
                        padding: EdgeInsets.only(
                            top: 10.w, left: 10.w, right: 10.w, bottom: 10.h),
                        child: Text('Reason',
                            style: GoogleFonts.nunitoSans(
                                color: Colors.black,
                                fontSize: 16.sp,
                                fontWeight: FontWeight.w500))),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: TextFormField(
                        controller: controller,
                        style: GoogleFonts.nunitoSans(
                            color: Colors.black,
                            fontSize: 14,
                            fontWeight: FontWeight.w500),
                        validator: (text) {
                          if (text == null || text.isEmpty) {
                            return 'Describe reason here...';
                          }
                          return null;
                        },
                        maxLines: 4,
                        minLines: null,
                        keyboardType: TextInputType.multiline,
                        decoration: InputDecoration(
                          counter: const SizedBox(),
                          hintText: 'Describe reason here...',
                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 12),
                          filled: true,
                          hintStyle: TextStyle(
                              color: Colors.grey,
                              fontSize: 14,
                              fontWeight: FontWeight.w400),
                          fillColor: Colors.transparent,
                          errorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(
                              color: AppTheme.greyColor,
                            ),
                          ),
                          focusedErrorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(
                              color: AppTheme.greyColor,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(
                              color: AppTheme.greyColor,
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(
                              color: AppTheme.greyColor,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(15),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          GestureDetector(
                              onTap: () => Navigator.pop(context),
                              child: const Text('CANCEL',
                                  style: TextStyle(
                                      color: Colors.red,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500))),
                          const SizedBox(width: 30),
                          GestureDetector(
                            onTap: () {
                              if (key.currentState!.validate()) {
                                Navigator.pop(context);
                                var feedbacks = {
                                  "parcel_id": parcelId.toString(),
                                  "description": controller.text.toString()
                                };
                                context
                                    .read<ParcelComplaintCubit>()
                                    .createParcelComplaintAPI(feedbacks);
                              }
                            },
                            child: const Text(
                              'SUBMIT',
                              style: TextStyle(
                                  color: Colors.deepPurpleAccent,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500),
                            ),
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    },
  );
}

/// PARCEL  RECEIVE DIALOG
void parcelReceiveDialog(BuildContext context, ParcelListing requestData) {
  TextEditingController name = TextEditingController();
  TextEditingController phone = TextEditingController();
  TextEditingController parcelIDController = TextEditingController();
  parcelIDController.text = requestData.parcelid.toString();
  name.text = requestData.deliveryName ?? '';
  phone.text = requestData.deliveryPhone ?? '';
  final key = GlobalKey<FormState>();
  List<CroppedFile>? croppedImagesList = [];
  List<File> documentFiles = [];

  bool isImageFetched = false;

  showDialog(
    barrierDismissible: false,
    context: context,
    builder: (ctx) {
      return StatefulBuilder(builder: (context, setState) {
        fromCamera(BuildContext context) async {
          final pickedFile = await picker.ImagePicker()
              .pickImage(source: picker.ImageSource.camera);
          if (pickedFile != null) {
            croppedImagesList.clear();
            croppedImagesList.add(await cropImage(pickedFile.path));
            setState(() {});
          }
        }

        fromGallery(BuildContext context) async {
          final pickedFile = await picker.ImagePicker()
              .pickImage(source: picker.ImageSource.gallery);

          print('------>>>>>$pickedFile');
          if (pickedFile != null) {
            croppedImagesList.clear();
            croppedImagesList.add(await cropImage(pickedFile.path));
            setState(() {});
          }
        }

        Future<void> _fetchAndCropImage(String imageUrl) async {
          final response = await http.get(Uri.parse(imageUrl));
          if (response.statusCode == 200) {
            final tempDir = await getTemporaryDirectory();
            final file = File('${tempDir.path}/${imageUrl.split('/').last}');
            await file.writeAsBytes(response.bodyBytes);
            croppedImagesList.clear();
            croppedImagesList.add(CroppedFile(file.path));
            setState(() {});
          }
        }

        _fetchAndCropImage(requestData.deliveryAgentImage.toString());
        return Scaffold(
          backgroundColor: Colors.transparent,
          body: Form(
            key: key,
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 100),
                    child: Container(
                      margin: const EdgeInsets.all(15),
                      padding: const EdgeInsets.all(5),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(15)),
                      width: MediaQuery.sizeOf(context).width,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            SizedBox(
                                height: 40,
                                child: ListTile(
                                    dense: true,
                                    contentPadding: const EdgeInsets.symmetric(
                                        horizontal: 10),
                                    title: Text('Receive Parcel',
                                        style: GoogleFonts.nunitoSans(
                                            color: Colors.black,
                                            fontSize: 16.sp,
                                            fontWeight: FontWeight.w600)),
                                    trailing: GestureDetector(
                                        onTap: () => Navigator.pop(context),
                                        child: const Icon(Icons.clear,
                                            color: Colors.black)))),
                            Divider(color: Colors.grey.withOpacity(0.3)),
                            Text('Order ID',
                                style: GoogleFonts.nunitoSans(
                                    color: Colors.black,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500)),
                            const SizedBox(height: 2),
                            TextFormField(
                              readOnly: true,
                              controller: parcelIDController,
                              style: GoogleFonts.nunitoSans(
                                  color: Colors.black,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500),
                              validator: (text) {
                                if (text == null || text.isEmpty) {
                                  return 'Describe reason here...';
                                }
                                return null;
                              },
                              keyboardType: TextInputType.multiline,
                              decoration: InputDecoration(
                                counter: const SizedBox(),
                                hintText: 'Describe reason here...',
                                contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 12),
                                filled: true,
                                hintStyle: TextStyle(
                                    color: Colors.grey,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w400),
                                fillColor: Colors.transparent,
                                errorBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: BorderSide(
                                    color: AppTheme.greyColor,
                                  ),
                                ),
                                focusedErrorBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: BorderSide(
                                    color: AppTheme.greyColor,
                                  ),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: BorderSide(
                                    color: AppTheme.greyColor,
                                  ),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: BorderSide(
                                    color: AppTheme.greyColor,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 5),
                            Text('Deliver Name',
                                style: GoogleFonts.nunitoSans(
                                    color: Colors.black,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500)),
                            TextFormField(
                              controller: name,
                              style: GoogleFonts.nunitoSans(
                                  color: Colors.black,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500),
                              validator: (text) {
                                if (text == null || text.isEmpty) {
                                  return 'Please enter name here...';
                                }
                                return null;
                              },
                              keyboardType: TextInputType.multiline,
                              decoration: InputDecoration(
                                counter: const SizedBox(),
                                hintText: 'Deliver name',
                                contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 12),
                                filled: true,
                                hintStyle: TextStyle(
                                    color: Colors.grey,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w400),
                                fillColor: Colors.transparent,
                                errorBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: BorderSide(
                                    color: AppTheme.greyColor,
                                  ),
                                ),
                                focusedErrorBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: BorderSide(
                                    color: AppTheme.greyColor,
                                  ),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: BorderSide(
                                    color: AppTheme.greyColor,
                                  ),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: BorderSide(
                                    color: AppTheme.greyColor,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 5),
                            Text('Deliver contact numbe',
                                style: GoogleFonts.nunitoSans(
                                    color: Colors.black,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500)),
                            TextFormField(
                              controller: phone,
                              style: GoogleFonts.nunitoSans(
                                  color: Colors.black,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500),
                              validator: (text) {
                                if (text == null || text.isEmpty) {
                                  return 'Please enter phone here...';
                                } else if (text.length < 10) {
                                  return 'Please enter valid phone number';
                                }
                                return null;
                              },
                              keyboardType: TextInputType.number,
                              maxLength: 10,
                              decoration: InputDecoration(
                                counter: const SizedBox(),
                                hintText: 'Deliver phone',
                                contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 12),
                                filled: true,
                                hintStyle: TextStyle(
                                    color: Colors.grey,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w400),
                                fillColor: Colors.transparent,
                                errorBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: BorderSide(
                                    color: AppTheme.greyColor,
                                  ),
                                ),
                                focusedErrorBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: BorderSide(
                                    color: AppTheme.greyColor,
                                  ),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: BorderSide(
                                    color: AppTheme.greyColor,
                                  ),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: BorderSide(
                                    color: AppTheme.greyColor,
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 10),
                                child: Text('Upload live photo',
                                    style: GoogleFonts.nunitoSans(
                                        textStyle: TextStyle(
                                            color: Colors.black87,
                                            fontSize: 16.sp,
                                            fontWeight: FontWeight.w400)))),
                            SizedBox(
                              height: 100,
                              child: uploadWidget(
                                  context: context,
                                  onTap: () {
                                    uploadFileWidget(
                                        context: context,
                                        fromCamera: () {
                                          fromCamera(context);
                                        },
                                        fromGallery: () {
                                          fromGallery(context);
                                        });
                                  },
                                  onRemove: (index) {
                                    setState(() =>
                                        croppedImagesList.removeAt(index));
                                  },
                                  croppedImagesList: croppedImagesList),
                            ),
                            Padding(
                                padding: const EdgeInsets.only(top: 20),
                                child: Divider(
                                    height: 0,
                                    color: Colors.grey.withOpacity(0.2))),
                            Padding(
                              padding: const EdgeInsets.all(15),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  GestureDetector(
                                      onTap: () => Navigator.pop(context),
                                      child: const Text('CANCEL',
                                          style: TextStyle(
                                              color: Colors.red,
                                              fontSize: 16,
                                              fontWeight: FontWeight.w500))),
                                  const SizedBox(width: 30),
                                  GestureDetector(
                                    onTap: () {
                                      if (key.currentState!.validate()) {
                                        if (croppedImagesList.isEmpty) {
                                          snackBarMsg(context,
                                              'Please upload delivery agent picture');
                                        } else {
                                          Navigator.pop(context);
                                          documentFiles.clear();
                                          for (int i = 0;
                                              i < croppedImagesList.length;
                                              i++) {
                                            documentFiles.add(File(
                                                croppedImagesList[i].path));
                                          }

                                          context
                                              .read<ReceiveParcelCubit>()
                                              .receiveParcelAPI(
                                                  requestData.id.toString(),
                                                  name.text.toString(),
                                                  phone.text.toString(),
                                                  documentFiles.first);
                                        }
                                      }
                                    },
                                    child: const Text(
                                      'SUBMIT',
                                      style: TextStyle(
                                          color: Colors.deepPurpleAccent,
                                          fontSize: 16,
                                          fontWeight: FontWeight.w500),
                                    ),
                                  )
                                ],
                              ),
                            )
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
      });
    },
  );
}

/// visitors dialog
void readComplaintDialog(BuildContext context, String data) => showDialog(
      barrierDismissible: false,
      context: context,
      builder: (ctx) {
        return Scaffold(
          backgroundColor: Colors.transparent,
          body: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                margin: const EdgeInsets.all(15),
                padding: const EdgeInsets.all(5),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15)),
                width: MediaQuery.sizeOf(context).width,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      SizedBox(
                          height: 40,
                          child: ListTile(
                              dense: true,
                              contentPadding: EdgeInsets.zero,
                              title: Text('Parcel Complaint',
                                  style: GoogleFonts.nunitoSans(
                                      color: Colors.black,
                                      fontSize: 16.sp,
                                      fontWeight: FontWeight.w600)),
                              trailing: GestureDetector(
                                  onTap: () => Navigator.pop(context),
                                  child: const Icon(Icons.clear,
                                      color: Colors.black)))),
                      Divider(color: Colors.grey.withOpacity(0.3)),
                      SizedBox(
                        height: 150,
                        child: Text(
                          data.toString(),
                          style: GoogleFonts.nunitoSans(
                            color: Colors.black,
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );

/// PROFILE VIEW DIALOG
profileViewAlertDialog(BuildContext context, UserProfileModel profileDetails) {
  final GlobalKey _globalKey = GlobalKey();
  return showDialog(
    context: context,
    builder: (BuildContext context) {
      final Map<String, dynamic> residentDetails = {
        'resident_id': profileDetails.data!.user!.id.toString()
      };
      String jsonDetails = jsonEncode(residentDetails);
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            margin: const EdgeInsets.all(12),
            decoration: BoxDecoration(
                color: Colors.white, borderRadius: BorderRadius.circular(8)),
            width: MediaQuery.sizeOf(context).width,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Padding(
                    padding: EdgeInsets.only(
                        top: 12.w, left: 10.w, right: 10.w, bottom: 4),
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("Profile Overview",
                              style: GoogleFonts.nunitoSans(
                                  color: Colors.black,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600)),
                          GestureDetector(
                              onTap: () {
                                Navigator.of(context).pop();
                              },
                              child:
                                  const Icon(Icons.close, color: Colors.black))
                        ])),
                Divider(color: Colors.grey.withOpacity(0.2)),
                Padding(
                  padding: EdgeInsets.only(top: 10.w, left: 10.w, right: 10.w),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Row(
                          children: [
                            profileDetails.data!.user!.image != null
                                ? ClipRRect(
                                    borderRadius: BorderRadius.circular(10),
                                    child: FadeInImage(
                                      height: 70,
                                      width: 70,
                                      fit: BoxFit.fill,
                                      placeholder: AssetImage(
                                          'assets/images/default.jpg'),
                                      image: NetworkImage(profileDetails
                                          .data!.user!.image
                                          .toString()),
                                      imageErrorBuilder: (_, child, st) =>
                                          Image.asset(
                                              'assets/images/default.jpg',
                                              height: 70,
                                              width: 70,
                                              fit: BoxFit.fill),
                                    ),
                                  )
                                : ClipRRect(
                                    borderRadius: BorderRadius.circular(10),
                                    child: FadeInImage(
                                      height: 70,
                                      width: 70,
                                      fit: BoxFit.fill,
                                      placeholder: AssetImage(
                                          'assets/images/default.jpg'),
                                      image: AssetImage(''),
                                      imageErrorBuilder: (_, child, st) =>
                                          Image.asset(
                                              'assets/images/default.jpg',
                                              height: 70,
                                              width: 70,
                                              fit: BoxFit.fill),
                                    ),
                                  ),
                            SizedBox(width: 10.w),
                            Flexible(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                      profileDetails.data!.user!.name
                                          .toString(),
                                      style: GoogleFonts.nunitoSans(
                                          color: Colors.black,
                                          fontSize: 14,
                                          fontWeight: FontWeight.w600)),
                                  Text(
                                      "Role : ${capitalizeWords(profileDetails.data!.user!.role.toString()).replaceAll("_", ' ')}",
                                      style: GoogleFonts.nunitoSans(
                                          color: Colors.pink,
                                          fontSize: 12,
                                          fontWeight: FontWeight.w600)),
                                  profileDetails.data!.user!.role == 'staff'
                                      ? Text(
                                          "Category: ${profileDetails.data!.user!.categoryName.toString()}",
                                          style: GoogleFonts.nunitoSans(
                                              color: Colors.deepPurpleAccent,
                                              fontSize: 12))
                                      : const SizedBox(),
                                  profileDetails.data!.user!.role == 'resident'
                                      ? Text(
                                          "Tower/Bloc : ${profileDetails.data!.user!.property!.blockName.toString()}/${profileDetails.data!.user!.floorNumber.toString()}\nProperty No: ${profileDetails.data!.user!.aprtNo.toString()}",
                                          style: GoogleFonts.nunitoSans(
                                              color: Colors.black,
                                              fontSize: 12))
                                      : const SizedBox(),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      profileDetails.data!.user!.role == 'resident'
                          ? GestureDetector(
                              onTap: () => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (_) => ResidentGatePass(
                                          residentModel:
                                              profileDetails.data!.user!))),
                              child: RepaintBoundary(
                                key:
                                    _globalKey, // Key for capturing the QR code
                                child: Container(
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(4),
                                      border: Border.all(
                                          color: Colors.grey.withOpacity(0.1))),
                                  child: QrImageView(
                                    data: jsonDetails,
                                    version: QrVersions.auto,
                                    size: 60.0,
                                  ),
                                ),
                              ),
                            )
                          : const SizedBox(),
                    ],
                  ),
                ),
                SizedBox(height: 10.h),
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(4.r),
                        border: Border.all(color: const Color(0XffE6E6E6))),
                    child: Padding(
                      padding: EdgeInsets.all(15.w),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('Status :',
                                  style: GoogleFonts.nunitoSans(
                                      color: Colors.black,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500)),
                              Text(
                                  capitalizeWords(profileDetails
                                      .data!.user!.status
                                      .toString()),
                                  style: GoogleFonts.nunitoSans(
                                      color: Colors.green,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600))
                            ],
                          ),
                          Divider(color: Colors.grey.withOpacity(0.1)),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('Phone :',
                                  style: GoogleFonts.nunitoSans(
                                      color: Colors.black,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500)),
                              Text(
                                  "+91 ${profileDetails.data!.user!.phone.toString()}",
                                  style: GoogleFonts.nunitoSans(
                                      color: Colors.black,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600))
                            ],
                          ),
                          Divider(color: Colors.grey.withOpacity(0.1)),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('Email ID : ',
                                  style: GoogleFonts.nunitoSans(
                                      color: Colors.black,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500)),
                              Text(profileDetails.data!.user!.email.toString(),
                                  style: GoogleFonts.nunitoSans(
                                      color: Colors.black,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600))
                            ],
                          ),
                          Divider(color: Colors.grey.withOpacity(0.1)),
                          profileDetails.data!.user!.role == 'resident'
                              ? Column(
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text('Unit Type : ',
                                            style: GoogleFonts.nunitoSans(
                                                color: Colors.black,
                                                fontSize: 14,
                                                fontWeight: FontWeight.w500)),
                                        Text(
                                            profileDetails.data!.user!.unitType
                                                .toString(),
                                            style: GoogleFonts.nunitoSans(
                                                color: Colors.black,
                                                fontSize: 14,
                                                fontWeight: FontWeight.w600))
                                      ],
                                    ),
                                    Divider(
                                        color: Colors.grey.withOpacity(0.1)),
                                  ],
                                )
                              : const SizedBox(),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('Society Name : ',
                                  style: GoogleFonts.nunitoSans(
                                      color: Colors.black,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500)),
                              Text(
                                  profileDetails.data!.user!.societyName
                                      .toString()
                                      .toString(),
                                  style: GoogleFonts.nunitoSans(
                                      color: Colors.deepPurpleAccent,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600))
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                )
              ],
            ),
          )
        ],
      );
    },
  );
}

/// VISITORS DESCRIPTION DIALOG
void privacyPolicyDialog(
    BuildContext context, Function(bool values) setPageValue) {
  context.read<PrivacyPolicyCubit>().fetchPrivacyPolicyAPI();

  showDialog(
    barrierDismissible: false,
    context: context,
    builder: (ctx) {
      return Scaffold(
        backgroundColor: Colors.transparent,
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              margin: const EdgeInsets.all(10),
              width: double.infinity,
              height: MediaQuery.sizeOf(context).height * 0.85,
              decoration: BoxDecoration(
                  color: Colors.white, borderRadius: BorderRadius.circular(10)),
              child: Column(
                children: [
                  Expanded(
                    child: BlocBuilder<PrivacyPolicyCubit, PrivacyPolicyState>(
                      builder: (context, state) {
                        if (state is PrivacyPolicyLoading) {
                          return notificationShimmerLoading();
                        } else if (state is PrivacyPolicyLoaded) {
                          final htmlData = state.privacyPolicyModel.data;
                          return SingleChildScrollView(
                              child: Html(
                                  data: htmlData.privacyPolicy.content
                                      .toString()));
                        } else if (state is PrivacyPolicyFailed) {
                          return Center(
                              child: Text(state.errorMessage.toString(),
                                  style: const TextStyle(color: Colors.red)));
                        } else if (state is PrivacyPolicyInternetError) {
                          return Center(
                              child: Text(state.errorMessage.toString(),
                                  style: const TextStyle(color: Colors.red)));
                        }
                        return const SizedBox();
                      },
                    ),
                  ),
                  Divider(color: Colors.grey.withOpacity(0.3)),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text("CANCEL",
                              style: TextStyle(
                                  color: Colors.red,
                                  fontWeight: FontWeight.w600))),
                      const SizedBox(width: 18),
                      TextButton(
                        onPressed: () {
                          setPageValue(true);
                          Navigator.pop(context);
                        },
                        child: const Text(
                          "I AGREE",
                          style: TextStyle(
                              color: Colors.green, fontWeight: FontWeight.w600),
                        ),
                      ),
                      const SizedBox(width: 5),
                    ],
                  ),
                  const SizedBox(height: 5),
                ],
              ),
            ),
          ],
        ),
      );
    },
  );
}

/// VIEW MEMBER DETAILS DIALOG
void referPropertyDialog(
    BuildContext context, ReferPropertyList referPropertyList) {
  showDialog(
    barrierDismissible: false,
    context: context,
    builder: (ctx) {
      return Scaffold(
        backgroundColor: Colors.transparent,
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              margin: const EdgeInsets.all(15),
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                  color: Colors.white, borderRadius: BorderRadius.circular(8)),
              width: MediaQuery.sizeOf(context).width,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    ListTile(
                        contentPadding: EdgeInsets.zero,
                        title: Text('Property Details',
                            style: GoogleFonts.nunitoSans(
                                color: Colors.black,
                                fontSize: 16,
                                fontWeight: FontWeight.w600)),
                        trailing: IconButton(
                            onPressed: () => Navigator.pop(context),
                            icon:
                                const Icon(Icons.clear, color: Colors.black))),
                    Divider(color: Colors.grey.withOpacity(0.1)),
                    Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Referred Name : ',
                              style: GoogleFonts.nunitoSans(
                                  textStyle: TextStyle(
                                      color: Colors.black45, fontSize: 15))),
                          Text(referPropertyList.name.toString(),
                              style: GoogleFonts.nunitoSans(
                                  textStyle: TextStyle(
                                      color: Colors.black87, fontSize: 15)))
                        ]),
                    Divider(color: Colors.grey.withOpacity(0.1)),
                    Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Phone Number : ',
                              style: GoogleFonts.nunitoSans(
                                  textStyle: TextStyle(
                                      color: Colors.black45, fontSize: 14))),
                          Text("+91 ${referPropertyList.phone.toString()}",
                              style: GoogleFonts.nunitoSans(
                                  textStyle: TextStyle(
                                      color: Colors.black87, fontSize: 14)))
                        ]),
                    Divider(color: Colors.grey.withOpacity(0.1)),
                    Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Unit Type : ',
                              style: GoogleFonts.nunitoSans(
                                  textStyle: TextStyle(
                                      color: Colors.black45, fontSize: 14))),
                          Text(referPropertyList.unitType.toString(),
                              style: GoogleFonts.nunitoSans(
                                  textStyle: TextStyle(
                                      color: Colors.black87, fontSize: 14)))
                        ]),
                    Divider(color: Colors.grey.withOpacity(0.1)),
                    Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Minimum Budget : ',
                              style: GoogleFonts.nunitoSans(
                                  textStyle: TextStyle(
                                      color: Colors.black45, fontSize: 14))),
                          Text("₹ ${referPropertyList.minBudget.toString()}",
                              style: GoogleFonts.nunitoSans(
                                  textStyle: TextStyle(
                                      color: Colors.black87, fontSize: 14)))
                        ]),
                    Divider(color: Colors.grey.withOpacity(0.1)),
                    Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Max Budget : ',
                              style: GoogleFonts.nunitoSans(
                                  textStyle: TextStyle(
                                      color: Colors.black45, fontSize: 14))),
                          Text("₹ ${referPropertyList.maxBudget.toString()}",
                              style: GoogleFonts.nunitoSans(
                                  textStyle: TextStyle(
                                      color: Colors.black87, fontSize: 14)))
                        ]),
                    Divider(color: Colors.grey.withOpacity(0.1)),
                    Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('BHK Type : ',
                              style: GoogleFonts.nunitoSans(
                                  textStyle: TextStyle(
                                      color: Colors.black45, fontSize: 14))),
                          Text(referPropertyList.bhk.toString(),
                              style: GoogleFonts.nunitoSans(
                                  textStyle: TextStyle(
                                      color: Colors.black87, fontSize: 14)))
                        ]),
                    Divider(color: Colors.grey.withOpacity(0.1)),
                    Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Property Facing : ',
                              style: GoogleFonts.nunitoSans(
                                  textStyle: TextStyle(
                                      color: Colors.black45, fontSize: 14))),
                          Text(referPropertyList.propertyFancing.toString(),
                              style: GoogleFonts.nunitoSans(
                                  textStyle: TextStyle(
                                      color: Colors.black87, fontSize: 14)))
                        ]),
                    Divider(color: Colors.grey.withOpacity(0.1)),
                    Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Property Status : ',
                              style: GoogleFonts.nunitoSans(
                                  textStyle: TextStyle(
                                      color: Colors.black45, fontSize: 14))),
                          Text(referPropertyList.propertyStatus.toString(),
                              style: GoogleFonts.nunitoSans(
                                  textStyle: TextStyle(
                                      color: Colors.black87, fontSize: 14)))
                        ]),
                    Divider(color: Colors.grey.withOpacity(0.1)),
                    Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Remark : ',
                              style: GoogleFonts.nunitoSans(
                                  textStyle: TextStyle(
                                      color: Colors.black45, fontSize: 14))),
                          Expanded(
                            child: Text(referPropertyList.remark.toString(),
                                style: GoogleFonts.nunitoSans(
                                    textStyle: TextStyle(
                                        color: Colors.black87, fontSize: 14))),
                          )
                        ]),
                    Divider(color: Colors.grey.withOpacity(0.1)),
                    Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Location : ',
                              style: GoogleFonts.nunitoSans(
                                  textStyle: TextStyle(
                                      color: Colors.black45, fontSize: 14))),
                          Text(referPropertyList.location.toString(),
                              style: GoogleFonts.nunitoSans(
                                  textStyle: TextStyle(
                                      color: Colors.black87, fontSize: 14)))
                        ]),
                  ],
                ),
              ),
            ),
          ],
        ),
      );
    },
  );
}

/// EXIT PAGE CONFIRMATION
void exitPageConfirmationDialog(BuildContext context) => showDialog(
      barrierDismissible: false,
      context: context,
      builder: (ctx) {
        return Dialog(
          backgroundColor: Colors.white,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          child: Padding(
            padding: const EdgeInsets.all(15),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text('Are you sure you want to exit this app!',
                    style: TextStyle(color: Colors.black, fontSize: 16)),
                const SizedBox(height: 15),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: const Text('CANCEL',
                          style: TextStyle(
                              color: Colors.red,
                              fontSize: 16,
                              fontWeight: FontWeight.w500)),
                    ),
                    const SizedBox(width: 20),
                    GestureDetector(
                      onTap: () => SystemNavigator.pop(),
                      child: const Text(
                        'YES , EXIT',
                        style: TextStyle(
                            color: Colors.deepPurpleAccent,
                            fontSize: 16,
                            fontWeight: FontWeight.w500),
                      ),
                    )
                  ],
                )
              ],
            ),
          ),
        );
      },
    );

// delete rent property dialog
void deleteRentSellPropertyDialog(
        BuildContext buildContext, Function()? onDelete) =>
    showDialog(
      barrierDismissible: false,
      context: buildContext,
      builder: (ctx) {
        return Dialog(
          backgroundColor: Colors.white,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          child: Padding(
            padding: const EdgeInsets.all(15),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text('Are you sure you want to delete this property!',
                    style: TextStyle(color: Colors.black, fontSize: 16)),
                const SizedBox(height: 15),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    GestureDetector(
                      onTap: () => Navigator.pop(buildContext),
                      child: const Text('CANCEL',
                          style: TextStyle(
                              color: Colors.red,
                              fontSize: 16,
                              fontWeight: FontWeight.w500)),
                    ),
                    const SizedBox(width: 20),
                    GestureDetector(
                      onTap: onDelete,
                      child: const Text(
                        'YES, DELETE',
                        style: TextStyle(
                            color: Colors.deepPurpleAccent,
                            fontSize: 16,
                            fontWeight: FontWeight.w500),
                      ),
                    )
                  ],
                )
              ],
            ),
          ),
        );
      },
    );

/// OVERDUE BILL ALERT DIALOG
Future<void> overDueBillAlertDialog(
    BuildContext context, UnpaidBill myUnpaidBill,
    {bool fromStaffSide = false}) async {
  DateTime dueDate = DateTime.parse(myUnpaidBill.dueDate.toString()); // e.
  String formattedDueDate = DateFormat('dd MMMM yyyy').format(dueDate);

  return showDialog(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return Dialog(
        insetPadding: const EdgeInsets.symmetric(horizontal: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
              color: Colors.white, borderRadius: BorderRadius.circular(8)),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Alert",
                      style: GoogleFonts.nunitoSans(
                          color: Colors.black,
                          fontSize: 18.sp,
                          fontWeight: FontWeight.w600)),
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).pop();
                    },
                    child: const Icon(Icons.close, color: Colors.black),
                  )
                ],
              ),
              Divider(color: Colors.grey.withOpacity(0.2)),
              const SizedBox(height: 5),
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                    color: Colors.red.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(4),
                    border: Border.all(color: Colors.red.withOpacity(0.3))),
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(Icons.warning_amber, color: Colors.red),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Warning',
                                style: GoogleFonts.nunitoSans(
                                    color: const Color(0x7FF30402),
                                    fontSize: 16.sp,
                                    fontWeight: FontWeight.w600)),
                            Text(
                              fromStaffSide
                                  ? 'Entry restricted due to pending maintenance bill :  ₹${myUnpaidBill.amount.toString()}.'
                                  : 'Your maintenance bill has been due on $formattedDueDate.Please pay ₹${myUnpaidBill.amount.toString()}',
                              style: GoogleFonts.nunitoSans(
                                color: Colors.red,
                                fontSize: 13.sp,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 10),
              fromStaffSide
                  ? const SizedBox()
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        MaterialButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            color: Colors.grey,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30)),
                            child: Text("Cancel",
                                style: GoogleFonts.nunitoSans(
                                    color: Colors.black,
                                    fontSize: 16.sp,
                                    fontWeight: FontWeight.w600))),
                        const SizedBox(width: 10),
                        MaterialButton(
                          onPressed: () {
                            Navigator.pop(context);
                            payBillFun(
                                double.parse(myUnpaidBill.amount.toString()),
                                context);
                          },
                          color: Colors.red,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30)),
                          child: Text(
                            "Pay Now",
                            style: GoogleFonts.nunitoSans(
                              color: Colors.white,
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
            ],
          ),
        ),
      );
    },
  );
}

/*class DialogService {
  static final DialogService _instance = DialogService._internal();
  factory DialogService() => _instance;
  DialogService._internal();

  bool _isDialogActive = false;
  Timer? _timer;
  String billStatus = 'pending';

  void startDialogCheck(BuildContext context) {
    if (_timer != null && _timer!.isActive) return;

    print("✅ Timer Started...");

    _timer = Timer.periodic(Duration(seconds: 10), (timer) {
      print("🔄 Timer Tick: Checking Bill Status...");

      if (!_isDialogActive && billStatus == "pending") {
        print("🚨 Dialog Triggering...");
        _isDialogActive = true; // डायलॉग एक्टिवेट हो गया

        WidgetsBinding.instance.addPostFrameCallback((_) {
          overDueBillAlertDialog(context).then((_) {
            _isDialogActive =
                false; // जब यूजर डायलॉग बंद करे, तब इसे false करें
          });
        });
      }
    });
  }
}*/
