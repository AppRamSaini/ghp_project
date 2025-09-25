import 'package:flutter/material.dart';
import 'package:ghp_society_management/constants/snack_bar.dart';
import 'package:ghp_society_management/model/service_request_history_model.dart';
import 'package:google_fonts/google_fonts.dart';

class ServiceDetailScreen extends StatefulWidget {
  final ServiceHistoryModel data;

  const ServiceDetailScreen({super.key, required this.data});

  @override
  State<ServiceDetailScreen> createState() => _ServiceDetailScreenState();
}

class _ServiceDetailScreenState extends State<ServiceDetailScreen> {
  @override
  Widget build(BuildContext context) {
    String status = widget.data.status!.toString();

    getStatus() {
      if (status == 'assigned') {
        return Text(capitalizeWords(status.toString()),
            style: const TextStyle(color: Colors.blue, fontSize: 16));
      } else if (status == 'in_progress') {
        return Text(capitalizeWords(status.toString()).replaceFirst("_", " "),
            style:
                const TextStyle(color: Colors.deepPurpleAccent, fontSize: 16));
      } else {
        return Text(capitalizeWords(status.toString()),
            style: const TextStyle(color: Colors.green, fontSize: 16));
      }
    }

    return Scaffold(
      appBar: appbarWidget(title: 'Service Details'),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(10),
          margin: const EdgeInsets.all(10),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.grey.withOpacity(0.2))),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Service Details',
                      style: GoogleFonts.nunitoSans(
                          color: Colors.black,
                          fontSize: 16,
                          fontWeight: FontWeight.w600)),
                  getStatus()
                ],
              ),
              Divider(color: Colors.grey.withOpacity(0.2)),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Property No : ',
                      style: GoogleFonts.nunitoSans(
                          color: const Color(0Xff666666),
                          fontSize: 14,
                          fontWeight: FontWeight.w500)),
                  Text('${widget.data.aprtNo}',
                      style: GoogleFonts.nunitoSans(
                          color: Colors.black,
                          fontSize: 12,
                          fontWeight: FontWeight.w600))
                ],
              ),
              Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Divider(color: Colors.grey.withOpacity(0.2))),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Service Name :",
                      style: GoogleFonts.nunitoSans(
                          color: const Color(0Xff666666),
                          fontSize: 14,
                          fontWeight: FontWeight.w600)),
                  Text(widget.data.serviceCategory!.name.toString(),
                      style: GoogleFonts.nunitoSans(
                          color: Colors.black,
                          fontSize: 14,
                          fontWeight: FontWeight.w600)),
                ],
              ),
              Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Divider(color: Colors.grey.withOpacity(0.2))),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Service Area :",
                      style: GoogleFonts.nunitoSans(
                          color: const Color(0Xff666666),
                          fontSize: 14,
                          fontWeight: FontWeight.w600)),
                  Text(widget.data.area.toString(),
                      style: GoogleFonts.nunitoSans(
                          color: Colors.black,
                          fontSize: 14,
                          fontWeight: FontWeight.w600)),
                ],
              ),
              Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Divider(color: Colors.grey.withOpacity(0.2))),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Create At :",
                      style: GoogleFonts.nunitoSans(
                          color: const Color(0Xff666666),
                          fontSize: 14,
                          fontWeight: FontWeight.w600)),
                  Text(
                      "${convertDateFormat(widget.data.createdAt!)} ${convertTimeFormat(widget.data.createdAt!)}",
                      style: GoogleFonts.nunitoSans(
                          color: Colors.black,
                          fontSize: 14,
                          fontWeight: FontWeight.w600)),
                ],
              ),
              Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Divider(color: Colors.grey.withOpacity(0.2))),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Assigned At :",
                      style: GoogleFonts.nunitoSans(
                          color: const Color(0Xff666666),
                          fontSize: 14,
                          fontWeight: FontWeight.w600)),
                  Text(
                      "${convertDateFormat(widget.data.assignedAt!)} ${convertTimeFormat(widget.data.assignedAt!)}",
                      style: GoogleFonts.nunitoSans(
                          color: Colors.black,
                          fontSize: 14,
                          fontWeight: FontWeight.w600)),
                ],
              ),
              Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Divider(color: Colors.grey.withOpacity(0.2))),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Start At :",
                      style: GoogleFonts.nunitoSans(
                          color: const Color(0Xff666666),
                          fontSize: 14,
                          fontWeight: FontWeight.w600)),
                  Text(
                      "${widget.data.startAt != null ? convertDateFormat(widget.data.startAt!) : 'N/A'} ${widget.data.startAt != null ? convertTimeFormat(widget.data.startAt!) : ''}",
                      style: GoogleFonts.nunitoSans(
                          color: Colors.black,
                          fontSize: 14,
                          fontWeight: FontWeight.w600)),
                ],
              ),
              Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Divider(color: Colors.grey.withOpacity(0.2))),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Description :",
                      style: GoogleFonts.nunitoSans(
                          color: const Color(0Xff666666),
                          fontSize: 14,
                          fontWeight: FontWeight.w600)),
                  Text(widget.data.description.toString(),
                      style: GoogleFonts.nunitoSans(
                          color: Colors.black,
                          fontSize: 14,
                          fontWeight: FontWeight.w600)),
                ],
              ),
              Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Divider(color: Colors.grey.withOpacity(0.2))),
              Text("Resident Details",
                  style: GoogleFonts.nunitoSans(
                      color: Colors.lightBlue,
                      fontSize: 16,
                      fontWeight: FontWeight.w600)),
              Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Divider(color: Colors.grey.withOpacity(0.2))),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Name :",
                      style: GoogleFonts.nunitoSans(
                          color: const Color(0Xff666666),
                          fontSize: 14,
                          fontWeight: FontWeight.w600)),
                  Text(widget.data.member!.name.toString(),
                      style: GoogleFonts.nunitoSans(
                          color: Colors.black,
                          fontSize: 14,
                          fontWeight: FontWeight.w600)),
                ],
              ),
              Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Divider(color: Colors.grey.withOpacity(0.2))),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Phone :",
                      style: GoogleFonts.nunitoSans(
                          color: const Color(0Xff666666),
                          fontSize: 14,
                          fontWeight: FontWeight.w600)),
                  Text("+91 ${widget.data.member!.phone.toString()}",
                      style: GoogleFonts.nunitoSans(
                          color: Colors.black,
                          fontSize: 14,
                          fontWeight: FontWeight.w600)),
                ],
              ),
              Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Divider(color: Colors.grey.withOpacity(0.2))),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text('Tower/Block ',
                            style: GoogleFonts.nunitoSans(
                                textStyle: TextStyle(
                                    color: Colors.black54, fontSize: 14))),
                        Text(widget.data.member!.blockName.toString(),
                            style: GoogleFonts.nunitoSans(
                                textStyle: TextStyle(
                                    color: Colors.black,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600)))
                      ]),
                  // Column(
                  //     crossAxisAlignment: CrossAxisAlignment.center,
                  //     children: [
                  //       Text('Floor',
                  //           style: GoogleFonts.nunitoSans(
                  //               textStyle: TextStyle(
                  //                   color: Colors.black54, fontSize: 14))),
                  //       Text(widget.data.member!.floorNumber.toString(),
                  //           style: GoogleFonts.nunitoSans(
                  //               textStyle: TextStyle(
                  //                   color: Colors.black,
                  //                   fontSize: 14,
                  //                   fontWeight: FontWeight.w600)))
                  //     ]),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text('Property No',
                          style: GoogleFonts.nunitoSans(
                              textStyle: TextStyle(
                                  color: Colors.black54, fontSize: 14))),
                      Text(
                        widget.data.member!.aprtNo.toString(),
                        style: GoogleFonts.nunitoSans(
                          textStyle: TextStyle(
                            color: Colors.black,
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
