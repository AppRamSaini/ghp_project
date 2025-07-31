import 'dart:io';

import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ghp_society_management/constants/app_images.dart';
import 'package:ghp_society_management/constants/app_theme.dart';
import 'package:ghp_society_management/constants/dialog.dart';
import 'package:ghp_society_management/constants/snack_bar.dart';
import 'package:ghp_society_management/controller/complants/create_complaints/create_complaints_cubit.dart';
import 'package:ghp_society_management/controller/sos_management/sos_element/sos_element_cubit.dart';
import 'package:ghp_society_management/view/session_dialogue.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';

class RegisterComplaintScreen extends StatefulWidget {
  final String categoryId;

  const RegisterComplaintScreen({super.key, required this.categoryId});

  @override
  State<RegisterComplaintScreen> createState() =>
      _RegisterComplaintScreenState();
}

class _RegisterComplaintScreenState extends State<RegisterComplaintScreen> {
  String? selectedValue;
  File? galleryFile;
  File? thumbnailFile;
  final picker = ImagePicker();

  List<File> videoList = [];
  List<File> imagesList = [];
  List<File> audioList = [];
  BuildContext? dialogueContext;
  File? audioFile;
  final controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocListener<CreateComplaintsCubit, CreateComplaintsState>(
      listener: (context, state) async {
        if (state is CreateComplaintsLoading) {
          showLoadingDialog(context, (ctx) {
            dialogueContext = ctx;
          });
        } else if (state is CreateComplaintsSuccessfully) {
          snackBar(
              context, "Complaint Submitted!", Icons.done, AppTheme.guestColor);

          Navigator.of(dialogueContext!).pop();
          Navigator.of(context).pop();
        } else if (state is CreateComplaintsFailed) {
          snackBar(context, state.errorMsg.toString(), Icons.warning,
              AppTheme.redColor);

          Navigator.of(dialogueContext!).pop();
        } else if (state is CreateComplaintsInternetError) {
          snackBar(context, 'Internet connection failed', Icons.wifi_off,
              AppTheme.redColor);

          Navigator.of(dialogueContext!).pop();
        } else if (state is CreateComplaintsLogout) {
          Navigator.of(dialogueContext!).pop();
          sessionExpiredDialog(context);
        }
      },
      child: Scaffold(
        appBar: appbarWidget(title: 'Register Complaint'),
        bottomNavigationBar: GestureDetector(
          onTap: () {
            if (selectedValue == null) {
              snackBar(context, 'Please select area', Icons.wifi_off,
                  AppTheme.redColor);
            } else if (controller.text.isEmpty) {
              snackBar(context, 'Please enter some description', Icons.wifi_off,
                  AppTheme.redColor);
            } else {
              context.read<CreateComplaintsCubit>().createComplaints(
                  serviceCategoryId: widget.categoryId.toString(),
                  area: selectedValue.toString(),
                  description: controller.text.toString(),
                  imageList: imagesList,
                  videoList: videoList,
                  audioList: audioList);
            }
          },
          child: Container(
            color: Colors.white,
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
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 10.h),
                Text('Area',
                    style: GoogleFonts.nunitoSans(
                      textStyle: TextStyle(
                        color: Colors.black,
                        fontSize: 15.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    )),
                SizedBox(height: 10.h),
                BlocBuilder<SosElementCubit, SosElementState>(
                  builder: (context, state) {
                    if (state is SosElementLoaded) {
                      return DropdownButton2<String>(
                          hint: const Text('--select--',
                              style:
                                  TextStyle(color: Colors.grey, fontSize: 14)),
                          underline: Container(color: Colors.transparent),
                          isExpanded: true,
                          value: selectedValue,
                          items: state.sosElement.first.data.areas
                              .map((item) => DropdownMenuItem<String>(
                                  value: item.name,
                                  child: Text(item.name,
                                      style: const TextStyle(
                                          fontSize: 14, color: Colors.black))))
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
                                  borderRadius: BorderRadius.circular(10))),
                          dropdownStyleData: DropdownStyleData(
                              maxHeight: MediaQuery.sizeOf(context).height / 2,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10))),
                          menuItemStyleData: const MenuItemStyleData(
                              padding: EdgeInsets.symmetric(horizontal: 16)));
                    } else {
                      return const SizedBox();
                    }
                  },
                ),
                SizedBox(height: 10.h),
                Text('Complaint Description',
                    style: GoogleFonts.nunitoSans(
                        textStyle: TextStyle(
                            color: Colors.black,
                            fontSize: 15.sp,
                            fontWeight: FontWeight.w600))),
                SizedBox(height: 10.h),
                SizedBox(
                  width: MediaQuery.of(context).size.width,
                  child: TextFormField(
                    controller: controller,
                    maxLines: 5,
                    style: GoogleFonts.nunitoSans(
                        color: Colors.black,
                        fontSize: 15.sp,
                        fontWeight: FontWeight.w500),
                    decoration: InputDecoration(
                      hintText: 'Enter your description..',
                      contentPadding: EdgeInsets.symmetric(
                          vertical: 12.h, horizontal: 10.0),
                      filled: true,
                      hintStyle: TextStyle(
                          color: Colors.grey,
                          fontSize: 14.sp,
                          fontWeight: FontWeight.normal),
                      fillColor: AppTheme.greyColor,
                      errorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15.0),
                        borderSide: BorderSide(color: AppTheme.greyColor),
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
                Text('Upload Media',
                    style: GoogleFonts.nunitoSans(
                      textStyle: TextStyle(
                        color: Colors.black,
                        fontSize: 15.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    )),
                SizedBox(height: 10.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    GestureDetector(
                        onTap: () {
                          // if (imagesList.length < 2) {
                          //
                          // } else {
                          //   snackbarMessage(context);
                          // }

                          _showPicker(context: context);
                        },
                        child: Image.asset(ImageAssets.galleryImage,
                            height: 90.h, width: 100.w)),
                    GestureDetector(
                        onTap: () {
                          // if (videoList.length < 2) {
                          //   _showPicker(
                          //       context: context, isPickVideo: true);
                          // } else {
                          //   snackbarMessage(context);
                          // }
                          _showPicker(context: context, isPickVideo: true);
                        },
                        child: Image.asset(ImageAssets.videoImage,
                            height: 90.h, width: 100.w)),
                    GestureDetector(
                      onTap: () {
                        // if (audioList.length < 2) {
                        //   getMP3();
                        // } else {
                        //   snackbarMessage(context);
                        // }
                        getMP3();
                      },
                      child: Image.asset(ImageAssets.audioImage,
                          height: 90.h, width: 100.w),
                    ),
                  ],
                ),
                Wrap(
                  children: [
                    _buildMediaGrid(imagesList, videoList, audioList),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showPicker({required BuildContext context, bool isPickVideo = false}) {
    final List<String> editProfileOptionList = [
      'Take By Camera',
      'Select From Gallery',
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
                            if (index == 1) {
                              if (isPickVideo) {
                                getVideo(ImageSource.gallery);
                              } else {
                                getImage(ImageSource.gallery);
                              }
                            } else if (index == 0) {
                              if (isPickVideo) {
                                getVideo(ImageSource.camera);
                              } else {
                                getImage(ImageSource.camera);
                              }
                            }
                            Navigator.of(context).pop();
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
                  padding: const EdgeInsets.all(12.0),
                  child: Container(
                    width: double.infinity,
                    height: 50,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
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

  /// Function to pick an MP3 file
  Future<void> getMP3() async {
    if (audioList.isNotEmpty) {
      snackbarMessage(context, "You can only upload 1 MP3 file.");
      return;
    }

    FilePickerResult? result = await FilePicker.platform
        .pickFiles(type: FileType.custom, allowedExtensions: ['mp3', 'aac']);
    if (result != null) {
      setState(() {
        audioFile = File(result.files.single.path!);
        audioList.add(audioFile!);
      });
    }
    // try {
    //   final String? path = await FlutterDocumentPicker.openDocument(
    //     params: FlutterDocumentPickerParams(
    //       allowedMimeTypes: [
    //         'audio/mpeg', // MP3 Files
    //         'audio/aac',  // AAC Files
    //       ],
    //     ),
    //   );
    //
    //   if (path != null) {
    //     File audioFile = File(path);
    //     audioList.add(audioFile);
    //     print("Selected Audio File: ${audioFile.path}");
    //   }
    // } catch (e) {
    //   print("Error picking file: $e");
    // }
  }

  /// GET IMAGE BY GALLERY
  Future<void> getImage(ImageSource img) async {
    if ((videoList.isNotEmpty || audioList.isNotEmpty) &&
        imagesList.length >= 1) {
      snackbarMessage(
          context, "You can only upload 1 image if video or MP3 is selected.");
      return;
    } else if (videoList.isEmpty &&
        audioList.isEmpty &&
        imagesList.length >= 3) {
      snackbarMessage(context, "You can only upload up to 3 images.");
      return;
    }

    final pickedFile = await picker.pickImage(source: img);
    if (pickedFile != null) {
      setState(() {
        imagesList.add(File(pickedFile.path));
      });
    }
  }

  /// GET VIDEO FROM CAMERA  &&  GALLERY
  Future<void> getVideo(ImageSource img) async {
    if (videoList.isNotEmpty) {
      snackbarMessage(context, "You can only upload 1 video.");
      return;
    }

    final pickedFile = await picker.pickVideo(
        source: img,
        preferredCameraDevice: CameraDevice.front,
        maxDuration: const Duration(minutes: 10));
    XFile? xfilePick = pickedFile;
    if (xfilePick != null) {
      setState(() {
        galleryFile = File(pickedFile!.path);
        videoList.add(File(galleryFile!.path));
      });
      // Generate the thumbnail
      // generateThumbnail(galleryFile!.path);
    } else {
      snackbarMessage(context, "No video selected.");
    }
  }

  /// Snackbar for showing messages
  void snackbarMessage(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        duration: const Duration(seconds: 2)));
  }

  // Future generateThumbnail(String videoPath) async {
  //   final tempDir = await getTemporaryDirectory();
  //   final thumbPath = await VideoThumbnail.thumbnailFile(
  //       video: videoPath,
  //       thumbnailPath: tempDir.path,
  //       imageFormat: ImageFormat.PNG,
  //       maxHeight: 200,
  //       quality: 75);
  //   if (thumbPath != null) {
  //     thumbnailFile = File(thumbPath);
  //     setState(() {});
  //   }
  //
  //   return thumbnailFile;
  // }

  /// Function to build media grid for images, videos, and audio
  Widget _buildMediaGrid(
      List<File> imagesList, List<File> videoList, List<File> audioList) {
    // Combine all media lists
    final allMediaList = [
      ...imagesList.map((file) => MediaItem(file: file, type: MediaType.image)),
      ...videoList.map((file) => MediaItem(file: file, type: MediaType.video)),
      ...audioList.map((file) => MediaItem(file: file, type: MediaType.audio)),
    ];

    return GridView.builder(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3, // Change this to adjust the number of columns
        mainAxisSpacing: 5,
        crossAxisSpacing: 5,
        // childAspectRatio: 0.65, // Aspect ratio for items
      ),
      itemCount: allMediaList.length,
      itemBuilder: (context, index) {
        final mediaItem = allMediaList[index];
        return _buildMediaItem(mediaItem, () {
          setState(() {
            if (mediaItem.type == MediaType.image) {
              imagesList.remove(mediaItem.file);
            } else if (mediaItem.type == MediaType.video) {
              videoList.remove(mediaItem.file);
            } else if (mediaItem.type == MediaType.audio) {
              audioList.remove(mediaItem.file);
            }
          });
        });
      },
    );
  }

// Function to build individual media item
  Widget _buildMediaItem(MediaItem mediaItem, VoidCallback onRemove) {
    if (mediaItem.type == MediaType.image) {
      return _buildImageItem(mediaItem.file, onRemove);
    } else if (mediaItem.type == MediaType.video) {
      return _buildVideoItem(mediaItem.file, onRemove);
    } else {
      return _buildAudioItem(mediaItem.file, onRemove);
    }
  }

// Function to build individual image item
  Widget _buildImageItem(File file, VoidCallback onRemove) {
    return Stack(
      alignment: Alignment.topRight,
      children: [
        Container(
          margin: const EdgeInsets.only(right: 10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.grey),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.file(
              file,
              width: 100,
              height: 120,
              fit: BoxFit.cover,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(right: 10),
          child: GestureDetector(
            onTap: onRemove,
            child: CircleAvatar(
              radius: 15,
              backgroundColor: Colors.red.withOpacity(0.8),
              child: const Icon(Icons.remove, size: 18, color: Colors.white),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildVideoItem(File file, VoidCallback onRemove) {
    return Stack(
      alignment: Alignment.topRight,
      children: [
        Container(
          margin: const EdgeInsets.only(right: 10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.grey),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Stack(
              children: [
                // अगर thumbnailFile null है तो डिफ़ॉल्ट इमेज दिखाओ
                thumbnailFile != null
                    ? Image.file(
                        thumbnailFile!,
                        width: 100,
                        height: 120,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) {
                          return Image.asset('assets/images/default.jpg',
                              fit: BoxFit.cover);
                        },
                      )
                    : Image.asset('assets/images/default.jpg',
                        width: 100, height: 120, fit: BoxFit.cover),

                Container(
                  width: 100,
                  height: 120,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                      color: Colors.deepPurpleAccent.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8)),
                  child: CircleAvatar(
                    radius: 20,
                    backgroundColor: Colors.red.withOpacity(0.8),
                    child: const Icon(Icons.play_arrow,
                        size: 40, color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(right: 10),
          child: GestureDetector(
            onTap: onRemove,
            child: CircleAvatar(
              radius: 15,
              backgroundColor: Colors.red.withOpacity(0.8),
              child: const Icon(Icons.remove, size: 18, color: Colors.white),
            ),
          ),
        ),
      ],
    );
  }

// Function to build individual audio item (remains unchanged)
  Widget _buildAudioItem(File file, VoidCallback onRemove) {
    final fileName = file.path.split('/').last;
    return Stack(
      alignment: Alignment.topRight,
      children: [
        Container(
          margin: const EdgeInsets.only(right: 10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.grey),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Container(
              width: 100,
              height: 120,
              color: Colors.blueGrey.withOpacity(0.3),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.audiotrack, size: 40),
                    Text(
                      fileName,
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.black,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(right: 10),
          child: GestureDetector(
            onTap: onRemove,
            child: CircleAvatar(
              radius: 15,
              backgroundColor: Colors.red.withOpacity(0.8),
              child: const Icon(Icons.remove, size: 18, color: Colors.white),
            ),
          ),
        ),
      ],
    );
  }
}

// Enum to define media types
enum MediaType { image, video, audio }

// Class to hold media file and type
class MediaItem {
  final File file;
  final MediaType type;

  MediaItem({required this.file, required this.type});
}
