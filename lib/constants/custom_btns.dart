import 'package:ghp_society_management/constants/export.dart';
import 'package:ghp_society_management/main.dart';

Widget customBtn({void Function()?onTap,String? txt})=>GestureDetector(
  onTap: onTap,
  child: SafeArea(
    top: false,
    child: Container(

      margin: EdgeInsets.symmetric(horizontal: size.width*0.035,vertical: size.height*0.01),
      width: double.infinity,
      height: size.height*0.056,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          color: AppTheme.primaryColor),
      child: Center(
        child: Text(
          txt.toString(),
          style: GoogleFonts.nunitoSans(
            textStyle: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    ),
  ),
);