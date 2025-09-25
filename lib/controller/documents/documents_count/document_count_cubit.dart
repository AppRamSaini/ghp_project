import 'dart:convert';
import 'dart:io';

import 'package:ghp_society_management/constants/config.dart';
import 'package:ghp_society_management/constants/export.dart';
import 'package:ghp_society_management/network/api_manager.dart';

part 'document_count_state.dart';

class DocumentCountCubit extends Cubit<DocumentCountState> {
  DocumentCountCubit() : super(DocumentCountInitial());

  final ApiManager apiManager = ApiManager();

  int outGoingCounts = 0;
  int incomingCounts = 0;

  Future<void> documentCountType() async {
    emit(DocumentCountLoading());

    try {
      final response = await apiManager.getRequest(
        Config.baseURL + Routes.documentsCounts,
        usePropertyID: true,
      );

      final data = json.decode(response.body.toString());

      if (response.statusCode == 200) {
        if (data['status'] == true) {
          outGoingCounts = data['data']['outgoing_request_count'] ?? 0;
          incomingCounts = data['data']['incoming_request_count'] ?? 0;

          emit(DocumentCountLoaded(
            outGoingRequestCount: outGoingCounts,
            incomingRequestCount: incomingCounts,
          ));
        } else {
          emit(DocumentCountFailed(
            errorMsg: data['message'] ?? "Failed to fetch document counts.",
          ));
        }
      } else if (response.statusCode == 401) {
        emit(UnAuthenticatedUser());
      } else {
        emit(DocumentCountFailed(
          errorMsg: data['message'] ?? "Server error (${response.statusCode})",
        ));
      }
    } on SocketException {
      emit(DocumentCountInternetError(
          errorMsg:
              "No Internet connection. Please check your network and try again."));
    } on FormatException {
      emit(DocumentCountFailed(
          errorMsg:
              "Data parsing error. Please try again later or contact support."));
    } catch (e) {
      emit(DocumentCountFailed(
          errorMsg:
              "An unexpected error occurred. Please try again later.\nError: ${e.toString()}"));
    }
  }
}
