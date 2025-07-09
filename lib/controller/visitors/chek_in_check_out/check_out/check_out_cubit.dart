import 'dart:convert';
import 'dart:io';
import 'package:bloc/bloc.dart';
import 'package:ghp_society_management/constants/config.dart';
import 'package:ghp_society_management/constants/local_storage.dart';
import 'package:ghp_society_management/network/api_manager.dart';
import 'package:meta/meta.dart';
part 'check_out_state.dart';

class CheckOutCubit extends Cubit<CheckOutState> {
  CheckOutCubit() : super(CheckOutInitial());
  ApiManager apiManager = ApiManager();

  checkOutAPI({var statusBody}) async {
    emit(CheckOutLoading());
    try {
      var token = LocalStorage.localStorage.getString('token');
      var responseData = await apiManager.postRequest(
          statusBody,
          Config.baseURL + Routes.checkOut,
          {'Authorization': 'Bearer $token', 'Accept': 'application/json'});

      var data = json.decode((responseData.body.toString()));

      print(data);
      print(responseData.statusCode);

      if (responseData.statusCode == 201) {
        if (data['status']) {
          emit(CheckOutSuccessfully(successMsg: data['message']));
        } else {
          emit(CheckOutFailed(errorMsg: data['message']));
        }
      } else if (responseData.statusCode == 401) {
        emit(CheckOutLogout());
      } else {
        emit(CheckOutFailed(errorMsg: data['message']));
      }
    } on SocketException {
      emit(CheckOutInternetError());
    } catch (e) {
      emit(CheckOutFailed(errorMsg: e.toString()));
    }
  }
}
