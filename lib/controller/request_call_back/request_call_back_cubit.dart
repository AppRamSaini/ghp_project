import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:ghp_society_management/constants/config.dart';
import 'package:ghp_society_management/constants/local_storage.dart';
import 'package:ghp_society_management/network/api_manager.dart';
import 'package:meta/meta.dart';

part 'request_call_back_state.dart';

class RequestCallBackCubit extends Cubit<RequestCallBackState> {
  RequestCallBackCubit() : super(RequestCallBackInitial());

  ApiManager apiManager = ApiManager();

  requestCallBack(requestBody) async {
    emit(RequestCallBackLoading());
    try {
      print(requestBody);
      var token = LocalStorage.localStorage.getString('token');

      var responseData = await apiManager.postRequest(
        requestBody,
        Config.baseURL + Routes.requestCallBack,
        {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      );

      print(responseData.body);

      if (responseData.statusCode == 201) {
        emit(RequestCallBacksuccessfully());
      } else if (responseData.statusCode == 401) {
        emit(RequestCallBackLogout());
      } else {
        emit(RequestCallBackFailed());
      }
    } on SocketException {
      emit(RequestCallBackInternetError());
    } catch (e) {
      print(e);
      emit(RequestCallBackFailed());
    }
  }
}
