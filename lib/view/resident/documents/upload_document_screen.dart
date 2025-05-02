import 'dart:io';
import 'package:dotted_border/dotted_border.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:flutter_document_picker/flutter_document_picker.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ghp_society_management/constants/app_theme.dart';
import 'package:ghp_society_management/constants/dialog.dart';
import 'package:ghp_society_management/constants/snack_bar.dart';
import 'package:ghp_society_management/controller/upload_document/upload_document_cubit.dart';
import 'package:ghp_society_management/controller/documents_element/document_elements_cubit.dart';
import 'package:ghp_society_management/model/incoming_documents_model.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class UploadDocumentScreen extends StatefulWidget {
  final IncomingRequestData incomingRequestData;
  const UploadDocumentScreen({super.key, required this.incomingRequestData});

  @override
  State<UploadDocumentScreen> createState() => _UploadDocumentScreenState();
}

class _UploadDocumentScreenState extends State<UploadDocumentScreen> {
  String? selectedValue;
  List<File> documentFiles = [];
  final formkey = GlobalKey<FormState>();
  final TextEditingController documentName = TextEditingController();
  final TextEditingController description = TextEditingController();
  final TextEditingController documentsType = TextEditingController();
  late BuildContext dialogueContext;

  @override
  void initState() {
    super.initState();
    documentName.text = widget.incomingRequestData.subject.toString();
    description.text = widget.incomingRequestData.description.toString();
    documentsType.text = widget.incomingRequestData.fileType != null
        ? widget.incomingRequestData.fileType.toString()
        : 'docs';
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<UploadDocumentCubit, UploadDocumentState>(
      listener: (context, state) async {
        if (state is UploadDocumentLoading) {
          showLoadingDialog(context, (ctx) {
            dialogueContext = ctx;
          });
        } else if (state is UploadDocumentSuccessfully) {
          snackBar(context, state.successMsg.toString(), Icons.done,
              AppTheme.guestColor);
          Navigator.of(dialogueContext).pop();
          Navigator.of(context).pop();
        } else if (state is UploadDocumentFailed) {
          snackBar(context, state.errorMsg.toString(), Icons.warning,
              AppTheme.redColor);
          Navigator.of(dialogueContext).pop();
        } else if (state is DocumentElementInternetError) {
          snackBar(context, 'Internet connection failed', Icons.wifi_off,
              AppTheme.redColor);

          Navigator.of(dialogueContext).pop();
        }
      },
      child: Scaffold(
        backgroundColor: AppTheme.backgroundColor,
        bottomNavigationBar: Container(
          color: Colors.white,
          child: GestureDetector(
            onTap: () {
              if (formkey.currentState!.validate()) {
                if (documentFiles.isEmpty) {
                  snackBar(context, 'Kindly upload document files', Icons.crop,
                      AppTheme.redColor);
                } else {
                  context.read<UploadDocumentCubit>().updateDocument(context,
                      widget.incomingRequestData.id.toString(), documentFiles);
                }
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
                  child: Text('Upload Document',
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
        body: SafeArea(
            child: Form(
              key: formkey,
              child: Column(
                children: [
                  SizedBox(height: 20.h),
                  Row(children: [
                    SizedBox(width: 10.w),
                    GestureDetector(
                        onTap: () {
                          Navigator.of(context).pop();
                        },
                        child: const Icon(Icons.arrow_back, color: Colors.white)),
                    SizedBox(width: 10.w),
                    Expanded(
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Upload Document',
                                  style: GoogleFonts.nunitoSans(
                                      textStyle: TextStyle(
                                          color: Colors.white,
                                          fontSize: 20.sp,
                                          fontWeight: FontWeight.w600)))
                            ])),
                    SizedBox(width: 10.w)
                  ]),
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
                            padding: const EdgeInsets.all(12),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(height: 10.h),
                                Text('Document Name',
                                    style: GoogleFonts.nunitoSans(
                                      textStyle: TextStyle(
                                        color: Colors.black,
                                        fontSize: 15.sp,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    )),
                                SizedBox(height: 10.h),
                                SizedBox(
                                  width: MediaQuery.of(context).size.width,
                                  child: TextFormField(
                                    readOnly: true,
                                    controller: documentName,
                                    style: GoogleFonts.nunitoSans(
                                      color: Colors.black,
                                      fontSize: 15.sp,
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
                                SizedBox(height: 10.h),
                                Text('Document Type',
                                    style: GoogleFonts.nunitoSans(
                                      textStyle: TextStyle(
                                        color: Colors.black,
                                        fontSize: 15.sp,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    )),
                                SizedBox(height: 10.h),
                                SizedBox(
                                  width: MediaQuery.of(context).size.width,
                                  child: TextFormField(
                                    readOnly: true,
                                    controller: documentsType,
                                    style: GoogleFonts.nunitoSans(
                                      color: Colors.black,
                                      fontSize: 15.sp,
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
                                SizedBox(height: 10.h),
                                Text('Description',
                                    style: GoogleFonts.nunitoSans(
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
                                    readOnly: true,
                                    controller: description,
                                    maxLines: 5,
                                    style: GoogleFonts.nunitoSans(
                                      color: Colors.black,
                                      fontSize: 15.sp,
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
                                SizedBox(
                                  height: 10.h,
                                ),
                                Text('Documents',
                                    style: GoogleFonts.nunitoSans(
                                      textStyle: TextStyle(
                                        color: Colors.black,
                                        fontSize: 15.sp,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    )),
                                Text('Upload related attachment files',
                                    style: GoogleFonts.nunitoSans(
                                      textStyle: TextStyle(
                                        color: AppTheme.primaryColor,
                                        fontSize: 12.sp,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    )),
                                SizedBox(height: 10.h),
                                Row(children: [
                                  GestureDetector(
                                    onTap: () async {
                                      showBottomSheet(context);
                                    },
                                    child: DottedBorder(
                                      borderType: BorderType.RRect,
                                      radius: const Radius.circular(12),
                                      dashPattern: const [8, 2],
                                      color: AppTheme.primaryColor,
                                      strokeWidth: 1,
                                      child: SizedBox(
                                        width: 100.w,
                                        height: 115.h,
                                        child: Icon(
                                          Icons.add,
                                          color: AppTheme.primaryColor,
                                        ),
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                      child: SizedBox(
                                        width: MediaQuery.of(context).size.width,
                                        height: 120.h,
                                        child: ListView.builder(
                                            shrinkWrap: true,
                                            scrollDirection: Axis.horizontal,
                                            itemCount: documentFiles.length,
                                            itemBuilder: (context, index) {
                                              return Padding(
                                                padding: EdgeInsets.only(left: 8.w),
                                                child: Stack(
                                                  alignment: Alignment.topRight,
                                                  children: [
                                                    Container(
                                                        decoration: BoxDecoration(
                                                            borderRadius:
                                                            BorderRadius.circular(
                                                                10),
                                                            border: Border.all(
                                                                color: AppTheme
                                                                    .primaryColor)),
                                                        width: 100.w,
                                                        height: 120.h,
                                                        child: ClipRRect(
                                                          borderRadius:
                                                          BorderRadius.circular(10),
                                                          child: (documentFiles[index]
                                                              .path
                                                              .contains('.pdf'))
                                                              ? SfPdfViewer.file(
                                                              documentFiles[index])
                                                              : Image.file(
                                                              documentFiles[index],
                                                              fit: BoxFit.cover),
                                                        )),
                                                    Padding(
                                                      padding:
                                                      const EdgeInsets.all(8.0),
                                                      child: GestureDetector(
                                                        onTap: () {
                                                          documentFiles.removeAt(index);
                                                          setState(() {});
                                                        },
                                                        child: Container(
                                                          decoration: BoxDecoration(
                                                              borderRadius:
                                                              BorderRadius.circular(
                                                                  1000),
                                                              color:
                                                              const Color.fromARGB(
                                                                  255,
                                                                  143,
                                                                  40,
                                                                  32)),
                                                          child: const Icon(
                                                            CupertinoIcons.minus,
                                                            color: Colors.white,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              );
                                            }),
                                      ))
                                ]),
                              ],
                            ),
                          ),
                        )),
                  ),
                ],
              ),
            )),
      ),
    );
  }

  void showBottomSheet(context) {
    final editProfileOptionList = ['Upload a Photo', 'Upload a Document'];
    final editProfileOptionIconsList = [
      Icons.image_outlined,
      Icons.edit_document
    ];
    showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      enableDrag: false,
      builder: (BuildContext context) {
        return Container(
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(20),
              ),
            ),
            padding: const EdgeInsets.all(15),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                const SizedBox(height: 10),
                Container(
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey[300]!),
                      borderRadius: BorderRadius.circular(10)),
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: editProfileOptionList.length,
                    itemBuilder: (context, index) {
                      return Column(
                        children: [
                          ListTile(
                            onTap: () async {
                              final ImagePicker picker = ImagePicker();
                              XFile? pickedImage;
                              if (index == 0) {
                                pickedImage = await picker.pickImage(
                                    source: ImageSource.gallery);
                                if (pickedImage != null) {
                                  final result = await cropAndCompressImage(
                                      File(pickedImage.path));
                                  documentFiles.add(File(result!.path));
                                }
                              } else {
                                FilePickerResult? result =
                                    await FilePicker.platform.pickFiles(
                                  type: FileType.custom,
                                  allowedExtensions: [
                                    'pdf',
                                    'doc',
                                    'docx',
                                    'txt'
                                  ],
                                );

                                if (result != null) {
                                  File file = File(result.files.single.path!);
                                  documentFiles.add(File(file.path));
                                }
                                //
                                // try {
                                //   final String? path = await FlutterDocumentPicker.openDocument(
                                //     params: FlutterDocumentPickerParams(
                                //       allowedMimeTypes: [
                                //         'application/pdf',
                                //         'application/msword',
                                //         'application/vnd.openxmlformats-officedocument.wordprocessingml.document',
                                //         'text/plain',
                                //       ],
                                //     ),
                                //   );
                                //
                                //   if (path != null) {
                                //     File file = File(path);
                                //     documentFiles.add(file);
                                //     print("Selected File: ${file.path}");
                                //   }
                                // } catch (e) {
                                //   print("Error picking file: $e");
                                // }
                              }
                              Navigator.of(context).pop();
                              setState(() {});
                            },
                            leading: Icon(
                              editProfileOptionIconsList[index],
                              color: AppTheme.primaryColor,
                            ),
                            title: Text(
                              editProfileOptionList[index],
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                          index == editProfileOptionIconsList.length - 1
                              ? const SizedBox()
                              : Divider(color: Colors.grey[300]),
                        ],
                      );
                    },
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.of(context).pop();
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Container(
                      width: double.infinity,
                      height: 50.h,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: AppTheme.primaryColor),
                      child: Center(
                        child: Text('Cancel ',
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
            ));
      },
    );
  }

  Future<CroppedFile?> cropAndCompressImage(File pickedImage) async {
    final croppedFile = await ImageCropper().cropImage(
      sourcePath: pickedImage.path,
      compressFormat: ImageCompressFormat.jpg,
      compressQuality: 100,
      aspectRatio: const CropAspectRatio(
          ratioX: 1, ratioY: 1), // Set the aspect ratio for a square image
      uiSettings: [
        AndroidUiSettings(
            toolbarTitle: 'Cropper',
            toolbarColor: AppTheme.backgroundColor,
            toolbarWidgetColor: Colors.white,
            aspectRatioPresets: [
              CropAspectRatioPreset.original,
              CropAspectRatioPreset.square,
              CropAspectRatioPreset.ratio4x3
            ],
            lockAspectRatio: false,
            hideBottomControls: true),
        IOSUiSettings(
            title: 'Cropper',
            aspectRatioPresets: [
              CropAspectRatioPreset.original,
              CropAspectRatioPreset.square,
              CropAspectRatioPreset.ratio4x3,
            ],
            aspectRatioLockEnabled: true,
            resetButtonHidden: true)
      ],
    );

    return croppedFile;
  }
}