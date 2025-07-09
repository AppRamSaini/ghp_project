import 'dart:convert';
import 'dart:io';
import 'package:bloc/bloc.dart';
import 'package:ghp_society_management/constants/config.dart';
import 'package:ghp_society_management/constants/local_storage.dart';
import 'package:ghp_society_management/network/api_manager.dart';
import 'package:meta/meta.dart';
part 'not_responde_state.dart';

class NotRespondingCubit extends Cubit<NotRespondingState> {
  NotRespondingCubit() : super(NotRespondingInitial());
  ApiManager apiManager = ApiManager();
  notRespondingAPI({var statusBody}) async {
    emit(NotRespondingLoading());
    try {
      var token = LocalStorage.localStorage.getString('token');
      var responseData = await apiManager.postRequest(
          statusBody,
          Config.baseURL + Routes.residenceNotResponding,
          {'Authorization': 'Bearer $token', 'Accept': 'application/json'});

      var data = json.decode((responseData.body.toString()));
      if (responseData.statusCode == 201) {
        if (data['status']) {
          print('---------------->>>>Not responding Api called');
          emit(NotRespondingSuccessfully(successMsg: data['message']));
        } else {
          emit(NotRespondingFailed(errorMsg: data['message']));
        }
      } else if (responseData.statusCode == 401) {
        emit(NotRespondingLogout());
      } else {
        emit(NotRespondingFailed(errorMsg: data['message']));
      }
    } on SocketException {
      emit(NotRespondingInternetError(errorMsg: "Internet Connection Failed"));
    } catch (e) {
      emit(NotRespondingFailed(errorMsg: e.toString()));
    }
  }
}
