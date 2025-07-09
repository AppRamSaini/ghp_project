import 'dart:convert';
import 'dart:io';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ghp_society_management/constants/config.dart';
import 'package:ghp_society_management/constants/local_storage.dart';
import 'package:ghp_society_management/network/api_manager.dart';
import 'package:http/http.dart' as http;

part 'create_polls_state.dart';

class CreatePollsCubit extends Cubit<CreatePollsState> {
  CreatePollsCubit() : super(CreatePollsInitial());
  ApiManager apiManager = ApiManager();

  /// FETCH MY BILLS
  Future giveTheVoteAPI(
      {required String pollId, required String optionId}) async {
    if (state is CreatePollsLoading) return;
    emit(CreatePollsLoading());
    print("${Config.baseURL}${Routes.createPolls}$pollId}");
    print("$optionId");
    try {
      var token = LocalStorage.localStorage.getString('token');
      if (token == null) {
        emit(CreatePollsLoading());
        return;
      }
      print("${Config.baseURL}${Routes.createPolls}$pollId");
      print("$optionId");

      final request = http.MultipartRequest(
          'POST', Uri.parse("${Config.baseURL}${Routes.createPolls}$pollId"))
        ..headers['Authorization'] = 'Bearer $token'
        ..headers['Accept'] = 'application/json'
        ..fields['poll_option_id'] = optionId;
      // Send the request
      final responseStream = await request.send();
      var response = await http.Response.fromStream(responseStream);
      var data = json.decode(response.body.toString());
      print(data);

      if (response.statusCode == 201) {
        var responseData = jsonDecode(response.body);
        print('Fetched polls data: $responseData');

        bool status = responseData['status'];
        if (status) {
          emit(CreatePollsLoaded(status: status));
        } else {
          emit(CreatePollsFailed()); // Handle failure response
        }

        return status;
      } else if (response.statusCode == 401) {
        emit(CreatePollsLogout());
      } else {
        emit(CreatePollsFailed()); // Handle failure response
      }
    } on SocketException {
      emit(CreatePollsInternetError()); // Handle network issues
    } catch (e) {
      emit(CreatePollsFailed()); // Handle general errors
    }
  }
}
