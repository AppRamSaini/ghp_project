import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ghp_society_management/constants/app_theme.dart';
import 'package:ghp_society_management/constants/dialog.dart';
import 'package:ghp_society_management/constants/snack_bar.dart';
import 'package:ghp_society_management/controller/parcel/create_parcel/create_parcel_cubit.dart';
import 'package:ghp_society_management/controller/parcel/parcel_element/parcel_element_cubit.dart';
import 'package:ghp_society_management/view/session_dialogue.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class CreateParcelPage extends StatefulWidget {
  const CreateParcelPage({super.key});

  @override
  State<CreateParcelPage> createState() => _CreateParcelPageState();
}

class _CreateParcelPageState extends State<CreateParcelPage> {
  final List<String> visitorsNumbers = [
    '1',
    '2',
    '3',
    '4',
    '5',
    '6',
    '7',
    '8',
    '9'
  ];

  TextEditingController nameController = TextEditingController();
  TextEditingController parcelIDController = TextEditingController();
  TextEditingController senderNameController = TextEditingController();
  String? numberOfParcel;
  TextEditingController? date = TextEditingController();
  TextEditingController? time = TextEditingController();
  String? parcelTypes;
  final _formkey = GlobalKey<FormState>();
  DateTime selectedDate = DateTime.now();
  TimeOfDay selectedTime = TimeOfDay.now();

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime.now(),
        lastDate: DateTime(2101));

    if (picked != null) {
      setState(() {
        time!.clear();
        selectedDate = picked;
        String formattedDate = DateFormat('yyyy-MM-dd').format(selectedDate);
        date!.text = formattedDate;
      });
    }
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: selectedTime,
    );

    if (pickedTime != null) {
      final now = DateTime.now();
      final selectedDate =
          DateFormat('yyyy-MM-dd').parse(date!.text); // चुनी गई तारीख

      if (selectedDate
          .isAtSameMomentAs(DateTime(now.year, now.month, now.day))) {
        DateTime pickedDateTime = DateTime(
            now.year, now.month, now.day, pickedTime.hour, pickedTime.minute);

        if (pickedDateTime.isBefore(now)) {
          snackBar(context, 'Cannot select past time!', Icons.warning,
              AppTheme.redColor);
          return;
        }
      }

      setState(() {
        selectedTime = pickedTime;
        final formattedTime = DateTime(now.year, now.month, now.day,
            selectedTime.hour, selectedTime.minute);

        // Format time in "HH:mm:ss" format
        final formattedTimeString =
            "${formattedTime.hour.toString().padLeft(2, '0')}:"
            "${formattedTime.minute.toString().padLeft(2, '0')}:00"; // Always add seconds as 00
        time?.text = formattedTimeString;
      });
    }
  }

  late BuildContext dialogueContext;

  @override
  void initState() {
    super.initState();
    context.read<ParcelElementsCubit>().fetchParcelElement();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ParcelManagementCubit, ParcelManagementState>(
      listener: (context, state) {
        if (state is CreateParcelLoading) {
          showLoadingDialog(context, (ctx) {
            dialogueContext = ctx;
          });
        } else if (state is CreateParcelSuccess) {
          snackBar(context, state.successMsg.toString(), Icons.done,
              AppTheme.guestColor);
          Navigator.of(dialogueContext).pop();
          Navigator.of(context).pop();
        } else if (state is CreateParcelFailed) {
          snackBar(context, state.errorMsg.toString(), Icons.warning,
              AppTheme.redColor);

          Navigator.of(dialogueContext).pop();
        } else if (state is ParcelManagementInternetError) {
          snackBar(context, state.errorMsg.toString(), Icons.wifi_off,
              AppTheme.redColor);
          Navigator.of(dialogueContext).pop();
        } else if (state is ParcelManagementLogout) {
          Navigator.of(dialogueContext).pop();
          sessionExpiredDialog(context);
        }
      },
      child: Scaffold(
        appBar: appbarWidget(title: 'Add Parcel Info'),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Form(
              key: _formkey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 10.h),
                  Text('Order ID',
                      style: GoogleFonts.nunitoSans(
                          textStyle: TextStyle(
                              color: Colors.black,
                              fontSize: 15.sp,
                              fontWeight: FontWeight.w500))),
                  SizedBox(height: 10.h),
                  SizedBox(
                    width: MediaQuery.of(context).size.width,
                    child: TextFormField(
                      controller: parcelIDController,
                      style: GoogleFonts.nunitoSans(
                        color: Colors.black,
                        fontSize: 15.sp,
                        fontWeight: FontWeight.w500,
                      ),
                      keyboardType: TextInputType.text,
                      validator: (text) {
                        if (text == null || text.isEmpty) {
                          return 'Please enter order ID';
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                        hintText: 'Enter order id',
                        contentPadding: EdgeInsets.symmetric(
                            vertical: 12.h, horizontal: 10.0),
                        filled: true,
                        hintStyle: TextStyle(
                            color: Colors.grey,
                            fontSize: 15.sp,
                            fontWeight: FontWeight.normal),
                        fillColor: AppTheme.greyColor,
                        errorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15.0),
                            borderSide: BorderSide(color: AppTheme.greyColor)),
                        focusedErrorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15.0),
                            borderSide: BorderSide(color: AppTheme.greyColor)),
                        focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15.0),
                            borderSide: BorderSide(color: AppTheme.greyColor)),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15.0),
                          borderSide: BorderSide(
                            color: AppTheme.greyColor,
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 10.h),
                  Text('Parcel Name',
                      style: GoogleFonts.nunitoSans(
                          textStyle: TextStyle(
                              color: Colors.black,
                              fontSize: 15.sp,
                              fontWeight: FontWeight.w500))),
                  SizedBox(height: 10.h),
                  SizedBox(
                    width: MediaQuery.of(context).size.width,
                    child: TextFormField(
                      controller: nameController,
                      style: GoogleFonts.nunitoSans(
                        color: Colors.black,
                        fontSize: 15.sp,
                        fontWeight: FontWeight.w500,
                      ),
                      keyboardType: TextInputType.text,
                      validator: (text) {
                        if (text == null || text.isEmpty) {
                          return 'Please enter parcel name';
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                        hintText: 'Enter parcel name',
                        contentPadding: EdgeInsets.symmetric(
                            vertical: 12.h, horizontal: 10.0),
                        filled: true,
                        hintStyle: TextStyle(
                            color: Colors.grey,
                            fontSize: 15.sp,
                            fontWeight: FontWeight.normal),
                        fillColor: AppTheme.greyColor,
                        errorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15.0),
                            borderSide: BorderSide(color: AppTheme.greyColor)),
                        focusedErrorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15.0),
                            borderSide: BorderSide(color: AppTheme.greyColor)),
                        focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15.0),
                            borderSide: BorderSide(color: AppTheme.greyColor)),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15.0),
                          borderSide: BorderSide(
                            color: AppTheme.greyColor,
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 10.h),
                  Text('Brands Name',
                      style: GoogleFonts.nunitoSans(
                          textStyle: TextStyle(
                              color: Colors.black,
                              fontSize: 15.sp,
                              fontWeight: FontWeight.w500))),
                  SizedBox(height: 10.h),
                  SizedBox(
                    width: MediaQuery.of(context).size.width,
                    child: TextFormField(
                      controller: senderNameController,
                      style: GoogleFonts.nunitoSans(
                        color: Colors.black,
                        fontSize: 15.sp,
                        fontWeight: FontWeight.w500,
                      ),
                      keyboardType: TextInputType.text,
                      validator: (text) {
                        if (text == null || text.isEmpty) {
                          return 'Please enter Brands Name';
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                        hintText: 'Enter Brands Name',
                        contentPadding: EdgeInsets.symmetric(
                            vertical: 12.h, horizontal: 10.0),
                        filled: true,
                        hintStyle: TextStyle(
                            color: Colors.grey,
                            fontSize: 15.sp,
                            fontWeight: FontWeight.normal),
                        fillColor: AppTheme.greyColor,
                        errorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15.0),
                            borderSide: BorderSide(color: AppTheme.greyColor)),
                        focusedErrorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15.0),
                            borderSide: BorderSide(color: AppTheme.greyColor)),
                        focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15.0),
                            borderSide: BorderSide(color: AppTheme.greyColor)),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15.0),
                          borderSide: BorderSide(
                            color: AppTheme.greyColor,
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 10.h),
                  Text('Type of Parcel',
                      style: GoogleFonts.nunitoSans(
                        textStyle: TextStyle(
                          color: Colors.black,
                          fontSize: 15.sp,
                          fontWeight: FontWeight.w500,
                        ),
                      )),
                  SizedBox(height: 10.h),
                  BlocBuilder<ParcelElementsCubit, ParcelElementsState>(
                    builder: (context, state) {
                      if (state is ParcelElementLoaded) {
                        return DropdownButton2<String>(
                          underline: Container(color: Colors.transparent),
                          isExpanded: true,
                          value: parcelTypes,
                          hint: Text('Select Parcel type',
                              style: GoogleFonts.nunitoSans(
                                  textStyle: TextStyle(
                                      color: Colors.grey, fontSize: 15.sp))),
                          items: state.parcelElement.first.data!.parcelTypes!
                              .map((item) => DropdownMenuItem<String>(
                                    value: item.name,
                                    child: Text(
                                      item.name.toString(),
                                      style: const TextStyle(
                                          fontSize: 14, color: Colors.black),
                                    ),
                                  ))
                              .toList(),
                          onChanged: (value) {
                            setState(() {
                              parcelTypes = value;
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
                            maxHeight: MediaQuery.sizeOf(context).height / 2,
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
                        return const SizedBox();
                      }
                    },
                  ),
                  SizedBox(height: 10.h),
                  Text('No. of parcel',
                      style: GoogleFonts.nunitoSans(
                          textStyle: TextStyle(
                              color: Colors.black,
                              fontSize: 15.sp,
                              fontWeight: FontWeight.w500))),
                  SizedBox(height: 10.h),
                  DropdownButton2<String>(
                      underline: Container(color: Colors.transparent),
                      isExpanded: true,
                      value: numberOfParcel,
                      hint: Text('Select no. of parcels',
                          style: GoogleFonts.nunitoSans(
                              textStyle: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 15.sp,
                                  fontWeight: FontWeight.normal))),
                      items: visitorsNumbers
                          .map((item) => DropdownMenuItem<String>(
                              value: item,
                              child: Text(item,
                                  style: const TextStyle(
                                      fontSize: 14, color: Colors.black))))
                          .toList(),
                      onChanged: (value) {
                        setState(() {
                          numberOfParcel = value; // Update selected value
                        });
                      },
                      iconStyleData: const IconStyleData(
                          icon: Icon(Icons.arrow_drop_down,
                              color: Colors.black45),
                          iconSize: 24),
                      buttonStyleData: ButtonStyleData(
                          decoration: BoxDecoration(
                              color: AppTheme.greyColor,
                              borderRadius: BorderRadius.circular(10))),
                      dropdownStyleData: DropdownStyleData(
                          maxHeight: MediaQuery.sizeOf(context).height / 2,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10))),
                      menuItemStyleData: const MenuItemStyleData(
                          padding: EdgeInsets.symmetric(horizontal: 16))),
                  SizedBox(height: 10.h),
                  Row(children: [
                    Expanded(
                        child: Text('Date',
                            style: GoogleFonts.nunitoSans(
                                textStyle: TextStyle(
                                    color: Colors.black,
                                    fontSize: 15.sp,
                                    fontWeight: FontWeight.w500)))),
                    Expanded(
                        child: Text('Time',
                            style: GoogleFonts.nunitoSans(
                                textStyle: TextStyle(
                                    color: Colors.black,
                                    fontSize: 15.sp,
                                    fontWeight: FontWeight.w500))))
                  ]),
                  SizedBox(height: 10.h),
                  Row(
                    children: [
                      Expanded(
                        child: SizedBox(
                          child: TextFormField(
                            onTap: () {
                              _selectDate(context);
                            },
                            readOnly: true,
                            controller: date,
                            style: GoogleFonts.nunitoSans(
                              color: Colors.black,
                              fontSize: 15.sp,
                              fontWeight: FontWeight.w500,
                            ),
                            keyboardType: TextInputType.text,
                            validator: (text) {
                              if (text == null || text.isEmpty) {
                                return 'Please enter date';
                              }
                              return null;
                            },
                            decoration: InputDecoration(
                              hintText: 'Select Date',
                              contentPadding: EdgeInsets.symmetric(
                                  vertical: 12.h, horizontal: 10.0),
                              prefixIcon: GestureDetector(
                                  onTap: () {
                                    _selectDate(context);
                                  },
                                  child: const Icon(Icons.calendar_month)),
                              filled: true,
                              hintStyle: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 15.sp,
                                  fontWeight: FontWeight.normal),
                              fillColor: AppTheme.greyColor,
                              errorBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(15.0),
                                  borderSide:
                                      BorderSide(color: AppTheme.greyColor)),
                              focusedErrorBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(15.0),
                                  borderSide:
                                      BorderSide(color: AppTheme.greyColor)),
                              focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(15.0),
                                  borderSide:
                                      BorderSide(color: AppTheme.greyColor)),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15.0),
                                borderSide: BorderSide(
                                  color: AppTheme.greyColor,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 10.w),
                      Expanded(
                        child: SizedBox(
                          child: TextFormField(
                            readOnly: true,
                            controller: time,
                            style: GoogleFonts.nunitoSans(
                              color: Colors.black,
                              fontSize: 15.sp,
                              fontWeight: FontWeight.w500,
                            ),
                            keyboardType: TextInputType.text,
                            validator: (text) {
                              if (text == null || text.isEmpty) {
                                return 'Please enter time';
                              }
                              return null;
                            },
                            decoration: InputDecoration(
                              hintText: 'Select Time',
                              contentPadding: EdgeInsets.symmetric(
                                  vertical: 12.h, horizontal: 10.0),
                              prefixIcon: GestureDetector(
                                  onTap: () {
                                    if (date!.text.isEmpty) {
                                      snackBar(
                                          context,
                                          'Kindly select first date!',
                                          Icons.info,
                                          AppTheme.redColor);
                                    } else {
                                      _selectTime(context);
                                    }
                                  },
                                  child: const Icon(Icons.timelapse)),
                              filled: true,
                              hintStyle: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 15.sp,
                                  fontWeight: FontWeight.normal),
                              fillColor: AppTheme.greyColor,
                              errorBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(15.0),
                                  borderSide:
                                      BorderSide(color: AppTheme.greyColor)),
                              focusedErrorBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(15.0),
                                  borderSide:
                                      BorderSide(color: AppTheme.greyColor)),
                              focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(15.0),
                                  borderSide:
                                      BorderSide(color: AppTheme.greyColor)),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15.0),
                                borderSide: BorderSide(
                                  color: AppTheme.greyColor,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 50),
                  GestureDetector(
                    onTap: () {
                      if (_formkey.currentState!.validate()) {
                        if (parcelTypes == null) {
                          snackBar(context, 'Kindly select type of parcels',
                              Icons.done, AppTheme.redColor);
                        } else if (numberOfParcel == null) {
                          snackBar(context, 'Kindly select no. of parcels',
                              Icons.done, AppTheme.redColor);
                        } else {
                          // var parcelBody = {
                          //   "parcelid":
                          //       parcelIDController.text.toString(),
                          //   "parcel_company_name":
                          //       senderNameController.text.toString(),
                          //   "parcel_name":
                          //       nameController.text.toString(),
                          //   "no_of_parcel": numberOfParcel.toString(),
                          //   "parcel_type": parcelTypes.toString(),
                          //   "date": date!.text,
                          //   "time": time!.text
                          // };
                          context.read<ParcelManagementCubit>().createParcelAPI(
                              parcelId: parcelIDController.text.toString(),
                              parcelName: nameController.text.toString(),
                              parcelType: parcelTypes.toString(),
                              numberOfParcel: numberOfParcel.toString(),
                              date: date!.text,
                              time: time!.text,
                              senderName: senderNameController.text.toString());
                        }
                      }
                    },
                    child: Padding(
                      padding: globalBottomPadding(context),
                      child: Container(
                        margin: EdgeInsets.all(12),
                        width: double.infinity,
                        height: 50,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(30),
                            color: AppTheme.primaryColor),
                        child: Center(
                          child: Text('Submit',
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
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
