import 'dart:async';
import 'dart:io';

import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ghp_society_management/constants/app_theme.dart';
import 'package:ghp_society_management/constants/crop_image.dart';
import 'package:ghp_society_management/constants/dialog.dart';
import 'package:ghp_society_management/constants/snack_bar.dart';
import 'package:ghp_society_management/controller/members/search_member/search_member_cubit.dart';
import 'package:ghp_society_management/controller/parcel/create_parcel/create_parcel_cubit.dart';
import 'package:ghp_society_management/controller/parcel/parcel_element/parcel_element_cubit.dart';
import 'package:ghp_society_management/model/search_member_modal.dart';
import 'package:ghp_society_management/view/resident/visitors/add_visitor_screen.dart';
import 'package:ghp_society_management/view/session_dialogue.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

class CreateParcelSecurityStaffSide extends StatefulWidget {
  const CreateParcelSecurityStaffSide({super.key});

  @override
  State<CreateParcelSecurityStaffSide> createState() =>
      _CreateParcelSecurityStaffSideState();
}

class _CreateParcelSecurityStaffSideState
    extends State<CreateParcelSecurityStaffSide> {
  TextEditingController nameController = TextEditingController();
  TextEditingController parcelIDController = TextEditingController();
  TextEditingController deliverNameController = TextEditingController();
  TextEditingController deliverPhoneController = TextEditingController();
  TextEditingController residenceController = TextEditingController();
  TextEditingController senderController = TextEditingController();
  String? numberOfParcel;
  TextEditingController? date = TextEditingController();
  TextEditingController? time = TextEditingController();
  String? parcelTypes;
  String? residenceID;
  final _formKey = GlobalKey<FormState>();
  DateTime selectedDate = DateTime.now();
  TimeOfDay selectedTime = TimeOfDay.now();

  late SearchMemberCubit _searchMemberCubit;
  List<File> documentFiles = [];

  void updateDate() {
    DateTime selectedDate = DateTime.now();
    String formattedDate = DateFormat('yyyy-MM-dd').format(selectedDate);
    date!.text = formattedDate;
    DateTime now = DateTime.now();
    String formattedTime = "${now.hour.toString().padLeft(2, '0')}:"
        "${now.minute.toString().padLeft(2, '0')}:"
        "${now.second.toString().padLeft(2, '0')}"; // Including seconds
    time!.text = formattedTime;
    setState(() {});
  }

  late BuildContext dialogueContext;
  int selectedIndex = -1;
  List<SearchItem> searchDataList = []; // List of SearchItem objects
  List<CroppedFile>? croppedImagesList = [];

  fromCamera(BuildContext context) async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.camera);
    if (pickedFile != null) {
      croppedImagesList!.clear();
      croppedImagesList!.add(await cropImage(pickedFile.path));
      setState(() {});
    }
  }

  fromGallery(BuildContext context) async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      croppedImagesList!.clear();
      croppedImagesList!.add(await cropImage(pickedFile.path));
      setState(() {});
    }
  }

  final List<String> visitorsNumbers = [
    '1',
    '2',
    '3',
    '4',
    '5',
    '6',
    '7',
    '8',
    '9',
    "10",
    '10+'
  ];

  @override
  void initState() {
    super.initState();
    _searchMemberCubit = SearchMemberCubit();
    _searchMemberCubit.fetchSearchMember('');
    updateDate();
  }

  TextEditingController searchController = TextEditingController();

  Future<void> _showSearchDialog() async {
    _searchMemberCubit.fetchSearchMember('');

    await showGeneralDialog(
      barrierDismissible: true,
      barrierLabel: "Search",
      context: context,
      pageBuilder: (context, anim1, anim2) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Scaffold(
              backgroundColor: Colors.black.withOpacity(0.3),
              body: Center(
                child: Container(
                  margin:
                      const EdgeInsets.symmetric(horizontal: 15, vertical: 100),
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8)),
                  width: MediaQuery.of(context).size.width,
                  child: BlocBuilder<SearchMemberCubit, SearchMemberState>(
                    bloc: _searchMemberCubit,
                    builder: (_, state) {
                      if (state is SearchMemberLoading) {
                        return SizedBox();
                      } else if (state is SearchMemberFailed) {
                        return Center(
                          child: Text(state.errorMessage.toString(),
                              style: const TextStyle(
                                  color: Colors.deepPurpleAccent)),
                        );
                      } else if (state is SearchMemberLoaded) {
                        List<SearchMemberInfo>? filteredItems =
                            state.searchMemberInfo;

                        return Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text("Select member",
                                    style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w500)),
                                IconButton(
                                  onPressed: () => Navigator.pop(context),
                                  icon: const Icon(Icons.clear,
                                      color: Colors.black87),
                                ),
                              ],
                            ),
                            Divider(
                                height: 0, color: Colors.grey.withOpacity(0.5)),
                            const SizedBox(height: 10),
                            TextField(
                              autofocus: true,
                              controller: searchController,
                              decoration: InputDecoration(
                                  contentPadding: const EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 5),
                                  isDense: true,
                                  hintText: "Search...",
                                  prefixIcon: const Icon(Icons.search),
                                  border: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color:
                                              Colors.grey.withOpacity(0.5)))),
                              onChanged: (query) {
                                setState(() {
                                  _searchMemberCubit
                                      .fetchSearchMember(query.toLowerCase());
                                });
                              },
                            ),
                            const SizedBox(height: 10),
                            filteredItems == null || filteredItems.isEmpty
                                ? const Center(
                                    child: Text("Member Not Found!",
                                        style: TextStyle(
                                            fontSize: 14,
                                            color: Colors.deepPurpleAccent)))
                                : Expanded(
                                    child: ListView.builder(
                                      shrinkWrap: true,
                                      itemCount: filteredItems.length,
                                      itemBuilder: (context, index) {
                                        final member = filteredItems[index];
                                        return Container(
                                          margin:
                                              const EdgeInsets.only(bottom: 8),
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(4),
                                              border: Border.all(
                                                  color: Colors.grey
                                                      .withOpacity(0.5))),
                                          child: ListTile(
                                            dense: true,
                                            title: Text(
                                                "${capitalizeWords(member.name.toString())} -  Floor(${member.floorNumber}) -  Aprt(${member.aprtNo}) - Tower(${member.block?.name})"),
                                            onTap: () {
                                              setState(() {
                                                residenceController.text =
                                                    member.name.toString();
                                                residenceID =
                                                    member.userId.toString();
                                              });
                                              Navigator.pop(context);
                                            },
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                          ],
                        );
                      } else {
                        return const Center(
                            child: Text("Something went wrong!"));
                      }
                    },
                  ),
                ),
              ),
            );
          },
        );
      },
      transitionBuilder: (context, anim1, anim2, child) {
        return FadeTransition(
          opacity: anim1,
          child: child,
        );
      },
    );

    searchController.clear();
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
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 10.h),
                  Text('Search Resident',
                      style: GoogleFonts.nunitoSans(
                          textStyle: TextStyle(
                              color: Colors.black,
                              fontSize: 15.sp,
                              fontWeight: FontWeight.w500))),
                  SizedBox(height: 10.h),
                  TextFormField(
                    onTap: () {
                      _searchMemberCubit.fetchSearchMember('');
                      _showSearchDialog();
                    },
                    readOnly: true,
                    style: const TextStyle(color: Colors.black87, fontSize: 16),
                    controller: residenceController,
                    decoration: InputDecoration(
                      hintText: 'Search resident',
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
                          borderSide: BorderSide(color: AppTheme.greyColor)),
                    ),
                    // scrollbarDecoration: ScrollbarDecoration(
                    //     controller: ScrollController(),
                    //     theme: const ScrollbarThemeData(
                    //         radius: Radius.circular(5))),
                    // future: () async {
                    //   return await fetchData(
                    //       residenceController.text.toString());
                    // },
                  ),
                  SizedBox(height: 10.h),
                  Text('Parcel ID',
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
                          return 'Please enter parcel ID';
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                        hintText: 'Enter parcel ID',
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
                            onTap: () {},
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
                                  onTap: () {},
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
                                  onTap: () {},
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
                  SizedBox(height: 10.h),
                  Text('Delivery Partner Name',
                      style: GoogleFonts.nunitoSans(
                          textStyle: TextStyle(
                              color: Colors.black,
                              fontSize: 15.sp,
                              fontWeight: FontWeight.w500))),
                  SizedBox(height: 10.h),
                  SizedBox(
                    width: MediaQuery.of(context).size.width,
                    child: TextFormField(
                      controller: deliverNameController,
                      style: GoogleFonts.nunitoSans(
                        color: Colors.black,
                        fontSize: 15.sp,
                        fontWeight: FontWeight.w500,
                      ),
                      keyboardType: TextInputType.text,
                      validator: (text) {
                        if (text == null || text.isEmpty) {
                          return 'Please enter delivery partner name';
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                        hintText: 'Enter delivery partner name',
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
                  Text('Delivery Partner Number',
                      style: GoogleFonts.nunitoSans(
                          textStyle: TextStyle(
                              color: Colors.black,
                              fontSize: 15.sp,
                              fontWeight: FontWeight.w500))),
                  SizedBox(height: 10.h),
                  SizedBox(
                    width: MediaQuery.of(context).size.width,
                    child: TextFormField(
                      controller: deliverPhoneController,
                      maxLength: 10,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      style: GoogleFonts.nunitoSans(
                          color: Colors.black,
                          fontSize: 15.sp,
                          fontWeight: FontWeight.w500),
                      keyboardType: TextInputType.number,
                      validator: (text) {
                        if (text == null || text.isEmpty) {
                          return 'Please enter delivery partner number';
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                        counter: const SizedBox(),
                        hintText: 'Enter delivery partner number',
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
                  SizedBox(height: 5.h),
                  Text('Parcel From',
                      style: GoogleFonts.nunitoSans(
                          textStyle: TextStyle(
                              color: Colors.black,
                              fontSize: 15.sp,
                              fontWeight: FontWeight.w500))),
                  SizedBox(height: 10.h),
                  SizedBox(
                    width: MediaQuery.of(context).size.width,
                    child: TextFormField(
                      controller: senderController,
                      style: GoogleFonts.nunitoSans(
                          color: Colors.black,
                          fontSize: 15.sp,
                          fontWeight: FontWeight.w500),
                      validator: (text) {
                        if (text == null || text.isEmpty) {
                          return 'Please enter parcel from';
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                        hintText: 'Enter parcel from name',
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
                  Text('Select Delivery Option',
                      style: GoogleFonts.nunitoSans(
                          textStyle: TextStyle(
                              color: Colors.black,
                              fontSize: 15.sp,
                              fontWeight: FontWeight.w500))),
                  SizedBox(height: 10.h),
                  Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: List.generate(
                          2,
                          (index) => GestureDetector(
                              onTap: () =>
                                  setState(() => selectedIndex = index),
                              child: Container(
                                  margin: const EdgeInsets.only(right: 30),
                                  alignment: Alignment.center,
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 15, vertical: 8),
                                  decoration: BoxDecoration(
                                      border: Border.all(
                                          color: selectedIndex == index
                                              ? AppTheme.primaryColor
                                              : Colors.blueGrey
                                                  .withOpacity(0.1)),
                                      borderRadius: BorderRadius.circular(8),
                                      color: selectedIndex == index
                                          ? AppTheme.primaryColor
                                              .withOpacity(0.3)
                                          : Colors.grey.withOpacity(0.3)),
                                  child: Text(index == 0 ? 'To Security Guard' : 'To Resident',
                                      style: GoogleFonts.nunitoSans(
                                          textStyle:
                                              TextStyle(color: selectedIndex == index ? AppTheme.primaryColor : Colors.black45, fontSize: 14.sp, fontWeight: FontWeight.w500))))))),
                  Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: Text('Upload Photos',
                          style: GoogleFonts.nunitoSans(
                              textStyle: TextStyle(
                                  color: Colors.black87,
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.w400)))),
                  uploadWidget(
                      context: context,
                      onTap: () {
                        uploadFileWidget(
                            context: context,
                            fromCamera: () {
                              fromCamera(context);
                            },
                            fromGallery: () {
                              fromGallery(context);
                            });
                      },
                      onRemove: (index) {
                        setState(() => croppedImagesList!.removeAt(index));
                      },
                      croppedImagesList: croppedImagesList),
                  const SizedBox(height: 50),
                  GestureDetector(
                    onTap: () {
                      FocusScope.of(context).unfocus();

                      if (_formKey.currentState!.validate()) {
                        if (parcelTypes == null) {
                          snackBar(context, 'Kindly select type of parcels',
                              Icons.done, AppTheme.redColor);
                        } else if (numberOfParcel == null) {
                          snackBar(context, 'Kindly select no. of parcels',
                              Icons.done, AppTheme.redColor);
                        } else if (numberOfParcel == null) {
                          snackBar(context, 'Kindly select no. of parcels',
                              Icons.done, AppTheme.redColor);
                        } else if (croppedImagesList!.isEmpty) {
                          snackBar(
                              context,
                              'Kindly upload delivery agent picture',
                              Icons.done,
                              AppTheme.redColor);
                        } else {
                          documentFiles.clear();
                          for (int i = 0; i < croppedImagesList!.length; i++) {
                            documentFiles.add(File(croppedImagesList![i].path));
                          }
                          /*   var parcelsBody = {
                            "parcelid":
                                parcelIDController.text.toString(),
                            "parcel_name":
                                nameController.text.toString(),
                            "no_of_parcel": numberOfParcel.toString(),
                            "parcel_type": parcelTypes.toString(),
                            "delivery_name":
                                deliverNameController.text.toString(),
                            "date": date!.text,
                            "time": time!.text,
                            "delivery_phone": deliverPhoneController
                                .text
                                .toString(),
                            "parcel_of": residenceID.toString(),
                            "delivery_option": selectedIndex == 0
                                ? "Security Guard"
                                : "Resident"
                          };*/

                          context.read<ParcelManagementCubit>().createParcelAPI(
                              parcelId: parcelIDController.text.toString(),
                              parcelName: nameController.text.toString(),
                              numberOfParcel: numberOfParcel.toString(),
                              parcelType: parcelTypes.toString(),
                              deliveryName:
                                  deliverNameController.text.toString(),
                              deliveryPhone:
                                  deliverPhoneController.text.toString(),
                              date: date!.text.toString(),
                              time: time!.text.toString(),
                              senderName: senderController.text.toString(),
                              parcelOfId: residenceID.toString(),
                              deliveryOption: selectedIndex == 0
                                  ? "Security Guard"
                                  : "Resident",
                              profilePicture: documentFiles.first);
                        }
                      }
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Container(
                        width: double.infinity,
                        height: 50,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(30),
                            color: AppTheme.primaryColor),
                        child: Center(
                          child: Text(
                            'Submit ',
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
