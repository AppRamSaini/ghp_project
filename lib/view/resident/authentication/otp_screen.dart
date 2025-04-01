// import 'package:firebase_messaging/firebase_messaging.dart';
import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ghp_app/constants/app_images.dart';
import 'package:ghp_app/constants/app_theme.dart';
import 'package:ghp_app/constants/dialog.dart';
import 'package:ghp_app/constants/snack_bar.dart';
import 'package:ghp_app/controller/verify_otp/verify_otp_cubit.dart';
import 'package:ghp_app/view/dashboard/bottom_nav_screen.dart';
import 'package:ghp_app/view/security_staff/dashboard/bottom_navigation.dart';
import 'package:ghp_app/view/staff/bottom_nav_screen.dart';
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
            builder: (_) => const SecurityGuardDashboard());
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
        width: 100.w,
        height: 60.h,
        textStyle: const TextStyle(
            fontSize: 22, color: Colors.white, fontWeight: FontWeight.bold),
        decoration: BoxDecoration(
            color: AppTheme.primaryLiteColor,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: AppTheme.remainingColor)));

    return BlocListener<VerifyOtpCubit, VerifyOtpState>(
      listener: _handleStateChanges,
      child: Scaffold(
        backgroundColor: AppTheme.primaryColor,
        body: Stack(
          alignment: Alignment.topCenter,
          children: [
            Image.asset(ImageAssets.loginImage, height: 400.h),
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
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            width: double.infinity,
            decoration: BoxDecoration(
                color: Colors.black,
                borderRadius:
                    BorderRadius.vertical(top: Radius.circular(20.r))),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildTitle(),
                const Spacer(),
                _buildOtpField(defaultPinTheme),
                const Spacer(flex: 2),
                _buildLoginButton(),
                const Spacer(),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTitle() {
    return Column(
      children: [
        SizedBox(height: 20.h),
        Text(
          "Enter Your OTP",
          style: GoogleFonts.nunitoSans(
            color: Colors.white,
            fontSize: 24.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 10.h),
        Text(
          "OTP is sent to your number \n+91-${widget.phoneNumber}",
          textAlign: TextAlign.center,
          style: GoogleFonts.nunitoSans(
            color: Colors.white,
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
        padding: const EdgeInsets.all(12.0),
        child: Container(
          width: double.infinity,
          height: 50.h,
          decoration: BoxDecoration(
              color: AppTheme.primaryColor,
              borderRadius: BorderRadius.circular(30)),
          child: Center(
            child: Text(
              'Login',
              style: GoogleFonts.nunitoSans(
                textStyle: TextStyle(
                  color: Colors.white,
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w500,
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
      child: Pinput(
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
              color: AppTheme.redColor,
            ),
          ],
        ),
      ),
    );
  }
}
