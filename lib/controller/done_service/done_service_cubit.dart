import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:ghp_society_management/constants/config.dart';
import 'package:ghp_society_management/constants/local_storage.dart';
import 'package:ghp_society_management/network/api_manager.dart';
import 'package:meta/meta.dart';

part 'done_service_state.dart';

class DoneServiceCubit extends Cubit<DoneServiceState> {
  DoneServiceCubit() : super(DoneServiceInitial());

  ApiManager apiManager = ApiManager();

  doneService(String serviceId, String otp) async {
    emit(DoneServiceLoading());
    try {
      var body = {'service_request_id': serviceId, 'otp': otp};

      var token = LocalStorage.localStorage.getString('token');

      var response = await apiManager.postRequest(
          body,
          Config.baseURL + Routes.doneService,
          {'Authorization': 'Bearer $token', 'Accept': 'application/json'});

      var resData = json.decode(response.body.toString());

      if (response.statusCode == 200) {
        if (resData['status']) {
          emit(DoneServiceSuccess(successMsg: resData['message'].toString()));
        } else {
          emit(DoneServiceFailed(errorMsg: resData['message'].toString()));
        }
      } else if (response.statusCode == 401) {
        emit(DoneServiceLogout());
      } else {
        emit(DoneServiceFailed(errorMsg: resData['message'].toString()));
      }
    } on SocketException {
      emit(DoneServiceInternetError());
    } on TimeoutException {
      emit(DoneServiceTimeout());
    } catch (e) {
      emit(DoneServiceFailed(errorMsg: "Error ${e.toString()}"));
    }
  }
}
