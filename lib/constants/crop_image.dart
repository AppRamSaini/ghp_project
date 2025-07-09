import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ghp_society_management/constants/app_theme.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_cropper/image_cropper.dart';

/// crop image
Future cropImage(source) async {
  CroppedFile? croppedFile = await ImageCropper().cropImage(
    sourcePath: source,
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

/// UPLOAD  FILE WIDGET
void uploadFileWidget(
    {required BuildContext context,
    Function()? fromCamera,
    Function()? fromGallery}) {
  final List<String> editProfileOptionList = [
    'Take By Camera',
    'Select From Gallery'
  ];
  final List<IconData> editProfileOptionIconsList = [
    Icons.camera_alt_outlined,
    Icons.image_outlined
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
                borderRadius: BorderRadius.circular(10),
              ),
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: editProfileOptionList.length,
                itemBuilder: (context, index) {
                  return Column(
                    children: [
                      ListTile(
                          onTap: () {
                            if (index == 0) {
                              fromCamera?.call();
                            } else if (index == 1) {
                              fromGallery?.call();
                            }
                            Navigator.of(context).pop();
                          },
                          leading: Icon(editProfileOptionIconsList[index],
                              color: AppTheme.primaryColor),
                          title: Text(editProfileOptionList[index],
                              style: const TextStyle(
                                  fontSize: 14, fontWeight: FontWeight.w500))),
                      if (index != editProfileOptionList.length - 1)
                        Divider(color: Colors.grey[300]),
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
                padding: const EdgeInsets.all(10.0),
                child: Container(
                  width: double.infinity,
                  height: 50,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    color: AppTheme.primaryColor,
                  ),
                  child: Center(
                    child: Text(
                      'Cancel',
                      style: GoogleFonts.nunitoSans(
                        textStyle: const TextStyle(
                          color: Colors.white,
                          fontSize: 14,
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
      );
    },
  );
}

// upload Image widget
Widget uploadWidget(
        {required BuildContext context,
        Function()? onTap,
        Function(int index)? onRemove,
        List<CroppedFile>? croppedImagesList}) =>
    Row(
      children: [
        GestureDetector(
            onTap: onTap!,
            child: DottedBorder(
                borderType: BorderType.RRect,
                radius: const Radius.circular(12),
                dashPattern: const [8, 2],
                color: AppTheme.primaryColor,
                strokeWidth: 1,
                child: SizedBox(
                    width: 90,
                    height: 120,
                    child: Icon(Icons.add, color: AppTheme.primaryColor)))),
        Expanded(
          child: SizedBox(
            width: MediaQuery.of(context).size.width,
            height: 120,
            child: croppedImagesList!.isEmpty
                ? const SizedBox()
                : ListView.builder(
                    shrinkWrap: true,
                    scrollDirection: Axis.horizontal,
                    itemCount: croppedImagesList.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.only(left: 8),
                        child: Stack(
                          alignment: Alignment.topRight,
                          children: [
                            Container(
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(
                                        color: AppTheme.primaryColor)),
                                width: 100,
                                height: 120,
                                child: ClipRRect(
                                    borderRadius: BorderRadius.circular(10),
                                    child: Image.file(
                                        File(croppedImagesList[index].path),
                                        fit: BoxFit.cover))),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: GestureDetector(
                                onTap: () {
                                  onRemove?.call(index);
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(1000),
                                    color:
                                        const Color.fromARGB(255, 143, 40, 32),
                                  ),
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
                    },
                  ),
          ),
        )
      ],
    );
