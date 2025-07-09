import 'dart:convert';
import 'dart:io';
import 'package:bloc/bloc.dart';
import 'package:ghp_society_management/constants/config.dart';
import 'package:ghp_society_management/network/api_manager.dart';
import 'package:meta/meta.dart';
part 'delete_visitor_state.dart';

class DeleteVisitorCubit extends Cubit<DeleteVisitorState> {
  DeleteVisitorCubit() : super(DeleteVisitorInitial());
  ApiManager apiManager = ApiManager();

  deleteVisitorAPI(String visitorId) async {
    emit(DeleteVisitorLoading());
    try {
      var responseData = await apiManager
          .deleteRequest("${Config.baseURL + Routes.deleteVisitor}$visitorId");
      var data = json.decode((responseData.body.toString()));
      print(data);
      print(responseData.statusCode);

      if (responseData.statusCode == 200) {
        if (data['status']) {
          emit(DeleteVisitorSuccessfully(successMsg: data['message']));
        } else {
          emit(DeleteVisitorFailed(errorMsg: data['message']));
        }
      } else if (responseData.statusCode == 401) {
        emit(DeleteVisitorLogout());
      } else {
        emit(DeleteVisitorFailed(errorMsg: data['message']));
      }
    } on SocketException {
      emit(DeleteVisitorInternetError());
    } catch (e) {
      emit(DeleteVisitorFailed(errorMsg: e.toString()));
    }
  }
}
