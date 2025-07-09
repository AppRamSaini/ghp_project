import 'dart:convert';
import 'dart:io';
import 'package:bloc/bloc.dart';
import 'package:ghp_society_management/constants/config.dart';
import 'package:ghp_society_management/model/incoming_visitors_request_model.dart';
import 'package:ghp_society_management/network/api_manager.dart';
import 'package:meta/meta.dart';

part 'incoming_request_state.dart';

class IncomingRequestCubit extends Cubit<IncomingRequestState> {
  IncomingRequestCubit() : super(IncomingRequestInitial());

  final ApiManager apiManager = ApiManager();

  Future<void> fetchIncomingRequest() async {
    emit(IncomingRequestLoading());
    try {
      // Fetching the response
      final responseData = await apiManager
          .getRequest(Config.baseURL + Routes.incomingVisitorRequest);

      // Decoding the response
      final response = json.decode(responseData.body.toString());

      if (responseData.statusCode == 200) {
        if (response['status']) {
          final visitorData = response['data']['visitor'];
          if (visitorData != null) {
            final incomingVisitor = IncomingVisitorsModel.fromJson(visitorData);

            emit(IncomingRequestLoaded(
                incomingVisitorsRequest: incomingVisitor));
          } else {
            emit(IncomingRequestFailed(errorMsg: 'No visitor data found'));
          }
        } else {
          emit(IncomingRequestFailed(
              errorMsg: response['message'] ?? 'Unknown error'));
        }
      } else if (responseData.statusCode == 401) {
        emit(IncomingRequestLogout());
      } else {
        emit(IncomingRequestFailed(
            errorMsg: response['message'] ?? 'An error occurred'));
      }
    } on SocketException {
      emit(IncomingRequestInternetError());
    } catch (e, stackTrace) {
      print('Error: $e');
      print('Stack Trace: $stackTrace');
      emit(IncomingRequestFailed(errorMsg: e.toString()));
    }
  }
}
