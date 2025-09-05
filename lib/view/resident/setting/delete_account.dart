import 'package:ghp_society_management/constants/custom_btns.dart';
import 'package:ghp_society_management/constants/export.dart';
import 'package:ghp_society_management/view/resident/setting/log_out_dialog.dart';

class DeleteUserAccount extends StatefulWidget {
  const DeleteUserAccount({super.key});

  @override
  State<DeleteUserAccount> createState() => _DeleteUserAccountState();
}

class _DeleteUserAccountState extends State<DeleteUserAccount> {
  String? selectedValue;
  List<String> reasonList = [
    'Find a Better Alternative',
    'Need a Break',
    'Do not find useful anymore',
    'Other',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: appbarWidget(title: "Delete Account"),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15.0),
        child: Column(
          children: [
            SizedBox(height: 20),
            Image.asset(ImageAssets.appLogo, height: 150.h),
            SizedBox(height: 20),
            Text('Delete your account ',
                style: TextStyle(color: Colors.black, fontSize: 25)),
            SizedBox(height: 10),
            Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30),
                child: Text(
                  "Help us improve our app, Explain the reason why you want to delete your account",
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.black, fontSize: 14),
                )),
            const SizedBox(height: 20),
            DropdownButtonHideUnderline(
              child: DropdownButton2<String>(
                isExpanded: true,
                hint: Text('Select Reason Type',
                    style: TextStyle(color: Colors.black54, fontSize: 14),
                    overflow: TextOverflow.ellipsis),
                items: reasonList
                    .map((String item) => DropdownMenuItem<String>(
                          value: item,
                          child: Text(
                            item,
                            style: TextStyle(color: Colors.black, fontSize: 16),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ))
                    .toList(),
                value: selectedValue,
                onChanged: (String? value) {
                  selectedValue = value;
                  setState(() {});
                },
                buttonStyleData: ButtonStyleData(
                    height: 50,
                    padding: const EdgeInsets.only(left: 5, right: 5),
                    decoration: BoxDecoration(
                        border: Border.all(color: Colors.black),
                        borderRadius:
                            const BorderRadius.all(Radius.circular(5)))),
                iconStyleData: const IconStyleData(
                    icon: Icon(Icons.arrow_drop_down_sharp), iconSize: 25),
                dropdownStyleData: DropdownStyleData(
                  maxHeight: 200,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      color: Colors.white),
                  offset: const Offset(0, -5),
                  scrollbarTheme: ScrollbarThemeData(
                    radius: const Radius.circular(5),
                    thickness: MaterialStateProperty.all<double>(6),
                    thumbVisibility: MaterialStateProperty.all<bool>(true),
                  ),
                ),
                menuItemStyleData: const MenuItemStyleData(
                  height: 40,
                  padding: EdgeInsets.only(left: 14, right: 14),
                ),
              ),
            ),
            Spacer(),
            customBtn(
              onTap: () {
                if (selectedValue != null) {
                  deleteAccountPermissionDialog(context);
                } else {
                  snackBar(context, 'Please Select Reason Type', Icons.warning,
                      Colors.red);
                }
              },
              txt: "Delete Account",

            ),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
