import 'dart:convert';
import 'dart:io';
import 'package:bloc/bloc.dart';
import 'package:ghp_society_management/constants/config.dart';
import 'package:ghp_society_management/constants/local_storage.dart';
import 'package:ghp_society_management/network/api_manager.dart';
import 'package:meta/meta.dart';
part 'send_request_docs_state.dart';

class SendDocsRequestCubit extends Cubit<SendDocsRequestState> {
  SendDocsRequestCubit() : super(SendDocsRequestInitial());
  ApiManager apiManager = ApiManager();
  sendDocsRequestAPI(requestBody) async {
    emit(SendDocsRequestLoading());
    try {
      var token = LocalStorage.localStorage.getString('token');
      final propertyId = LocalStorage.localStorage.getString('property_id');

      var responseData = await apiManager
          .postRequest(requestBody, Config.baseURL + Routes.sendRequest, {
        'Authorization': 'Bearer $token',
        'Accept': 'application/json',
        'x-property-id': '$propertyId'
      });


      print('p-------------------....$propertyId');
      var response = json.decode(responseData.body.toString());
      print(responseData.body);
      if (responseData.statusCode == 201) {
        if (response['status']) {
          emit(SendDocsRequestSuccessfully(
              successMsg: response['message'].toString()));
        } else {
          emit(SendDocsRequestFailed(errorMsg: response['message'].toString()));
        }
      } else if (responseData.statusCode == 401) {
        emit(SendDocsRequestLogout());
      } else {
        emit(SendDocsRequestFailed(errorMsg: response['message'].toString()));
      }
    } on SocketException {
      emit(SendDocsRequestInternetError(
          errorMsg: "Internet Connection Failed!"));
    } catch (e) {
      emit(SendDocsRequestFailed(errorMsg: "Error ${e.toString()}"));
    }
  }
}
