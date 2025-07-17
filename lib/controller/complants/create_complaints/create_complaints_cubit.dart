import 'dart:convert';
import 'dart:io';
import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:ghp_society_management/constants/config.dart';
import 'package:ghp_society_management/constants/local_storage.dart';
import 'package:ghp_society_management/network/api_manager.dart';
import 'package:http/http.dart' as http;

part 'create_complaints.state.dart';

class CreateComplaintsCubit extends Cubit<CreateComplaintsState> {
  CreateComplaintsCubit() : super(CreateComplaintsInitial());

  final ApiManager apiManager = ApiManager();

  Future<void> createComplaints({
    required String area,
    required String serviceCategoryId,
    required String description,
    List<File>? imageList,
    List<File>? videoList,
    List<File>? audioList,
  }) async {
    emit(CreateComplaintsLoading());

    try {
      final token = LocalStorage.localStorage.getString('token');
      print('--------------------$serviceCategoryId');
      final request = http.MultipartRequest(
          'POST', Uri.parse(Config.baseURL + Routes.createComplaints))
        ..headers['Authorization'] = 'Bearer $token'
        ..headers['Accept'] = 'application/json'
        ..fields['complaint_category_id'] = serviceCategoryId.toString()
        ..fields['area'] = area
        ..fields['description'] = description;

      // Add files if they exist
      await _addFilesToRequest(request, 'images[]', imageList);
      await _addFilesToRequest(request, 'video', videoList);
      await _addFilesToRequest(request, 'audio', audioList);

      // Send the request
      final responseStream = await request.send();
      final response = await http.Response.fromStream(responseStream);

      // Decoding the response
      final data = jsonDecode(utf8.decode(response.bodyBytes));

      print(data);
      print(response.statusCode);
      if (response.statusCode == 201) {
        emit(CreateComplaintsSuccessfully(msg: data['message']));
      } else if (response.statusCode == 401) {
        emit(CreateComplaintsLogout());
      } else {
        emit(CreateComplaintsFailed(errorMsg: data['message']));
      }
    } on SocketException {
      emit(CreateComplaintsInternetError());
    } catch (e) {
      emit(CreateComplaintsFailed(errorMsg: "Error $e"));
    }
  }

  Future<void> _addFilesToRequest(
    http.MultipartRequest request,
    String fieldName,
    List<File>? files,
  ) async {
    if (files != null) {
      for (final file in files) {
        final multipartFile = await http.MultipartFile.fromPath(
          fieldName,
          file.path,
          filename: file.path.split('/').last,
        );
        request.files.add(multipartFile);
      }
    }
  }
}

