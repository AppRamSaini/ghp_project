import 'package:flutter/gestures.dart';
import 'package:ghp_society_management/constants/custom_btns.dart';
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
  final formKey = GlobalKey<FormState>();
  bool checked = false;
  late BuildContext dialogueContext;

  @override
  Widget build(BuildContext context) {
    return BlocListener<SendOtpCubit, SendOtpState>(
      listener: handleOtpState,
      child: Scaffold(
        body: Column(
          children: [
             Expanded(child:GestureDetector(onTap: ()=>    FocusScope.of(context).unfocus(),

                 child: buildForm(context))),
            buildBottomButton(context),
          ],
        ),
      ),
    );
  }

  /// --- BlocListener Logic
  void handleOtpState(BuildContext context, SendOtpState state) {
    if (state is SendOtpLoading) {
      showLoadingDialog(context, (ctx) {
        dialogueContext = ctx;
      });
    } else {
      Navigator.of(dialogueContext).pop();
      if (state is SendOtpSuccessfully) {
        snackBar(
            context, 'OTP sent successfully', Icons.done, AppTheme.guestColor);
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (_) => OtpScreen(phoneNumber: phoneNumber.text)));
      } else if (state is SendOtpFailed) {
        snackBar(context, state.errorMessage, Icons.warning, AppTheme.redColor);
      } else if (state is SendOtpInternetError) {
        snackBar(context, 'Internet connection failed', Icons.wifi_off,
            AppTheme.redColor);
      }
    }
  }

  /// --- Body Section
  Widget buildForm(BuildContext context) {
    return SingleChildScrollView(
      child: Form(
        key: formKey,
        child: Column(
          children: [
            buildHeaderImage(),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: size.width * 0.035),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  20.verticalSpace,
                  buildTitleText(),
                  5.verticalSpace,
                  buildSubtitleText(),
                  20.verticalSpace,
                  buildLabel("Your Number"),
                  5.verticalSpace,
                  buildPhoneInput(),
                  10.verticalSpace,
                  buildPolicyCheckbox(),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  /// --- Header Section
  Widget buildHeaderImage() {
    return Stack(
      children: [
        Image.asset(ImageAssets.loginImage,
            height: size.height * 0.5, width: size.width, fit: BoxFit.cover),
        Positioned(
          top: 60,
          left: 20,
          child: GestureDetector(
            onTap: () => Navigator.pop(context),
            child: const CircleAvatar(
              child: Icon(Icons.arrow_back_ios_new_outlined),
            ),
          ),
        ),
      ],
    );
  }

  /// --- Text Widgets
  Widget buildTitleText() => RichText(
        textAlign: TextAlign.start,
        text: TextSpan(
          style: GoogleFonts.cormorant(
              color: Colors.black,
              fontSize: 28.sp,
              fontWeight: FontWeight.w500),
          children: [
            const TextSpan(text: "Log in to "),
            TextSpan(
              text: "your account ",
              style: TextStyle(color: AppTheme.primaryColor),
            ),
          ],
        ),
      );

  Widget buildSubtitleText() => Text(
        "Enter the Phone Number",
        style: GoogleFonts.nunitoSans(
            color: Colors.black, fontSize: 15.sp, fontWeight: FontWeight.w500),
      );

  Widget buildLabel(String text) => Align(
        alignment: Alignment.centerLeft,
        child: Text(
          text,
          style: GoogleFonts.nunitoSans(
              color: Colors.black,
              fontSize: 15.sp,
              fontWeight: FontWeight.w500),
        ),
      );

  /// --- Input Field
  Widget buildPhoneInput() => TextFormField(
        style: GoogleFonts.nunitoSans(
            color: AppTheme.backgroundColor,
            fontSize: 15.sp,
            fontWeight: FontWeight.w500),
        inputFormatters: [
          LengthLimitingTextInputFormatter(10),
          FilteringTextInputFormatter.digitsOnly,
        ],
        keyboardType: TextInputType.number,
        controller: phoneNumber,
        validator: validatePhone,
        onChanged: (v) {
          if (v.length > 9) FocusScope.of(context).unfocus();
        },
        decoration: InputDecoration(
          filled: true,
          hintText: "1234-XXXXXX",
          hintStyle: TextStyle(color: Colors.grey, fontSize: 14.sp),
          fillColor: Colors.white10,
          border: outlineBorder(),
          enabledBorder: outlineBorder(),
          focusedBorder: outlineBorder(),
          errorBorder: outlineBorder(),
          focusedErrorBorder: outlineBorder(),
        ),
      );

  OutlineInputBorder outlineBorder() => OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: AppTheme.primaryColor),
      );

  String? validatePhone(String? text) {
    if (text == null || text.isEmpty) return 'Please enter mobile number';
    if (text.length != 10) return 'Phone number must be 10 digits';
    return null;
  }

  /// --- Checkbox
  Widget buildPolicyCheckbox() => Theme(
        data: Theme.of(context).copyWith(
          checkboxTheme: CheckboxThemeData(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(2)),
          ),
        ),
        child: CheckboxListTile(
          contentPadding: EdgeInsets.zero,
          title: RichText(
            text: TextSpan(
              style: TextStyle(color: Colors.black, fontSize: 14),
              children: [
                const TextSpan(text: "I agree to your "),
                TextSpan(
                  text: "Privacy Policy  ",
                  style: TextStyle(
                      color: AppTheme.primaryColor,
                      decoration: TextDecoration.underline),
                  recognizer: TapGestureRecognizer()
                    ..onTap = () => privacyPolicyDialog(context, (value) {
                          setState(() => checked = value);
                        }),
                ),
                const TextSpan(text: "and "),
                TextSpan(
                  text: "Terms & Conditions",
                  style: TextStyle(
                      color: AppTheme.primaryColor,
                      decoration: TextDecoration.underline),
                  recognizer: TapGestureRecognizer()
                    ..onTap = () => privacyPolicyDialog(context, (value) {
                          setState(() => checked = value);
                        }),
                ),
              ],
            ),
          ),
          value: checked,
          onChanged: (val) => setState(() => checked = val ?? false),
          controlAffinity: ListTileControlAffinity.leading,
        ),
      );

  /// --- Bottom Send OTP Button
  Widget buildBottomButton(BuildContext context) => customBtn(
    onTap: () {
      FocusScope.of(context).unfocus();
      if (formKey.currentState!.validate() && checked) {
        context
            .read<SendOtpCubit>()
            .sendOtp(phoneNumber.text, widget.societyId);
      } else if (!checked) {
        snackBar(context, 'Please confirm the Terms & conditions',
            Icons.warning, AppTheme.redColor);
      }
    },
    txt: "Send OTP",
  );
}
