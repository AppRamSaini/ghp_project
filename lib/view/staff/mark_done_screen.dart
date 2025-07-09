import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ghp_society_management/constants/app_images.dart';
import 'package:ghp_society_management/constants/app_theme.dart';
import 'package:ghp_society_management/view/staff/bottom_nav_screen.dart';
import 'package:google_fonts/google_fonts.dart';

class MarkDoneScreen extends StatelessWidget {
  const MarkDoneScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: Padding(
        padding: EdgeInsets.all(15.w),
        child: GestureDetector(
          onTap: () {
            Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (_) => const StaffDashboard()),
                (route) => false);
          },
          child: Container(
            height: 45.h,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              border: Border.all(color: AppTheme.staffPrimaryColor),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Center(
              child: Text(
                'Back To Home Screen',
                style: GoogleFonts.nunitoSans(
                  color: AppTheme.staffPrimaryColor,
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(ImageAssets.markDoneImage),
        ],
      ),
    );
  }
}
