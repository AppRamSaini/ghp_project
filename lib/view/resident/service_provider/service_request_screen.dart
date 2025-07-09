import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ghp_society_management/constants/app_theme.dart';
import 'package:ghp_society_management/constants/dialog.dart';
import 'package:ghp_society_management/constants/snack_bar.dart';
import 'package:ghp_society_management/controller/request_call_back/request_call_back_cubit.dart';
import 'package:ghp_society_management/view/session_dialogue.dart';
import 'package:google_fonts/google_fonts.dart';

class ServiceRequestScreen extends StatefulWidget {
  final String categoryId;
  final String serviceProviderUserId;

  const ServiceRequestScreen(
      {super.key,
      required this.categoryId,
      required this.serviceProviderUserId});

  @override
  State<ServiceRequestScreen> createState() => _ServiceRequestScreenState();
}

class _ServiceRequestScreenState extends State<ServiceRequestScreen> {
  final formkey = GlobalKey<FormState>();
  final TextEditingController faltNumber = TextEditingController();
  final TextEditingController description = TextEditingController();
  late BuildContext dialogueContext;
  @override
  Widget build(BuildContext context) {
    return BlocListener<RequestCallBackCubit, RequestCallBackState>(
      listener: (context, state) {
        if (state is RequestCallBackLoading) {
          showLoadingDialog(context, (ctx) {
            dialogueContext = ctx;
          });
        } else if (state is RequestCallBacksuccessfully) {
          snackBar(context, 'Visitor created successfully', Icons.done,
              AppTheme.guestColor);
          Navigator.of(dialogueContext).pop();
          Navigator.of(context).pop();
        } else if (state is RequestCallBackFailed) {
          snackBar(context, 'Failed to create visitor', Icons.warning,
              AppTheme.redColor);
          Navigator.of(dialogueContext).pop();
        } else if (state is RequestCallBackInternetError) {
          snackBar(context, 'Internet connection failed', Icons.wifi_off,
              AppTheme.redColor);
          Navigator.of(dialogueContext).pop();
        } else if (state is RequestCallBackLogout) {
          Navigator.of(dialogueContext).pop();
          sessionExpiredDialog(context);
        }
      },
      child: Scaffold(
        backgroundColor: AppTheme.backgroundColor,
        bottomNavigationBar: Container(
          color: Colors.white,
          child: GestureDetector(
            onTap: () {
              if (formkey.currentState!.validate()) {
                var requestBody = {
                  "service_category_id": widget.categoryId,
                  "service_provider_user_id": widget.serviceProviderUserId,
                  "aprt_no": faltNumber.text,
                  "description": description.text
                };
                context
                    .read<RequestCallBackCubit>()
                    .requestCallBack(requestBody);
              }
            },
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Container(
                width: double.infinity,
                height: 50.h,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    color: AppTheme.primaryColor),
                child: Center(
                  child: Text('Request Callback',
                      style:GoogleFonts.nunitoSans(
                        textStyle: TextStyle(
                          color: Colors.white,
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w500,
                        ),
                      )),
                ),
              ),
            ),
          ),
        ),
        body: SafeArea(
          child: Form(
            key: formkey,
            child: Column(
              children: [
                SizedBox(height: 20.h),
                Row(
                  children: [
                    SizedBox(width: 10.w),
                    GestureDetector(
                      onTap: () {
                        Navigator.of(context).pop();
                      },
                      child: const Icon(
                        Icons.arrow_back,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(
                      width: 10.w,
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Request for Callback',
                              style:GoogleFonts.nunitoSans(
                                textStyle: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20.sp,
                                  fontWeight: FontWeight.w600,
                                ),
                              )),
                        ],
                      ),
                    ),
                    SizedBox(width: 10.w),
                  ],
                ),
                SizedBox(height: 20.h),
                Expanded(
                  child: Container(
                      width: double.infinity,
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(20),
                          topRight: Radius.circular(20),
                        ),
                      ),
                      child: SingleChildScrollView(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                height: 10.h,
                              ),
                              Text('Flat Number ',
                                  style:GoogleFonts.nunitoSans(
                                    textStyle: TextStyle(
                                      color: Colors.black,
                                      fontSize: 15.sp,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  )),
                              SizedBox(
                                height: 10.h,
                              ),
                              SizedBox(
                                width: MediaQuery.of(context).size.width,
                                child: TextFormField(
                                  controller: faltNumber,
                                  style:GoogleFonts.nunitoSans(
                                    color: Colors.black,
                                    fontSize: 15.sp,
                                    fontWeight: FontWeight.w500,
                                  ),
                                  keyboardType: TextInputType.text,
                                  validator: (text) {
                                    if (text == null || text.isEmpty) {
                                      return 'Please enter flat number';
                                    }
                                    return null;
                                  },
                                  decoration: InputDecoration(
                                    isDense: true,
                                    filled: true,
                                    hintText: "Eg.  A-101",
                                    hintStyle: TextStyle(
                                        color: Colors.grey,
                                        fontSize: 14.sp,
                                        fontWeight: FontWeight.w400),
                                    fillColor: AppTheme.greyColor,
                                    errorBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(15.0),
                                      borderSide: BorderSide(
                                        color: AppTheme.greyColor,
                                      ),
                                    ),
                                    focusedErrorBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(15.0),
                                      borderSide: BorderSide(
                                        color: AppTheme.greyColor,
                                      ),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(15.0),
                                      borderSide: BorderSide(
                                        color: AppTheme.greyColor,
                                      ),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(15.0),
                                      borderSide: BorderSide(
                                        color: AppTheme.greyColor,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 10.h,
                              ),
                              Text('Description',
                                  style:GoogleFonts.nunitoSans(
                                    textStyle: TextStyle(
                                      color: Colors.black,
                                      fontSize: 15.sp,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  )),
                              SizedBox(
                                height: 10.h,
                              ),
                              SizedBox(
                                width: MediaQuery.of(context).size.width,
                                child: TextFormField(
                                  controller: description,
                                  maxLines: 5,
                                  style:GoogleFonts.nunitoSans(
                                    color: Colors.black,
                                    fontSize: 15.sp,
                                    fontWeight: FontWeight.w500,
                                  ),
                                  keyboardType: TextInputType.text,
                                  validator: (text) {
                                    if (text == null || text.isEmpty) {
                                      return 'Please enter description';
                                    }
                                    return null;
                                  },
                                  decoration: InputDecoration(
                                    hintText: 'Enter description here...',
                                    filled: true,
                                    hintStyle: TextStyle(
                                        color: Colors.grey,
                                        fontSize: 14.sp,
                                        fontWeight: FontWeight.w400),
                                    fillColor: AppTheme.greyColor,
                                    errorBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(15.0),
                                      borderSide: BorderSide(
                                        color: AppTheme.greyColor,
                                      ),
                                    ),
                                    focusedErrorBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(15.0),
                                      borderSide: BorderSide(
                                        color: AppTheme.greyColor,
                                      ),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(15.0),
                                      borderSide: BorderSide(
                                        color: AppTheme.greyColor,
                                      ),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(15.0),
                                      borderSide: BorderSide(
                                        color: AppTheme.greyColor,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 10.h,
                              ),
                            ],
                          ),
                        ),
                      )),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
