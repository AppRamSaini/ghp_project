import 'dart:convert';
import 'dart:io';
import 'package:bloc/bloc.dart';
import 'package:ghp_society_management/constants/config.dart';
import 'package:ghp_society_management/constants/local_storage.dart';
import 'package:ghp_society_management/network/api_manager.dart';
import 'package:meta/meta.dart';
part 'update_visitors_status_state.dart';

class UpdateVisitorsStatusCubit extends Cubit<UpdateVisitorsStatusState> {
  UpdateVisitorsStatusCubit() : super(UpdateVisitorsStatusInitial());
  ApiManager apiManager = ApiManager();
  updateVisitorsStatusAPI({var visitorId, var statusBody}) async {
    emit(UpdateVisitorsStatusLoading());
    try {
      var token = LocalStorage.localStorage.getString('token');
      var responseData = await apiManager.postRequest(
          statusBody,
          "${Config.baseURL + Routes.blockUnBlockVisitors}$visitorId",
          {'Authorization': 'Bearer $token', 'Accept': 'application/json'});

      var data = json.decode((responseData.body.toString()));

      print(data);
      print(responseData.statusCode);

      if (responseData.statusCode == 200) {
        if (data['status']) {
          emit(UpdateVisitorsStatusSuccessfully(successMsg: data['message']));
        } else {
          emit(UpdateVisitorsStatusFailed(errorMsg: data['message']));
        }
      } else if (responseData.statusCode == 401) {
        emit(UpdateVisitorsStatusLogout());
      } else {
        emit(UpdateVisitorsStatusFailed(errorMsg: data['message']));
      }
    } on SocketException {
      emit(UpdateVisitorsStatusInternetError());
    } catch (e) {
      emit(UpdateVisitorsStatusFailed(errorMsg: e.toString()));
    }
  }
}
