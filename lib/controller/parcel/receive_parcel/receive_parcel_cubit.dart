import 'dart:convert';
import 'dart:io';
import 'package:bloc/bloc.dart';
import 'package:ghp_society_management/constants/config.dart';
import 'package:ghp_society_management/constants/local_storage.dart';
import 'package:ghp_society_management/network/api_manager.dart';
import 'package:meta/meta.dart';
import 'package:http/http.dart' as http;

part 'receive_parcel_state.dart';

class ReceiveParcelCubit extends Cubit<ReceiveParcelState> {
  ReceiveParcelCubit() : super(ReceiveParcelInitial());
  ApiManager apiManager = ApiManager();

  receiveParcelAPI(
    String parcelId,
    String name,
    String phoneNumber,
    File? profilePicture,
  ) async {
    emit(ReceiveParcelLoading());
    print('$phoneNumber $parcelId $name $profilePicture');
    try {
      final token = LocalStorage.localStorage.getString('token');
      if (token == null || token.isEmpty) {
        emit(ReceiveParcelFailed(errorMsg: "Unauthorized: Token missing."));
        return;
      }

      final uri = Uri.parse(Config.baseURL + Routes.receiveParcel);
      final request = http.MultipartRequest('POST', uri)
        ..headers['Authorization'] = 'Bearer $token'
        ..headers['Accept'] = 'application/json'
        ..fields['parcel_id'] = parcelId
        ..fields['delivery_name'] = name
        ..fields['delivery_phone'] = phoneNumber;

      if (profilePicture != null) {
        final multipartFile = await http.MultipartFile.fromPath(
          'delivery_agent_image',
          profilePicture.path,
          filename: profilePicture.path.split('/').last,
        );
        request.files.add(multipartFile);
      }

      final responseStream = await request.send();
      final response = await http.Response.fromStream(responseStream);
      final resData = json.decode(response.body);
      print('Response: ${response.statusCode} -> $resData');

      // var token = LocalStorage.localStorage.getString('token');
      // var responseData = await apiManager.postRequest(
      //     parcelBody,
      //     Config.baseURL + Routes.receiveParcel,
      //     {'Authorization': 'Bearer $token', 'Accept': 'application/json'});
      //
      // var resData = json.decode(responseData.body.toString());

      if (response.statusCode == 200) {
        if (resData['status']) {
          emit(ReceiveParcelSuccess(successMsg: resData['message'].toString()));
        } else {
          emit(ReceiveParcelFailed(errorMsg: resData['message'].toString()));
        }
      } else if (response.statusCode == 401) {
        emit(ReceiveParcelLogout());
      } else {
        emit(ReceiveParcelFailed(errorMsg: resData['message'].toString()));
      }
    } on SocketException {
      emit(ReceiveParcelInternetError(errorMsg: "Internet connection failed!"));
    } catch (e) {
      emit(ReceiveParcelFailed(errorMsg: "Error ${e.toString()}"));
    }
  }
}
