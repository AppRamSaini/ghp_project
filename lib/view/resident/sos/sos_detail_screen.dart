import 'dart:async';

import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:geolocator/geolocator.dart';
import 'package:ghp_society_management/constants/app_theme.dart';
import 'package:ghp_society_management/constants/dialog.dart';
import 'package:ghp_society_management/constants/snack_bar.dart';
import 'package:ghp_society_management/controller/society_contacts/society_contacts_cubit.dart';
import 'package:ghp_society_management/controller/sos_management/sos_cancel/sos_cancel_cubit.dart';
import 'package:ghp_society_management/controller/sos_management/sos_element/sos_element_cubit.dart';
import 'package:ghp_society_management/controller/sos_management/submit_sos/submit_sos_cubit.dart';
import 'package:ghp_society_management/model/sos_category_model.dart';
import 'package:ghp_society_management/view/resident/sos/sos_timer_countdown.dart';
import 'package:ghp_society_management/view/session_dialogue.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:share_plus/share_plus.dart';

class SosDetailScreen extends StatefulWidget {
  bool forStaffSide;
  final SosCategory sosCategory;

  SosDetailScreen(
      {super.key, required this.sosCategory, this.forStaffSide = false});

  @override
  State<SosDetailScreen> createState() => _SosDetailScreenState();
}

class _SosDetailScreenState extends State<SosDetailScreen> {
  String? selectedValue;
  String? sosReasonDes;
  final formkey = GlobalKey<FormState>();
  final TextEditingController descriptionController = TextEditingController();
  late BuildContext dialogueContext;
  String location = "";
  late SosElementCubit _sosElementCubit;

  @override
  void initState() {
    context.read<SocietyContactsCubit>().fetchSocietyContacts();
    _sosElementCubit = SosElementCubit();
    _sosElementCubit.fetchSosElement();
    super.initState();
  }

  Timer? countdownTimer;
  late BuildContext timerContext;

  void _startCountdownAndCloseDialog(String sosId) {
    const totalTime = 30;
    sosTimerCountdownDialog(
      context: context,
      setDialogueContext: (ctx) {
        timerContext = ctx;
      },
      onComplete: () {
        stopTimerDialog();
        Future.delayed(const Duration(milliseconds: 10), () {
          Navigator.pop(context);
          Navigator.pop(context);
        });
      },
      onChange: (time) {},
      onTap: () {
        Map<String, String?> sosBody = {"sos_id": sosId};
        context.read<SosCancelCubit>().sosCancelApi(sosBody);
      },
    );

    countdownTimer = Timer(const Duration(seconds: totalTime), () {
      stopTimerDialog();
    });
  }

  void stopTimerDialog() {
    countdownTimer?.cancel();
    Future.delayed(const Duration(milliseconds: 10), () {
      Navigator.pop(timerContext);
    });
  }

  @override
  Widget build(BuildContext context) {
    List actionsList = widget.sosCategory.emergencyDetails!.actions;
    List contactList = widget.sosCategory.emergencyDetails!.contacts;

    return MultiBlocListener(
      listeners: [
        BlocListener<SubmitSosCubit, SubmitSosState>(
          listener: (context, state) async {
            if (state is SubmitSosLoading) {
              showLoadingDialog(context, (ctx) {
                dialogueContext = ctx;
              });
            } else if (state is SubmitSosSuccessfully) {
              snackBar(context, state.successMsg.toString(), Icons.done,
                  AppTheme.guestColor);
              Navigator.of(dialogueContext).pop();
              _startCountdownAndCloseDialog(state.sosId.toString());
            } else if (state is SubmitSosFailed) {
              snackBar(context, state.errorMsg.toString(), Icons.warning,
                  AppTheme.redColor);
              Navigator.of(dialogueContext).pop();
            } else if (state is SubmitSosInternetError) {
              snackBar(context, 'Internet connection failed', Icons.wifi_off,
                  AppTheme.redColor);
              Navigator.of(dialogueContext).pop();
            } else if (state is SubmitSosLogout) {
              Navigator.of(dialogueContext).pop();
              sessionExpiredDialog(context);
            }
          },
        ),
        BlocListener<SosCancelCubit, SosCancelState>(
          listener: (context, state) async {
            if (state is SosCancelLoading) {
              showLoadingDialog(context, (ctx) {
                dialogueContext = ctx;
              });
            } else if (state is SosCancelSuccessfully) {
              snackBar(context, state.successMsg.toString(), Icons.done,
                  AppTheme.guestColor);
              stopTimerDialog();
              Future.delayed(const Duration(milliseconds: 10), () {
                Navigator.pop(dialogueContext);
                Navigator.of(context).pop();
              });
            } else if (state is SosCancelFailed) {
              snackBar(context, state.errorMsg.toString(), Icons.warning,
                  AppTheme.redColor);
              Navigator.of(dialogueContext).pop();
            } else if (state is SosCancelInternetError) {
              snackBar(context, 'Internet connection failed', Icons.wifi_off,
                  AppTheme.redColor);
              Navigator.of(dialogueContext).pop();
            } else if (state is SosCancelLogout) {
              Navigator.of(dialogueContext).pop();
              sessionExpiredDialog(context);
            }
          },
        )
      ],
      child: Scaffold(
        appBar: appbarWidget(title: 'Request for Callback'),
        bottomNavigationBar: widget.forStaffSide
            ? SizedBox()
            : Padding(
                padding: globalBottomPadding(context),
                child: Container(
                  color: Colors.white,
                  child: GestureDetector(
                    onTap: () {
                      if (formkey.currentState!.validate()) {
                        Map<String, String?> sosBody = {
                          "sos_category_id": widget.sosCategory.id.toString(),
                          "area": selectedValue,
                          "description": descriptionController.text
                        };

                        print(selectedValue);
                        if (selectedValue == null) {
                          snackBar(context, 'Please select area', Icons.warning,
                              AppTheme.redColor);
                        } else {
                          context.read<SubmitSosCubit>().submitSos(sosBody);
                        }
                      }
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Container(
                        width: double.infinity,
                        height: 50,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(30),
                            color: AppTheme.primaryColor),
                        child: Center(
                          child: Text('Submit ',
                              style: GoogleFonts.nunitoSans(
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
              ),
        body: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: Form(
            key: formkey,
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 10.h),
                    Text('Immediate Actions :',
                        style: GoogleFonts.nunitoSans(
                            textStyle: TextStyle(
                                color: Colors.black,
                                fontSize: 16.sp,
                                fontWeight: FontWeight.w600))),
                    SizedBox(height: 10.h),
                    actionsList.isEmpty
                        ? const Text("Actions :-  NOT DEFINE",
                            style: TextStyle(fontSize: 12))
                        : Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: List.generate(
                              actionsList.length,
                              (index) => Text(
                                  actionsList[index].name.toString(),
                                  style: GoogleFonts.nunitoSans(
                                      textStyle: TextStyle(
                                          color: Colors.red,
                                          fontSize: 12.sp,
                                          fontWeight: FontWeight.w500))),
                            )),
                    SizedBox(height: 10.h),
                    Text('Emergency Contacts :',
                        style: GoogleFonts.nunitoSans(
                            textStyle: TextStyle(
                                color: Colors.black,
                                fontSize: 16.sp,
                                fontWeight: FontWeight.w600))),
                    SizedBox(height: 10.h),
                    contactList.isEmpty
                        ? const Text("Emergency Contacts :-  NOT DEFINE",
                            style: TextStyle(fontSize: 12))
                        : Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: List.generate(
                              contactList.length,
                              (index) => Text(
                                  "${contactList[index].name.toString()}: ${contactList[index].phone.toString()}",
                                  style: GoogleFonts.nunitoSans(
                                      textStyle: TextStyle(
                                          color: Colors.deepPurpleAccent,
                                          fontSize: 12.sp,
                                          fontWeight: FontWeight.w500))),
                            )),
                    SizedBox(height: 10.h),
                    Text(
                        'Tap here to share your location with emergency responders',
                        style: GoogleFonts.nunitoSans(
                            textStyle: TextStyle(
                                color: Colors.black,
                                fontSize: 12.sp,
                                fontWeight: FontWeight.w500))),
                    GestureDetector(
                      onTap: () async {
                        showLoadingDialog(context, (ctx) {
                          dialogueContext = ctx;
                        });

                        LocationPermission permission =
                            await Geolocator.checkPermission();

                        if (permission == LocationPermission.denied) {
                          permission = await Geolocator.requestPermission();
                          Navigator.of(dialogueContext).pop();
                        }

                        if (permission == LocationPermission.deniedForever) {
                          // Navigator.of(dialogueContext).pop();
                          showDialog(
                            context: dialogueContext,
                            builder: (_) => AlertDialog(
                              title: Text(
                                "Permission Permanently Denied",
                                style: TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.bold),
                              ),
                              content: Text(
                                "Location permission has been permanently denied. Please go to settings and allow permission.",
                                style: TextStyle(fontSize: 12),
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.of(context).pop(),
                                  child: Text("Cancel"),
                                ),
                                TextButton(
                                  onPressed: () async {
                                    Navigator.pop(context);
                                    await Geolocator
                                        .openAppSettings(); // Then open settings
                                  },
                                  child: Text("Open Settings"),
                                ),
                              ],
                            ),
                          );

                          return;
                        }

                        // Now we have permission
                        Position position = await Geolocator.getCurrentPosition(
                            desiredAccuracy: LocationAccuracy.high);

                        setState(() {
                          location =
                              "Latitude: ${position.latitude}, Longitude: ${position.longitude}";
                          Navigator.of(dialogueContext).pop();
                        });

                        Share.shareUri(Uri.parse(
                            'https://www.google.com/maps/search/?api=1&query=${position.latitude},${position.longitude}'));
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Container(
                          width: double.infinity,
                          height: 50,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(30),
                              border: Border.all(color: AppTheme.redColor)),
                          child: Center(
                            child: Text('Share My Location ',
                                style: GoogleFonts.nunitoSans(
                                  textStyle: TextStyle(
                                    color: AppTheme.redColor,
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.w500,
                                  ),
                                )),
                          ),
                        ),
                      ),
                    ),
                    widget.forStaffSide
                        ? SizedBox()
                        : Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Divider(),
                              Text('Report Incident :',
                                  style: GoogleFonts.nunitoSans(
                                      textStyle: TextStyle(
                                          color: Colors.black,
                                          fontSize: 18.sp,
                                          fontWeight: FontWeight.w600))),
                              SizedBox(height: 10.h),
                              Text('Select Area',
                                  style: GoogleFonts.nunitoSans(
                                      textStyle: TextStyle(
                                          color: Colors.black,
                                          fontSize: 15.sp,
                                          fontWeight: FontWeight.w500))),
                              SizedBox(height: 10.h),
                              BlocBuilder<SosElementCubit, SosElementState>(
                                bloc: _sosElementCubit,
                                builder: (context, state) {
                                  if (state is SosElementLoaded) {
                                    return DropdownButton2<String>(
                                      hint: const Text('Select Area',
                                          style: TextStyle(
                                              color: Colors.grey,
                                              fontSize: 14)),
                                      underline:
                                          Container(color: Colors.transparent),
                                      isExpanded: true,
                                      value: selectedValue,
                                      items: state.sosElement.first.data.areas
                                          .map((item) =>
                                              DropdownMenuItem<String>(
                                                  value: item.name,
                                                  child: Text(item.name,
                                                      style: const TextStyle(
                                                          fontSize: 14,
                                                          color:
                                                              Colors.black))))
                                          .toList(),
                                      onChanged: (value) {
                                        setState(() {
                                          selectedValue = value;
                                        });
                                      },
                                      iconStyleData: const IconStyleData(
                                          icon: Icon(Icons.arrow_drop_down,
                                              color: Colors.black45),
                                          iconSize: 24),
                                      buttonStyleData: ButtonStyleData(
                                        decoration: BoxDecoration(
                                          color: AppTheme.greyColor,
                                          // Background color for the button
                                          borderRadius: BorderRadius.circular(
                                              10), // Set border radius
                                          // Optional border
                                        ),
                                      ),
                                      dropdownStyleData: DropdownStyleData(
                                        maxHeight:
                                            MediaQuery.sizeOf(context).height /
                                                2,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(
                                              10), // Set border radius for dropdown
                                        ),
                                      ),
                                      menuItemStyleData:
                                          const MenuItemStyleData(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 16),
                                      ),
                                    );
                                  } else {
                                    return const SizedBox();
                                  }
                                },
                              ),
                              SizedBox(height: 10.h),
                              Text('Description',
                                  style: GoogleFonts.nunitoSans(
                                      textStyle: TextStyle(
                                          color: Colors.black,
                                          fontSize: 15.sp,
                                          fontWeight: FontWeight.w500))),
                              SizedBox(height: 10.h),
                              DropdownButton2<String>(
                                underline: Container(color: Colors.transparent),
                                isExpanded: true,
                                value: sosReasonDes,
                                hint: Text('Select visiting reason',
                                    style: GoogleFonts.nunitoSans(
                                        textStyle: TextStyle(
                                            color: Colors.grey,
                                            fontSize: 15,
                                            fontWeight: FontWeight.normal))),
                                items: sosReasonsDec
                                    .map((item) => DropdownMenuItem<String>(
                                        value: item,
                                        child: Text(item.toString(),
                                            style: const TextStyle(
                                                fontSize: 12,
                                                color: Colors.black))))
                                    .toList(),
                                onChanged: (value) =>
                                    setState(() => sosReasonDes = value),
                                iconStyleData: const IconStyleData(
                                    icon: Icon(Icons.arrow_drop_down,
                                        color: Colors.black45),
                                    iconSize: 24),
                                buttonStyleData: ButtonStyleData(
                                    decoration: BoxDecoration(
                                        color: AppTheme.greyColor,
                                        borderRadius:
                                            BorderRadius.circular(10))),
                                dropdownStyleData: DropdownStyleData(
                                    maxHeight:
                                        MediaQuery.sizeOf(context).height / 2,
                                    decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(10))),
                                menuItemStyleData: const MenuItemStyleData(
                                  padding: EdgeInsets.symmetric(horizontal: 16),
                                ),
                              ),
                              SizedBox(height: 10.h),
                            ],
                          ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

List<String> sosReasonsDec = [
  "Medical Emergency - Sudden health issue or injury needing urgent medical help.",
  "Fire Alert - Fire or smoke detected, requires immediate attention.",
  "Earthquake Tremor - Tremors felt, safety alert needed.",
  "Flood / Water Logging - Heavy rain causing water accumulation or flooding.",
  "Suspicious Activity - Unknown person, vehicle, or unusual movement noticed.",
  "Theft or Burglary - Incident of robbery, theft, or house break-in.",
  "Domestic Violence - Conflict or violence inside the society premises.",
  "Gas Leak - Leakage from cylinder or pipeline, risk of fire or blast.",
  "Animal Threat - Dangerous animal entered society (dog, snake, monkey, etc.).",
  "Harassment - Resident facing harassment, threat, or misconduct.",
  "Accident - Road accident, fall, or serious injury in society area.",
  "Other Emergency - Any other urgent situation needing quick response.",
];
