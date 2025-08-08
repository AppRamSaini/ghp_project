import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ghp_society_management/constants/app_theme.dart';
import 'package:ghp_society_management/constants/custom_btns.dart';
import 'package:ghp_society_management/constants/dialog.dart';
import 'package:ghp_society_management/constants/local_storage.dart';
import 'package:ghp_society_management/constants/snack_bar.dart';
import 'package:ghp_society_management/controller/refer_property/create_refer_property/create_refer_property_cubit.dart';
import 'package:ghp_society_management/controller/refer_property/get_refer_property/get_refer_property_cubit.dart';
import 'package:ghp_society_management/controller/refer_property/refer_property_element/refer_property_element_cubit.dart';
import 'package:ghp_society_management/controller/refer_property/update_refer_property/update_refer_property_cubit.dart';
import 'package:ghp_society_management/model/refer_property_model.dart';
import 'package:ghp_society_management/view/session_dialogue.dart';
import 'package:google_fonts/google_fonts.dart';

class RegisterReferPropertyScreen extends StatefulWidget {
  final ReferPropertyList? requestData;
  bool isRefer;

  RegisterReferPropertyScreen(
      {super.key, this.requestData, this.isRefer = false});

  @override
  State<RegisterReferPropertyScreen> createState() =>
      _RegisterReferPropertyScreenState();
}

class _RegisterReferPropertyScreenState
    extends State<RegisterReferPropertyScreen> {
  String? selectMaxBudget;
  String? selectMinBudget;
  String? lookingFor;
  String? bhk;
  String? propertyStatus;
  String? propertyFacing;

  final TextEditingController propertyName = TextEditingController();
  final TextEditingController mobileNumber = TextEditingController();
  final TextEditingController preferredLocation = TextEditingController();
  final TextEditingController remark = TextEditingController();

  final formkey = GlobalKey<FormState>();
  BuildContext? dialogueContext;
  late GetReferPropertyCubit getReferPropertyCubit;
  int min = 0;
  int max = 0;

  @override
  void initState() {
    super.initState();

    if (widget.isRefer) {
      initData();
    }
  }

  initData() {
    propertyName.text = widget.requestData!.name.toString();
    mobileNumber.text = widget.requestData!.phone.toString();
    preferredLocation.text = widget.requestData!.location.toString();
    remark.text = widget.requestData!.remark.toString();
    selectMaxBudget = widget.requestData!.maxBudget.toString();
    selectMinBudget = widget.requestData!.minBudget.toString();
    lookingFor = widget.requestData!.unitType.toString();
    bhk = widget.requestData!.bhk.toString();
    propertyStatus = widget.requestData!.propertyStatus.toString();
    propertyFacing = widget.requestData!.propertyFancing.toString();
    setState(() {});
  }

  ScrollController _scrollController = ScrollController();
  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<CreateReferPropertyCubit, CreateReferPropertyState>(
            listener: (context, state) async {
          if (state is CreateReferPropertyLoading) {
            showLoadingDialog(context, (ctx) {
              dialogueContext = ctx;
            });
          } else if (state is CreateReferPropertysuccessfully) {
            snackBar(context, 'Refer property created successfully', Icons.done,
                AppTheme.guestColor);
            Navigator.of(dialogueContext!).pop();
            Navigator.of(context).pop();
          } else if (state is CreateReferPropertyFailed) {
            snackBar(context, state.message, Icons.warning, AppTheme.redColor);
            Navigator.of(dialogueContext!).pop();
          } else if (state is CreateReferPropertyInternetError) {
            snackBar(context, 'Internet connection failed', Icons.wifi_off,
                AppTheme.redColor);
            Navigator.of(dialogueContext!).pop();
          } else if (state is CreateReferPropertyLogout) {
            Navigator.of(dialogueContext!).pop();

            sessionExpiredDialog(context);
          }
        }),
        BlocListener<UpdateReferPropertyCubit, UpdateReferPropertyState>(
            listener: (context, state) async {
          if (state is UpdateReferPropertyLoading) {
            showLoadingDialog(context, (ctx) {
              dialogueContext = ctx;
            });
          } else if (state is UpdateReferPropertySuccess) {
            snackBar(context, state.successMsg.toString(), Icons.done,
                AppTheme.guestColor);
            Navigator.of(dialogueContext!).pop();
            Navigator.of(context).pop();
          } else if (state is UpdateReferPropertyFailed) {
            snackBar(context, state.errorMsg.toString(), Icons.warning,
                AppTheme.redColor);
            Navigator.of(dialogueContext!).pop();
          } else if (state is UpdateReferPropertyInternetError) {
            snackBar(context, state.errorMsg.toString(), Icons.wifi_off,
                AppTheme.redColor);
            Navigator.of(dialogueContext!).pop();
          } else if (state is UpdateReferPropertyLogout) {
            Navigator.of(dialogueContext!).pop();
            sessionExpiredDialog(context);
          }
        })
      ],
      child: Scaffold(
        appBar: appbarWidget(title: 'Refer Property '),
        body: Column(
          children: [
            Expanded(
              child: Form(
                key: formkey,
                child: SingleChildScrollView(
                  controller: _scrollController,
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 10),
                        Text('Name',
                            style: GoogleFonts.nunitoSans(
                                textStyle: TextStyle(
                                    color: Colors.black,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500))),
                        SizedBox(height: 10.h),
                        SizedBox(
                          width: MediaQuery.of(context).size.width,
                          child: TextFormField(
                            onTap: () => scrollManagement(_scrollController),
                            textInputAction: TextInputAction.done,
                            controller: propertyName,
                            style: GoogleFonts.nunitoSans(
                              color: Colors.black,
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                            keyboardType: TextInputType.name,
                            validator: (text) {
                              if (text == null || text.isEmpty) {
                                return 'Please enter property name';
                              }
                              return null;
                            },
                            decoration: InputDecoration(
                              hintText: 'Enter name',
                              contentPadding: EdgeInsets.symmetric(
                                  vertical: 12.h, horizontal: 10.0),
                              filled: true,
                              hintStyle: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 14,
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
                        Text('Mobile Number ',
                            style: GoogleFonts.nunitoSans(
                              textStyle: TextStyle(
                                color: Colors.black,
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                            )),
                        SizedBox(
                          height: 10.h,
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width,
                          child: TextFormField(
                            textInputAction: TextInputAction.done,
                            controller: mobileNumber,
                            style: GoogleFonts.nunitoSans(
                              color: Colors.black,
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                            keyboardType: TextInputType.number,
                            inputFormatters: [
                              LengthLimitingTextInputFormatter(10),
                              FilteringTextInputFormatter.digitsOnly
                            ],
                            validator: (text) {
                              if (text == null || text.isEmpty) {
                                return 'Please enter mobile number';
                              } else if (text.length > 10 || text.length < 10) {
                                return 'Mobile number length must be equal to 10';
                              }
                              return null;
                            },
                            decoration: InputDecoration(
                              hintText: 'Enter number',
                              contentPadding: EdgeInsets.symmetric(
                                  vertical: 12.h, horizontal: 10.0),
                              filled: true,
                              hintStyle: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 14,
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
                        Row(
                          children: [
                            Expanded(
                              child: Text('Min Budget',
                                  style: GoogleFonts.nunitoSans(
                                    textStyle: TextStyle(
                                      color: Colors.black,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  )),
                            ),
                            Expanded(
                              child: Text('Max Budget',
                                  style: GoogleFonts.nunitoSans(
                                    textStyle: TextStyle(
                                      color: Colors.black,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  )),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 10.h,
                        ),
                        BlocBuilder<ReferPropertyElementCubit,
                            ReferPropertyElementState>(
                          builder: (context, state) {
                            if (state is ReferPropertyElementLoaded) {
                              return Row(
                                children: [
                                  Expanded(
                                    child: DropdownButton2<String>(
                                      underline:
                                          Container(color: Colors.transparent),
                                      isExpanded: true,
                                      value: selectMinBudget,
                                      hint: Text('--select--',
                                          style: GoogleFonts.nunitoSans(
                                            textStyle: TextStyle(
                                              color: Colors.grey,
                                              fontSize: 14,
                                              fontWeight: FontWeight.normal,
                                            ),
                                          )),
                                      items: state.referPropertyElement.first
                                          .data.minBudgetOptions
                                          .map((item) =>
                                              DropdownMenuItem<String>(
                                                value: item.name,
                                                child: Text(
                                                  item.name,
                                                  style: const TextStyle(
                                                      fontSize: 14,
                                                      color: Colors.black),
                                                ),
                                              ))
                                          .toList(),
                                      onChanged: (value) {
                                        setState(() {
                                          selectMinBudget = value;

                                          min = int.parse(value.toString());
                                        });
                                      },
                                      iconStyleData: const IconStyleData(
                                        icon: Icon(
                                          Icons.arrow_drop_down,
                                          color: Colors.black45,
                                        ),
                                        iconSize: 24,
                                      ),
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
                                    ),
                                  ),
                                  SizedBox(
                                    width: 10.w,
                                  ),
                                  Expanded(
                                    child: DropdownButton2<String>(
                                      underline:
                                          Container(color: Colors.transparent),
                                      isExpanded: true,
                                      value: selectMaxBudget,
                                      hint: Text('--select--',
                                          style: GoogleFonts.nunitoSans(
                                            textStyle: TextStyle(
                                              color: Colors.grey,
                                              fontSize: 14,
                                              fontWeight: FontWeight.normal,
                                            ),
                                          )),
                                      items: state.referPropertyElement.first
                                          .data.maxBudgetOptions
                                          .map((item) =>
                                              DropdownMenuItem<String>(
                                                value: item.name,
                                                child: Text(
                                                  item.name,
                                                  style: const TextStyle(
                                                      fontSize: 14,
                                                      color: Colors.black),
                                                ),
                                              ))
                                          .toList(),
                                      onChanged: (value) {
                                        setState(() {
                                          selectMaxBudget = value;
                                          max = int.parse(value.toString());
                                        });
                                      },
                                      iconStyleData: const IconStyleData(
                                        icon: Icon(
                                          Icons.arrow_drop_down,
                                          color: Colors.black45,
                                        ),
                                        iconSize: 24,
                                      ),
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
                                    ),
                                  ),
                                ],
                              );
                            } else {
                              return SizedBox();
                            }
                          },
                        ),
                        SizedBox(
                          height: 10.h,
                        ),
                        Text('Preferred Location',
                            style: GoogleFonts.nunitoSans(
                              textStyle: TextStyle(
                                color: Colors.black,
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                            )),
                        SizedBox(
                          height: 10.h,
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width,
                          child: TextFormField(
                            textInputAction: TextInputAction.done,
                            controller: preferredLocation,
                            style: GoogleFonts.nunitoSans(
                              color: Colors.black,
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                            keyboardType: TextInputType.text,
                            validator: (text) {
                              if (text == null || text.isEmpty) {
                                return 'Please enter preferred location';
                              }
                              return null;
                            },
                            decoration: InputDecoration(
                              hintText: 'Enter location',
                              contentPadding: EdgeInsets.symmetric(
                                  vertical: 12.h, horizontal: 10.0),
                              filled: true,
                              hintStyle: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 14,
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
                        Text('Looking For',
                            style: GoogleFonts.nunitoSans(
                              textStyle: TextStyle(
                                color: Colors.black,
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                            )),
                        SizedBox(
                          height: 10.h,
                        ),
                        BlocBuilder<ReferPropertyElementCubit,
                            ReferPropertyElementState>(
                          builder: (context, state) {
                            if (state is ReferPropertyElementLoaded) {
                              return DropdownButton2<String>(
                                hint: const Text(
                                  'Select looking for',
                                  style: TextStyle(
                                      color: Colors.grey,
                                      fontSize: 14,
                                      fontWeight: FontWeight.normal),
                                ),
                                underline: Container(color: Colors.transparent),
                                isExpanded: true,
                                value: lookingFor,
                                items: state
                                    .referPropertyElement.first.data.unitTypes
                                    .map((item) => DropdownMenuItem<String>(
                                          value: item.name,
                                          child: Text(
                                            item.name,
                                            style: const TextStyle(
                                                fontSize: 14,
                                                color: Colors.black),
                                          ),
                                        ))
                                    .toList(),
                                onChanged: (value) {
                                  setState(() {
                                    lookingFor = value; // Update selected value
                                  });
                                },
                                iconStyleData: const IconStyleData(
                                  icon: Icon(
                                    Icons.arrow_drop_down,
                                    color: Colors.black45,
                                  ),
                                  iconSize: 24,
                                ),
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
                                      MediaQuery.sizeOf(context).height / 2,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(
                                        10), // Set border radius for dropdown
                                  ),
                                ),
                                menuItemStyleData: const MenuItemStyleData(
                                  padding: EdgeInsets.symmetric(horizontal: 16),
                                ),
                              );
                            } else {
                              return SizedBox();
                            }
                          },
                        ),
                        SizedBox(
                          height: 10.h,
                        ),
                        Text('Select BHK',
                            style: GoogleFonts.nunitoSans(
                              textStyle: TextStyle(
                                color: Colors.black,
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                            )),
                        SizedBox(
                          height: 10.h,
                        ),
                        BlocBuilder<ReferPropertyElementCubit,
                            ReferPropertyElementState>(
                          builder: (context, state) {
                            if (state is ReferPropertyElementLoaded) {
                              return DropdownButton2<String>(
                                hint: const Text(
                                  'Select BHK type',
                                  style: TextStyle(
                                      color: Colors.grey,
                                      fontSize: 14,
                                      fontWeight: FontWeight.normal),
                                ),
                                underline: Container(color: Colors.transparent),
                                isExpanded: true,
                                value: bhk,
                                items:
                                    state.referPropertyElement.first.data.bhks
                                        .map((item) => DropdownMenuItem<String>(
                                              value: item.name,
                                              child: Text(
                                                item.name,
                                                style: const TextStyle(
                                                    fontSize: 14,
                                                    color: Colors.black),
                                              ),
                                            ))
                                        .toList(),
                                onChanged: (value) {
                                  setState(() {
                                    bhk = value; // Update selected value
                                  });
                                },
                                iconStyleData: const IconStyleData(
                                  icon: Icon(
                                    Icons.arrow_drop_down,
                                    color: Colors.black45,
                                  ),
                                  iconSize: 24,
                                ),
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
                                      MediaQuery.sizeOf(context).height / 2,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(
                                        10), // Set border radius for dropdown
                                  ),
                                ),
                                menuItemStyleData: const MenuItemStyleData(
                                  padding: EdgeInsets.symmetric(horizontal: 16),
                                ),
                              );
                            } else {
                              return SizedBox();
                            }
                          },
                        ),
                        SizedBox(
                          height: 10.h,
                        ),
                        SizedBox(
                          height: 10.h,
                        ),
                        Text('Select Property Status ',
                            style: GoogleFonts.nunitoSans(
                              textStyle: TextStyle(
                                color: Colors.black,
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                            )),
                        SizedBox(
                          height: 10.h,
                        ),
                        BlocBuilder<ReferPropertyElementCubit,
                            ReferPropertyElementState>(
                          builder: (context, state) {
                            if (state is ReferPropertyElementLoaded) {
                              return DropdownButton2<String>(
                                hint: const Text(
                                  'Select property status',
                                  style: TextStyle(
                                      color: Colors.grey,
                                      fontSize: 14,
                                      fontWeight: FontWeight.normal),
                                ),
                                underline: Container(color: Colors.transparent),
                                isExpanded: true,
                                value: propertyStatus,
                                items: state.referPropertyElement.first.data
                                    .propertyStatus
                                    .map((item) => DropdownMenuItem<String>(
                                          value: item.name,
                                          child: Text(
                                            item.name,
                                            style: const TextStyle(
                                                fontSize: 14,
                                                color: Colors.black),
                                          ),
                                        ))
                                    .toList(),
                                onChanged: (value) {
                                  setState(() {
                                    propertyStatus =
                                        value; // Update selected value
                                  });
                                },
                                iconStyleData: const IconStyleData(
                                  icon: Icon(
                                    Icons.arrow_drop_down,
                                    color: Colors.black45,
                                  ),
                                  iconSize: 24,
                                ),
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
                                      MediaQuery.sizeOf(context).height / 2,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(
                                        10), // Set border radius for dropdown
                                  ),
                                ),
                                menuItemStyleData: const MenuItemStyleData(
                                  padding: EdgeInsets.symmetric(horizontal: 16),
                                ),
                              );
                            } else {
                              return SizedBox();
                            }
                          },
                        ),
                        SizedBox(
                          height: 10.h,
                        ),
                        Text('Property Facing ',
                            style: GoogleFonts.nunitoSans(
                              textStyle: TextStyle(
                                color: Colors.black,
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                            )),
                        SizedBox(
                          height: 10.h,
                        ),
                        BlocBuilder<ReferPropertyElementCubit,
                            ReferPropertyElementState>(
                          builder: (context, state) {
                            if (state is ReferPropertyElementLoaded) {
                              return DropdownButton2<String>(
                                hint: const Text(
                                  'Select property facing',
                                  style: TextStyle(
                                      color: Colors.grey,
                                      fontSize: 14,
                                      fontWeight: FontWeight.normal),
                                ),
                                underline: Container(color: Colors.transparent),
                                isExpanded: true,
                                value: propertyFacing,
                                items: state.referPropertyElement.first.data
                                    .propertyFencing
                                    .map((item) => DropdownMenuItem<String>(
                                          value: item.name,
                                          child: Text(
                                            item.name,
                                            style: const TextStyle(
                                                fontSize: 14,
                                                color: Colors.black),
                                          ),
                                        ))
                                    .toList(),
                                onChanged: (value) {
                                  setState(() {
                                    propertyFacing =
                                        value; // Update selected value
                                  });
                                },
                                iconStyleData: const IconStyleData(
                                  icon: Icon(
                                    Icons.arrow_drop_down,
                                    color: Colors.black45,
                                  ),
                                  iconSize: 24,
                                ),
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
                                      MediaQuery.sizeOf(context).height / 2,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(
                                        10), // Set border radius for dropdown
                                  ),
                                ),
                                menuItemStyleData: const MenuItemStyleData(
                                  padding: EdgeInsets.symmetric(horizontal: 16),
                                ),
                              );
                            } else {
                              return SizedBox();
                            }
                          },
                        ),
                        SizedBox(
                          height: 10.h,
                        ),
                        Text('Remark',
                            style: GoogleFonts.nunitoSans(
                              textStyle: TextStyle(
                                color: Colors.black,
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                            )),
                        SizedBox(
                          height: 10.h,
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width,
                          child: TextFormField(
                            textInputAction: TextInputAction.done,
                            controller: remark,
                            style: GoogleFonts.nunitoSans(
                              color: Colors.black,
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                            keyboardType: TextInputType.text,
                            validator: (text) {
                              if (text == null || text.isEmpty) {
                                return 'Please enter remark';
                              }
                              return null;
                            },
                            decoration: InputDecoration(
                              hintText: 'Enter remark',
                              contentPadding: EdgeInsets.symmetric(
                                  vertical: 12.h, horizontal: 10.0),
                              filled: true,
                              hintStyle: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 14,
                                  fontWeight: FontWeight.normal),
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
                        SizedBox(height: 20.h),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            customBtn(
                onTap: () {
                  final propertyId =
                      LocalStorage.localStorage.getString('property_id');

                  if (formkey.currentState!.validate()) {
                    if (selectMinBudget == null) {
                      snackBar(context, "Kindly select min budget of property",
                          Icons.warning, AppTheme.redColor);
                    } else if (selectMaxBudget == null) {
                      snackBar(context, "Kindly select max budget of property",
                          Icons.warning, AppTheme.redColor);
                    } else if (min > max) {
                      snackBar(
                          context,
                          "Minimum budget cannot be greater then max budget",
                          Icons.warning,
                          AppTheme.redColor);
                    } else if (lookingFor == null) {
                      snackBar(
                          context,
                          "Kindly select what you are looking for?",
                          Icons.warning,
                          AppTheme.redColor);
                    } else if (bhk == null) {
                      snackBar(context, "Kindly select bhk", Icons.warning,
                          AppTheme.redColor);
                    } else if (propertyStatus == null) {
                      snackBar(context, "Kindly select property status",
                          Icons.warning, AppTheme.redColor);
                    } else if (bhk == null) {
                      snackBar(context, "Kindly select property facing",
                          Icons.warning, AppTheme.redColor);
                    } else {
                      var referPropertyBody = {
                        "property_id": propertyId.toString(),
                        "name": propertyName.text,
                        "phone": mobileNumber.text,
                        "min_budget": selectMinBudget!,
                        "max_budget": selectMaxBudget!,
                        "location": preferredLocation.text,
                        "unit_type": lookingFor,
                        "bhk": bhk,
                        "property_status": propertyStatus,
                        "property_fancing": propertyFacing,
                        "remark": remark.text
                      };

                      if (widget.isRefer) {
                        context
                            .read<UpdateReferPropertyCubit>()
                            .updateReferProperty(
                                widget.requestData!.id.toString(),
                                referPropertyBody);
                      } else {
                        context
                            .read<CreateReferPropertyCubit>()
                            .createReferProperty(referPropertyBody);
                      }
                    }
                  }
                },
                txt: "Submit"),
          ],
        ),
      ),
    );
  }
}
