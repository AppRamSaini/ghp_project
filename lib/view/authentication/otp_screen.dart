import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ghp_society_management/constants/app_images.dart';
import 'package:ghp_society_management/constants/app_theme.dart';
import 'package:ghp_society_management/constants/custom_btns.dart';
import 'package:ghp_society_management/constants/dialog.dart';
import 'package:ghp_society_management/constants/snack_bar.dart';
import 'package:ghp_society_management/controller/verify_otp/verify_otp_cubit.dart';
import 'package:ghp_society_management/main.dart';
import 'package:ghp_society_management/view/dashboard/bottom_nav_screen.dart';
import 'package:ghp_society_management/view/maintenance_staff//bottom_nav_screen.dart';
import 'package:ghp_society_management/view/security_staff/dashboard/bottom_navigation.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pinput/pinput.dart';
import 'package:sms_autofill/sms_autofill.dart'; // NEW

class OtpScreen extends StatefulWidget {
  final String phoneNumber;

  const OtpScreen({super.key, required this.phoneNumber});

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> with CodeAutoFill {
  final TextEditingController _otpController = TextEditingController();
  late BuildContext _dialogueContext;

  @override
  void initState() {
    super.initState();
    _listenForOtp();
  }

  void _listenForOtp() async {
    await SmsAutoFill().listenForCode();
    listenForCode(); // For CodeAutoFill mixin
  }

  @override
  void codeUpdated() {
    setState(() {
      _otpController.text = code ?? '';
    });

    if ((code ?? '').length == 4) {
      _submitOtp(code!);
    }
  }

  @override
  void dispose() {
    cancel();
    _otpController.dispose();
    super.dispose();
  }

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
        return MaterialPageRoute(builder: (_) => SecurityGuardDashboard());
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
        width: 60,
        height: 60,
        textStyle: TextStyle(
            fontSize: 22,
            color: AppTheme.primaryColor,
            fontWeight: FontWeight.bold),
        decoration: BoxDecoration(
            color: AppTheme.white,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: AppTheme.primaryColor)));

    return BlocListener<VerifyOtpCubit, VerifyOtpState>(
      listener: _handleStateChanges,
      child: Scaffold(
        body: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: GestureDetector(
                onTap: () => FocusScope.of(context).unfocus(),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Stack(
                        children: [
                          Image.asset(ImageAssets.loginImage,
                              height: size.height * 0.5,
                              width: size.width,
                              fit: BoxFit.cover),
                          Padding(
                            padding: EdgeInsets.only(
                                top: size.height * 0.05,
                                left: size.width * 0.035),
                            child: GestureDetector(
                                onTap: () => Navigator.pop(context),
                                child: const CircleAvatar(
                                  child: Icon(Icons.arrow_back_ios_outlined),
                                )),
                          )
                        ],
                      ),
                      _buildTitle(),
                      SizedBox(height: size.height * 0.03),
                      _buildOtpField(defaultPinTheme),
                    ],
                  ),
                ),
              ),
            ),
            _buildLoginButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildTitle() {
    return Column(
      children: [
        SizedBox(height: 20.h),
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
    return customBtn(
      onTap: () async {
        if (_otpController.text.isNotEmpty && _otpController.text.length == 4) {
          _submitOtp(_otpController.text);
        }
      },
      txt: "Log In",
    );
  }

  void _submitOtp(String otp) async {
    FirebaseMessaging messaging = FirebaseMessaging.instance;
    await messaging.requestPermission(alert: true, badge: true, sound: true);

    String? token;
    if (Platform.isIOS) {
      token = await messaging.getAPNSToken();
    } else {
      token = await messaging.getToken();
    }

    context
        .read<VerifyOtpCubit>()
        .verifyOtp(widget.phoneNumber, otp, token ?? "");
  }

  Widget _buildOtpField(PinTheme defaultPinTheme) {
    return Pinput(
      controller: _otpController,
      defaultPinTheme: defaultPinTheme,
      separatorBuilder: (_) => const SizedBox(width: 20),
      length: 4,
      keyboardType: TextInputType.number,
      onCompleted: (pin) => _submitOtp(pin),
      cursor: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Container(
            margin: const EdgeInsets.only(bottom: 9),
            width: 25,
            height: 2,
            color: AppTheme.primaryColor,
          ),
        ],
      ),
    );
  }
}
