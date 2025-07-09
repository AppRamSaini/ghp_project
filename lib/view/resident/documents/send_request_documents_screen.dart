import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ghp_society_management/constants/app_theme.dart';
import 'package:ghp_society_management/constants/dialog.dart';
import 'package:ghp_society_management/constants/snack_bar.dart';
import 'package:ghp_society_management/controller/documents/send_request/send_request_docs_cubit.dart';
import 'package:ghp_society_management/controller/documents_element/document_elements_cubit.dart';
import 'package:google_fonts/google_fonts.dart';

class SendDocumentsRequestScree extends StatefulWidget {
  const SendDocumentsRequestScree({super.key});

  @override
  State<SendDocumentsRequestScree> createState() =>
      _SendDocumentsRequestScreeState();
}

class _SendDocumentsRequestScreeState extends State<SendDocumentsRequestScree> {
  String? selectedValue;
  int? selectedDocId;

  final formkey = GlobalKey<FormState>();
  final TextEditingController documentName = TextEditingController();
  final TextEditingController description = TextEditingController();
  late BuildContext dialogueContext;

  @override
  Widget build(BuildContext context) {
    return BlocListener<SendDocsRequestCubit, SendDocsRequestState>(
      listener: (context, state) async {
        if (state is SendDocsRequestLoading) {
          showLoadingDialog(context, (ctx) {
            dialogueContext = ctx;
          });
        } else if (state is SendDocsRequestSuccessfully) {
          snackBar(context, state.successMsg.toString(), Icons.done,
              AppTheme.guestColor);
          Navigator.of(dialogueContext).pop();
          Navigator.of(context).pop();
        } else if (state is SendDocsRequestFailed) {
          snackBar(context, state.errorMsg.toString(), Icons.warning,
              AppTheme.redColor);
          Navigator.of(dialogueContext).pop();
        } else if (state is SendDocsRequestInternetError) {
          snackBar(context, state.errorMsg.toString(), Icons.wifi_off,
              AppTheme.redColor);
          Navigator.of(dialogueContext).pop();
        }
      },
      child: Scaffold(
        appBar: AppBar(title: Text('Send Request',
            style: GoogleFonts.nunitoSans(
                textStyle: TextStyle(
                    color: Colors.black,
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600)))),
        bottomNavigationBar: Container(
          color: Colors.white,
          child: GestureDetector(
            onTap: () {
              if (formkey.currentState!.validate()) {
                if (selectedValue == null) {
                  snackBar(context, 'Kindly select document type', Icons.done,
                      AppTheme.redColor);
                } else {
                  Map requestData = {
                    "subject": documentName.text.toString(),
                    "document_type_id": selectedDocId.toString(),
                    "description": description.text.toString()
                  };
                  context
                      .read<SendDocsRequestCubit>()
                      .sendDocsRequestAPI(requestData);
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
                  child: Text('Send Request',
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
        body: Form(
          key: formkey,
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 10.h),
                  Text('Document Name',
                      style: GoogleFonts.nunitoSans(
                          textStyle: TextStyle(
                              color: Colors.black,
                              fontSize: 14,
                              fontWeight: FontWeight.w600))),
                  SizedBox(height: 10.h),
                  SizedBox(
                    width: MediaQuery.of(context).size.width,
                    child: TextFormField(
                      controller: documentName,
                      style: GoogleFonts.nunitoSans(
                        color: Colors.black,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                      keyboardType: TextInputType.text,
                      validator: (text) {
                        if (text == null || text.isEmpty) {
                          return 'Please enter document name';
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.symmetric(
                            vertical: 12.h, horizontal: 10.0),
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
                                color: AppTheme.greyColor)),
                        focusedErrorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15.0),
                            borderSide: BorderSide(
                                color: AppTheme.greyColor)),
                        focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15.0),
                            borderSide: BorderSide(
                                color: AppTheme.greyColor)),
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
                  Text('Document Type',
                      style: GoogleFonts.nunitoSans(
                        textStyle: TextStyle(
                          color: Colors.black,
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      )),
                  SizedBox(height: 10.h),
                  BlocBuilder<DocumentElementsCubit,
                      DocumentElementsState>(
                    builder: (context, state) {
                      if (state is DocumentElementLoaded) {

                        return DropdownButton2<String>(
                          underline:
                              Container(color: Colors.transparent),
                          isExpanded: true,
                          value: selectedValue,
                          hint: Text('Select document type',
                              style: GoogleFonts.nunitoSans(
                                  textStyle: TextStyle(
                                      color: Colors.grey,
                                      fontSize: 14))),
                          items: state.documentElement.first.data
                              .documentsTypes
                              .map((item) => DropdownMenuItem<String>(
                                    onTap: () {
                                      setState(() {
                                        selectedDocId =
                                            item.id.toInt();
                                      });
                                    },
                                    value: item.type,
                                    child: Text(
                                      item.type,
                                      style: const TextStyle(
                                          fontSize: 14,
                                          color: Colors.black),
                                    ),
                                  ))
                              .toList(),
                          onChanged: (value) {
                            setState(() {
                              selectedValue = value;
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
                          fontSize: 14,
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
                      style: GoogleFonts.nunitoSans(
                        color: Colors.black,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                      keyboardType: TextInputType.multiline,
                      validator: (text) {
                        if (text == null || text.isEmpty) {
                          return 'Please enter description';
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                        hintText: 'Write description here..',
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
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
