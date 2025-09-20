import 'dart:convert';
import 'dart:io';

import 'package:ghp_society_management/constants/config.dart';
import 'package:ghp_society_management/network/api_manager.dart';

import '../../constants/export.dart';

part 'update_fcm_state.dart';

class UpdateFCMCubit extends Cubit<UpdateFCMState> {
  UpdateFCMCubit() : super(UpdateFCMInitial());

  ApiManager apiManager = ApiManager();

  updateFCMData(String fcm) async {
    var token = LocalStorage.localStorage.getString('token');
    emit(UpdateFCMLoading());
    try {
      var bodyData = {"device_token": fcm};

      var responseData = await apiManager.postRequest(
          bodyData,
          Routes.updateFCM,
          {'Authorization': 'Bearer $token', 'Accept': 'application/json'});

      var json = jsonDecode(responseData.body);

      print('----->>>>$json');
      if (responseData.statusCode == 200 || responseData.statusCode == 201) {
        print("✅ Token sent to server: $token");
        emit(UpdateFCMSuccessfully());
      } else {
        emit(UpdateFCMFailed(errorMessage: json['message']));
      }
    } on SocketException {
      emit(UpdateFCMInternetError());
    } catch (e) {
      emit(UpdateFCMFailed(errorMessage: 'Failed to send an OTP'));
    }
  }
}
