import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ghp_society_management/constants/app_theme.dart';
import 'package:ghp_society_management/constants/snack_bar.dart';
import 'package:ghp_society_management/controller/notification_settings/get_notification_settings/get_notification_settings_cubit.dart';
import 'package:ghp_society_management/controller/notification_settings/update_notification_settings/update_notification_settings_cubit.dart';
import 'package:ghp_society_management/model/get_notification_settings_model.dart';
import 'package:google_fonts/google_fonts.dart';

class NotificationScreen extends StatefulWidget {
  bool isStaffSide = false;

  NotificationScreen({super.key, this.isStaffSide = false});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  Map<String, bool> toggleStates = {}; // Toggle states for each setting
  late GetNotificationSettingsCubit _getNotificationSettingsCubit;
  String updateValue = '';
  String updatingSetting = ''; // Holds the setting being updated

  @override
  void initState() {
    super.initState();
    _getNotificationSettingsCubit = GetNotificationSettingsCubit();
    _getNotificationSettingsCubit.fetchGetNotificationSettingsAPI();
  }

  BuildContext? dialogueContext;




  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(
        'Notification Settings',
        style: GoogleFonts.nunitoSans(
          textStyle: TextStyle(
            color: Colors.black,
            fontSize: 16.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
      )),
      body: BlocListener<UpdateNotificationSettingsCubit,
          UpdateNotificationSettingsState>(
        listener: (context, state) {
          if (state is UpdateNotificationSettingsLoading) {
            /*  showLoadingDialog(context, (ctx) {
              dialogueContext = ctx;
            });*/
          } else if (state
              is UpdateNotificationSettingsSuccessfully) {
            // snackBar(context, state.message.toString(), Icons.done,
            //     AppTheme.guestColor);

            // Navigator.of(dialogueContext!).pop();
            // Update the toggle state only upon success
            setState(() {
              toggleStates[updatingSetting] =
                  updateValue == 'enabled';
              updatingSetting = '';
            });
          } else if (state
              is UpdateNotificationSettingsInternetError) {
            snackBar(context, state.errorMessage.toString(),
                Icons.done, AppTheme.redColor);

            // Navigator.of(dialogueContext!).pop();
          }
        },
        child: BlocBuilder<GetNotificationSettingsCubit,
            GetNotificationSettingsState>(
          bloc: _getNotificationSettingsCubit,
          builder: (context, state) {
            if (state is GetNotificationSettingsLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is GetNotificationSettingsLoaded) {
              List<NotificationSetting> data =
                  state.notificationSettings;
              for (var setting in data) {
                toggleStates[setting.name] ??=
                    setting.status == "enabled";
              }

              return ListView.builder(
                padding: const EdgeInsets.symmetric(
                    horizontal: 15, vertical: 5),
                itemCount: data.length,
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  String formattedTitle = data[index]
                      .name
                      .replaceAll('_', ' ')
                      .split(' ')
                      .map((word) =>
                          word[0].toUpperCase() + word.substring(1))
                      .join(' ');

                  return _buildSwitchRow(
                    formattedTitle,
                    toggleStates[data[index].name] ?? false,
                    (value) {
                      setState(() {
                        updatingSetting = data[index].name;
                        updateValue = value ? 'enabled' : 'disabled';
                        var bodyData = {
                          "name": data[index].name,
                          "status": updateValue
                        };
                        context
                            .read<UpdateNotificationSettingsCubit>()
                            .updateNotificationSettingsAPI(bodyData);
                      });
                    },
                  );
                },
              );
            } else if (state is GetNotificationSettingsFailed) {
              return Center(
                  child: Text(state.errorMessage.toString(),
                      style: const TextStyle(
                          color: Colors.deepPurpleAccent)));
            } else if (state
                is GetNotificationSettingsInternetError) {
              return Center(
                  child: Text(state.errorMessage.toString(),
                      style: const TextStyle(color: Colors.red)));
            }
            return const SizedBox();
          },
        ),
      ),
    );
  }

  Widget _buildSwitchRow(
      String title, bool switchValue, ValueChanged<bool> onChanged) {
    return Card(
      color: AppTheme.white,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 5.0,horizontal: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: GoogleFonts.nunitoSans(
                textStyle: TextStyle(
                  color: Colors.black,
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            Transform.scale(
              scale: 0.7,
              child: CupertinoSwitch(
                activeColor: AppTheme.primaryColor,
                value: switchValue,
                onChanged: onChanged,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
