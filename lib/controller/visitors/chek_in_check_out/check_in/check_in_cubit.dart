import 'dart:convert';
import 'dart:io';
import 'package:bloc/bloc.dart';
import 'package:ghp_society_management/constants/config.dart';
import 'package:ghp_society_management/constants/local_storage.dart';
import 'package:ghp_society_management/network/api_manager.dart';
import 'package:meta/meta.dart';

part 'check_in_state.dart';

class CheckInCubit extends Cubit<CheckInState> {
  CheckInCubit() : super(CheckInInitial());
  ApiManager apiManager = ApiManager();

  checkInAPI({var statusBody}) async {
    emit(CheckInLoading());
    try {
      var token = LocalStorage.localStorage.getString('token');
      var responseData = await apiManager.postRequest(
          statusBody,
          Config.baseURL + Routes.checkIn,
          {'Authorization': 'Bearer $token', 'Accept': 'application/json'});

      var data = json.decode((responseData.body.toString()));

      print("---------->>>>$data");
      print(responseData.statusCode);

      if (responseData.statusCode == 201) {
        if (data['status']) {
          emit(CheckInSuccessfully(successMsg: data['message']));
        } else {
          emit(CheckInFailed(errorMsg: data['message']));
        }
      } else if (responseData.statusCode == 401) {
        emit(CheckInLogout());
      } else {
        emit(CheckInFailed(errorMsg: data['message']));
      }
    } on SocketException {
      emit(CheckInInternetError());
    } catch (e) {
      emit(CheckInFailed(errorMsg: e.toString()));
    }
  }
}
