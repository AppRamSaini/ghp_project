import 'dart:convert';
import 'dart:io';
import 'package:bloc/bloc.dart';
import 'package:ghp_society_management/constants/config.dart';
import 'package:ghp_society_management/constants/local_storage.dart';
import 'package:ghp_society_management/network/api_manager.dart';
import 'package:meta/meta.dart';

part 'sos_cancel_state.dart';

class SosCancelCubit extends Cubit<SosCancelState> {
  SosCancelCubit() : super(SosCancelInitial());

  ApiManager apiManager = ApiManager();

  sosCancelApi(sosBody) async {
    emit(SosCancelLoading());
    try {
      var token = LocalStorage.localStorage.getString('token');

      var responseData = await apiManager.postRequest(
          sosBody,
          Config.baseURL + Routes.sosCancel,
          {'Authorization': 'Bearer $token', 'Accept': 'application/json'});

      var data = json.decode(responseData.body.toString());
      if (responseData.statusCode == 200) {
        if (data['status']) {
          emit(SosCancelSuccessfully(successMsg: data['message'].toString()));
        } else {
          emit(SosCancelFailed(errorMsg: data['message'].toString()));
        }
      } else if (responseData.statusCode == 401) {
        emit(SosCancelLogout());
      } else {
        emit(SosCancelFailed(errorMsg: data['message'].toString()));
      }
    } on SocketException {
      emit(SosCancelInternetError());
    } catch (e) {
      emit(SosCancelFailed(errorMsg: "Error ${e.toString()}"));
    }
  }
}
