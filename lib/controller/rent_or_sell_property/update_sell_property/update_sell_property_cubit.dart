import 'dart:convert';
import 'dart:io';
import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:ghp_society_management/constants/config.dart';
import 'package:ghp_society_management/constants/local_storage.dart';
import 'package:ghp_society_management/network/api_manager.dart';
import 'package:http/http.dart' as http;

part 'update_sell_property_state.dart';

class UpdateSellPropertyCubit extends Cubit<UpdateSellPropertyState> {
  UpdateSellPropertyCubit() : super(UpdateSellPropertyInitial());

  ApiManager apiManager = ApiManager();

  Future<void> updateSellProperty({
    required String? propertyId,
    required String? block,
    required String? floor,
    required String? unitType,
    required String? unitNumber,
    required String? bhk,
    required String? area,
    required String? housePrice,
    required String? upFront,
    required String? date,
    required String? name,
    required String? number,
    required String? email,
    List<File>? files,
    List<String>? amenities,
  }) async {
    emit(UpdateSellPropertyLoading());

    try {
      var token = LocalStorage.localStorage.getString('token');
      if (token == null) {
        emit(UpdateSellPropertyFailed());
        return;
      }

      final request = http.MultipartRequest(
          'POST',
          Uri.parse(
              "${Config.baseURL + Routes.updateSellProperty}$propertyId"))
        ..headers['Authorization'] = 'Bearer $token'
        ..headers['Accept'] = 'application/json'
        ..fields['block_id'] = block ?? ''
        ..fields['floor'] = floor ?? ''
        ..fields['unit_type'] = unitType ?? ''
        ..fields['unit_number'] = unitNumber ?? ''
        ..fields['bhk'] = bhk ?? ''
        ..fields['area'] = area ?? ''
        ..fields['house_price'] = housePrice ?? ''
        ..fields['upfront'] = upFront ?? ''
        ..fields['available_from_date'] = date ?? ''
        ..fields['name'] = name ?? ''
        ..fields['phone'] = number ?? ''
        ..fields['email'] = email ?? ''
        ..fields['amenities[]'] = (amenities?.join(",") ?? '');

      // // Add files if they exist
      if (files != null) {
        for (var file in files) {
          var multipartFile = await http.MultipartFile.fromPath(
            'files[]',
            file.path,
            filename: file.path.split('/').last,
          );
          request.files.add(multipartFile);
        }
      }

      // Send the request
      final responseStream = await request.send();
      var response = await http.Response.fromStream(responseStream);
      var data = json.decode(response.body);

      print(data);
      if (response.statusCode == 200) {
        emit(UpdateSellPropertySuccessfully());
      } else {
        emit(UpdateSellPropertyFailed());
      }
    } on SocketException {
      emit(UpdateSellPropertyInternetError());
    } catch (e) {
      print('Error: $e');
      emit(UpdateSellPropertyFailed());
    }
  }
}
