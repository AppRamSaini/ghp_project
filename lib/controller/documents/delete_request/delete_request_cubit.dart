import 'dart:convert';
import 'dart:io';
import 'package:bloc/bloc.dart';
import 'package:ghp_society_management/constants/config.dart';
import 'package:ghp_society_management/network/api_manager.dart';
import 'package:meta/meta.dart';
part 'delete_request_state.dart';

class DeleteRequestCubit extends Cubit<DeleteRequestState> {
  DeleteRequestCubit() : super(DeleteRequestInitial());
  ApiManager apiManager = ApiManager();

  deleteRequestAPI(String documentId) async {
    emit(DeleteRequestLoading());
    try {
      var responseData = await apiManager
          .deleteRequest("${Config.baseURL + Routes.deleteRequest}$documentId");
      var data = json.decode((responseData.body.toString()));
      print(data);
      print(responseData.statusCode);
      if (responseData.statusCode == 200) {
        if (data['status']) {
          emit(DeleteRequestSuccessfully(successMsg: data['message']));
        } else {
          emit(DeleteRequestFailed(errorMsg: data['message']));
        }
      } else if (responseData.statusCode == 401) {
        emit(DeleteRequestLogout());
      } else {
        emit(DeleteRequestFailed(errorMsg: data['message']));
      }
    } on SocketException {
      emit(DeleteRequestInternetError(errorMsg: "Internet Connection Failed"));
    } catch (e) {
      emit(DeleteRequestFailed(errorMsg: e.toString()));
    }
  }
}
