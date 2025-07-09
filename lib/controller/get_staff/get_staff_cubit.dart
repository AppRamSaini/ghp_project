import 'dart:convert';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:ghp_society_management/constants/config.dart';
import 'package:ghp_society_management/model/staff_model.dart';
import 'package:ghp_society_management/network/api_manager.dart';
import 'package:meta/meta.dart';

part 'get_staff_state.dart';

class GetStaffCubit extends Cubit<GetStaffState> {
  GetStaffCubit() : super(GetStaffInitial());

  ApiManager apiManager = ApiManager();

  List<StaffModel> staffList = [];

  List<Datum?> searchList = [];

  fetchStaffList() async {
    emit(GetStaffLoading());
    try {
      var responseData =
          await apiManager.getRequest(Config.baseURL + Routes.staff);

      var response = json.decode(responseData.body);
      if (responseData.statusCode == 200) {
        if (response['status']) {
          var decodedList = StaffModel.fromJson(jsonDecode(responseData.body));
          staffList = [decodedList];

          emit(GetStaffLoaded(staffList: [decodedList]));
        } else {
          emit(GetStaffFailed(errorMsg: response['message'].toString()));
        }
      } else {
        emit(GetStaffFailed(errorMsg: response['message'].toString()));
      }
    } on SocketException {
      emit(GetStaffInternetError());
    } catch (e) {
      emit(GetStaffFailed(errorMsg: "Error ${e.toString()}"));
    }
  }

  searchStaff(String query) {
    emit(GetStaffLoaded(staffList: staffList));

    if (staffList.isNotEmpty) {
      searchList = staffList.first.data.staffs.data;
    } else {
      searchList = [];
    }

    final suggestion = searchList.where((element) {
      final apartmentNumber = element!.name.toLowerCase();
      final input = query.toLowerCase();

      return apartmentNumber.contains(input);
    }).toList();

    emit(GetStaffSearchedLoaded(
      staffList: suggestion,
    ));
  }
}
