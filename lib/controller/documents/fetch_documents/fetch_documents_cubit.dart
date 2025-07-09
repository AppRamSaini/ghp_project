import 'dart:convert';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:ghp_society_management/constants/config.dart';
import 'package:ghp_society_management/model/document_model.dart';
import 'package:ghp_society_management/network/api_manager.dart';
import 'package:meta/meta.dart';

part 'fetch_documents_state.dart';

class FetchDocumentsCubit extends Cubit<FetchDocumentsState> {
  FetchDocumentsCubit() : super(FetchDocumentsInitial());

  ApiManager apiManager = ApiManager();
  int currentPage = 1;
  bool hasMore = true;
  int amount = 0;
  List<Datum> documents = [];

  fetchFetchDocuments() async {
    try {
      emit(FetchDocumentsLoading());
      var response =
          await apiManager.getRequest(Config.baseURL + Routes.fetchDocuments);
      var responseData = jsonDecode(response.body);

      if (response.statusCode == 200) {
        if (responseData['status']) {
          var newDocuments = (responseData['data']['data'] as List)
              .map((e) => Datum.fromJson(e))
              .toList();
          emit(FetchDocumentsLoaded(fetchDocuments: newDocuments));
        } else {
          emit(FetchDocumentsFailed(
              errorMsg: responseData['message'].toString()));
        }
      } else if (response.statusCode == 401) {
        emit(FetchDocumentsLogout());
      } else {
        emit(
            FetchDocumentsFailed(errorMsg: responseData['message'].toString()));
      }
    } on SocketException {
      emit(FetchDocumentsInternetError());
    } catch (e) {
      emit(FetchDocumentsFailed(errorMsg: e.toString()));
    }
  }
}
