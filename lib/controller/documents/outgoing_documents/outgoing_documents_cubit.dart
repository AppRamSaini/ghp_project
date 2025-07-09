import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:bloc/bloc.dart';
import 'package:ghp_society_management/constants/config.dart';
import 'package:ghp_society_management/model/outgoing_document_model.dart';
import 'package:ghp_society_management/network/api_manager.dart';
import 'package:http/http.dart';
import 'package:meta/meta.dart';
part 'outgoing_documents_state.dart';

class OutgoingDocumentsCubit extends Cubit<OutgoingDocumentsState> {
  OutgoingDocumentsCubit() : super(OutgoingDocumentsInitial());

  ApiManager apiManager = ApiManager();

  List<RequestData> documentList = [];

  List<RequestData> searchList = [];

  getOutgoingDocumentsAPI(filter) async {
    emit(OutgoingDocumentsLoading());
    try {
      Response response = await apiManager
          .getRequest("${Config.baseURL + Routes.getOutgoingDocuments}$filter");
      var res = json.decode(response.body.toString());
      print('------------->>>>>$res');
      if (response.statusCode == 200) {
        if (res['status']) {
          List dataList = res['data']['outgoing_requests']['data'];
          if (dataList.isEmpty) {
            documentList = [];
          } else {
            var outgoingDocuments = OutgoingDocumentModel.fromJson(res);
            documentList = outgoingDocuments.data!.outgoingRequests!.data!;
          }
          emit(OutgoingDocumentsLoaded(outgoingDocuments: documentList));
        } else {
          emit(OutgoingDocumentsFailed(errorMsg: res['message'].toString()));
        }
      } else if (response.statusCode == 401) {
        emit(OutgoingDocumentsLogout());
      } else {
        emit(OutgoingDocumentsFailed(errorMsg: res['message'].toString()));
      }
    } on SocketException {
      emit(OutgoingDocumentsInternetError(
          errorMsg: 'Internet connection failed!'));
    } on TimeoutException {
      emit(OutgoingDocumentsTimeout(errorMsg: 'Server timeOut exception'));
    } catch (e) {
      emit(OutgoingDocumentsFailed(errorMsg: "Error ${e.toString()}"));
    }
  }

  searchOutgoingDocuments(String query) {
    emit(OutgoingDocumentsLoaded(outgoingDocuments: documentList));
    searchList = documentList;
    final suggestion = searchList.where((element) {
      final documentTitle = element.subject!.toLowerCase();
      final input = query.toLowerCase();
      return documentTitle.contains(input);
    }).toList();
    emit(OutgoingDocumentsSearchLoaded(
      searchList: suggestion,
    ));
  }
}
