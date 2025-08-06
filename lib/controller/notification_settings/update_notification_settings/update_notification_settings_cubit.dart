import 'dart:io';
import 'package:flutter/material.dart';
import 'package:bloc/bloc.dart';
import 'package:ghp_society_management/constants/config.dart';
import 'package:ghp_society_management/constants/local_storage.dart';
import 'package:ghp_society_management/network/api_manager.dart';

part 'update_notification_settings_state.dart';

class UpdateNotificationSettingsCubit
    extends Cubit<UpdateNotificationSettingsState> {
  UpdateNotificationSettingsCubit()
      : super(UpdateNotificationSettingsInitial());

  ApiManager apiManager = ApiManager();

  Future<bool> updateNotificationSettingsAPI(notificationBody) async {
    print(notificationBody);
    emit(UpdateNotificationSettingsLoading());
    try {
      var token = LocalStorage.localStorage.getString('token');
      var responseData = await apiManager.postRequest(
          notificationBody,
          Config.baseURL + Routes.updateNotificationSettings,
          {'Authorization': 'Bearer $token', 'Accept': 'application/json'});

      print(responseData.statusCode);
      if (responseData.statusCode == 200) {
        emit(UpdateNotificationSettingsSuccessfully(
            message: 'Setting update successfully'));
        return     true;
      } else {
        emit(UpdateNotificationSettingsFailed(
            errorMessage: 'Failed update setting'));
        return false;
      }
    } on SocketException {
      emit(UpdateNotificationSettingsInternetError(
          errorMessage: 'Internet connection error'));
      return false;
    } catch (e) {
      emit(UpdateNotificationSettingsFailed(
          errorMessage: 'An error occurred $e '));
      return false;
    }
  }


  ////
}
