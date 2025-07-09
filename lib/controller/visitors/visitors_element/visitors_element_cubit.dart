import 'dart:convert';
import 'dart:io';
import 'package:bloc/bloc.dart';
import 'package:ghp_society_management/constants/config.dart';
import 'package:ghp_society_management/model/visitors_element_model.dart';
import 'package:ghp_society_management/network/api_manager.dart';
import 'package:meta/meta.dart';
part 'visitors_element_state.dart';

class VisitorsElementCubit extends Cubit<VisitorsElementState> {
  VisitorsElementCubit() : super(VisitorsElementInitial());

  ApiManager apiManager = ApiManager();

  fetchVisitorsElement() async {
    emit(VisitorsElementLoading());
    try {
      var responseData =
          await apiManager.getRequest(Config.baseURL + Routes.visitorsElement);

      if (responseData.statusCode == 200) {
        var decodedList =
            VisitorElementModel.fromJson(jsonDecode(responseData.body));

        emit(VisitorsElementLoaded(visitorsElement: [decodedList]));
      } else if (responseData.statusCode == 401) {
        emit(VisitorsElementLogout());
      }
    } on SocketException {
      emit(VisitorsElementInternetError());
    } catch (e) {
      print(e);
      emit(VisitorsElementFailed());
    }
  }
}
