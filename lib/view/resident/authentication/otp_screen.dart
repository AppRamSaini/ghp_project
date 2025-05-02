// import 'package:firebase_messaging/firebase_messaging.dart';
import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ghp_society_management/constants/app_images.dart';
import 'package:ghp_society_management/constants/app_theme.dart';
import 'package:ghp_society_management/constants/dialog.dart';
import 'package:ghp_society_management/constants/snack_bar.dart';
import 'package:ghp_society_management/controller/verify_otp/verify_otp_cubit.dart';
import 'package:ghp_society_management/main.dart';
import 'package:ghp_society_management/view/dashboard/bottom_nav_screen.dart';
import 'package:ghp_society_management/view/security_staff/dashboard/bottom_navigation.dart';
import 'package:ghp_society_management/view/Staff/bottom_nav_screen.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pinput/pinput.dart';

class OtpScreen extends StatefulWidget {
  final String phoneNumber;

  const OtpScreen({super.key, required this.phoneNumber});

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  final TextEditingController _otpController = TextEditingController();
  late BuildContext _dialogueContext;

  void _handleStateChanges(BuildContext context, VerifyOtpState state) {
    if (state is VerifyOtpLoading) {
      showLoadingDialog(context, (ctx) => _dialogueContext = ctx);
    } else if (state is VerifyOtpSuccessfully) {
      _showSuccessAndNavigate(state.role);
    } else if (state is VerifyOtpFailed) {
      _showSnackBar(state.errorMessage, Icons.warning, AppTheme.redColor);
      Navigator.of(_dialogueContext).pop();
    } else if (state is VerifyOtpInternetError) {
      _showSnackBar(
          'Internet connection failed', Icons.wifi_off, AppTheme.redColor);
      Navigator.of(_dialogueContext).pop();
    }
  }

  void _showSuccessAndNavigate(String role) {
    final route = _getDashboardRoute(role);
    if (route != null) {
      _showSnackBar(
          'OTP verified successfully', Icons.done, AppTheme.guestColor);
      Navigator.of(_dialogueContext).pop();
      Navigator.of(context).pushAndRemoveUntil(route, (route) => false);
    }
  }

  MaterialPageRoute? _getDashboardRoute(String role) {
    switch (role) {
      case 'resident':
      case 'admin':
        return MaterialPageRoute(builder: (_) => const Dashboard());
      case 'staff':
        return MaterialPageRoute(builder: (_) => const StaffDashboard());
      case 'staff_security_guard':
        return MaterialPageRoute(
            builder: (_) =>  SecurityGuardDashboard());
      default:
        return null;
    }
  }

  void _showSnackBar(String message, IconData icon, Color color) {
    snackBar(context, message, icon, color);
  }

  @override
  Widget build(BuildContext context) {
    final defaultPinTheme = PinTheme(
        width: 70.w,
        height: 60.h,
        textStyle:  TextStyle(
            fontSize: 22, color: AppTheme.primaryColor, fontWeight: FontWeight.bold),
        decoration: BoxDecoration(
            color: AppTheme.white,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: AppTheme.primaryColor)));

    return BlocListener<VerifyOtpCubit, VerifyOtpState>(
      listener: _handleStateChanges,
      child: Scaffold(
        body: Stack(
          alignment: Alignment.topCenter,
          children: [
            Image.asset(ImageAssets.loginImage,
                height: size.height * 0.5,
                width: size.width,
                fit: BoxFit.cover),
            _buildOtpInputSection(defaultPinTheme),
          ],
        ),
      ),
    );
  }

  Widget _buildOtpInputSection(PinTheme defaultPinTheme) {
    return Column(
      children: [
        const Spacer(flex: 5),
        Expanded(
          flex: 6,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildTitle(),
            SizedBox(height: size.height*0.03),
              _buildOtpField(defaultPinTheme),
              SizedBox(height: size.height*0.02),
              _buildLoginButton(),
              const Spacer(),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTitle() {
    return Column(
      children: [
        SizedBox(height: 50.h),
        Text(
          "Enter Your OTP",
          style: GoogleFonts.cormorant(
            color: Colors.black,
            fontSize: 24.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 10.h),
        Text(
          "We've sent an OTP to +91 ${widget.phoneNumber}",
          textAlign: TextAlign.center,
          style: GoogleFonts.nunitoSans(
            color: Colors.black,
            fontSize: 15.sp,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildLoginButton() {
    return GestureDetector(
      onTap: () async {
        FirebaseMessaging messaging = FirebaseMessaging.instance;

        // Push Notification की परमिशन पहले लें
        await messaging.requestPermission(
            alert: true, badge: true, sound: true);

        String? token;

        if (Platform.isIOS) {
          // iOS के लिए APNS Token प्राप्त करें
          token = await messaging.getAPNSToken();
          print("APNS Token: $token");
        } else {
          // Android के लिए FCM Token प्राप्त करें
          token = await messaging.getToken();
          print("FCM Token: $token");
        }
        // print("------------$token");
        if (_otpController.text.isNotEmpty && _otpController.text.length == 4) {
          context.read<VerifyOtpCubit>().verifyOtp(
              widget.phoneNumber, _otpController.text, token ?? "rrr");
        }
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30,vertical: 15),
        child: Container(
          width: double.infinity,
          height: 52.h,
          decoration: BoxDecoration(
              color: AppTheme.primaryColor,
              borderRadius: BorderRadius.circular(30)),
          child: Center(
            child: Text(
              'Log In',
              style: GoogleFonts.nunitoSans(
                textStyle: TextStyle(
                  color: Colors.white,
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildOtpField(PinTheme defaultPinTheme) {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Enter Otp',
            style: GoogleFonts.nunitoSans(
              textStyle: TextStyle(
                color: Colors.black,
                fontSize: 14.sp,
                fontWeight: FontWeight.w500

            ))
          ),
          SizedBox(height: 10),
          Pinput(
            controller: _otpController,
            defaultPinTheme: defaultPinTheme,
            separatorBuilder: (_) => const SizedBox(width: 20),
            hapticFeedbackType: HapticFeedbackType.lightImpact,
            onCompleted: (pin) async {
              FirebaseMessaging messaging = FirebaseMessaging.instance;

              // Push Notification की परमिशन पहले लें
              await messaging.requestPermission(
                alert: true,
                badge: true,
                sound: true,
              );

              String? token;

              if (Platform.isIOS) {
                // iOS के लिए APNS Token प्राप्त करें
                token = await messaging.getAPNSToken();
                print("APNS Token: $token");
              } else {
                // Android के लिए FCM Token प्राप्त करें
                token = await messaging.getToken();
                print("FCM Token: $token");
              }

              // अगर कोई टोकन null आ रहा है, तो इसे Default Empty String से हैंडल करें
              context
                  .read<VerifyOtpCubit>()
                  .verifyOtp(widget.phoneNumber, pin, token ?? "rees");

              print('Token Sent: $token');
            },
            cursor: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Container(
                  margin: const EdgeInsets.only(bottom: 9),
                  width: 22,
                  height: 1,
                  color: AppTheme.primaryColor,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}