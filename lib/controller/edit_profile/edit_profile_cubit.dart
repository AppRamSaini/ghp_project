import 'dart:convert';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:ghp_society_management/constants/config.dart';
import 'package:ghp_society_management/constants/local_storage.dart';
import 'package:ghp_society_management/network/api_manager.dart';
import 'package:meta/meta.dart';
import 'package:http/http.dart' as http;

part 'edit_profile_state.dart';

class EditProfileCubit extends Cubit<EditProfileState> {
  EditProfileCubit() : super(EditProfileInitial());

  ApiManager apiManager = ApiManager();

  Future<void> editProfile(String name, String email, String phoneNumber,
      File? profilePicture) async {
    emit(EditProfileLoading());

    try {
      final token = LocalStorage.localStorage.getString('token');
      if (token == null || token.isEmpty) {
        emit(EditProfileFailed(errorMsg: "Unauthorized: Token missing."));
        return;
      }

      final uri = Uri.parse(Config.baseURL + Routes.editProfile);
      final request = http.MultipartRequest('POST', uri)
        ..headers['Authorization'] = 'Bearer $token'
        ..headers['Accept'] = 'application/json'
        ..fields['name'] = name
        ..fields['email'] = email
        ..fields['phone'] = phoneNumber;

      if (profilePicture != null) {
        final multipartFile = await http.MultipartFile.fromPath(
            'profile_picture', profilePicture.path,
            filename: profilePicture.path.split('/').last);
        request.files.add(multipartFile);
      }

      final responseStream = await request.send();
      final response = await http.Response.fromStream(responseStream);
      final data = json.decode(response.body);
      print('Response: ${response.statusCode} -> $data');

      if (response.statusCode == 200) {
        if (data['status']) {
          emit(EditProfileSuccessfully());
        } else {
          emit(EditProfileFailed(
              errorMsg: data['message'] ?? "Unknown error occurred."));
        }
      } else if (response.statusCode == 401) {
        emit(EditProfileLogout());
      } else {
        emit(EditProfileFailed(
            errorMsg: data['message'] ?? "Unknown error occurred."));
      }
    } on SocketException {
      emit(EditProfileInternetError());
    } catch (e) {
      emit(EditProfileFailed(errorMsg: "Error: ${e.toString()}"));
    }
  }
}
