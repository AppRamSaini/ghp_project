import 'dart:convert';
import 'dart:io';
import 'package:ghp_society_management/constants/config.dart';
import 'package:ghp_society_management/constants/export.dart';
import 'package:ghp_society_management/network/api_manager.dart';
part 'sos_acknowledged_state.dart';

class AcknowledgedCubit extends Cubit<AcknowledgedState> {
  AcknowledgedCubit() : super(AcknowledgedInitial());
  ApiManager apiManager = ApiManager();
  acknowledgedAPI({var statusBody}) async {
    emit(AcknowledgedLoading());

    try {
      var token = LocalStorage.localStorage.getString('token');
      var responseData = await apiManager.postRequest(
          statusBody,
          Config.baseURL + Routes.sosAcknowledge,
          {'Authorization': 'Bearer $token', 'Accept': 'application/json'});

      var data = json.decode((responseData.body.toString()));
      print(statusBody);
      print('-accept------------>>>>>$data');

      if (responseData.statusCode == 200) {
        if (data['status']) {
          emit(AcknowledgedSuccessfully(successMsg: data['message']));
        } else {
          emit(AcknowledgedFailed(errorMsg: data['message']));
        }
      } else if (responseData.statusCode == 401) {
        emit(AcknowledgedLogout());
      } else {
        emit(AcknowledgedFailed(errorMsg: data['message']));
      }
    } on SocketException {
      emit(AcknowledgedInternetError(errorMsg: "Internet Connection Failed"));
    } catch (e) {
      emit(AcknowledgedFailed(errorMsg: e.toString()));
    }
  }
}
