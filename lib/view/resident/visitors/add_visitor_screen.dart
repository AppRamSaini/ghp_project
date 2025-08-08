import 'dart:async';
import 'dart:io';

import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ghp_society_management/constants/app_theme.dart';
import 'package:ghp_society_management/constants/crop_image.dart';
import 'package:ghp_society_management/constants/custom_btns.dart';
import 'package:ghp_society_management/constants/dialog.dart';
import 'package:ghp_society_management/constants/local_storage.dart';
import 'package:ghp_society_management/constants/snack_bar.dart';
import 'package:ghp_society_management/controller/members/search_member/search_member_cubit.dart';
import 'package:ghp_society_management/controller/visitors/chek_in_check_out/visitors_scan/scan_visitors_cubit.dart';
import 'package:ghp_society_management/controller/visitors/create_visitors/create_visitors_cubit.dart';
import 'package:ghp_society_management/controller/visitors/visitor_request/not_responding/not_responde_cubit.dart';
import 'package:ghp_society_management/controller/visitors/visitors_element/visitors_element_cubit.dart';
import 'package:ghp_society_management/timer_countdown.dart';
import 'package:ghp_society_management/view/resident/visitors/visitor_screen.dart';
import 'package:ghp_society_management/view/security_staff/select_residents.dart';
import 'package:ghp_society_management/view/session_dialogue.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

class AddVisitorScreen extends StatefulWidget {
  bool isTypeResidence;

  AddVisitorScreen({super.key, this.isTypeResidence = false});

  @override
  State<AddVisitorScreen> createState() => _AddVisitorScreenState();
}

class _AddVisitorScreenState extends State<AddVisitorScreen> {
  String? residenceId;
  String? propertyID;

  String? selectedValue;
  List<File> documentFiles = [];
  String? typeOfVisitor;
  String? visitorFrequency;
  TextEditingController visitorName = TextEditingController();
  TextEditingController residenceController = TextEditingController();
  TextEditingController number = TextEditingController();
  TextEditingController visitorsCount = TextEditingController();
  String? visitorsNo;
  TextEditingController? date = TextEditingController();
  TextEditingController? time = TextEditingController();
  TextEditingController? vehicleNumber = TextEditingController();
  TextEditingController? purposeController = TextEditingController();
  String? validTill;
  final formkey = GlobalKey<FormState>();
  final formkey2 = GlobalKey<FormState>();
  DateTime selectedDate = DateTime.now();
  TimeOfDay selectedTime = TimeOfDay.now();
  List<Map<String, String>> usersList = [];
  TextEditingController? flatNo = TextEditingController();
  TextEditingController? blocNo = TextEditingController();
  TextEditingController? floorNo = TextEditingController();

  late SearchMemberCubit _searchMemberCubit;

  // add user to,list
  void addUserToList() {
    if (number.text.isNotEmpty && visitorName.text.isNotEmpty) {
      Map<String, String> usersMap = {
        'name': visitorName.text,
        'phone': number.text
      };
      usersList.clear();
      setState(() {
        usersList.add(usersMap);
        visitorsCount.text = usersList.length.toString();
      });
      // visitorName.clear();
      // number.clear();
    }
  }

  // remove users to list
  removeUser(int index) {
    usersList.removeAt(index);
    visitorsCount.text = usersList.length.toString();
    setState(() {});
  }

// Function to select a date
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime.now(), // Restrict to today or later
      lastDate: DateTime(2101),
    );

    if (picked != null) {
      setState(() {
        time!.clear();
        selectedDate = picked;
        String formattedDate = DateFormat('yyyy-MM-dd').format(selectedDate);
        date?.text = formattedDate;
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
  List<SearchItem> searchDataList = []; // List of SearchItem objects

/*  Future<List<SearchItem>> fetchData(String query) async {
    try {
      await _searchMemberCubit.fetchSearchMember(query);

      if (_searchMemberCubit.state is SearchMemberLoaded) {
        List<SearchMemberInfo> searchMemberInfo =
            _searchMemberCubit.searchMemberInfo;
        print(searchMemberInfo);
        List<SearchItem> memberItems = [];
        for (var member in searchMemberInfo) {
          memberItems.add(SearchItem(
              label: member.name.toString(),
              id: member.userId!.toInt(),
              floor: member.floorNumber!.toString(),
              block: member.block!.name.toString(),
              flat: member.aprtNo.toString()));
        }

        searchDataList = memberItems;
        print('Member Names and IDs: ${searchDataList.map((item) => {
          'label': item.label,
          'id': item.id
        }).toList()}');
      }
    } catch (error) {
      print("Error fetching members: $error");
      searchDataList = [];
    }

    setState(() {});
    return searchDataList;
  }*/

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

    print('------>>>>>$pickedFile');
    if (pickedFile != null) {
      croppedImagesList!.clear();
      croppedImagesList!.add(await cropImage(pickedFile.path));
      setState(() {});
    }
  }

  @override
  void initState() {
    super.initState();
    _searchMemberCubit = SearchMemberCubit();
    _searchMemberCubit.fetchSearchMember('');
    setVisitorsCount();
    if (!widget.isTypeResidence) {
      updateDate();
    }
  }

  setVisitorsCount() {
    visitorsCount.text = '1';
    setState(() {});
  }

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

  void _handleNotResponding(String visitorsId) {
    var requestBody = {"visitor_id": visitorsId.toString()};
    context
        .read<NotRespondingCubit>()
        .notRespondingAPI(statusBody: requestBody);
  }

  Timer? periodicTimer;

  void _startCountdownAndAPICalls(String visitorsId) {
    const duration = Duration(seconds: 5); // Call API every 5 seconds
    const totalTime = 59; // Total countdown time in seconds
    int remainingTime = totalTime;

    // Show the countdown dialog
    timerCountdownDialog(
      context: context,
      setDialogueContext: (ctx) {
        dialogueContext = ctx;
      },
      onComplete: () {
        if (mounted) {
          periodicTimer?.cancel(); // Stop the timer
          if (Navigator.canPop(dialogueContext)) {
            Navigator.of(dialogueContext).pop();
          }
          _handleNotResponding(visitorsId);
        }
      },
      onChange: (time) {
        if (mounted) {
          remainingTime = int.tryParse(time) ?? remainingTime;
        }
      },
    );

    // Start a periodic timer to call the API
    periodicTimer = Timer.periodic(duration, (timer) {
      if (mounted && remainingTime > 0) {
        context
            .read<ScanVisitorsCubit>()
            .fetchScanVisitors(visitorsId: visitorsId);
        setState(() {});
      } else {
        timer.cancel();
      }
    });
  }

  /// Stops the active timer and closes the dialog.
  void stopTimerDialog() {
    periodicTimer?.cancel(); // Stop the timer
  }

/*  TextEditingController searchController = TextEditingController();

  Future<void> _showSearchDialog() async {
    List<SearchMemberInfo>? filteredItems =
        List.from(_searchMemberCubit.searchMemberInfo);

    await showDialog(
      barrierDismissible: true,
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Scaffold(
              backgroundColor: Colors.transparent,
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
                        return notificationShimmerLoading();
                      }
                      if (state is SearchMemberFailed) {
                        return emptyDataWidget(state.errorMessage.toString());
                      }

                      return Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text("Select Resident",
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
                            controller: searchController,
                            decoration: InputDecoration(
                                contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 5),
                                isDense: true,
                                hintText: "Search...",
                                prefixIcon: const Icon(Icons.search),
                                border: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Colors.grey.withOpacity(0.5)))),
                            onChanged: (query) {
                              setState(() {
                                filteredItems = _searchMemberCubit
                                    .searchMemberInfo
                                    .where((item) => item.name
                                        .toString()
                                        .toLowerCase()
                                        .contains(query.toLowerCase()))
                                    .toList();
                              });
                            },
                          ),
                          const SizedBox(height: 10),
                          filteredItems == null || filteredItems!.isEmpty
                              ? emptyDataWidget("Resident Not Found!")
                              : Expanded(
                                  child: ListView.builder(
                                    itemCount: filteredItems?.length ?? 0,
                                    itemBuilder: (context, index) {
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
                                              "${capitalizeWords(filteredItems![index].name.toString())} Floor: ${filteredItems![index].floorNumber.toString()}  Aprt: ${filteredItems![index].aprtNo.toString()} Tower: ${filteredItems![index].block!.name.toString()}"),
                                          onTap: () {
                                            setState(() {
                                              residenceController.text =
                                                  filteredItems![index]
                                                      .name
                                                      .toString();
                                              residenceId =
                                                  filteredItems![index]
                                                      .userId
                                                      .toString();
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
                    },
                  ),
                ),
              ),
            );
          },
        );
      },
    );

    searchController.clear();
  }*/

  ScrollController _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<NotRespondingCubit, NotRespondingState>(
          listener: (context, state) {
            if (state is NotRespondingSuccessfully) {
              snackBar(context, state.successMsg.toString(), Icons.warning,
                  AppTheme.redColor);
              // Navigator.of(dialogueContext).pop();
              Future.delayed(Duration.zero, () {
                stopTimerDialog();
                Navigator.pop(context);
              });
            }
          },
        ),
        BlocListener<ScanVisitorsCubit, ScanVisitorsState>(
          listener: (context, state) {
            if (state is CallToFetchListAPI) {
              if (state.status == 'not_allowed') {
                snackBar(context, 'Resident Not Allowed This Visitor!',
                    Icons.clear, AppTheme.redColor);
              }
              if (state.status == 'not_responded') {
                snackBar(context, 'Resident Not Responded!', Icons.info,
                    AppTheme.redColor);
              }
              if (state.status == 'checked_in') {
                snackBar(context, 'Resident has been Allowed This Visitor!',
                    Icons.done, AppTheme.guestColor);
              }
              Future.delayed(Duration.zero, () {
                // stopTimerDialog();
                Navigator.pop(context);
              });
            }
          },
        ),
        BlocListener<CreateVisitorsCubit, CreateVisitorsState>(
          listener: (context, state) {
            if (state is CreateVisitorsLoading) {
              showLoadingDialog(context, (ctx) {
                dialogueContext = ctx;
              });
            } else if (state is CreateVisitorsSuccessfully) {
              snackBar(context, 'Visitor created successfully', Icons.done,
                  AppTheme.guestColor);
              Navigator.of(dialogueContext).pop();
              if (!widget.isTypeResidence &&
                  state.visitorsClassificationTypes == 'resident_related') {
                _startCountdownAndAPICalls(state.visitorsId.toString());
              } else {
                Navigator.pop(context);
              }
            } else if (state is CreateVisitorsFailed) {
              snackBar(context, state.errorMsg.toString(), Icons.warning,
                  AppTheme.redColor);

              Navigator.of(dialogueContext).pop();
            } else if (state is CreateVisitorsInternetError) {
              snackBar(context, 'Internet connection failed', Icons.wifi_off,
                  AppTheme.redColor);

              Navigator.of(dialogueContext).pop();
            } else if (state is CreateVisitorsLogut) {
              Navigator.of(dialogueContext).pop();
              sessionExpiredDialog(context);
            }
          },
        ),
      ],
      child: Scaffold(
        appBar: appbarWidget(title: 'Add Visitors'),
        body:


        Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                controller: _scrollController,
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Form(
                    key: formkey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 10.h),
                        widget.isTypeResidence
                            ? const SizedBox()
                            : Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Select Residence',
                                      style: GoogleFonts.nunitoSans(
                                          textStyle: TextStyle(
                                              color: Colors.black,
                                              fontSize: 15,
                                              fontWeight: FontWeight.w500))),
                                  SizedBox(height: 10.h),
                                  TextFormField(
                                    onTap: () async {
                                      // _searchMemberCubit.fetchSearchMember('');
                                      // _showSearchDialog();

                                      final result = await Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) => SelectMembers()));

                                      if (result != null) {
                                        residenceController.text = result['name'];
                                        residenceId = result['user_id'];
                                        propertyID = result['property_id'];
                                        setState(() {});
                                      }
                                    },
                                    readOnly: true,
                                    style: const TextStyle(
                                        color: Colors.black87, fontSize: 16),
                                    controller: residenceController,
                                    // initialList: searchDataList
                                    //     .map((item) => item.label)
                                    //     .toList(),
                                    // getSelectedValue: (value) {
                                    //   SearchItem selectedItem =
                                    //       searchDataList.firstWhere(
                                    //           (item) => item.label == value.label);
                                    //   setState(() {
                                    //     residenceID = selectedItem.id.toString();
                                    //     blocController.text =
                                    //         selectedItem.block.toString();
                                    //     flatController.text =
                                    //         selectedItem.flat.toString();
                                    //     floorController.text =
                                    //         selectedItem.floor.toString();
                                    //   });
                                    // },
                                    decoration: InputDecoration(
                                      hintText: 'Select resident',
                                      contentPadding: EdgeInsets.symmetric(
                                          vertical: 12.h, horizontal: 10.0),
                                      filled: true,
                                      hintStyle: TextStyle(
                                          color: Colors.grey,
                                          fontSize: 15,
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
                                          borderSide:
                                              BorderSide(color: AppTheme.greyColor)),
                                    ),
                                  ),
                                  SizedBox(height: 10.h),
                                ],
                              ),
                        Text('Type of Visitor',
                            style: GoogleFonts.nunitoSans(
                                textStyle: TextStyle(
                                    color: Colors.black,
                                    fontSize: 15,
                                    fontWeight: FontWeight.w500))),
                        SizedBox(height: 10.h),
                        BlocBuilder<VisitorsElementCubit, VisitorsElementState>(
                          builder: (context, state) {
                            if (state is VisitorsElementLoaded) {
                              return DropdownButton2<String>(
                                underline: Container(color: Colors.transparent),
                                isExpanded: true,
                                value: typeOfVisitor,
                                hint: Text('Select visitors',
                                    style: GoogleFonts.nunitoSans(
                                        textStyle: TextStyle(
                                            color: Colors.grey,
                                            fontSize: 15,
                                            fontWeight: FontWeight.normal))),
                                items: state.visitorsElement.first.data.visitorTypes
                                    .map((item) => DropdownMenuItem<String>(
                                          value: item.type,
                                          child: Text(
                                            item.type,
                                            style: const TextStyle(
                                                fontSize: 14, color: Colors.black),
                                          ),
                                        ))
                                    .toList(),
                                onChanged: (value) {
                                  setState(() {
                                    typeOfVisitor = value;
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
                        SizedBox(
                          height: 10.h,
                        ),
                        Text('Visiting Frequency ',
                            style: GoogleFonts.nunitoSans(
                              textStyle: TextStyle(
                                color: Colors.black,
                                fontSize: 15,
                                fontWeight: FontWeight.w500,
                              ),
                            )),
                        SizedBox(height: 10.h),
                        BlocBuilder<VisitorsElementCubit, VisitorsElementState>(
                          builder: (context, state) {
                            if (state is VisitorsElementLoaded) {
                              return DropdownButton2<String>(
                                  underline: Container(color: Colors.transparent),
                                  isExpanded: true,
                                  value: visitorFrequency,
                                  hint: Text('Select Visitor Frequency',
                                      style: GoogleFonts.nunitoSans(
                                        textStyle: TextStyle(
                                          color: Colors.grey,
                                          fontSize: 15,
                                          fontWeight: FontWeight.normal,
                                        ),
                                      )),
                                  items: state
                                      .visitorsElement.first.data.visitingFrequencies
                                      .map((item) => DropdownMenuItem<String>(
                                            value: item.frequency,
                                            child: Text(
                                              item.frequency,
                                              style: const TextStyle(
                                                  fontSize: 14, color: Colors.black),
                                            ),
                                          ))
                                      .toList(),
                                  onChanged: (value) {
                                    setState(() {
                                      visitorFrequency = value;
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
                                      maxHeight:
                                          MediaQuery.sizeOf(context).height / 2,
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
                        Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text('Visitor Name',
                                        style: GoogleFonts.nunitoSans(
                                          textStyle: TextStyle(
                                            color: Colors.black,
                                            fontSize: 15,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        )),
                                    // SizedBox(
                                    //     height: 45,
                                    //     width: 45,
                                    //     child: FloatingActionButton(
                                    //         backgroundColor:
                                    //         AppTheme.primaryColor,
                                    //         shape: RoundedRectangleBorder(
                                    //             borderRadius:
                                    //             BorderRadius
                                    //                 .circular(
                                    //                 50)),
                                    //         onPressed: () {
                                    //           if (formkey2
                                    //               .currentState!
                                    //               .validate()) {
                                    //             addUserToList();
                                    //           }
                                    //         },
                                    //         child: const Icon(
                                    //             Icons.add,
                                    //             color: Colors.white)
                                    //     )
                                    // )
                                  ]),
                              SizedBox(height: 10.h),
                              SizedBox(
                                  width: MediaQuery.of(context).size.width,
                                  child: TextFormField(
                                    onTap: ()=>scrollManagement(_scrollController),
                                      controller: visitorName,
                                      style: GoogleFonts.nunitoSans(
                                        color: Colors.black,
                                        fontSize: 15,
                                        fontWeight: FontWeight.w500,
                                      ),
                                      keyboardType: TextInputType.text,
                                      validator: (text) {
                                        if (text == null || text.isEmpty) {
                                          return 'Please enter visitor name';
                                        }
                                        return null;
                                      },
                                      decoration: InputDecoration(
                                          hintText: 'Enter visitor name',
                                          contentPadding: EdgeInsets.symmetric(
                                              vertical: 12.h, horizontal: 10.0),
                                          filled: true,
                                          hintStyle: TextStyle(
                                            color: Colors.grey,
                                            fontSize: 15,
                                            fontWeight: FontWeight.normal,
                                          ),
                                          fillColor: AppTheme.greyColor,
                                          errorBorder: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(15.0),
                                              borderSide: BorderSide(
                                                  color: AppTheme.greyColor)),
                                          focusedErrorBorder: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(15.0),
                                              borderSide: BorderSide(
                                                  color: AppTheme.greyColor)),
                                          focusedBorder: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(15.0),
                                              borderSide: BorderSide(
                                                  color: AppTheme.greyColor)),
                                          enabledBorder: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(15.0),
                                              borderSide: BorderSide(
                                                  color: AppTheme.greyColor))))),
                              SizedBox(height: 10.h),
                              Text('Number',
                                  style: GoogleFonts.nunitoSans(
                                      textStyle: TextStyle(
                                          color: Colors.black,
                                          fontSize: 15,
                                          fontWeight: FontWeight.w500))),
                              SizedBox(height: 10.h),
                              SizedBox(
                                  width: MediaQuery.of(context).size.width,
                                  child: TextFormField(
                                      controller: number,
                                      style: GoogleFonts.nunitoSans(
                                        color: Colors.black,
                                        fontSize: 15,
                                        fontWeight: FontWeight.w500,
                                      ),
                                      keyboardType: TextInputType.text,
                                      textInputAction: TextInputAction.done,
                                      validator: (text) {
                                        if (text == null || text.isEmpty) {
                                          return 'Please enter number';
                                        } else if (text.length > 10 ||
                                            text.length < 10) {
                                          return 'Number length must be equal to 10';
                                        }
                                        return null;
                                      },
                                      inputFormatters: [
                                        LengthLimitingTextInputFormatter(10),
                                        FilteringTextInputFormatter.digitsOnly
                                      ],
                                      decoration: InputDecoration(
                                          hintText: 'Enter mobile number',
                                          contentPadding: EdgeInsets.symmetric(
                                              vertical: 12.h, horizontal: 10.0),
                                          filled: true,
                                          hintStyle: TextStyle(
                                              color: Colors.grey,
                                              fontSize: 15,
                                              fontWeight: FontWeight.normal),
                                          fillColor: AppTheme.greyColor,
                                          errorBorder: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(15.0),
                                              borderSide: BorderSide(
                                                  color: AppTheme.greyColor)),
                                          focusedErrorBorder: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(15.0),
                                              borderSide: BorderSide(
                                                  color: AppTheme.greyColor)),
                                          focusedBorder: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(15.0),
                                              borderSide: BorderSide(
                                                  color: AppTheme.greyColor)),
                                          enabledBorder: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(15.0),
                                              borderSide: BorderSide(
                                                  color: AppTheme.greyColor))))),
                              /*       Wrap(
                                    children: List.generate(
                                        usersList.length,
                                            (index) =>
                                            Container(
                                                margin: const EdgeInsets
                                                    .only(
                                                    top: 5, right: 5),
                                                padding:
                                                const EdgeInsets
                                                    .symmetric(
                                                    horizontal: 10,
                                                    vertical: 6),
                                                decoration: BoxDecoration(
                                                    borderRadius:
                                                    BorderRadius
                                                        .circular(
                                                        30),
                                                    border: Border
                                                        .all(
                                                        color: AppTheme
                                                            .primaryColor
                                                            .withOpacity(
                                                            0.6))),
                                                child: Row(
                                                    mainAxisSize:
                                                    MainAxisSize.min,
                                                    children: [
                                                      Text(
                                                          usersList[index]['name']
                                                              .toString(),
                                                          style: TextStyle(
                                                              color: AppTheme
                                                                  .primaryColor,
                                                              fontSize: 14)),
                                                      Text(
                                                          " , ${usersList[index]['phone']
                                                              .toString()}",
                                                          style: TextStyle(
                                                              color: AppTheme
                                                                  .primaryColor,
                                                              fontSize: 14)),
                                                      const SizedBox(
                                                          width: 5),
                                                      GestureDetector(
                                                          onTap: () =>
                                                              removeUser(
                                                                  index),
                                                          child: Icon(
                                                              Icons
                                                                  .clear,
                                                              color: AppTheme
                                                                  .primaryColor)
                                                      )
                                                    ]
                                                )
                                            ))
                                )*/
                            ]),
                        SizedBox(height: 10.h),

                        // Text('No. of visitors',
                        //     style:GoogleFonts.nunitoSans(
                        //         textStyle: TextStyle(
                        //             color: Colors.black,
                        //             fontSize: 15,
                        //             fontWeight: FontWeight.w500
                        //         )
                        //     )),
                        // SizedBox(
                        //     height: 10.h
                        // ),
                        // SizedBox(
                        //     width: MediaQuery
                        //         .of(context)
                        //         .size
                        //         .width,
                        //     child: TextFormField(
                        //       readOnly: true,
                        //         controller: visitorsCount,
                        //         style:GoogleFonts.nunitoSans(
                        //           color: Colors.black,
                        //           fontSize: 15,
                        //           fontWeight: FontWeight.w500
                        //         ),
                        //         keyboardType: TextInputType
                        //             .number,
                        //         validator: (text) {
                        //           if (text == null ||
                        //               text.isEmpty) {
                        //             return 'Please enter number';
                        //           }
                        //           return null;
                        //         },
                        //         inputFormatters: [
                        //           FilteringTextInputFormatter
                        //               .digitsOnly
                        //         ],
                        //         decoration: InputDecoration(
                        //             hintText: 'Visitors Counts',
                        //             contentPadding: EdgeInsets
                        //                 .symmetric(
                        //                 vertical: 12.h,
                        //                 horizontal: 10.0),
                        //             filled: true,
                        //             hintStyle: TextStyle(
                        //                 color: Colors.grey,
                        //                 fontSize: 15,
                        //                 fontWeight: FontWeight
                        //                     .normal
                        //             ),
                        //             fillColor: AppTheme
                        //                 .greyColor,
                        //             errorBorder: OutlineInputBorder(
                        //                 borderRadius:
                        //                 BorderRadius.circular(
                        //                     15.0),
                        //                 borderSide: BorderSide(
                        //                     color: AppTheme
                        //                         .greyColor
                        //                 )
                        //             ),
                        //             focusedErrorBorder:
                        //             OutlineInputBorder(
                        //                 borderRadius:
                        //                 BorderRadius.circular(
                        //                     15.0),
                        //                 borderSide: BorderSide(
                        //                     color: AppTheme
                        //                         .greyColor
                        //                 )
                        //             ),
                        //             focusedBorder: OutlineInputBorder(
                        //                 borderRadius:
                        //                 BorderRadius.circular(
                        //                     15.0),
                        //                 borderSide: BorderSide(
                        //                     color: AppTheme
                        //                         .greyColor
                        //                 )
                        //             ),
                        //             enabledBorder: OutlineInputBorder(
                        //                 borderRadius:
                        //                 BorderRadius.circular(
                        //                     15.0),
                        //                 borderSide: BorderSide(
                        //                     color: AppTheme
                        //                         .greyColor
                        //                 )
                        //             )
                        //         )
                        //     )
                        // ),
                        // SizedBox(
                        //     height: 10.h
                        // ),
                        Row(children: [
                          Expanded(
                              child: Text('Date',
                                  style: GoogleFonts.nunitoSans(
                                      textStyle: TextStyle(
                                          color: Colors.black,
                                          fontSize: 15,
                                          fontWeight: FontWeight.w500)))),
                          Expanded(
                              child: Text('Time',
                                  style: GoogleFonts.nunitoSans(
                                      textStyle: TextStyle(
                                          color: Colors.black,
                                          fontSize: 15,
                                          fontWeight: FontWeight.w500))))
                        ]),
                        SizedBox(height: 10.h),
                        Row(children: [
                          Expanded(
                              child: SizedBox(
                                  child: TextFormField(
                                      // onTap: () {
                                      //   _selectDate(context);
                                      // },
                                      readOnly: true,
                                      controller: date,
                                      style: GoogleFonts.nunitoSans(
                                        color: Colors.black,
                                        fontSize: 15,
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
                                                if (widget.isTypeResidence) {
                                                  _selectDate(context);
                                                }
                                              },
                                              child:
                                                  const Icon(Icons.calendar_month)),
                                          filled: true,
                                          hintStyle: TextStyle(
                                              color: Colors.grey,
                                              fontSize: 15,
                                              fontWeight: FontWeight.normal),
                                          fillColor: AppTheme.greyColor,
                                          errorBorder: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(15.0),
                                              borderSide: BorderSide(
                                                  color: AppTheme.greyColor)),
                                          focusedErrorBorder: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(15.0),
                                              borderSide: BorderSide(
                                                  color: AppTheme.greyColor)),
                                          focusedBorder: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(15.0),
                                              borderSide: BorderSide(
                                                  color: AppTheme.greyColor)),
                                          enabledBorder: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(15.0),
                                              borderSide: BorderSide(
                                                  color: AppTheme.greyColor)))))),
                          SizedBox(width: 10.w),
                          Expanded(
                              child: SizedBox(
                                  child: TextFormField(
                                      readOnly: true,
                                      controller: time,
                                      style: GoogleFonts.nunitoSans(
                                        color: Colors.black,
                                        fontSize: 15,
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
                                                if (widget.isTypeResidence) {
                                                  if (date!.text.isEmpty) {
                                                    snackBar(
                                                        context,
                                                        'Kindly select first date!',
                                                        Icons.info,
                                                        AppTheme.redColor);
                                                  } else {
                                                    _selectTime(context);
                                                  }
                                                }
                                              },
                                              child: const Icon(Icons.timelapse)),
                                          filled: true,
                                          hintStyle: TextStyle(
                                              color: Colors.grey,
                                              fontSize: 15,
                                              fontWeight: FontWeight.normal),
                                          fillColor: AppTheme.greyColor,
                                          errorBorder: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(15.0),
                                              borderSide: BorderSide(
                                                  color: AppTheme.greyColor)),
                                          focusedErrorBorder: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(15.0),
                                              borderSide: BorderSide(
                                                  color: AppTheme.greyColor)),
                                          focusedBorder: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(15.0),
                                              borderSide: BorderSide(
                                                  color: AppTheme.greyColor)),
                                          enabledBorder: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(15.0),
                                              borderSide: BorderSide(
                                                  color: AppTheme.greyColor))))))
                        ]),
                        SizedBox(height: 10.h),
                        Text('Vehicle Number',
                            style: GoogleFonts.nunitoSans(
                                textStyle: TextStyle(
                                    color: Colors.black,
                                    fontSize: 15,
                                    fontWeight: FontWeight.w500))),
                        SizedBox(height: 10.h),
                        SizedBox(
                            width: MediaQuery.of(context).size.width,
                            child: TextFormField(

                                controller: vehicleNumber,
                                style: GoogleFonts.nunitoSans(
                                  color: Colors.black,
                                  fontSize: 15,
                                  fontWeight: FontWeight.w500,
                                ),
                                keyboardType: TextInputType.text,
                                textInputAction: TextInputAction.done,
                                inputFormatters: [
                                  VehicleNumberFormatter(), // Custom formatter
                                  LengthLimitingTextInputFormatter(
                                      13), // Max length = 13
                                ],
                                decoration: InputDecoration(
                                    hintText: 'Enter vehicle number',
                                    contentPadding: EdgeInsets.symmetric(
                                        vertical: 12.h, horizontal: 10.0),
                                    filled: true,
                                    hintStyle: TextStyle(
                                        color: Colors.grey,
                                        fontSize: 15,
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
                                        borderSide:
                                            BorderSide(color: AppTheme.greyColor))))),
                        SizedBox(height: 10.h),
                        Text('Purpose of Visit ',
                            style: GoogleFonts.nunitoSans(
                                textStyle: TextStyle(
                                    color: Colors.black,
                                    fontSize: 15,
                                    fontWeight: FontWeight.w500))),
                        SizedBox(height: 10.h),
                        SizedBox(
                            width: MediaQuery.of(context).size.width,
                            child: TextFormField(
                                controller: purposeController,
                                style: GoogleFonts.nunitoSans(
                                    color: Colors.black,
                                    fontSize: 15,
                                    fontWeight: FontWeight.w500),
                                maxLines: null,
                                minLines: 3,
                                keyboardType: TextInputType.multiline,
                                validator: (text) {
                                  if (text == null || text.isEmpty) {
                                    return 'Please enter purpose of visit';
                                  }
                                  return null;
                                },
                                textInputAction: TextInputAction.done
                                ,
                                decoration: InputDecoration(
                                    hintText: 'Describe the purpose...',
                                    contentPadding: EdgeInsets.symmetric(
                                        vertical: 12.h, horizontal: 10.0),
                                    filled: true,
                                    hintStyle: TextStyle(
                                        color: Colors.grey,
                                        fontSize: 15,
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
                                        borderSide:
                                            BorderSide(color: AppTheme.greyColor))))),
                        SizedBox(height: 10.h),
                        Text('Valid Till',
                            style: GoogleFonts.nunitoSans(
                                textStyle: TextStyle(
                                    color: Colors.black,
                                    fontSize: 15,
                                    fontWeight: FontWeight.w500))),
                        SizedBox(height: 10.h),
                        BlocBuilder<VisitorsElementCubit, VisitorsElementState>(
                            builder: (context, state) {
                          if (state is VisitorsElementLoaded) {
                            return DropdownButton2<String>(
                                underline: Container(color: Colors.transparent),
                                isExpanded: true,
                                value: validTill,
                                items: state
                                    .visitorsElement.first.data.visitorValidity
                                    .map((item) => DropdownMenuItem<String>(
                                        value: item.type,
                                        child: Text(item.type,
                                            style: const TextStyle(
                                                fontSize: 14, color: Colors.black))))
                                    .toList(),
                                onChanged: (value) {
                                  setState(() {
                                    validTill = value;
                                  });
                                },
                                hint: Text('Select Valid till',
                                    style: GoogleFonts.nunitoSans(
                                        textStyle: TextStyle(
                                            color: Colors.grey,
                                            fontSize: 15,
                                            fontWeight: FontWeight.normal))),
                                iconStyleData: const IconStyleData(
                                    icon: Icon(Icons.arrow_drop_down,
                                        color: Colors.black45),
                                    iconSize: 24),
                                buttonStyleData: ButtonStyleData(
                                    decoration: BoxDecoration(
                                        color: AppTheme.greyColor,
                                        // Background color for the button
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
                        }),
                        const SizedBox(height: 15),
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
                        SizedBox(height: 30.h),

                      ],
                    ),
                  ),
                ),
              ),
            ),


            customBtn(
              onTap: () {
                if (widget.isTypeResidence) {
                  propertyID =
                      LocalStorage.localStorage.getString('property_id');
                }

                if (formkey.currentState!.validate()) {
                  if (typeOfVisitor == null) {
                    snackBar(context, 'Kindly select type of visitors',
                        Icons.done, AppTheme.redColor);
                  } else
                    // if (residenceController.text == '' &&
                    //     widget.isTypeResidence == false) {
                    //   snackBar(
                    //       context,
                    //       'Kindly select residence name',
                    //       Icons.done,
                    //       AppTheme.redColor);
                    // } else
                  if (visitorFrequency == null) {
                    snackBar(context, 'Kindly select visitors frequency',
                        Icons.done, AppTheme.redColor);
                  } else if (validTill == null) {
                    snackBar(context, 'Kindly select valid time',
                        Icons.done, AppTheme.redColor);
                  } else if (croppedImagesList!.isEmpty) {
                    snackBar(context, 'Kindly upload visitors picture',
                        Icons.done, AppTheme.redColor);
                  } else {
                    documentFiles.clear();
                    for (int i = 0; i < croppedImagesList!.length; i++) {
                      documentFiles.add(File(croppedImagesList![i].path));
                    }
                    addUserToList();
                    context.read<CreateVisitorsCubit>().createVisitors(
                        propertyId: propertyID.toString(),
                        visitorsType: typeOfVisitor.toString(),
                        visitingFrequency: visitorFrequency.toString(),
                        noOFVisitors: visitorsCount.text.toString(),
                        date: date!.text.toString(),
                        vehicleNumber: vehicleNumber!.text.toString(),
                        purposeOfVisit:
                        purposeController!.text.toString(),
                        validTill: validTill.toString(),
                        time: time!.text.toString(),
                        files: documentFiles,
                        visitors: usersList,
                        userId: residenceId.toString());
                  }
                }
              },
              txt: "Submit",
            ),
          ],
        ),
      ),
    );
  }
}

class SearchItem {
  final String label;
  final int id;
  var floor;
  var block;
  var flat;

  SearchItem(
      {required this.label,
      required this.id,
      required this.block,
      required this.floor,
      required this.flat});
}
