import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ghp_society_management/constants/app_theme.dart';
import 'package:google_fonts/google_fonts.dart';

class NotificationSettingScreen extends StatefulWidget {
  const NotificationSettingScreen({super.key});

  @override
  State<NotificationSettingScreen> createState() =>
      _NotificationSettingScreenState();
}

class _NotificationSettingScreenState extends State<NotificationSettingScreen> {
  bool checkbox1 = false;
  bool checkbox2 = false;
  bool checkbox3 = false;
  bool checkbox4 = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            SizedBox(
              height: 20.h,
            ),
            Row(
              children: [
                SizedBox(
                  width: 10.w,
                ),
                SizedBox(
                  width: 10.w,
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Notification Settings',
                          style: GoogleFonts.nunitoSans(
                            textStyle: TextStyle(
                              color: Colors.white,
                              fontSize: 20.sp,
                              fontWeight: FontWeight.w600,
                            ),
                          )),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 20.h,
            ),
            Expanded(
              child: Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                ),
                child: Padding(
                  padding: EdgeInsets.all(12.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 10.h,
                      ),
                      Text(
                        "Service Requests Notifications",
                        style: GoogleFonts.nunitoSans(
                          color: Colors.black,
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(
                        height: 10.h,
                      ),
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10.r),
                          border: Border.all(color: Colors.grey[300]!),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            children: [
                              CheckboxListTile(
                                contentPadding: EdgeInsets.zero,
                                activeColor: AppTheme.primaryColor,
                                controlAffinity:
                                    ListTileControlAffinity.leading,
                                dense: true,
                                value: checkbox1,
                                onChanged: (val) {
                                  setState(() {
                                    checkbox1 = val!;
                                  });
                                },
                                title: Text(
                                  "Receive notifications when new service requests are assigned to you.",
                                  style: GoogleFonts.nunitoSans(
                                    color: Colors.black,
                                    fontSize: 12.sp,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ),
                              Divider(
                                color: Colors.grey[300],
                              ),
                              CheckboxListTile(
                                contentPadding: EdgeInsets.zero,
                                activeColor: AppTheme.primaryColor,
                                controlAffinity:
                                    ListTileControlAffinity.leading,
                                dense: true,
                                value: checkbox2,
                                onChanged: (val) {
                                  setState(() {
                                    checkbox2 = val!;
                                  });
                                },
                                title: Text(
                                  "Stay informed about the type of service requested, customer details, and any special instructions.",
                                  style: GoogleFonts.nunitoSans(
                                    color: Colors.black,
                                    fontSize: 12.sp,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 30.h,
                      ),
                      Text(
                        "Service Updates",
                        style: GoogleFonts.nunitoSans(
                          color: Colors.black,
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(
                        height: 10.h,
                      ),
                      Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey[300]!),
                          borderRadius: BorderRadius.circular(10.r),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            children: [
                              CheckboxListTile(
                                contentPadding: EdgeInsets.zero,
                                activeColor: AppTheme.primaryColor,
                                controlAffinity:
                                    ListTileControlAffinity.leading,
                                dense: true,
                                value: checkbox3,
                                onChanged: (val) {
                                  setState(() {
                                    checkbox3 = val!;
                                  });
                                },
                                title: Text(
                                  "Stay updated on any changes or updates to service requests.",
                                  style: GoogleFonts.nunitoSans(
                                    color: Colors.black,
                                    fontSize: 12.sp,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ),
                              Divider(
                                color: Colors.grey[300],
                              ),
                              CheckboxListTile(
                                contentPadding: EdgeInsets.zero,
                                activeColor: AppTheme.primaryColor,
                                controlAffinity:
                                    ListTileControlAffinity.leading,
                                dense: true,
                                value: checkbox4,
                                onChanged: (val) {
                                  setState(() {
                                    checkbox4 = val!;
                                  });
                                },
                                title: Text(
                                  "Receive notifications for changes in appointment times, instructions, or job status.",
                                  style: GoogleFonts.nunitoSans(
                                    color: Colors.black,
                                    fontSize: 12.sp,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
