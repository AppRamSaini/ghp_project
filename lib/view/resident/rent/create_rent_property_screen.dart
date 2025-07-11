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
import 'package:ghp_society_management/controller/rent_or_sell_property/create_rent_property/create_rent_property_cubit.dart';
import 'package:ghp_society_management/controller/rent_or_sell_property/property_element/property_element_cubit.dart';
import 'package:ghp_society_management/controller/user_profile/user_profile_cubit.dart';
import 'package:ghp_society_management/view/session_dialogue.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

class RentPropertyScreen extends StatefulWidget {
  const RentPropertyScreen({super.key});

  @override
  State<RentPropertyScreen> createState() => _RentPropertyScreenState();
}

class _RentPropertyScreenState extends State<RentPropertyScreen> {
  String? selectedAmenities;
  List<File> documentFiles = [];
  List<String> amenitiesList = [];

  late PropertyElementCubit _propertyElementCubit;

  TextEditingController dateController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController numberController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController rentController = TextEditingController();
  TextEditingController securityDepositController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _propertyElementCubit = PropertyElementCubit()..fetchPropertyElement();
    userProfileCubit = context.read<UserProfileCubit>();
    userProfileCubit.fetchUserProfile();
    initData();
  }

  final formkey = GlobalKey<FormState>();

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
    );
    if (picked != null) {
      String newFormattedDate = DateFormat('yyyy-MM-dd').format(picked);
      setState(() {
        dateController.text = newFormattedDate;
      });
    }
  }

  BuildContext? dialogueContext;
  List<CroppedFile>? croppedImagesList = [];
  fromCamera(BuildContext context) async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.camera);
    if (pickedFile != null) {
      croppedImagesList!.add(await cropImage(pickedFile.path));
      setState(() {});
    }
  }

  fromGallery(BuildContext context) async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      croppedImagesList!.add(await cropImage(pickedFile.path));
      setState(() {});
    }
  }

  late UserProfileCubit userProfileCubit;

  String? towerName;
  String? floorNo;
  String? propertyType;
  String? aptNo;
  String? bhkType;
  String? areaSt;
  String? blockId;

  initData() {
    towerName = userProfileCubit.userProfile.first.data!.user!.blockInfo!.name
        .toString();
    floorNo = userProfileCubit.userProfile.first.data!.user!.blockInfo!.floor
        .toString();
    propertyType = userProfileCubit
        .userProfile.first.data!.user!.blockInfo!.unitType
        .toString();
    aptNo = userProfileCubit
        .userProfile.first.data!.user!.blockInfo!.propertyNumber
        .toString();
    bhkType = userProfileCubit.userProfile.first.data!.user!.blockInfo!.bhk
        .toString();
    areaSt = userProfileCubit.userProfile.first.data!.user!.blockInfo!.unitSize
        .toString();
    blockId =
        userProfileCubit.userProfile.first.data!.user!.blockInfo!.id.toString();
    nameController.text =
        userProfileCubit.userProfile.first.data!.user!.name.toString();
    numberController.text =
        userProfileCubit.userProfile.first.data!.user!.phone.toString();
    emailController.text =
        userProfileCubit.userProfile.first.data!.user!.email.toString();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<CreateRentPropertyCubit, CreateRentPropertyState>(
      listener: (context, state) async {
        if (state is CreateRentPropertyLoading) {
          showLoadingDialog(context, (ctx) {
            dialogueContext = ctx;
          });
        } else if (state is CreateRentPropertySuccessfully) {
          snackBar(context, 'Rent property uploaded successfully', Icons.done,
              AppTheme.guestColor);
          Navigator.of(dialogueContext!).pop();
          context.read<PropertyElementCubit>().fetchPropertyElement();
          Navigator.of(context).pop();
        } else if (state is CreateRentPropertyFailed) {
          snackBar(context, 'Failed to upload rent property', Icons.warning,
              AppTheme.redColor);
          Navigator.of(dialogueContext!).pop();
        } else if (state is CreateRentPropertyInternetError) {
          snackBar(context, 'Internet connection failed', Icons.wifi_off,
              AppTheme.redColor);
          Navigator.of(dialogueContext!).pop();
        } else if (state is CreateRentPropertyLogout) {
          Navigator.of(dialogueContext!).pop();
          sessionExpiredDialog(context);
        }
      },
      child: Scaffold(
        appBar: AppBar(title:  Text('Rent My Property',
            style: GoogleFonts.nunitoSans(
                textStyle: TextStyle(
                    color: Colors.black,
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600)))),
        body: Form(
          key: formkey,
          child: BlocBuilder<PropertyElementCubit, PropertyElementState>(
                          bloc: _propertyElementCubit,
                          builder: (context, state) {
          if (state is PropertyElementLoading) {
            return Center(
                child: CircularProgressIndicator.adaptive(
                    backgroundColor: AppTheme.primaryColor));
          } else if (state is PropertyElementInternetError) {
            return Center(
                child: Text('Internet connection error!',
                    style: GoogleFonts.nunitoSans(
                        textStyle: TextStyle(
                            color: Colors.red,
                            fontSize:14,
                            fontWeight: FontWeight.w600))));
          } else if (state is PropertyElementLoaded) {
            return SingleChildScrollView(
                child: Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 10.h),
                    Text('Property Details :',
                        style: GoogleFonts.nunitoSans(
                            textStyle: TextStyle(
                                color: Colors.deepPurpleAccent,
                                fontSize:14,
                                fontWeight: FontWeight.w600))),
                    SizedBox(height: 10.h),
                    Row(
                      crossAxisAlignment:

                          CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Text('Tower Name',
                              style: GoogleFonts.nunitoSans(
                                  textStyle: TextStyle(
                                      color: Colors.black,
                                      fontSize:14,
                                      fontWeight:
                                          FontWeight.w500))),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text('Floor No',
                              style: GoogleFonts.ptSans(
                                  textStyle: TextStyle(
                                      color: Colors.black,
                                      fontSize:14,
                                      fontWeight:
                                          FontWeight.w500))),
                        ),
                      ],
                    ),
                    const SizedBox(height: 5),
                    Row(
                        crossAxisAlignment:
                            CrossAxisAlignment.start,
                        children: [
                          valueContainer(towerName.toString()),
                          const SizedBox(width: 10),
                          valueContainer(floorNo.toString())
                        ]),
                    SizedBox(height: 20.h),
                    Row(
                      crossAxisAlignment:
                          CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Text('Property Type',
                              style: GoogleFonts.nunitoSans(
                                  textStyle: TextStyle(
                                      color: Colors.black,
                                      fontSize:14,
                                      fontWeight:
                                          FontWeight.w500))),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text('Apartment No',
                              style: GoogleFonts.ptSans(
                                  textStyle: TextStyle(
                                      color: Colors.black,
                                      fontSize:14,
                                      fontWeight:
                                          FontWeight.w500))),
                        ),
                      ],
                    ),
                    const SizedBox(height: 5),
                    Row(
                        crossAxisAlignment:
                            CrossAxisAlignment.start,
                        children: [
                          valueContainer(propertyType.toString()),
                          const SizedBox(width: 10),
                          valueContainer(aptNo.toString())
                        ]),
                    const SizedBox(height: 20),
                    Row(
                      crossAxisAlignment:
                          CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Text('BHK Type',
                              style: GoogleFonts.nunitoSans(
                                  textStyle: TextStyle(
                                      color: Colors.black,
                                      fontSize:14,
                                      fontWeight:
                                          FontWeight.w500))),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text('Area (sq.)',
                              style: GoogleFonts.ptSans(
                                  textStyle: TextStyle(
                                      color: Colors.black,
                                      fontSize:14,
                                      fontWeight:
                                          FontWeight.w500))),
                        ),
                      ],
                    ),
                    const SizedBox(height: 5),
                    Row(
                        crossAxisAlignment:
                            CrossAxisAlignment.start,
                        children: [
                          valueContainer('$bhkType BHK'),
                          const SizedBox(width: 10),
                          valueContainer(areaSt.toString())
                        ]),
                    SizedBox(height: 20.h),
                    Text('Rental Information:',
                        style: GoogleFonts.nunitoSans(
                            textStyle: TextStyle(
                                color: Colors.deepPurpleAccent,
                                fontSize:14,
                                fontWeight: FontWeight.w600))),
                    SizedBox(height: 10.h),
                    Text('Monthly Rent Price',
                        style: GoogleFonts.nunitoSans(
                          textStyle: TextStyle(
                            color: Colors.black,
                            fontSize:14,
                            fontWeight: FontWeight.w500,
                          ),
                        )),
                    SizedBox(height: 10.h),
                    TextFormField(
                      controller: rentController,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly
                      ],
                      style: GoogleFonts.nunitoSans(
                        color: Colors.black,
                        fontSize:14,
                        fontWeight: FontWeight.w500,
                      ),
                      keyboardType: TextInputType.number,
                      validator: (text) {
                        if (text == null || text.isEmpty) {
                          return 'Please enter monthly price';
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                        contentPadding:
                            const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 12),
                        filled: true,
                        hintText: 'Monthly price',
                        hintStyle: TextStyle(
                            color: Colors.grey,
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w400),
                        fillColor: AppTheme.greyColor,
                        errorBorder: OutlineInputBorder(
                          borderRadius:
                              BorderRadius.circular(15.0),
                          borderSide: BorderSide(
                            color: AppTheme.greyColor,
                          ),
                        ),
                        focusedErrorBorder: OutlineInputBorder(
                          borderRadius:
                              BorderRadius.circular(15.0),
                          borderSide: BorderSide(
                            color: AppTheme.greyColor,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius:
                              BorderRadius.circular(15.0),
                          borderSide: BorderSide(
                            color: AppTheme.greyColor,
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius:
                              BorderRadius.circular(15.0),
                          borderSide: BorderSide(
                            color: AppTheme.greyColor,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 15.h,
                    ),
                    Text('Security Deposit',
                        style: GoogleFonts.nunitoSans(
                          textStyle: TextStyle(
                            color: Colors.black,
                            fontSize:14,
                            fontWeight: FontWeight.w500,
                          ),
                        )),
                    SizedBox(height: 10.h),
                    TextFormField(
                      controller: securityDepositController,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly
                      ],
                      style: GoogleFonts.nunitoSans(
                        color: Colors.black,
                        fontSize:14,
                        fontWeight: FontWeight.w500,
                      ),
                      keyboardType: TextInputType.number,
                      validator: (text) {
                        if (text == null || text.isEmpty) {
                          return 'Please enter security deposit';
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                        contentPadding:
                            const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 12),
                        filled: true,
                        hintText: 'Security deposit',
                        hintStyle: TextStyle(
                            color: Colors.grey,
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w400),
                        fillColor: AppTheme.greyColor,
                        errorBorder: OutlineInputBorder(
                          borderRadius:
                              BorderRadius.circular(15.0),
                          borderSide: BorderSide(
                            color: AppTheme.greyColor,
                          ),
                        ),
                        focusedErrorBorder: OutlineInputBorder(
                          borderRadius:
                              BorderRadius.circular(15.0),
                          borderSide: BorderSide(
                            color: AppTheme.greyColor,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius:
                              BorderRadius.circular(15.0),
                          borderSide: BorderSide(
                            color: AppTheme.greyColor,
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius:
                              BorderRadius.circular(15.0),
                          borderSide: BorderSide(
                            color: AppTheme.greyColor,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 15.h),
                    Text('Available From Date',
                        style: GoogleFonts.nunitoSans(
                          textStyle: TextStyle(
                            color: Colors.black,
                            fontSize:14,
                            fontWeight: FontWeight.w500,
                          ),
                        )),
                    SizedBox(
                      height: 10.h,
                    ),
                    TextFormField(
                      onTap: () => _selectDate(context),
                      readOnly: true,
                      controller: dateController,
                      style: GoogleFonts.nunitoSans(
                        color: Colors.black,
                        fontSize:14,
                        fontWeight: FontWeight.w500,
                      ),
                      keyboardType: TextInputType.number,
                      validator: (text) {
                        if (text == null || text.isEmpty) {
                          return 'Please enter select date';
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                        contentPadding:
                            const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 12),
                        hintText: 'Select date',
                        suffixIcon: const Padding(
                          padding: EdgeInsets.all(10),
                          child: Icon(
                            Icons.calendar_month_rounded,
                            color: Colors.black,
                          ),
                        ),
                        filled: true,
                        hintStyle: TextStyle(
                            color: Colors.grey,
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w400),
                        fillColor: AppTheme.greyColor,
                        errorBorder: OutlineInputBorder(
                          borderRadius:
                              BorderRadius.circular(15.0),
                          borderSide: BorderSide(
                            color: AppTheme.greyColor,
                          ),
                        ),
                        focusedErrorBorder: OutlineInputBorder(
                          borderRadius:
                              BorderRadius.circular(15.0),
                          borderSide: BorderSide(
                            color: AppTheme.greyColor,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius:
                              BorderRadius.circular(15.0),
                          borderSide: BorderSide(
                            color: AppTheme.greyColor,
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius:
                              BorderRadius.circular(15.0),
                          borderSide: BorderSide(
                            color: AppTheme.greyColor,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 20.h),
                    Text('Amenities :',
                        style: GoogleFonts.nunitoSans(
                          textStyle: TextStyle(
                            color: Colors.deepPurpleAccent,
                            fontSize:14,
                            fontWeight: FontWeight.w600,
                          ),
                        )),
                    SizedBox(height: 15.h),
                    Text('Add Amenities',
                        style: GoogleFonts.nunitoSans(
                            textStyle: TextStyle(
                                color: Colors.black,
                                fontSize:14,
                                fontWeight: FontWeight.w500))),
                    const SizedBox(height: 10),
                    DropdownButton2<String>(
                      underline:
                          Container(color: Colors.transparent),
                      isExpanded: true,
                      value: selectedAmenities,
                      hint: Text('--select--',
                          style: GoogleFonts.nunitoSans(
                              textStyle: TextStyle(
                                  color: Colors.black,
                                  fontSize:14,
                                  fontWeight: FontWeight.w500))),
                      items: state
                          .propertyElementDataList.first.amenities
                          .map((item) => DropdownMenuItem<String>(
                                value: item.name.toString(),
                                child: Text(
                                  item.name.toString(),
                                  style: const TextStyle(
                                      fontSize: 14,
                                      color: Colors.black),
                                ),
                              ))
                          .toList(),
                      onChanged: (value) {
                        setState(() {
                          selectedAmenities = value;
                          if (!amenitiesList.contains(selectedAmenities.toString())) {
                            amenitiesList.add(selectedAmenities.toString());
                          }
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
                        padding:
                            EdgeInsets.symmetric(horizontal: 16),
                      ),
                    ),
                    SizedBox(height: 10.h),
                    Wrap(
                        children: List.generate(
                      amenitiesList.length,
                      (index) => amenitiesWidget(
                          amenitiesList[index].toString(), () {
                        amenitiesList.removeAt(index);
                        setState(() {});
                      }),
                    )),
                    GestureDetector(
                      onTap: () {},
                      child: Text('Upload Photos :',
                          style: GoogleFonts.nunitoSans(
                            textStyle: TextStyle(
                              color: Colors.black,
                              fontSize:14,
                              fontWeight: FontWeight.w500,
                            ),
                          )),
                    ),
                    SizedBox(height: 10.h),
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
                          setState(() =>
                              croppedImagesList!.removeAt(index));
                        },
                        croppedImagesList: croppedImagesList),
                    SizedBox(height: 20.h),
                    Text('Contact Information:',
                        style: GoogleFonts.nunitoSans(
                          textStyle: TextStyle(
                            color: Colors.deepPurpleAccent,
                            fontSize:14,
                            fontWeight: FontWeight.w600,
                          ),
                        )),
                    SizedBox(
                      height: 10.h,
                    ),
                    Text('Your Name',
                        style: GoogleFonts.nunitoSans(
                          textStyle: TextStyle(
                            color: Colors.black,
                            fontSize:14,
                            fontWeight: FontWeight.w500,
                          ),
                        )),
                    SizedBox(
                      height: 10.h,
                    ),
                    TextFormField(
                      controller: nameController,
                      style: GoogleFonts.nunitoSans(
                        color: Colors.black,
                        fontSize:14,
                        fontWeight: FontWeight.w500,
                      ),
                      keyboardType: TextInputType.text,
                      validator: (text) {
                        if (text == null || text.isEmpty) {
                          return 'Please enter name';
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                        contentPadding:
                            const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 12),
                        hintText: 'Name',
                        filled: true,
                        hintStyle: TextStyle(
                            color: Colors.grey,
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w400),
                        fillColor: AppTheme.greyColor,
                        errorBorder: OutlineInputBorder(
                          borderRadius:
                              BorderRadius.circular(15.0),
                          borderSide: BorderSide(
                            color: AppTheme.greyColor,
                          ),
                        ),
                        focusedErrorBorder: OutlineInputBorder(
                          borderRadius:
                              BorderRadius.circular(15.0),
                          borderSide: BorderSide(
                            color: AppTheme.greyColor,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius:
                              BorderRadius.circular(15.0),
                          borderSide: BorderSide(
                            color: AppTheme.greyColor,
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius:
                              BorderRadius.circular(15.0),
                          borderSide: BorderSide(
                            color: AppTheme.greyColor,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 10.h,
                    ),
                    Text('Phone Number',
                        style: GoogleFonts.nunitoSans(
                          textStyle: TextStyle(
                            color: Colors.black,
                            fontSize:14,
                            fontWeight: FontWeight.w500,
                          ),
                        )),
                    SizedBox(
                      height: 10.h,
                    ),
                    TextFormField(
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly
                      ],
                      controller: numberController,
                      maxLength: 10,
                      style: GoogleFonts.nunitoSans(
                          color: Colors.black,
                          fontSize:14,
                          fontWeight: FontWeight.w500),
                      keyboardType: TextInputType.number,
                      validator: (text) {
                        if (text == null ||
                            text.isEmpty ||
                            text.length < 10) {
                          return 'Please enter minimum 10 digit number';
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                        contentPadding:
                            const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 12),
                        hintText: 'number',
                        filled: true,
                        counter: const SizedBox(),
                        hintStyle: TextStyle(
                            color: Colors.grey,
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w400),
                        fillColor: AppTheme.greyColor,
                        errorBorder: OutlineInputBorder(
                          borderRadius:
                              BorderRadius.circular(15.0),
                          borderSide: BorderSide(
                            color: AppTheme.greyColor,
                          ),
                        ),
                        focusedErrorBorder: OutlineInputBorder(
                          borderRadius:
                              BorderRadius.circular(15.0),
                          borderSide: BorderSide(
                            color: AppTheme.greyColor,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius:
                              BorderRadius.circular(15.0),
                          borderSide: BorderSide(
                            color: AppTheme.greyColor,
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius:
                              BorderRadius.circular(15.0),
                          borderSide: BorderSide(
                            color: AppTheme.greyColor,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 10.h,
                    ),
                    Text('Email',
                        style: GoogleFonts.nunitoSans(
                          textStyle: TextStyle(
                            color: Colors.black,
                            fontSize:14,
                            fontWeight: FontWeight.w500,
                          ),
                        )),
                    SizedBox(height: 10.h),
                    TextFormField(
                      controller: emailController,
                      style: GoogleFonts.nunitoSans(
                        color: Colors.black,
                        fontSize:14,
                        fontWeight: FontWeight.w500,
                      ),
                      keyboardType: TextInputType.emailAddress,
                      validator: (text) {
                        if (text == null ||
                            text.isEmpty ||
                            !text.contains('@')) {
                          return 'Please enter valid email';
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                        hintText: 'Enter email',
                        contentPadding:
                            const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 12),
                        filled: true,
                        hintStyle: TextStyle(
                            color: Colors.grey,
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w400),
                        fillColor: AppTheme.greyColor,
                        errorBorder: OutlineInputBorder(
                          borderRadius:
                              BorderRadius.circular(15.0),
                          borderSide: BorderSide(
                            color: AppTheme.greyColor,
                          ),
                        ),
                        focusedErrorBorder: OutlineInputBorder(
                          borderRadius:
                              BorderRadius.circular(15.0),
                          borderSide: BorderSide(
                            color: AppTheme.greyColor,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius:
                              BorderRadius.circular(15.0),
                          borderSide: BorderSide(
                            color: AppTheme.greyColor,
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius:
                              BorderRadius.circular(15.0),
                          borderSide: BorderSide(
                            color: AppTheme.greyColor,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 20.h,
                    ),
                    GestureDetector(
                      onTap: () {
                        if (formkey.currentState!.validate()) {
                          if (amenitiesList.isEmpty) {
                            snackBar(
                                context,
                                'Please select amenities type',
                                Icons.cancel,
                                AppTheme.redColor);
                          } else {
                            documentFiles.clear();
                            for (int i = 0;
                                i < croppedImagesList!.length;
                                i++) {
                              documentFiles.add(File(
                                  croppedImagesList![i].path));
                            }

                            context
                                .read<CreateRentPropertyCubit>()
                                .createRentProperty(
                                    block: blockId.toString(),
                                    floor: floorNo.toString(),
                                    unitType:
                                        propertyType.toString(),
                                    unitNumber: aptNo.toString(),
                                    bhk: bhkType.toString(),
                                    area: areaSt.toString(),
                                    monthlyRent: rentController
                                        .text
                                        .toString(),
                                    securityDeposit:
                                        securityDepositController
                                            .text
                                            .toString(),
                                    date: dateController.text
                                        .toString(),
                                    name: nameController.text
                                        .toString(),
                                    number: numberController.text
                                        .toString(),
                                    email: emailController.text
                                        .toString(),
                                    amenities: amenitiesList,
                                    files: documentFiles);
                          }
                        }
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Container(
                          width: double.infinity,
                          height: 50,
                          decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.circular(30),
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
                  ]),
            ));
          } else {
            return Center(
                child: Text('Data not Loaded!',
                    style: GoogleFonts.nunitoSans(
                        textStyle: TextStyle(
                            color: Colors.black,
                            fontSize:14,
                            fontWeight: FontWeight.w600))));
          }
                          },
                        ),
        ),
      ),
    );
  }
}

Widget valueContainer(String value) {
  return Expanded(
    child: Container(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
      decoration: BoxDecoration(
          color: AppTheme.greyColor, borderRadius: BorderRadius.circular(8)),
      child: Text(
        value.toString(),
        style: GoogleFonts.nunitoSans(
          textStyle: TextStyle(
              color: Colors.black,
              fontSize: 14,
              fontWeight: FontWeight.w500),
        ),
      ),
    ),
  );
}
