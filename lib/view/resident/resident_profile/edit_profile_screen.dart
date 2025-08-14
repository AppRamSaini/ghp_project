import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ghp_society_management/constants/app_images.dart';
import 'package:ghp_society_management/constants/app_theme.dart';
import 'package:ghp_society_management/constants/crop_image.dart';
import 'package:ghp_society_management/constants/custom_btns.dart';
import 'package:ghp_society_management/constants/dialog.dart';
import 'package:ghp_society_management/constants/snack_bar.dart';
import 'package:ghp_society_management/controller/edit_profile/edit_profile_cubit.dart';
import 'package:ghp_society_management/controller/user_profile/user_profile_cubit.dart';
import 'package:ghp_society_management/view/session_dialogue.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  int selectedValue = 0;
  final formkey = GlobalKey<FormState>();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  late UserProfileCubit userProfileCubit;
  BuildContext? dialogueContext;

  @override
  void initState() {
    userProfileCubit = context.read<UserProfileCubit>();
    userProfileCubit.fetchUserProfile();
    initData();

    super.initState();
  }

  String imgFile = '';
  File? imageFile;

  initData() {
    nameController.text =
        userProfileCubit.userProfile.first.data!.user!.name.toString();
    phoneController.text =
        userProfileCubit.userProfile.first.data!.user!.phone.toString();
    emailController.text =
        userProfileCubit.userProfile.first.data!.user!.email ?? '';
    imgFile = userProfileCubit.userProfile.first.data!.user!.image.toString();
    setState(() {});
  }

  final ImagePicker picker = ImagePicker();

  @override
  Widget build(BuildContext context) {
    print('$imgFile');

    return BlocListener<EditProfileCubit, EditProfileState>(
      listener: (context, state) async {
        if (state is EditProfileLoading) {
          showLoadingDialog(context, (ctx) {
            dialogueContext = ctx;
          });
        } else if (state is EditProfileSuccessfully) {
          snackBar(context, 'User profile updated successfully', Icons.done,
              AppTheme.guestColor);
          Navigator.of(dialogueContext!).pop();
          context.read<UserProfileCubit>().fetchUserProfile();
          Navigator.of(context).pop();
        } else if (state is EditProfileFailed) {
          snackBar(context, state.errorMsg.toString(), Icons.warning,
              AppTheme.redColor);
          Navigator.of(dialogueContext!).pop();
          Navigator.of(context).pop();
        } else if (state is EditProfileInternetError) {
          snackBar(context, 'Internet connection failed', Icons.wifi_off,
              AppTheme.redColor);
          Navigator.of(dialogueContext!).pop();
          Navigator.of(context).pop();
        } else if (state is EditProfileLogout) {
          Navigator.of(dialogueContext!).pop();
          sessionExpiredDialog(context);
        }
      },
      child: Scaffold(
        appBar: appbarWidget(title: 'Edit Profile'),
        body: Column(
          children: [
            Expanded(
              child: GestureDetector(
                onTap: () => FocusScope.of(context).unfocus(),
                child: Form(
                  key: formkey,
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.all(15),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Align(
                            alignment: Alignment.center,
                            child: Stack(
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(200),
                                  child: SizedBox(
                                    height: 120,
                                    width: 120,
                                    child: imageFile != null
                                        ? Image.file(
                                            imageFile!,
                                            fit: BoxFit.cover,
                                            errorBuilder: (_, __, ___) =>
                                                Image.asset(
                                              'assets/images/default.jpg',
                                              fit: BoxFit.cover,
                                            ),
                                          )
                                        : (imgFile != null &&
                                                imgFile.isNotEmpty)
                                            ? FadeInImage(
                                                fit: BoxFit.cover,
                                                placeholder: AssetImage(
                                                    'assets/images/default.jpg'),
                                                image: NetworkImage(imgFile),
                                                imageErrorBuilder:
                                                    (_, __, ___) => Image.asset(
                                                  'assets/images/default.jpg',
                                                  fit: BoxFit.cover,
                                                ),
                                              )
                                            : Image.asset(
                                                'assets/images/default.jpg',
                                                fit: BoxFit.cover,
                                              ),
                                  ),
                                ),
                                Positioned(
                                  top: 75,
                                  left: 80,
                                  child: GestureDetector(
                                    onTap: () {
                                      uploadFileWidget(
                                        context: context,
                                        fromGallery: () async {
                                          pickAndCropImage(
                                              source: ImageSource.gallery);
                                        },
                                        fromCamera: () async {
                                          pickAndCropImage(
                                              source: ImageSource.camera);
                                        },
                                      );
                                    },
                                    child: Image.asset(
                                      ImageAssets.cameraImage,
                                      height: 40,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 50.h),
                          Text('Name',
                              style: GoogleFonts.nunitoSans(
                                textStyle: TextStyle(
                                  color: Colors.black,
                                  fontSize: 15.sp,
                                  fontWeight: FontWeight.w500,
                                ),
                              )),
                          SizedBox(height: 10.h),
                          TextFormField(
                            controller: nameController,
                            style: GoogleFonts.nunitoSans(
                              color: AppTheme.backgroundColor,
                              fontSize: 15.sp,
                              fontWeight: FontWeight.w500,
                            ),
                            keyboardType: TextInputType.text,
                            textInputAction: TextInputAction.done,
                            validator: (text) {
                              if (text == null || text.isEmpty) {
                                return 'Please enter user name';
                              }
                              return null;
                            },
                            decoration: InputDecoration(
                              hintText: 'Enter name',
                              contentPadding: EdgeInsets.only(left: 8.w),
                              filled: true,
                              hintStyle: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 14.sp,
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
                          SizedBox(height: 10.h),
                          Text('Phone',
                              style: GoogleFonts.nunitoSans(
                                  textStyle: TextStyle(
                                      color: Colors.black,
                                      fontSize: 15.sp,
                                      fontWeight: FontWeight.w500))),
                          SizedBox(height: 10.h),
                          TextFormField(
                            controller: phoneController,
                            maxLength: 10,
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly
                            ],
                            style: GoogleFonts.nunitoSans(
                                color: AppTheme.backgroundColor,
                                fontSize: 15.sp,
                                fontWeight: FontWeight.w500),
                            keyboardType: TextInputType.text,
                            textInputAction: TextInputAction.done,
                            validator: (text) {
                              if (text == null || text.isEmpty) {
                                return 'Please enter phone number';
                              } else if (text.length < 10 || text.length > 10) {
                                return 'Phone number length must be equal to 10';
                              }
                              return null;
                            },
                            decoration: InputDecoration(
                              counter: const SizedBox(),
                              hintText: 'Enter number',
                              contentPadding: EdgeInsets.only(left: 8.w),
                              filled: true,
                              hintStyle: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 14.sp,
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
                          SizedBox(height: 10.h),
                          Text('Email',
                              style: GoogleFonts.nunitoSans(
                                  textStyle: TextStyle(
                                      color: Colors.black,
                                      fontSize: 15.sp,
                                      fontWeight: FontWeight.w500))),
                          SizedBox(height: 10.h),
                          TextFormField(
                            controller: emailController,
                            style: GoogleFonts.nunitoSans(
                                color: AppTheme.backgroundColor,
                                fontSize: 15.sp,
                                fontWeight: FontWeight.w500),
                            keyboardType: TextInputType.emailAddress,
                            textInputAction: TextInputAction.done,
                            validator: (text) {
                              if (text == null || text.isEmpty) {
                                return 'Please enter email';
                              }
                              return null;
                            },
                            decoration: InputDecoration(
                              hintText: 'Enter email',
                              contentPadding: EdgeInsets.only(left: 8.w),
                              filled: true,
                              hintStyle: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 14.sp,
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
                          SizedBox(height: 50.h),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
            customBtn(
              onTap: () {
                if (formkey.currentState!.validate()) {
                  context.read<EditProfileCubit>().editProfile(
                      nameController.text,
                      emailController.text,
                      phoneController.text,
                      imageFile);
                }
              },
              txt: "Save Changes",
            )
          ],
        ),
      ),
    );
  }

  void pickAndCropImage({required ImageSource source}) async {
    XFile? pickedImage = await picker.pickImage(source: source);
    if (pickedImage != null) {
      CroppedFile? croppedImage = await ImageCropper().cropImage(
          sourcePath: pickedImage!.path,
          aspectRatio: const CropAspectRatio(ratioX: 1, ratioY: 1),
          uiSettings: uiSettings);

      if (croppedImage != null) {
        imageFile = File(croppedImage.path);
        setState(() {});
      }
    }
  }
}

/// for global image cropper
List<PlatformUiSettings>? uiSettings = [
  AndroidUiSettings(
    toolbarTitle: 'Image Cropper',
    toolbarColor: AppTheme.backgroundColor,
    toolbarWidgetColor: Colors.white,
    initAspectRatio: CropAspectRatioPreset.original,
    lockAspectRatio: false,
    hideBottomControls: false,
    cropFrameStrokeWidth: 2,
    cropGridStrokeWidth: 1,
    showCropGrid: true,
  ),
  IOSUiSettings(
    title: 'Image Cropper',
    aspectRatioPresets: [
      CropAspectRatioPreset.original,
      CropAspectRatioPreset.square,
      CropAspectRatioPreset.ratio4x3
    ],
    aspectRatioLockEnabled: true,
    resetButtonHidden: false,
    rotateButtonsHidden: false,
  )
];
