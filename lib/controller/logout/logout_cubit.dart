import 'dart:io';
import 'package:bloc/bloc.dart';
import 'package:ghp_society_management/constants/config.dart';
import 'package:ghp_society_management/constants/local_storage.dart';
import 'package:ghp_society_management/network/api_manager.dart';
import 'package:meta/meta.dart';

part 'logout_state.dart';

class LogoutCubit extends Cubit<LogoutState> {
  LogoutCubit() : super(LogoutInitial());

  ApiManager apiManager = ApiManager();

  logout() async {
    emit(LogoutLoading());
    try {
      var token = LocalStorage.localStorage.getString('token');
      var responseData = await apiManager.postRequest(
        null,
        Config.baseURL + Routes.logout,
        {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      );
      if (responseData.statusCode == 200) {
        emit(LogoutSuccessfully());
        LocalStorage.localStorage.clear();
      } else if (responseData.statusCode == 401) {
        emit(LogoutSessionError());
        LocalStorage.localStorage.clear();
      } else {
        emit(LogoutFailed());
      }
    } on SocketException {
      emit(LogoutInternetError());
    } catch (e) {
      emit(LogoutFailed());
    }
  }
}
