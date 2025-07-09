import 'dart:convert';
import 'dart:io';
import 'package:ghp_society_management/constants/config.dart';
import 'package:ghp_society_management/constants/export.dart';
import 'package:ghp_society_management/network/api_manager.dart';

part 'document_count_state.dart';

class DocumentCountCubit extends Cubit<DocumentCountState> {
  DocumentCountCubit() : super(DocumentCountInitial());
  ApiManager apiManager = ApiManager();

  int outGoingCounts = 0;
  int incomingCounts = 0;

  documentCountType() async {
    emit(DocumentCountLoading());
    try {
      var responseData =
          await apiManager.getRequest(Config.baseURL + Routes.documentsCounts);
      var data = json.decode((responseData.body.toString()));

      print(responseData.statusCode);

      if (responseData.statusCode == 200) {
        outGoingCounts = data['data']['outgoing_request_count'] as int;
        incomingCounts = data['data']['incoming_request_count'] as int;

        if (data['status']) {
          print(data);
          emit(DocumentCountLoaded(
              outGoingRequestCount: outGoingCounts,
              incomingRequestCount: incomingCounts));
        } else {
          emit(DocumentCountFailed(errorMsg: data['message'].toString()));
        }
      } else {
        emit(DocumentCountFailed(errorMsg: data['message'].toString()));
      }
    } on SocketException {
      emit(DocumentCountInternetError(errorMsg: 'Internet connection failed!'));
    } catch (e) {
      emit(DocumentCountFailed(errorMsg: e.toString()));
    }
  }
}
