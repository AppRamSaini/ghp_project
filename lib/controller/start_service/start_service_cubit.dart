import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:ghp_society_management/constants/config.dart';
import 'package:ghp_society_management/constants/local_storage.dart';
import 'package:ghp_society_management/network/api_manager.dart';
import 'package:meta/meta.dart';

part 'start_service_state.dart';

class StartServiceCubit extends Cubit<StartServiceState> {
  StartServiceCubit() : super(StartServiceInitial());

  ApiManager apiManager = ApiManager();

  startService(String requestid) async {
    emit(StartServiceLoading());
    try {
      var token = LocalStorage.localStorage.getString('token');
      var response = await apiManager.postRequest(
          null,
          "${Config.baseURL}${Routes.startService}?service_request_id=${requestid}",
          {'Authorization': 'Bearer $token', 'Accept': 'application/json'});
      var data = json.decode(response.body.toString());
      if (response.statusCode == 200) {
        if (data['status']) {
          emit(StartServiceSuccess(successMsg: data['message'].toString()));
        } else {
          emit(StartServiceFailed(errorMsg: data['message'].toString()));
        }
      } else if (response.statusCode == 401 || response.statusCode == 403) {
        emit(StartServiceLogout());
      } else {
        emit(StartServiceFailed(errorMsg: data['message'].toString()));
      }
    } on SocketException {
      emit(StartServiceInternetError());
    } on TimeoutException {
      emit(StartServiceTimeout());
    } catch (e) {
      emit(StartServiceFailed(errorMsg: 'Error : Something went wrong'));
    }
  }
}
