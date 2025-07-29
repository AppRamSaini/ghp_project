import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ghp_society_management/constants/app_theme.dart';
import 'package:ghp_society_management/constants/local_storage.dart';
import 'package:ghp_society_management/controller/my_bills/my_bills_cubit.dart';
import 'package:ghp_society_management/controller/property_listing/property_listing_cubit.dart';
import 'package:ghp_society_management/controller/user_profile/user_profile_cubit.dart';
import 'package:ghp_society_management/model/property_listing_model.dart';
import 'package:google_fonts/google_fonts.dart';

class ManageProperty extends StatefulWidget {
  const ManageProperty({super.key});

  @override
  State<ManageProperty> createState() => _ManagePropertyState();
}

class _ManagePropertyState extends State<ManageProperty> {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  late final PropertyListingCubit _propertyListingCubit;
  PropertyList? selectedValue;

  @override
  void initState() {
    super.initState();
    _propertyListingCubit = PropertyListingCubit();
    _propertyListingCubit.fetchPropertyList();
  }

  @override
  void dispose() {
    _propertyListingCubit.close();
    super.dispose();
  }

  void _onPropertyChanged(PropertyList value) {
    setState(() => selectedValue = value);
    LocalStorage.localStorage.setString('property_id', value.id.toString());
    context.read<UserProfileCubit>().fetchUserProfile();
    context
        .read<MyBillsCubit>()
        .fetchMyBills(context: context, billTypes: "all");
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PropertyListingCubit, PropertyListingState>(
      bloc: _propertyListingCubit,
      builder: (context, state) {
        if (state is PropertyListingLoading) {
          return CircleAvatar(
              backgroundColor: AppTheme.white.withOpacity(0.5),
              child:
                  Icon(Icons.more_horiz, color: AppTheme.resolvedButtonColor));
        } else if (state is PropertyListingError) {
          return SizedBox();
        } else if (state is PropertyListingLoaded) {
          final propData = state.propertyList.data ?? [];
          if (propData.isEmpty) {
            return Center(
                child: CircleAvatar(
                    backgroundColor: AppTheme.white.withOpacity(0.5),
                    child: Icon(Icons.more_horiz,
                        color: AppTheme.resolvedButtonColor)));
          }

          final storedPropId =
              LocalStorage.localStorage.getString('property_id');

          selectedValue ??= propData.firstWhere(
            (element) => element.id.toString() == storedPropId,
            orElse: () => propData.first,
          );

          if (storedPropId == null || storedPropId.isEmpty) {
            LocalStorage.localStorage
                .setString('property_id', selectedValue!.id.toString());
            context.read<UserProfileCubit>().fetchUserProfile();
            context
                .read<MyBillsCubit>()
                .fetchMyBills(context: context, billTypes: "all");
          }

          return CircleAvatar(
            backgroundColor: AppTheme.white.withOpacity(0.5),
            child: PopupMenuButton<PropertyList>(
              initialValue:
                  propData.contains(selectedValue) ? selectedValue : null,
              onSelected: _onPropertyChanged,
              offset: Offset(0, 40),
              itemBuilder: (context) {
                return propData.map((item) {
                  return PopupMenuItem<PropertyList>(
                    value: item,
                    child: Text(
                      "${item.name ?? ''} (${item.blockName} - ${item.aprtNo})",
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  );
                }).toList();
              },
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5)),
              color: AppTheme.white,
              child:
                  Icon(Icons.more_horiz, color: AppTheme.resolvedButtonColor),
            ),
          );
        } else {
          return const SizedBox();
        }
      },
    );
  }
}

//   Align(
//   alignment: Alignment.centerLeft,
//   child: Padding(
//     padding: const EdgeInsets.only(left: 20, top: 5),
//     child: DropdownButton2<PropertyList>(
//         underline: const SizedBox(),
//         hint: Text(
//           "Select Property",
//           style: GoogleFonts.poppins(
//             color: Colors.white,
//             fontSize: 13.0,
//             fontWeight: FontWeight.w400,
//           ),
//         ),
//         items: propData.map((item) {
//           return DropdownMenuItem<PropertyList>(
//             value: item,
//             child: Text(
//               "${item.name ?? ''} - ${item.aprtNo ?? ''}",
//               style: GoogleFonts.poppins(
//                   fontSize: 15,
//                   color: Colors.black,
//                   fontWeight: FontWeight.w500),
//             ),
//           );
//         }).toList(),
//         value:
//             propData.contains(selectedValue) ? selectedValue : null,
//         onChanged: (PropertyList? value) {
//           setState(() => selectedValue = value);
//           if (value != null) {
//             LocalStorage.localStorage
//                 .setString('property_id', value.id.toString());
//             context.read<UserProfileCubit>().fetchUserProfile();
//             context.read<MyBillsCubit>().fetchMyBills(context: context,billTypes: "all");
//           }
//         },
//         iconStyleData: const IconStyleData(
//             icon: Icon(Icons.expand_more),
//             iconSize: 24,
//             iconEnabledColor: Colors.white,
//             iconDisabledColor: Colors.white),
//         buttonStyleData: ButtonStyleData(
//           padding: EdgeInsets.zero,
//           decoration: BoxDecoration(
//             borderRadius: BorderRadius.circular(5),
//             color: AppTheme.primaryColor.withOpacity(0.7),
//           ),
//         ),
//         dropdownStyleData: DropdownStyleData(
//             decoration: BoxDecoration(
//                 borderRadius: BorderRadius.circular(5),
//                 color: AppTheme.secondaryColor,
//                 border: const Border.symmetric(
//                     horizontal: BorderSide(color: Colors.white))),
//             offset: const Offset(10, -10),
//             scrollbarTheme: ScrollbarThemeData(
//                 radius: const Radius.circular(20),
//                 thickness: MaterialStateProperty.all(6),
//                 thumbVisibility: MaterialStateProperty.all(true))),
//         menuItemStyleData: const MenuItemStyleData(height: 40)),
//   ),
// );
