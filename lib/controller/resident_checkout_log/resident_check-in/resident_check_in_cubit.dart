import 'dart:convert';
import 'dart:io';
import 'package:bloc/bloc.dart';
import 'package:ghp_society_management/constants/config.dart';
import 'package:ghp_society_management/constants/local_storage.dart';
import 'package:ghp_society_management/network/api_manager.dart';
import 'package:meta/meta.dart';

part 'resident_check_in_state.dart';

class ResidentCheckInCubit extends Cubit<ResidentCheckInState> {
  ResidentCheckInCubit() : super(ResidentCheckInInitial());
  ApiManager apiManager = ApiManager();

  checkInAPI({var statusBody}) async {
    emit(ResidentCheckInLoading());
    try {
      var token = LocalStorage.localStorage.getString('token');
      var responseData = await apiManager.postRequest(
          statusBody,
          Config.baseURL + Routes.residentCheckIn,
          {'Authorization': 'Bearer $token', 'Accept': 'application/json'});

      var data = json.decode((responseData.body.toString()));
      print("---------->>>>$data");
      print(responseData.statusCode);

      if (responseData.statusCode == 201) {
        if (data['status']) {
          emit(ResidentCheckInSuccessfully(successMsg: data['message']));
        } else {
          emit(ResidentCheckInFailed(errorMsg: data['message']));
        }
      } else {
        emit(ResidentCheckInFailed(errorMsg: data['message']));
      }
    } on SocketException {
      emit(ResidentCheckInFailed(errorMsg: 'Internet Connection Error!'));
    } catch (e) {
      emit(ResidentCheckInFailed(errorMsg: "Something Went Wrong!"));
    }
  }
}
