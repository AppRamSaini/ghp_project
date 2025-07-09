import 'dart:convert';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:ghp_society_management/constants/config.dart';
import 'package:ghp_society_management/constants/local_storage.dart';
import 'package:ghp_society_management/network/api_manager.dart';
import 'package:meta/meta.dart';

part 'verify_otp_state.dart';

class VerifyOtpCubit extends Cubit<VerifyOtpState> {
  VerifyOtpCubit() : super(VerifyOtpInitial());

  ApiManager apiManager = ApiManager();

  verifyOtp(String number, String otp, String token) async {
    emit(VerifyOtpLoading());
    try {
      var phoneBody = {"phone": number, "otp": otp, "device_id": token};
      var responseData = await apiManager.postRequest(
          phoneBody, Config.baseURL + Routes.verifyOtp, null);

      print('-------->>>>$token');

      var json = jsonDecode(responseData.body);
      var decodedBody = jsonDecode(responseData.body);
      print(responseData.statusCode);
      if (responseData.statusCode == 200) {
        if (json['status']) {
          await LocalStorage.localStorage
              .setString('token', decodedBody['data']['token']);
          await LocalStorage.localStorage
              .setString('role', decodedBody['data']['role']);
          await LocalStorage.localStorage.setString(
              'user_id', decodedBody['data']['user']['id'].toString());
          emit(VerifyOtpSuccessfully(role: decodedBody['data']['role']));
        } else {
          emit(VerifyOtpFailed(errorMessage: json['message']));
        }

        // if (decodedBody['data']['role'] == 'resident') {
        //   emit(VerifyOtpResidentSuccessfully());
        // } else if (decodedBody['data']['role'] == 'staff_security_guard') {
        //   emit(VerifyOtpSecurityStaffSuccessfully());
        // } else if (decodedBody['data']['role'] == 'admin') {
        //   emit(VerifyOtpAdminSuccessfully());
        // } else {
        //   emit(VerifyOtpStaffSuccessfully());
        // }
      } else {
        emit(VerifyOtpFailed(errorMessage: json['message']));
      }
    } on SocketException {
      emit(VerifyOtpInternetError());
    } catch (e) {
      emit(VerifyOtpFailed(errorMessage: 'Failed to verify OTP'));
    }
  }
}
