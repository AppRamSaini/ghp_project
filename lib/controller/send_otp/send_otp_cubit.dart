import 'dart:convert';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:ghp_society_management/constants/config.dart';
import 'package:ghp_society_management/network/api_manager.dart';
import 'package:meta/meta.dart';

part 'send_otp_state.dart';

class SendOtpCubit extends Cubit<SendOtpState> {
  SendOtpCubit() : super(SendOtpInitial());

  ApiManager apiManager = ApiManager();

  sendOtp(String number, String societyId) async {
    emit(SendOtpLoading());
    try {
      var phoneBody = {"phone": number, "society_id": societyId};

      var responseData = await apiManager.postRequest(
        phoneBody,
        Config.baseURL + Routes.sendOtp,
        null,
      );

      var json = jsonDecode(responseData.body);


      print('----->>>>$json');
      if (responseData.statusCode == 200 || responseData.statusCode == 201) {
        emit(SendOtpSuccessfully());
      } else {
        emit(SendOtpFailed(errorMessage: json['message']));
      }
    } on SocketException {
      emit(SendOtpInternetError());
    } catch (e) {
      emit(SendOtpFailed(errorMessage: 'Failed to send an OTP'));
    }
  }
}
