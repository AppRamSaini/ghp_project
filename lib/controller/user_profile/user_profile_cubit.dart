import 'dart:convert';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:ghp_society_management/constants/config.dart';
import 'package:ghp_society_management/constants/local_storage.dart';
import 'package:ghp_society_management/model/user_profile_model.dart';
import 'package:ghp_society_management/network/api_manager.dart';
import 'package:meta/meta.dart';

part 'user_profile_state.dart';

class UserProfileCubit extends Cubit<UserProfileState> {
  UserProfileCubit() : super(UserProfileInitial());

  ApiManager apiManager = ApiManager();
  List<UserProfileModel> userProfile = [];

  fetchUserProfile({String userId = ''}) async {
    emit(UserProfileLoading());
    try {
      var responseData = await apiManager.getRequest(
          "${Config.baseURL + Routes.userProfile}/$userId",
          usePropertyID: true);

      print("--------->>>${responseData.statusCode}");

      if (responseData.statusCode == 200) {
        var decodedList =
            UserProfileModel.fromJson(jsonDecode(responseData.body));
        userProfile = [decodedList];
        await LocalStorage.localStorage
            .setString('userId', decodedList.data!.user!.id.toString());
        await LocalStorage.localStorage
            .setString('user_name', decodedList.data!.user!.name.toString());
        await LocalStorage.localStorage
            .setString('user_image', decodedList.data!.user!.image.toString());

        emit(UserProfileLoaded(userProfile: [decodedList]));
      } else if (responseData.statusCode == 401) {
        emit(UserProfileLogout());
      } else {
        emit(UserProfileFailed(
            errorMsg: jsonDecode(responseData.body)['message']));
      }
    } on SocketException {
      emit(UserProfileInternetError());
    } catch (e) {
      emit(UserProfileFailed(errorMsg: 'Something went wrong!'));
    }
  }
}
