import 'dart:convert';
import 'dart:io';
import 'package:bloc/bloc.dart';
import 'package:ghp_app/constants/config.dart';
import 'package:ghp_app/constants/export.dart';
import 'package:ghp_app/constants/local_storage.dart';
import 'package:ghp_app/network/api_manager.dart';
import 'package:meta/meta.dart';
import 'package:http/http.dart' as http;
// Part file for states
part 'create_visitors_state.dart';

class CreateVisitorsCubit extends Cubit<CreateVisitorsState> {
  CreateVisitorsCubit() : super(CreateVisitorsInitial());

  final ApiManager apiManager = ApiManager();

  String visitorsId = '';
  String visitorsClassificationType = '';

  /// Function to create visitors
  Future<void> createVisitors(
      {required String visitorsType,
      required String visitingFrequency,
      required String noOFVisitors,
      required String date,
      required String time,
      required String vehicleNumber,
      required String purposeOfVisit,
      required String validTill,
      String? userId,
      required List<Map<String, String>> visitors,
      required List<File>? files}) async {
    emit(CreateVisitorsLoading());

    try {
      // Retrieve the token
      var token = LocalStorage.localStorage.getString('token');
      if (token == null) {
        emit(CreateVisitorsFailed(errorMsg: 'Leading'));
        return;
      }

      var url = Uri.parse(Config.baseURL + Routes.createVisitors);

      // Set headers
      var headers = {
        'Accept': 'application/json',
        'Authorization': 'Bearer $token'
      };

      // Prepare the multipart request
      var request = http.MultipartRequest('POST', url)
        ..headers.addAll(headers)
        ..fields['type_of_visitor'] = visitorsType
        ..fields['visiting_frequency'] = visitingFrequency
        ..fields['no_of_visitors'] = noOFVisitors
        ..fields['date'] = date
        ..fields['date'] = date
        ..fields['time'] = time
        ..fields['user_id'] = userId!
        ..fields['vehicle_number'] = vehicleNumber
        ..fields['purpose_of_visit'] = purposeOfVisit
        ..fields['valid_till'] = validTill;
      request.fields['visitors'] = json.encode(visitors);
      if (files != null) {
        for (var file in files) {
          var multipartFile = await http.MultipartFile.fromPath(
              'image', file.path,
              filename: file.path.split('/').last);
          request.files.add(multipartFile);
        }
      }

      print("Payload fields: ${request.fields}");

      final responseStream = await request.send();
      final response = await http.Response.fromStream(responseStream);

      var data = json.decode(response.body);
      print("Response--------->>>> ${response.body}");
      // Process response
      if (response.statusCode == 201) {
        if (data['status']) {
          visitorsId = data['data']['visitor']['id'].toString();
          visitorsClassificationType =
              data['data']['visitor']['visitor_classification'].toString();
          print("Response body:--------->>>> ${data}");

          emit(CreateVisitorsSuccessfully(
              visitorsId: visitorsId.toString(),
              visitorsClassificationTypes: visitorsClassificationType));
        } else {
          emit(CreateVisitorsFailed(
              errorMsg: data['message'] ?? 'Unknown error'));
        }
      } else if (response.statusCode == 401) {
        emit(CreateVisitorsLogut());
      } else {
        emit(
            CreateVisitorsFailed(errorMsg: data['message'] ?? 'Unknown error'));
      }
    } on SocketException {
      emit(CreateVisitorsInternetError());
    } catch (e) {
      print("Exception caught: $e");
      emit(CreateVisitorsFailed(errorMsg: 'Something went wrong: $e'));
    }
  }
}
