import 'dart:convert';
import 'dart:io';
import 'package:bloc/bloc.dart';
import 'package:ghp_society_management/constants/config.dart';
import 'package:ghp_society_management/constants/local_storage.dart';
import 'package:ghp_society_management/network/api_manager.dart';
import 'package:meta/meta.dart';
part 'visitors_feedback_state.dart';

class VisitorsFeedBackCubit extends Cubit<VisitorsFeedBackState> {
  VisitorsFeedBackCubit() : super(VisitorsFeedBackInitial());
  ApiManager apiManager = ApiManager();

  visitorsFeedBackAPI({var statusBody}) async {
    emit(VisitorsFeedBackLoading());
    try {
      var token = LocalStorage.localStorage.getString('token');
      var responseData = await apiManager.postRequest(
          statusBody,
          Config.baseURL + Routes.visitorsFeedback,
          {'Authorization': 'Bearer $token', 'Accept': 'application/json'});

      var data = json.decode((responseData.body.toString()));

      print(data);
      print(responseData.statusCode);

      if (responseData.statusCode == 201) {
        if (data['status']) {
          emit(VisitorsFeedBackSuccessfully(successMsg: data['message']));
        } else {
          emit(VisitorsFeedBackFailed(errorMsg: data['message']));
        }
      } else if (responseData.statusCode == 401) {
        emit(VisitorsFeedBackLogout());
      } else {
        emit(VisitorsFeedBackFailed(errorMsg: data['message']));
      }
    } on SocketException {
      emit(VisitorsFeedBackInternetError());
    } catch (e) {
      emit(VisitorsFeedBackFailed(errorMsg: e.toString()));
    }
  }
}
