import 'dart:convert';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:ghp_society_management/constants/config.dart';
import 'package:ghp_society_management/constants/local_storage.dart';
import 'package:ghp_society_management/network/api_manager.dart';
import 'package:meta/meta.dart';

part 'create_refer_property_state.dart';

class CreateReferPropertyCubit extends Cubit<CreateReferPropertyState> {
  CreateReferPropertyCubit() : super(CreateReferPropertyInitial());

  final ApiManager _apiManager = ApiManager();

  /// CREATE REFER PROPERTY
  Future<void> createReferProperty(Map<String, dynamic> referPropertyBody) async {
    emit(CreateReferPropertyLoading());

    try {
      final token = LocalStorage.localStorage.getString('token');
      final propertyId = LocalStorage.localStorage.getString('property_id');

      if (token == null || token.isEmpty || propertyId == null || propertyId.isEmpty) {
        emit(CreateReferPropertyFailed(message: "Token or Property ID not found"));
        return;
      }

      final response = await _apiManager.postRequest(
        referPropertyBody,
        "${Config.baseURL}${Routes.createReferProperty}",
        {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
          'x-property-id': propertyId,
        },
      );

      final decodedData = json.decode(response.body);
      print('Status: ${response.statusCode}, Response: $decodedData');

      switch (response.statusCode) {
        case 201:
          emit(CreateReferPropertysuccessfully());
          break;
        case 401:
          emit(CreateReferPropertyLogout());
          break;
        default:
          emit(CreateReferPropertyFailed(message: decodedData['message'] ?? "Something went wrong"));
          break;
      }
    } on SocketException {
      emit(CreateReferPropertyInternetError());
    } catch (e, stackTrace) {
      print('CreateReferProperty Error: $e');
      print(stackTrace);
      emit(CreateReferPropertyFailed(message: e.toString()));
    }
  }
}
