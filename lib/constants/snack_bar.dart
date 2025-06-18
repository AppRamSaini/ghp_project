import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ghp_society_management/constants/app_theme.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:searchbar_animation/searchbar_animation.dart';
import 'package:url_launcher/url_launcher.dart';

void snackBar(BuildContext context, String title, IconData icon, Color color) {
  final overlay = Overlay.of(context);
  final overlayEntry = OverlayEntry(
    builder: (context) => Positioned(
      top: MediaQuery.of(context).padding.top + 15, // Top position with padding
      left: 15,
      right: 15,
      child: Material(
        color: Colors.transparent,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 13),
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(4),
            boxShadow: const [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 4,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            children: [
              Icon(icon, color: Colors.white),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  title,
                  style: GoogleFonts.nunitoSans(
                    color: Colors.white,
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    ),
  );
  overlay.insert(overlayEntry);
  Future.delayed(const Duration(seconds: 2), () {
    overlayEntry.remove();
  });
}

snackBarMsg(BuildContext context, String msg) {
  WidgetsBinding.instance.addPostFrameCallback((_) {
    final snackBar = SnackBar(
        backgroundColor: Colors.red,
        clipBehavior: Clip.hardEdge,
        behavior: SnackBarBehavior.floating,
        content: Text(msg.toString()));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  });
}

String capitalizeWords(String input) {
  return input
      .split(' ')
      .map((word) => word.isNotEmpty
          ? '${word[0].toUpperCase()}${word.substring(1).toLowerCase()}'
          : '')
      .join(' ');
}

// find current datetime
getDateTime() {
  DateTime now = DateTime.now();
  String formattedDateTime = DateFormat('yyyy-MM-dd HH:mm:ss').format(now);
  return formattedDateTime;
}

/// AMENITIES  WIDGET
Widget amenitiesWidget(String text, Function()? onTap) => Container(
      margin: const EdgeInsets.only(bottom: 8, right: 8),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          border: Border.all(color: AppTheme.primaryColor)),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(text,
              style: GoogleFonts.nunitoSans(
                textStyle: TextStyle(
                  color: AppTheme.primaryColor,
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w500,
                ),
              )),
          const SizedBox(width: 10),
          GestureDetector(
            onTap: onTap,
            child: Icon(
              Icons.clear,
              size: 20,
              color: AppTheme.primaryColor,
            ),
          )
        ],
      ),
    );

/// find date and moths name

monthYear(DateTime assignedDate) {
  return "${_getMonthName(assignedDate.month)} ${assignedDate.year}";
}

// महीना और साल (Month & Year) निकालना

String _getMonthName(int month) {
  List<String> months = [
    "Jan",
    "Feb",
    "Mar",
    "Apr",
    "May",
    "Jun",
    "Jul",
    "Aug",
    "Sep",
    "Oct",
    "Nov",
    "Dec"
  ];
  return months[month - 1];
}

String _formatTime(int hour, int minute) {
  String period = hour >= 12 ? "PM" : "AM";
  int formattedHour = hour % 12 == 0 ? 12 : hour % 12;
  String formattedMinute = minute.toString().padLeft(2, '0');
  return "$formattedHour:$formattedMinute $period";
}

formatTime(DateTime assignedDate) {
  return _formatTime(assignedDate.hour, assignedDate.minute);
}

/// phone call launcher
phoneCallLauncher(String number) async {
  final call = Uri.parse('tel:${number.toString()}');
  if (await canLaunchUrl(call)) {
    launchUrl(call);
  } else {
    throw 'Could not launch $call';
  }
}

String formatDate(String dateTime) {
  DateTime parsedDate = DateTime.parse(dateTime).toLocal();
  String formattedDate = DateFormat('MMM dd, yyyy hh:mm a').format(parsedDate);
  return formattedDate;
}

String formatDateOnly(String dateTime) {
  DateTime parsedDate = DateTime.parse(dateTime).toLocal();
  String formattedDate = DateFormat('MMM dd, yyyy').format(parsedDate);
  return formattedDate;
}

String formatCheckoutDate(String checkoutAtString) {
  if (checkoutAtString.isEmpty) return "No Date Available";

  DateTime checkoutDate = DateTime.parse(checkoutAtString);
  DateTime now = DateTime.now();

  if (checkoutDate.year == now.year &&
      checkoutDate.month == now.month &&
      checkoutDate.day == now.day) {
    return "Today";
  } else if (checkoutDate.year == now.year &&
      checkoutDate.month == now.month &&
      checkoutDate.day == now.day - 1) {
    return "Yesterday";
  } else {
    return DateFormat("MMM d, yyyy")
        .format(checkoutDate); // Example: Mar 19, 2025
  }
}

String formatShiftTime(String shiftTime) {
  List<String> parts = shiftTime.split(":"); // Split "HH:mm:ss"

  if (parts.length != 3) return "Invalid Time"; // Handle errors

  DateTime dateTime = DateTime(
    DateTime.now().year, // Use today's date
    DateTime.now().month,
    DateTime.now().day,
    int.parse(parts[0]), // Hours
    int.parse(parts[1]), // Minutes
    int.parse(parts[2]), // Seconds
  );

  return DateFormat('hh:mm a').format(dateTime); // Convert to AM/PM format
}



// CUSTOM APPBAR
AppBar customAppbar(
    {required BuildContext context,
      required String title,
      bool searchBarOpen = false,
      required TextEditingController textController,
      Function()? onExpansionComplete,
      Function()? onCollapseComplete,
      Function(bool)? onPressButton,
      String hintText = "Search Here",
      Function? onChanged}) {
  return AppBar(
    iconTheme: const IconThemeData(color: Colors.black),
    title: searchBarOpen
        ? const SizedBox()
        : Text(title,
        style: GoogleFonts.nunitoSans(
            textStyle: TextStyle(
                color: Colors.black,
                fontSize: 16.sp,
                fontWeight: FontWeight.w600))),
    actions: [
      SearchBarAnimation(
        searchBoxColour: AppTheme.white,
        buttonColour: AppTheme.primaryColor,
        cursorColour: AppTheme.primaryColor,
        isSearchBoxOnRightSide: false,
        textEditingController: textController,
        isOriginalAnimation: true,
        enableKeyboardFocus: true,
        hintTextColour: AppTheme.primaryColor,
        trailingWidget:
        Icon(Icons.search, size: 20, color: AppTheme.primaryColor),
        secondaryButtonWidget:
        const Icon(Icons.close, size: 20, color: Colors.white),
        buttonWidget: Icon(Icons.search, size: 20, color: AppTheme.white),
        searchBoxWidth: MediaQuery.of(context).size.width / 1.1,

        enteredTextStyle: GoogleFonts.nunitoSans(
            textStyle: TextStyle(
                color: AppTheme.primaryColor,
                fontSize: 14.sp,
                fontWeight: FontWeight.w600)),
        hintText: hintText,
        onExpansionComplete: onExpansionComplete,
        onCollapseComplete: onCollapseComplete,
        onPressButton: onPressButton,
        onChanged: onChanged,
      ),
    ],
  );
}



String formatTimeToAMPM(String time) {
  final inputFormat = DateFormat("HH:mm:ss");
  final outputFormat = DateFormat("hh:mm a");

  final dateTime = inputFormat.parse(time);
  return outputFormat.format(dateTime);
}



String convertDateTimeFormat(DateTime inputDate) {
  String formattedDate = DateFormat('dd MMMM, y').format(inputDate);

  String formattedTime = DateFormat('hh:mm a').format(inputDate);

  return '$formattedDate $formattedTime';
}

String convertDateFormat(DateTime inputDate) {
  String formattedDate = DateFormat('dd MMMM, y').format(inputDate);

  return formattedDate;
}

String convertTimeFormat(DateTime inputDate) {
  String formattedTime = DateFormat('hh:mm a').format(inputDate);

  return formattedTime;
}
