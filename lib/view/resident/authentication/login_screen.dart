import 'package:flutter/gestures.dart';
import 'package:ghp_society_management/constants/dialog.dart';
import 'package:ghp_society_management/constants/export.dart';
import 'package:ghp_society_management/main.dart';
import 'package:ghp_society_management/view/resident/authentication/otp_screen.dart';
import 'package:ghp_society_management/view/resident/setting/log_out_dialog.dart';

class LoginScreen extends StatefulWidget {
  final String societyId;

  const LoginScreen({super.key, required this.societyId});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController phoneNumber = TextEditingController();
  final formkey = GlobalKey<FormState>();
  bool checked = false;
  late BuildContext dialogueContext;

  @override
  Widget build(BuildContext context) {
    return BlocListener<SendOtpCubit, SendOtpState>(
      listener: (context, state) async {
        if (state is SendOtpLoading) {
          showLoadingDialog(context, (ctx) {
            dialogueContext = ctx;
          });
        } else if (state is SendOtpSuccessfully) {
          snackBar(context, 'OTP sent successfully', Icons.done,
              AppTheme.guestColor);
          Navigator.of(dialogueContext).pop();
          Navigator.of(context).push(MaterialPageRoute(
              builder: (builder) => OtpScreen(phoneNumber: phoneNumber.text)));
        } else if (state is SendOtpFailed) {
          snackBar(
              context, state.errorMessage, Icons.warning, AppTheme.redColor);
          Navigator.of(dialogueContext).pop();
        } else if (state is SendOtpInternetError) {
          snackBar(context, 'Internet connection failed', Icons.wifi_off,
              AppTheme.redColor);

          Navigator.of(dialogueContext).pop();
        }
      },
      child: Scaffold(
        body: SingleChildScrollView(
          child: Form(
            key: formkey,
            child: Column(
              children: [
                Stack(
                  children: [
                    Image.asset(ImageAssets.loginImage,
                        height: size.height * 0.5,
                        width: size.width,
                        fit: BoxFit.cover),
                    Positioned(
                      top: 60,
                      left: 20,
                      child: GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: CircleAvatar(
                          child: Icon(Icons.arrow_back_ios_new_outlined),
                        ),
                      ),
                    )
                  ],
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: size.width * 0.035),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(height: 20.h),
                      RichText(
                        textAlign: TextAlign.start,
                        text: TextSpan(
                          style: GoogleFonts.cormorant(
                              color: Colors.black,
                              fontSize: 28.sp,
                              fontWeight: FontWeight.w500),
                          children: [
                            TextSpan(
                                text: "Log in to ",
                                style: GoogleFonts.cormorant(
                                    color: Colors.black,
                                    fontSize: 28.sp,
                                    fontWeight: FontWeight.w500)),
                            TextSpan(
                                text: "your account ",
                                style: TextStyle(color: AppTheme.primaryColor)),
                          ],
                        ),
                      ),
                      SizedBox(height: 5.h),
                      Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text("Enter the Phone Number",
                              style: GoogleFonts.nunitoSans(
                                  color: Colors.black,
                                  fontSize: 15.sp,
                                  fontWeight: FontWeight.w500))),
                      SizedBox(height: 20.h),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text("Your Number",
                            style: GoogleFonts.nunitoSans(
                                color: Colors.black,
                                fontSize: 15.sp,
                                fontWeight: FontWeight.w500)),
                      ),
                      Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: SizedBox(
                              width: MediaQuery.of(context).size.width,
                              child: TextFormField(
                                  style: GoogleFonts.nunitoSans(
                                      color: AppTheme.backgroundColor,
                                      fontSize: 15.sp,
                                      fontWeight: FontWeight.w500),
                                  inputFormatters: [
                                    LengthLimitingTextInputFormatter(10),
                                    FilteringTextInputFormatter.digitsOnly
                                  ],
                                  controller: phoneNumber,
                                  keyboardType: TextInputType.number,
                                  validator: (text) {
                                    if (text == null || text.isEmpty) {
                                      return 'Please enter mobile number';
                                    } else if (text.length < 10 ||
                                        text.length > 10) {
                                      return 'Phone number length must be 10';
                                    }
                                    return null;
                                  },
                                  onChanged: (v) {
                                    if (v.length > 9) {
                                      FocusScope.of(context).unfocus();
                                    }
                                  },
                                  decoration: InputDecoration(
                                      filled: true,
                                      hintText: "1234-XXXXXX",
                                      hintStyle: TextStyle(
                                          color: Colors.grey,
                                          fontSize: 14.sp,
                                          fontWeight: FontWeight.w400),
                                      fillColor: Colors.white10,
                                      errorBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(12.0),
                                          borderSide: BorderSide(
                                              color: AppTheme.primaryColor)),
                                      focusedErrorBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(12.0),
                                          borderSide: BorderSide(
                                              color: AppTheme.primaryColor)),
                                      focusedBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(12.0),
                                          borderSide: BorderSide(
                                              color: AppTheme.primaryColor)),
                                      enabledBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(12.0),
                                          borderSide: BorderSide(
                                              color:
                                                  AppTheme.primaryColor)))))),
                      SizedBox(height: 10.h),
                      Theme(
                        data: Theme.of(context).copyWith(
                          checkboxTheme: CheckboxThemeData(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(2),
                              side:
                                  const BorderSide(color: Colors.red, width: 1),
                            ),
                          ),
                        ),
                        child: CheckboxListTile(
                          contentPadding: EdgeInsets.zero,
                          title: RichText(
                            textAlign: TextAlign.start,
                            text: TextSpan(
                              style: const TextStyle(
                                  color: Colors.black, fontSize: 14),
                              children: [
                                TextSpan(
                                    text: "I agree to your ",
                                    style: GoogleFonts.nunitoSans(
                                        color: Colors.black)),
                                TextSpan(
                                    text: "Privacy Policy  ",
                                    style: TextStyle(
                                        color: AppTheme.primaryColor,
                                        decoration: TextDecoration.underline),
                                    recognizer: TapGestureRecognizer()
                                      ..onTap = () {
                                        FocusScope.of(context).unfocus();
                                        privacyPolicyDialog(context, (value) {
                                          setState(() {
                                            checked = value;
                                          });
                                        });
                                      }),
                                TextSpan(
                                    text: "and",
                                    style: GoogleFonts.nunitoSans(
                                        color: Colors.black)),
                                TextSpan(
                                  text: "  Terms & Conditions",
                                  style: TextStyle(
                                      color: AppTheme.primaryColor,
                                      decoration: TextDecoration.underline),
                                  recognizer: TapGestureRecognizer()
                                    ..onTap = () {
                                      privacyPolicyDialog(context, (value) {
                                        setState(() {
                                          checked = value;
                                        });
                                      });
                                    },
                                ),
                              ],
                            ),
                          ),
                          value: checked,
                          onChanged: (newValue) {
                            setState(() {
                              checked = newValue!;
                            });
                          },
                          controlAffinity: ListTileControlAffinity.leading,
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          FocusScope.of(context).unfocus();
                          if (formkey.currentState!.validate() && checked) {
                            context
                                .read<SendOtpCubit>()
                                .sendOtp(phoneNumber.text, widget.societyId);
                          } else if (checked == false) {
                            snackBar(
                                context,
                                'Please confirm the Terms & conditions',
                                Icons.warning,
                                AppTheme.redColor);
                          }
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Container(
                            width: double.infinity,
                            height: 50,
                            decoration: BoxDecoration(
                                color: AppTheme.primaryColor,
                                borderRadius: BorderRadius.circular(30)),
                            child: Center(
                              child: Text(
                                'Send OTP',
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
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
