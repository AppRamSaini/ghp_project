import 'dart:convert';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:ghp_society_management/constants/config.dart';
import 'package:ghp_society_management/constants/local_storage.dart';
import 'package:ghp_society_management/network/api_manager.dart';
import 'package:http/http.dart' as http;
import 'package:meta/meta.dart';

part 'create_parcel_state.dart';

class ParcelManagementCubit extends Cubit<ParcelManagementState> {
  ParcelManagementCubit() : super(ParcelManagementInitial());
  ApiManager apiManager = ApiManager();

  /// FOR CREATE PARCEL MANAGEMENT
  createParcelAPI(
      {String? parcelId,
      String? parcelName,
      String? numberOfParcel,
      String? parcelType,
      String? deliveryName,
      String? deliveryPhone,
      String? date,
      String? time,
      String? parcelOfId,
      String? deliveryOption,
      String? senderName,
      String? prId,
      File? profilePicture,
      bool forUseStaff = false}) async {
    var propertyId = LocalStorage.localStorage.getString('property_id');
    emit(CreateParcelLoading());
    try {
      final token = LocalStorage.localStorage.getString('token');
      if (token == null || token.isEmpty) {
        emit(CreateParcelFailed(errorMsg: "Unauthorized: Token missing."));
        return;
      }

      final uri = Uri.parse(Config.baseURL + Routes.createParcel);
      final request = http.MultipartRequest('POST', uri)
        ..headers['Authorization'] = 'Bearer $token'
        ..headers['Accept'] = 'application/json'
        ..fields['property_id'] =
            forUseStaff ? prId.toString() : propertyId.toString()
        ..fields['parcelid'] = parcelId.toString()
        ..fields['parcel_name'] = parcelName.toString()
        ..fields['no_of_parcel'] = numberOfParcel.toString()
        ..fields['parcel_type'] = parcelType.toString()
        ..fields['delivery_name'] = deliveryName.toString()
        ..fields['delivery_phone'] = deliveryPhone.toString()
        ..fields['date'] = date.toString()
        ..fields['time'] = time.toString()
        ..fields['parcel_of'] = parcelOfId.toString()
        ..fields['delivery_option'] = deliveryOption.toString()
        ..fields['parcel_company_name'] = senderName.toString();
      if (profilePicture != null) {
        final multipartFile = await http.MultipartFile.fromPath(
            'delivery_agent_image', profilePicture.path,
            filename: profilePicture.path.split('/').last);
        request.files.add(multipartFile);
      }

      print('Fields: ---------->> ${request.fields}');

      final responseStream = await request.send();
      final response = await http.Response.fromStream(responseStream);
      final resData = json.decode(response.body);
      print('-------------->>>>>msg: ${resData['message']} -> $resData');

      print('-------------->>>>>Response: ${response.statusCode} -> $resData');

      if (response.statusCode == 201) {
        if (resData['status']) {
          emit(CreateParcelSuccess(successMsg: resData['message'].toString()));
        } else {
          emit(CreateParcelFailed(errorMsg: resData['message'].toString()));
        }
      } else if (response.statusCode == 401) {
        emit(ParcelManagementLogout());
      } else {
        emit(CreateParcelFailed(errorMsg: resData['message'].toString()));
      }
    } on SocketException {
      emit(ParcelManagementInternetError(
          errorMsg: "Internet connection failed!"));
    } catch (e) {
      print(e);
      emit(CreateParcelFailed(errorMsg: "Error ${e.toString()}"));
    }
  }
}
