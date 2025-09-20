import 'dart:convert';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:ghp_society_management/constants/config.dart';
import 'package:ghp_society_management/constants/local_storage.dart';
import 'package:ghp_society_management/network/api_manager.dart';
import 'package:meta/meta.dart';

part 'accept_request_state.dart';

class AcceptRequestCubit extends Cubit<AcceptRequestState> {
  AcceptRequestCubit() : super(AcceptRequestInitial());
  ApiManager apiManager = ApiManager();

  acceptRequestAPI({var statusBody}) async {
    emit(AcceptRequestLoading());

    try {
      var token = LocalStorage.localStorage.getString('token');
      var responseData = await apiManager.postRequest(
          statusBody,
          Config.baseURL + Routes.incomingRequestResponse,
          {'Authorization': 'Bearer $token', 'Accept': 'application/json'});

      var data = json.decode((responseData.body.toString()));
      print('ACTION_BODY---->>>$statusBody');
      print('RES------------>>>>>$data');

      if (responseData.statusCode == 201) {
        if (data['status']) {
          emit(AcceptRequestSuccessfully(successMsg: data['message']));
        } else {
          emit(AcceptRequestFailed(errorMsg: data['message']));
        }
      } else if (responseData.statusCode == 401) {
        emit(AcceptRequestLogout());
      } else {
        emit(AcceptRequestFailed(errorMsg: data['message']));
      }
    } on SocketException {
      emit(AcceptRequestInternetError(errorMsg: "Internet Connection Failed"));
    } catch (e) {
      emit(AcceptRequestFailed(errorMsg: e.toString()));
    }
  }
}
