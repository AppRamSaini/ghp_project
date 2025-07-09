import 'dart:convert';
import 'dart:io';
import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:ghp_society_management/constants/config.dart';
import 'package:ghp_society_management/constants/local_storage.dart';
import 'package:ghp_society_management/network/api_manager.dart';
import 'package:ghp_society_management/view/session_dialogue.dart';
import 'package:meta/meta.dart';
import 'package:http/http.dart' as http;

part 'upload_document_state.dart';

class UploadDocumentCubit extends Cubit<UploadDocumentState> {
  UploadDocumentCubit() : super(UploadDocumentInitial());

  ApiManager apiManager = ApiManager();

  Future<void> updateDocument(
      BuildContext context, String documentsId, List<File>? files) async {
    emit(UploadDocumentLoading());

    try {
      final token = LocalStorage.localStorage.getString('token');

      final request = http.MultipartRequest(
          'POST', Uri.parse(Config.baseURL + Routes.createDocuments))
        ..headers['Authorization'] = 'Bearer $token'
        ..headers['Accept'] = 'application/json'
        ..fields['document_id'] = documentsId;

      if (files != null) {
        for (var file in files) {
          // Add file to request
          var multipartFile = await http.MultipartFile.fromPath(
              'files[]', file.path,
              filename: file.path.split('/').last);
          request.files.add(multipartFile);
        }
      }

      final responseStream = await request.send();
      final response = await http.Response.fromStream(responseStream);

      final data = json.decode(response.body);
      print('Response: ${response.statusCode}, Body: $data');

      if (response.statusCode == 201) {
        if (data['status']) {
          emit(UploadDocumentSuccessfully(
              successMsg: data['message'].toString()));
        } else {
          emit(UploadDocumentFailed(
              errorMsg: data['message'] ?? "Unknown error occurred."));
        }
      } else if (response.statusCode == 401) {
        sessionExpiredDialog(context);
      } else {
        emit(UploadDocumentFailed(
            errorMsg: data['message'] ?? "Unknown error occurred."));
      }
    } on SocketException {
      emit(UploadDocumentInternetError());
    } catch (e) {
      print("Error: $e");
      emit(UploadDocumentFailed(errorMsg: "Error: ${e.toString()}"));
    }
  }
}
