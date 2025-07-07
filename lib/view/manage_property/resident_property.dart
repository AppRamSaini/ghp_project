import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ghp_society_management/constants/app_theme.dart';
import 'package:google_fonts/google_fonts.dart';

class ManageProperty extends StatefulWidget {
  const ManageProperty({super.key});

  @override
  State<ManageProperty> createState() => _ManagePropertyState();
}

class _ManagePropertyState extends State<ManageProperty> {
  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
  }

  final List<String> propertyList = [
    "Property(A-1)",
    "Property(A-2)",
    "Property(A-3)"
  ];
  String? selectedValue;

  @override
  Widget build(BuildContext context) {
    // BlocBuilder<GetResidentsCubit, GetResidentsState>(
    // builder: (context, state) {
    //   if (state is GetResidentsLoaded &&
    //       state.getResidents.isNotEmpty &&
    //       state.getResidents.first.allResident?.residents != null &&
    //       state.getResidents.first.allResident!.residents!.isNotEmpty) {
    //     final residents = state.getResidents.first.allResident!.residents!
    //         .where((r) =>
    //     (r.townshipName?.isNotEmpty ?? false) &&
    //         (r.residentName?.isNotEmpty ?? false))
    //         .toList();
    //
    //     final uniqueResidents = {
    //       for (var r in residents) "${r.townshipId}_${r.residentId}": r
    //     }.values.toList();
    //
    //     // Initialize selectedValue if null or no longer valid
    //     if (selectedValue == null ||
    //         !uniqueResidents.any((r) => r.residentId == selectedValue?.residentId)) {
    //       selectedValue = uniqueResidents.isNotEmpty ? uniqueResidents.first : null;
    //     }
    //
    //     if (uniqueResidents.isEmpty) {
    //       return _emptyResidentWidget();
    //     }

    return Padding(
      padding: const EdgeInsets.only(left: 20),
      child: DropdownButton2<String>(

        underline: const SizedBox(),
        hint: Text("Select Property",
            style: GoogleFonts.poppins(
                color: Colors.white,
                fontSize: 13.0,
                fontWeight: FontWeight.w400)),
        items: propertyList
            .map(
              (String item) => DropdownMenuItem<String>(
                value: item,
                child: Text(
                  item,
                  style: GoogleFonts.poppins(
                    color: Colors.black,
                    fontSize: 14.0,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
            )
            .toList(),
        value: selectedValue,
        onChanged: (String? value) {
          // if (value == null) return;
          // setState(() => selectedValue = value);
          //
          // UserSecureStorage.setResidentId(value.residentId?.toString() ?? '');
          // UserSecureStorage.setTownshipId(value.townshipId?.toString() ?? '');
          // UserSecureStorage.setIdentity(value.aadharAuthentication?.toString() ?? 'false');
          //
          // messageCountCubit.messageCounter();
          // context.read<DocumentCountCubit>().documentCountType();
          //
          // if (value.aadharAuthentication == false && value.booklet != null) {
          //   privacyPolicyDialog(context, value.townshipId?.toString() ?? '', value.booklet ?? '');
          // }
        },
        iconStyleData: const IconStyleData(
            icon: Icon(Icons.expand_more),
            iconSize: 24,
            iconEnabledColor: Colors.white,
            iconDisabledColor: Colors.white),
        buttonStyleData: ButtonStyleData(
            padding: EdgeInsets.zero,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5), color:  AppTheme.primaryColor.withOpacity(0.7))),
        dropdownStyleData: DropdownStyleData(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              color: AppTheme.secondaryColor,
              border: const Border.symmetric(
                  horizontal: BorderSide(color: Colors.white))),
          offset: const Offset(10, -10),
          scrollbarTheme: ScrollbarThemeData(
            radius: const Radius.circular(20),
            thickness: MaterialStateProperty.all(6),
            thumbVisibility: MaterialStateProperty.all(true),
          ),
        ),
        menuItemStyleData: const MenuItemStyleData(height: 30),
      ),
    );
  }
}
