import 'dart:convert';
import 'dart:io';
import 'package:bloc/bloc.dart';
import 'package:ghp_society_management/constants/config.dart';
import 'package:ghp_society_management/network/api_manager.dart';
import 'package:meta/meta.dart';
import '../../model/document_element_model.dart';
part 'document_elements_state.dart';

class DocumentElementsCubit extends Cubit<DocumentElementsState> {
  DocumentElementsCubit() : super(DocumentElementsInitial());

  ApiManager apiManager = ApiManager();

  fetchDocumentElement() async {
    emit(DocumentElementLoading());
    try {
      var responseData =
          await apiManager.getRequest(Config.baseURL + Routes.documentElement);

      if (responseData.statusCode == 200) {
        var decodedList =
            DocumentElementModel.fromJson(jsonDecode(responseData.body));
        emit(DocumentElementLoaded(documentElement: [decodedList]));
      } else if (responseData.statusCode == 401) {
        emit(DocumentElementLogout());
      }
    } on SocketException {
      emit(DocumentElementInternetError());
    } catch (e) {
      print(e);
      emit(DocumentElementFailed());
    }
  }
}
