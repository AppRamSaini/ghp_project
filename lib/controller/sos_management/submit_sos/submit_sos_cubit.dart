import 'dart:convert';
import 'dart:io';
import 'package:bloc/bloc.dart';
import 'package:ghp_society_management/constants/config.dart';
import 'package:ghp_society_management/constants/local_storage.dart';
import 'package:ghp_society_management/network/api_manager.dart';
import 'package:meta/meta.dart';

part 'submit_sos_state.dart';

class SubmitSosCubit extends Cubit<SubmitSosState> {
  SubmitSosCubit() : super(SubmitSosInitial());

  ApiManager apiManager = ApiManager();

  submitSos(sosBody) async {
    emit(SubmitSosLoading());
    try {
      var token = LocalStorage.localStorage.getString('token');

      var responseData = await apiManager.postRequest(
          sosBody,
          Config.baseURL + Routes.submitSos,
          {'Authorization': 'Bearer $token', 'Accept': 'application/json'});

      var data = json.decode(responseData.body.toString());
      if (responseData.statusCode == 201) {
        if (data['status']) {
          print('----------->>>>>>$data');
          emit(SubmitSosSuccessfully(
              successMsg: data['message'].toString(),
              sosId: data['data']['sent_alert']['id'].toString()));
        } else {
          emit(SubmitSosFailed(errorMsg: data['message'].toString()));
        }
      } else if (responseData.statusCode == 401) {
        emit(SubmitSosLogout());
      } else {
        emit(SubmitSosFailed(errorMsg: data['message'].toString()));
      }
    } on SocketException {
      emit(SubmitSosInternetError());
    } catch (e) {
      emit(SubmitSosFailed(errorMsg: "Error ${e.toString()}"));
    }
  }
}
