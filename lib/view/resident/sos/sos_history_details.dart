import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ghp_society_management/constants/app_theme.dart';
import 'package:ghp_society_management/constants/snack_bar.dart';
import 'package:ghp_society_management/model/sos_history_model.dart';
import 'package:google_fonts/google_fonts.dart';

class SosHistoryDetails extends StatefulWidget {
  final SosHistoryList sosHistoryList;

  const SosHistoryDetails({super.key, required this.sosHistoryList});

  @override
  State<SosHistoryDetails> createState() => SosHistoryDetailsState();
}

class SosHistoryDetailsState extends State<SosHistoryDetails> {
  @override
  Widget build(BuildContext context) {
    String formatted = formatDate(widget.sosHistoryList.createdAt.toString());

    acknowledgedAt() {
      if (widget.sosHistoryList.acknowledgedAt != null) {
        return formatDate(widget.sosHistoryList.acknowledgedAt.toString());
      }
      return 'N/A';
    }

    acknowledgedBy() {
      if (widget.sosHistoryList.user != null) {
        return capitalizeWords(widget.sosHistoryList.user!.name ?? '')
            .replaceAll("_", ' ');
      }
      return 'N/A';
    }

    acknowledgedName() {
      if (widget.sosHistoryList.acknowledgedAt != null) {
        return capitalizeWords(widget.sosHistoryList.acknowledgedBy!.name ?? '')
            .replaceAll("_", ' ');
      }
      return 'N/A';
    }

    Widget sosPlace() {
      return widget.sosHistoryList.user!.member != null
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: Divider(color: Colors.grey.withOpacity(0.2))),
                Text("Alert Place ",
                    style: GoogleFonts.nunitoSans(
                        textStyle: TextStyle(
                            color: Colors.deepPurpleAccent, fontSize: 14.sp))),
                const SizedBox(height: 5),
                Row(
                  children: [
                    Expanded(
                        child: Text(
                            "Floor No : ${widget.sosHistoryList.user!.member!.floorNumber.toString()}",
                            style: GoogleFonts.nunitoSans(
                                textStyle: TextStyle(
                                    color: Colors.black87, fontSize: 14.sp)))),
                    Expanded(
                        child: Text(
                            "Property No : ${widget.sosHistoryList.user!.member!.aprtNo.toString()}",
                            style: GoogleFonts.nunitoSans(
                                textStyle: TextStyle(
                                    color: Colors.black87, fontSize: 14.sp))))
                  ],
                ),
              ],
            )
          : SizedBox();
    }

    Widget sosStatus() {
      return Text(capitalizeWords(widget.sosHistoryList.status.toString()),
          style: GoogleFonts.nunitoSans(
              textStyle: TextStyle(
                  color: widget.sosHistoryList.status == 'new'
                      ? Colors.orange
                      : widget.sosHistoryList.status == 'cancelled'
                          ? Colors.red
                          : Colors.deepPurpleAccent,
                  fontSize: 18.sp)));
    }

    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
                padding: EdgeInsets.only(top: 20.h, left: 12.h, bottom: 20.h),
                child: Row(children: [
                  GestureDetector(
                      onTap: () {
                        Navigator.of(context).pop();
                      },
                      child: const Icon(Icons.arrow_back, color: Colors.white)),
                  Padding(
                      padding: const EdgeInsets.only(left: 10),
                      child: Text('SOS Alert Details',
                          style: GoogleFonts.nunitoSans(
                              textStyle: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20.sp,
                                  fontWeight: FontWeight.w600))))
                ])),
            Expanded(
              child: Container(
                width: double.infinity,
                decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20),
                        topRight: Radius.circular(20))),
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          border:
                              Border.all(color: Colors.grey.withOpacity(0.3))),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                  child: Text("Alert Status",
                                      style: GoogleFonts.nunitoSans(
                                          textStyle: TextStyle(
                                              color: Colors.black,
                                              fontSize: 18.sp,
                                              fontWeight: FontWeight.w600)))),
                              Expanded(
                                child: sosStatus(),
                              ),
                            ],
                          ),
                          Padding(
                              padding: const EdgeInsets.symmetric(vertical: 4),
                              child:
                                  Divider(color: Colors.grey.withOpacity(0.2))),
                          Row(
                            children: [
                              Expanded(
                                  child: Text('Area : ',
                                      style: GoogleFonts.nunitoSans(
                                          textStyle: TextStyle(
                                              color: Colors.black87,
                                              fontSize: 14.sp)))),
                              Expanded(
                                child:
                                    Text(widget.sosHistoryList.area.toString(),
                                        style: GoogleFonts.nunitoSans(
                                          textStyle: TextStyle(
                                              color: Colors.black87,
                                              fontSize: 14.sp),
                                        )),
                              ),
                            ],
                          ),
                          Padding(
                              padding: const EdgeInsets.symmetric(vertical: 4),
                              child:
                                  Divider(color: Colors.grey.withOpacity(0.2))),
                          Row(children: [
                            Expanded(
                                child: Text('Acknowledged At ',
                                    style: GoogleFonts.nunitoSans(
                                        textStyle: TextStyle(
                                            color: Colors.black87,
                                            fontSize: 14.sp)))),
                            Expanded(
                                child: Text(acknowledgedAt(),
                                    style: TextStyle(
                                        color: Colors.black87,
                                        fontSize: 14.sp)))
                          ]),
                          Padding(
                              padding: const EdgeInsets.symmetric(vertical: 4),
                              child:
                                  Divider(color: Colors.grey.withOpacity(0.2))),
                          Row(
                            children: [
                              Expanded(
                                  child: Text('Created At : ',
                                      style: GoogleFonts.nunitoSans(
                                          textStyle: TextStyle(
                                              color: Colors.black87,
                                              fontSize: 14.sp)))),
                              Expanded(
                                child: Text(formatted,
                                    style: GoogleFonts.nunitoSans(
                                      textStyle: TextStyle(
                                          color: Colors.black87,
                                          fontSize: 14.sp),
                                    )),
                              ),
                            ],
                          ),
                          Padding(
                              padding: const EdgeInsets.symmetric(vertical: 4),
                              child:
                                  Divider(color: Colors.grey.withOpacity(0.2))),
                          Row(
                            children: [
                              Expanded(
                                  child: Text('SOS Category : ',
                                      style: GoogleFonts.nunitoSans(
                                          textStyle: TextStyle(
                                              color: Colors.black87,
                                              fontSize: 14.sp)))),
                              Expanded(
                                  child: Text(
                                      widget.sosHistoryList.sosCategory!.name
                                          .toString(),
                                      style: GoogleFonts.nunitoSans(
                                          textStyle: TextStyle(
                                              color: Colors.black87,
                                              fontSize: 14.sp))))
                            ],
                          ),
                          Padding(
                              padding: const EdgeInsets.symmetric(vertical: 4),
                              child:
                                  Divider(color: Colors.grey.withOpacity(0.2))),
                          Row(
                            children: [
                              Expanded(
                                  child: Text('Created By : ',
                                      style: GoogleFonts.nunitoSans(
                                          textStyle: TextStyle(
                                              color: Colors.black87,
                                              fontSize: 14.sp)))),
                              Expanded(
                                  child: Text(acknowledgedBy(),
                                      style: GoogleFonts.nunitoSans(
                                          textStyle: TextStyle(
                                              color: Colors.black87,
                                              fontSize: 14.sp))))
                            ],
                          ),
                          sosPlace(),
                          Padding(
                              padding: const EdgeInsets.symmetric(vertical: 4),
                              child:
                                  Divider(color: Colors.grey.withOpacity(0.2))),
                          Row(
                            children: [
                              Expanded(
                                  child: Text('Acknowledge By : ',
                                      style: GoogleFonts.nunitoSans(
                                          textStyle: TextStyle(
                                              color: Colors.black87,
                                              fontSize: 14.sp)))),
                              Expanded(
                                  child: Text(acknowledgedName(),
                                      style: GoogleFonts.nunitoSans(
                                          textStyle: TextStyle(
                                              color: Colors.black87,
                                              fontSize: 14.sp))))
                            ],
                          ),
                          Padding(
                              padding: const EdgeInsets.symmetric(vertical: 4),
                              child:
                                  Divider(color: Colors.grey.withOpacity(0.2))),
                          Row(
                            children: [
                              Expanded(
                                  child: Text('Description : ',
                                      style: GoogleFonts.nunitoSans(
                                          textStyle: TextStyle(
                                              color: Colors.black87,
                                              fontSize: 14.sp)))),
                              Expanded(
                                  child: Text(
                                      widget.sosHistoryList.description ?? '',
                                      style: GoogleFonts.nunitoSans(
                                          textStyle: TextStyle(
                                              color: Colors.black87,
                                              fontSize: 14.sp))))
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
