import 'dart:convert';
import 'dart:io';
import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:ghp_society_management/constants/config.dart';
import 'package:ghp_society_management/constants/local_storage.dart';
import 'package:ghp_society_management/network/api_manager.dart';
import 'package:http/http.dart' as http;

part 'create_rent_property_state.dart';

class CreateRentPropertyCubit extends Cubit<CreateRentPropertyState> {
  CreateRentPropertyCubit() : super(CreateRentPropertyInitial());

  ApiManager apiManager = ApiManager();

  Future<void> createRentProperty({
    required String? block,
    required String? floor,
    required String? unitType,
    required String? unitNumber,
    required String? bhk,
    required String? area,
    required String? monthlyRent,
    required String? securityDeposit,
    required String? date,
    required String? name,
    required String? number,
    required String? email,
    List<File>? files,
    List<String>? amenities,
  }) async {
    emit(CreateRentPropertyLoading());

    try {
      var token = LocalStorage.localStorage.getString('token');
      final propertyId = LocalStorage.localStorage.getString('property_id');

      if (token == null) {
        emit(CreateRentPropertyFailed());
        return;
      }

      final request = http.MultipartRequest(
          'POST', Uri.parse(Config.baseURL + Routes.createRentProperty))
        ..headers['Authorization'] = 'Bearer $token'
        ..headers['Accept'] = 'application/json'
        ..fields['property_id'] = propertyId ?? ''
        ..fields['block_id'] = block ?? ''
        ..fields['floor'] = floor ?? ''
        ..fields['unit_type'] = unitType ?? ''
        ..fields['unit_number'] = unitNumber ?? ''
        ..fields['bhk'] = bhk ?? ''
        ..fields['area'] = area ?? ''
        ..fields['rent_per_month'] = monthlyRent ?? ''
        ..fields['security_deposit'] = securityDeposit ?? ''
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

      print('payload -------->>>>${request.fields}');

      // Send the request
      final responseStream = await request.send();
      var response = await http.Response.fromStream(responseStream);

      var data = json.decode(response.body.toString());

      print(data);

      if (response.statusCode == 201) {
        emit(CreateRentPropertySuccessfully());
      } else if (response.statusCode == 401) {
        emit(CreateRentPropertyLogout());
      } else {
        emit(CreateRentPropertyFailed());
      }
    } on SocketException {
      emit(CreateRentPropertyInternetError());
    } catch (e) {
      print('Error: $e');
      emit(CreateRentPropertyFailed());
    }
  }
}
