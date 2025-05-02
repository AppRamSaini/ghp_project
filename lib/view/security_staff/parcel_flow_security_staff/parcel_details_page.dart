import 'package:ghp_society_management/constants/dialog.dart';
import 'package:ghp_society_management/constants/export.dart';
import 'package:ghp_society_management/controller/parcel/parcel_complaint/parcel_complaint_cubit.dart';
import 'package:ghp_society_management/controller/parcel/parcel_details/parcel_details_cubit.dart';
import 'package:ghp_society_management/model/parcel_details_model.dart';
import 'package:intl/intl.dart';

class ParcelDetailsSecurityStaffSide extends StatefulWidget {
  bool isStaffSide;
  final String parcelId;

  ParcelDetailsSecurityStaffSide(
      {super.key, required this.parcelId, this.isStaffSide = true});

  @override
  State<ParcelDetailsSecurityStaffSide> createState() =>
      _ParcelDetailsSecurityStaffSideState();
}

class _ParcelDetailsSecurityStaffSideState
    extends State<ParcelDetailsSecurityStaffSide> {
  late BuildContext dialogueContext;
  late ParcelDetailsCubit _parcelDetailsCubit;

  @override
  void initState() {
    super.initState();
    _parcelDetailsCubit = ParcelDetailsCubit();
    _parcelDetailsCubit.fetchParcelDetailsApi(widget.parcelId.toString());
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<ParcelComplaintCubit, ParcelComplaintState>(
            listener: (context, state) {
          if (state is ParcelComplaintLoading) {
            showLoadingDialog(context, (ctx) {
              dialogueContext = ctx;
            });
          } else if (state is ParcelComplaintSuccess) {
            snackBar(context, state.successMsg.toString(), Icons.done,
                AppTheme.guestColor);
            _parcelDetailsCubit
                .fetchParcelDetailsApi(widget.parcelId.toString());
            Navigator.of(dialogueContext).pop();
          } else if (state is ParcelComplaintFailed) {
            snackBar(context, state.errorMsg.toString(), Icons.warning,
                AppTheme.redColor);
            Navigator.of(dialogueContext).pop();
          } else if (state is ParcelComplaintInternetError) {
            snackBar(context, state.errorMsg.toString(), Icons.wifi_off,
                AppTheme.redColor);
            Navigator.of(dialogueContext).pop();
          } else if (state is ParcelComplaintLogout) {
            Navigator.of(dialogueContext).pop();
            sessionExpiredDialog(context);
          }
        }),
      ],
      child: Scaffold(
          backgroundColor: AppTheme.backgroundColor,
          body: SafeArea(
            child: Column(
              children: [
                Padding(
                    padding:
                        EdgeInsets.only(top: 20.h, left: 6.h, bottom: 20.h),
                    child: Row(children: [
                      GestureDetector(
                          onTap: () => Navigator.of(context).pop(),
                          child: const Icon(Icons.arrow_back,
                              color: Colors.white)),
                      SizedBox(width: 10.w),
                      Text('Parcel Details',
                          style: GoogleFonts.nunitoSans(
                              textStyle: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20.sp,
                                  fontWeight: FontWeight.w600)))
                    ])),
                Expanded(
                  child: Container(
                    width: double.infinity,
                    decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(20),
                            topRight: Radius.circular(20))),
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: BlocBuilder(
                        bloc: _parcelDetailsCubit,
                        builder: (_, state) {
                          if (state is ParcelDetailsLoaded) {
                            ParcelDetails requestData =
                                state.parcelDetails!.first;
                            String formattedDate = DateFormat('dd MMM yyyy')
                                .format(requestData.date!);
                            DateTime parsedTime =
                                DateFormat("HH:mm:ss").parse(requestData.time!);
                            String formattedTime =
                                DateFormat.jm().format(parsedTime);
                            // complaint
                            complaintDate() {
                              if (requestData.parcelComplaint != null) {
                                String complaintFormattedDate =
                                    DateFormat('dd MMM yyyy').format(
                                        requestData.parcelComplaint!.date!);
                                DateTime parsedTime2 = DateFormat("HH:mm:ss")
                                    .parse(requestData.parcelComplaint!.time!);
                                String complaintFormattedTime =
                                    DateFormat.jm().format(parsedTime2);
                                return "$complaintFormattedDate  |  $complaintFormattedTime";
                              } else {
                                return '';
                              }
                            }

                            checkingDate() {
                              if (requestData.checkinDetail != null) {
                                String complaintFormattedDate =
                                    DateFormat('dd MMM yyyy hh:mm:a').format(
                                        requestData.checkinDetail!.checkinAt!);
                                return complaintFormattedDate;
                              } else {
                                return 'N/A';
                              }
                            }

                            checkOutDate() {
                              if (requestData.checkinDetail != null) {
                                if (requestData.checkinDetail!.checkoutAt !=
                                    null) {
                                  String complaintFormattedDate =
                                      DateFormat('dd MMM yyyy hh:mm:a').format(
                                          requestData
                                              .checkinDetail!.checkoutAt!);
                                  return complaintFormattedDate;
                                } else {
                                  return 'N/A';
                                }
                              } else {
                                return 'N/A';
                              }
                            }

                            String status() {
                              if (requestData.checkinDetail == null) {
                                return 'Pending';
                              } else {
                                final checkinStatus =
                                    requestData.checkinDetail?.status;
                                final handoverStatus =
                                    requestData.handoverStatus;
                                final entryRole = requestData.entryByRole;
                                final receivedByRole =
                                    requestData.receivedByRole;

                                if (checkinStatus == 'checked_in' &&
                                    handoverStatus != 'delivered') {
                                  return "Parcel Arrived";
                                }
                                if (handoverStatus == 'delivered' &&
                                    checkinStatus == 'checked_in') {
                                  return !widget.isStaffSide
                                      ? "Received"
                                      : 'Not Checkout';
                                }
                                if (handoverStatus == 'received' &&
                                    entryRole == 'staff_security_guard') {
                                  return !widget.isStaffSide
                                      ? "Received by staff"
                                      : 'Not Delivered';
                                }

                                if (handoverStatus == 'received' &&
                                    receivedByRole == 'staff_security_guard') {
                                  return !widget.isStaffSide
                                      ? "Received by staff"
                                      : 'Not Delivered';
                                } else {
                                  return !widget.isStaffSide
                                      ? "Received"
                                      : "Delivered";
                                }
                              }

                              return "Delivered";

                              //
                              // if (parcelData.handoverStatus == "pending") {
                              //   if (parcelData.checkinDetail == null) {
                              //     return 'Pending';
                              //   }
                              //   final checkinStatus =
                              //       parcelData.checkinDetail?.status;
                              //   final handoverStatus =
                              //       parcelData.handoverStatus;
                              //   final entryRole = parcelData.entryByRole;
                              //
                              //   if (checkinStatus == 'checked_in' &&
                              //       handoverStatus != 'delivered') {
                              //     return "Checked IN";
                              //   }
                              //
                              //   if (handoverStatus == 'received' ||
                              //       entryRole == 'staff_security_guard') {
                              //     return 'Not Delivered';
                              //   }
                              //
                              //   if (handoverStatus == 'delivered' &&
                              //       checkinStatus == 'checked_in') {
                              //     return 'Not Checkout';
                              //   }
                              //
                              //   return "Pending";
                              // }else{
                              //   return "Delivered";
                              // }
                            }

                            return SingleChildScrollView(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(height: 10.h),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text('Parcel Info',
                                          style: GoogleFonts.nunitoSans(
                                              textStyle: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 18.sp,
                                                  fontWeight:
                                                      FontWeight.w600))),
                                      Text(
                                        status(),
                                        style: GoogleFonts.nunitoSans(
                                          textStyle: TextStyle(
                                            color: requestData.handoverStatus == 'pending' ||
                                                requestData.checkinDetail?.checkoutAt == null
                                                ? Colors.red
                                                : requestData.handoverStatus == 'received'
                                                ? Colors.orange
                                                : Colors.green,
                                            fontSize: 15.sp,
                                          ),
                                        ),
                                      )

                                    ],
                                  ),
                                  SizedBox(height: 10.h),
                                  Container(
                                    padding: const EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        border: Border.all(
                                            color:
                                                Colors.grey.withOpacity(0.1))),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text('Parcel ID : ',
                                                  style: GoogleFonts.nunitoSans(
                                                      textStyle: TextStyle(
                                                          color: Colors.black45,
                                                          fontSize: 15.sp,
                                                          fontWeight: FontWeight
                                                              .w500))),
                                              Text(
                                                  requestData.parcelid
                                                      .toString(),
                                                  style: GoogleFonts.nunitoSans(
                                                      textStyle: TextStyle(
                                                          color: Colors.black87,
                                                          fontSize: 15.sp,
                                                          fontWeight:
                                                              FontWeight.w500)))
                                            ]),
                                        Padding(
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 3),
                                            child: Divider(
                                                color: Colors.grey
                                                    .withOpacity(0.1))),
                                        Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text('Parcel Name :',
                                                  style: GoogleFonts.nunitoSans(
                                                      textStyle: TextStyle(
                                                          color: Colors.black45,
                                                          fontSize: 15.sp,
                                                          fontWeight: FontWeight
                                                              .w500))),
                                              Text(
                                                  capitalizeWords(requestData
                                                      .parcelName
                                                      .toString()),
                                                  style: GoogleFonts.nunitoSans(
                                                      textStyle: TextStyle(
                                                          color: Colors.black87,
                                                          fontSize: 15.sp,
                                                          fontWeight:
                                                              FontWeight.w500)))
                                            ]),
                                        Padding(
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 3),
                                            child: Divider(
                                                color: Colors.grey
                                                    .withOpacity(0.1))),
                                        Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text('Parcel Date : ',
                                                  style: GoogleFonts.nunitoSans(
                                                      textStyle: TextStyle(
                                                          color: Colors.black45,
                                                          fontSize: 15.sp,
                                                          fontWeight: FontWeight
                                                              .w500))),
                                              Text(
                                                  '$formattedDate || $formattedTime',
                                                  style: GoogleFonts.nunitoSans(
                                                      textStyle: TextStyle(
                                                          color: Colors.black87,
                                                          fontSize: 15.sp,
                                                          fontWeight:
                                                              FontWeight.w500)))
                                            ]),
                                        Padding(
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 3),
                                            child: Divider(
                                                color: Colors.grey
                                                    .withOpacity(0.1))),
                                        Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text('Created by :',
                                                  style: GoogleFonts.nunitoSans(
                                                      textStyle: TextStyle(
                                                          color: Colors.black45,
                                                          fontSize: 15.sp,
                                                          fontWeight: FontWeight
                                                              .w500))),
                                              Text(
                                                  capitalizeWords(requestData
                                                      .entryByRole
                                                      .toString()
                                                      .replaceAll("_", " ")),
                                                  style: GoogleFonts.nunitoSans(
                                                      textStyle: TextStyle(
                                                          color: Colors.black87,
                                                          fontSize: 15.sp,
                                                          fontWeight:
                                                              FontWeight.w500)))
                                            ]),
                                        Padding(
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 3),
                                            child: Divider(
                                                color: Colors.grey
                                                    .withOpacity(0.1))),
                                        Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text('No. Of Parcels :',
                                                  style: GoogleFonts.nunitoSans(
                                                      textStyle: TextStyle(
                                                          color: Colors.black45,
                                                          fontSize: 15.sp,
                                                          fontWeight: FontWeight
                                                              .w500))),
                                              Text(
                                                  requestData.noOfParcel
                                                      .toString(),
                                                  style: GoogleFonts.nunitoSans(
                                                      textStyle: TextStyle(
                                                          color: Colors.black87,
                                                          fontSize: 15.sp,
                                                          fontWeight:
                                                              FontWeight.w500)))
                                            ]),
                                        Padding(
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 3),
                                            child: Divider(
                                                color: Colors.grey
                                                    .withOpacity(0.1))),
                                        Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text('Parcel types :',
                                                  style: GoogleFonts.nunitoSans(
                                                      textStyle: TextStyle(
                                                          color: Colors.black45,
                                                          fontSize: 15.sp,
                                                          fontWeight: FontWeight
                                                              .w500))),
                                              Text(
                                                  requestData.parcelType
                                                      .toString(),
                                                  style: GoogleFonts.nunitoSans(
                                                      textStyle: TextStyle(
                                                          color: Colors.black87,
                                                          fontSize: 15.sp,
                                                          fontWeight:
                                                              FontWeight.w500)))
                                            ]),
                                        Padding(
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 3),
                                            child: Divider(
                                                color: Colors.grey
                                                    .withOpacity(0.1))),
                                        Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text('Check In At :',
                                                  style: GoogleFonts.nunitoSans(
                                                      textStyle: TextStyle(
                                                          color: Colors.black45,
                                                          fontSize: 15.sp,
                                                          fontWeight: FontWeight
                                                              .w500))),
                                              Text(checkingDate(),
                                                  style: GoogleFonts.nunitoSans(
                                                      textStyle: TextStyle(
                                                          color: Colors.black87,
                                                          fontSize: 15.sp,
                                                          fontWeight:
                                                              FontWeight.w500)))
                                            ]),
                                        Padding(
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 3),
                                            child: Divider(
                                                color: Colors.grey
                                                    .withOpacity(0.1))),
                                        Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text('Check Out At :',
                                                  style: GoogleFonts.nunitoSans(
                                                      textStyle: TextStyle(
                                                          color: Colors.black45,
                                                          fontSize: 15.sp,
                                                          fontWeight: FontWeight
                                                              .w500))),
                                              Text(checkOutDate(),
                                                  style: GoogleFonts.nunitoSans(
                                                      textStyle: TextStyle(
                                                          color: Colors.black87,
                                                          fontSize: 15.sp,
                                                          fontWeight:
                                                              FontWeight.w500)))
                                            ]),
                                        Padding(
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 3),
                                            child: Divider(
                                                color: Colors.grey
                                                    .withOpacity(0.1))),
                                        Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text('Received by :',
                                                  style: GoogleFonts.nunitoSans(
                                                      textStyle: TextStyle(
                                                          color: Colors.black45,
                                                          fontSize: 15.sp,
                                                          fontWeight: FontWeight
                                                              .w500))),
                                              Text(
                                                  requestData.receivedByRole !=
                                                          null
                                                      ? capitalizeWords(
                                                          requestData
                                                              .receivedByRole
                                                              .replaceAll(
                                                                  "_", " ")
                                                              .toString()
                                                              .replaceAll(
                                                                  "staff", ''))
                                                      : "N/A",
                                                  style: GoogleFonts.nunitoSans(
                                                      textStyle: TextStyle(
                                                          color: Colors.black87,
                                                          fontSize: 15.sp,
                                                          fontWeight:
                                                              FontWeight.w500)))
                                            ]),
                                        Padding(
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 3),
                                            child: Divider(
                                                color: Colors.grey
                                                    .withOpacity(0.1))),
                                        Text('Delivered to :',
                                            style: GoogleFonts.nunitoSans(
                                                textStyle: TextStyle(
                                                    color: Colors.black45,
                                                    fontSize: 15.sp,
                                                    fontWeight:
                                                        FontWeight.w500))),
                                        const SizedBox(height: 10),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                children: [
                                                  Text('Name',
                                                      style: GoogleFonts
                                                          .nunitoSans(
                                                              textStyle: TextStyle(
                                                                  color: Colors
                                                                      .black54,
                                                                  fontSize:
                                                                      14.sp))),
                                                  Text(
                                                      requestData.member!.name
                                                          .toString(),
                                                      style: GoogleFonts.nunitoSans(
                                                          textStyle: TextStyle(
                                                              color:
                                                                  Colors.black,
                                                              fontSize: 14.sp,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600)))
                                                ]),
                                            Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                children: [
                                                  Text('Phone',
                                                      style: GoogleFonts
                                                          .nunitoSans(
                                                              textStyle: TextStyle(
                                                                  color: Colors
                                                                      .black54,
                                                                  fontSize:
                                                                      14.sp))),
                                                  Text(
                                                      "+91 ${requestData.member!.phone.toString()}",
                                                      style: GoogleFonts.nunitoSans(
                                                          textStyle: TextStyle(
                                                              color:
                                                                  Colors.black,
                                                              fontSize: 14.sp,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600)))
                                                ]),
                                          ],
                                        ),
                                        const SizedBox(height: 20),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                children: [
                                                  Text('Tower Name ',
                                                      style: GoogleFonts
                                                          .nunitoSans(
                                                              textStyle: TextStyle(
                                                                  color: Colors
                                                                      .black54,
                                                                  fontSize:
                                                                      14.sp))),
                                                  Text(
                                                      requestData
                                                          .member!.blockName
                                                          .toString(),
                                                      style: GoogleFonts.nunitoSans(
                                                          textStyle: TextStyle(
                                                              color:
                                                                  Colors.black,
                                                              fontSize: 14.sp,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600)))
                                                ]),
                                            Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                children: [
                                                  Text('Floor ',
                                                      style: GoogleFonts
                                                          .nunitoSans(
                                                              textStyle: TextStyle(
                                                                  color: Colors
                                                                      .black54,
                                                                  fontSize:
                                                                      14.sp))),
                                                  Text(
                                                      requestData
                                                          .member!.floorNumber
                                                          .toString(),
                                                      style: GoogleFonts.nunitoSans(
                                                          textStyle: TextStyle(
                                                              color:
                                                                  Colors.black,
                                                              fontSize: 14.sp,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600)))
                                                ]),
                                            Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                children: [
                                                  Text('Property No',
                                                      style: GoogleFonts
                                                          .nunitoSans(
                                                              textStyle: TextStyle(
                                                                  color: Colors
                                                                      .black54,
                                                                  fontSize:
                                                                      14.sp))),
                                                  Text(
                                                      requestData.member!.aprtNo
                                                          .toString(),
                                                      style: GoogleFonts.nunitoSans(
                                                          textStyle: TextStyle(
                                                              color:
                                                                  Colors.black,
                                                              fontSize: 14.sp,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600)))
                                                ]),
                                          ],
                                        ),
                                        requestData.parcelComplaint == null
                                            ? const SizedBox()
                                            : Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Padding(
                                                      padding: const EdgeInsets
                                                          .symmetric(
                                                          vertical: 3),
                                                      child: Divider(
                                                          color: Colors.grey
                                                              .withOpacity(
                                                                  0.1))),
                                                  Text('Parcel Complaint :',
                                                      style: GoogleFonts.nunitoSans(
                                                          textStyle: TextStyle(
                                                              color: Colors.red,
                                                              fontSize: 15.sp,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500))),
                                                  const SizedBox(height: 10),
                                                  Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceBetween,
                                                          children: [
                                                            Text('Date & Time',
                                                                style: GoogleFonts.nunitoSans(
                                                                    textStyle: TextStyle(
                                                                        color: Colors
                                                                            .black54,
                                                                        fontSize:
                                                                            14.sp))),
                                                            Text(
                                                                complaintDate(),
                                                                style: GoogleFonts.nunitoSans(
                                                                    textStyle: TextStyle(
                                                                        color: Colors
                                                                            .black,
                                                                        fontSize: 14
                                                                            .sp,
                                                                        fontWeight:
                                                                            FontWeight.w500)))
                                                          ]),
                                                      Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .symmetric(
                                                                  vertical: 3),
                                                          child: Divider(
                                                              color: Colors.grey
                                                                  .withOpacity(
                                                                      0.1))),
                                                      Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            Text('Reason',
                                                                style: GoogleFonts.nunitoSans(
                                                                    textStyle: TextStyle(
                                                                        color: Colors
                                                                            .black54,
                                                                        fontSize:
                                                                            14.sp))),
                                                            Text(
                                                                requestData
                                                                    .parcelComplaint!
                                                                    .description
                                                                    .toString(),
                                                                style: GoogleFonts.nunitoSans(
                                                                    textStyle: TextStyle(
                                                                        color: Colors
                                                                            .black,
                                                                        fontSize: 14
                                                                            .sp,
                                                                        fontWeight:
                                                                            FontWeight.w500)))
                                                          ]),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                        const SizedBox(height: 20),
                                      ],
                                    ),
                                  ),
                                  SizedBox(height: 15.h),
                                  Text('Delivery Partner`s Info',
                                      style: GoogleFonts.nunitoSans(
                                          textStyle: TextStyle(
                                              color: Colors.black,
                                              fontSize: 18.sp,
                                              fontWeight: FontWeight.w600))),
                                  SizedBox(height: 10.h),
                                  Container(
                                      padding: const EdgeInsets.all(10),
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          border: Border.all(
                                              color: Colors.grey
                                                  .withOpacity(0.1))),
                                      child: Row(
                                        children: [
                                          requestData.deliveryAgentImage != null
                                              ? CircleAvatar(
                                                  radius: 35,
                                                  backgroundImage: NetworkImage(
                                                      requestData
                                                          .deliveryAgentImage
                                                          .toString()))
                                              : const CircleAvatar(
                                                  radius: 35,
                                                  backgroundImage: AssetImage(
                                                      'assets/images/default.jpg')),
                                          const SizedBox(width: 15),
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                  capitalizeWords(requestData
                                                          .deliveryName ??
                                                      '**************'),
                                                  style: GoogleFonts.nunitoSans(
                                                      textStyle: TextStyle(
                                                          color: Colors.black,
                                                          fontSize: 16.sp,
                                                          fontWeight: FontWeight
                                                              .w600))),
                                              const SizedBox(height: 3),
                                              Text(
                                                  "+91 ${requestData.deliveryPhone ?? 'XXXXXXXXXX'}",
                                                  style: GoogleFonts.nunitoSans(
                                                      textStyle: TextStyle(
                                                          color: Colors.black,
                                                          fontSize: 14.sp,
                                                          fontWeight: FontWeight
                                                              .w500))),
                                              const SizedBox(height: 3),
                                              Text(
                                                  "Parcel From : ${requestData.parcelCompanyName ?? ''}",
                                                  style: GoogleFonts.nunitoSans(
                                                      textStyle: TextStyle(
                                                          color: Colors.black,
                                                          fontSize: 12.sp,
                                                          fontWeight: FontWeight
                                                              .w500))),
                                            ],
                                          )
                                        ],
                                      )),
                                ],
                              ),
                            );
                          } else if (state is ParcelDetailsFailed) {
                            return Center(
                                child: Text(state.errorMsg.toString(),
                                    style: const TextStyle(
                                        color: Colors.deepPurpleAccent)));
                          } else if (state is ParcelDetailsLoading) {
                            return const Center(
                                child: CircularProgressIndicator.adaptive(
                                    backgroundColor: Colors.deepPurpleAccent));
                          } else if (state is ParcelDetailsInternetError) {
                            return Center(
                                child: Text(state.errorMsg.toString(),
                                    style: const TextStyle(
                                        color: Colors.deepPurpleAccent)));
                          } else {
                            return const SizedBox();
                          }
                        },
                      ),
                    ),
                  ),
                ),
              ],
            ),
          )),
    );
  }
}
