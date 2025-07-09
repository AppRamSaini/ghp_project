import 'dart:convert';
import 'dart:io';
import 'package:bloc/bloc.dart';
import 'package:ghp_society_management/constants/config.dart';
import 'package:ghp_society_management/model/search_member_modal.dart';
import 'package:ghp_society_management/network/api_manager.dart';
import 'package:meta/meta.dart';

part 'search_member_state.dart';

class SearchMemberCubit extends Cubit<SearchMemberState> {
  SearchMemberCubit() : super(SearchMemberInitial());

  ApiManager apiManager = ApiManager();
  List<SearchMemberInfo> searchMemberInfo = [];

  fetchSearchMember(String query) async {
    emit(SearchMemberLoading());

    try {
      var response = await apiManager
          .getRequest("${Config.baseURL}${Routes.searchMember}$query");
      var responseData = json.decode(response.body.toString());

      print('API Response: ${jsonEncode(responseData)}');

      if (response.statusCode == 200) {
        if (responseData['status']) {
          if (responseData['data'] != null &&
              responseData['data']['members'] != null) {
            searchMemberInfo = (responseData['data']['members']['data'] as List)
                .map((e) => SearchMemberInfo.fromJson(e))
                .toList();
          }
          print('Fetched Members: ${searchMemberInfo.map((e) => e.name)}');
          emit(SearchMemberLoaded(searchMemberInfo: searchMemberInfo));
        } else {
          emit(SearchMemberFailed(
              errorMessage: responseData['message'].toString()));
        }
      } else if (response.statusCode == 401) {
        emit(SearchMemberLogout());
      } else {
        emit(SearchMemberFailed(
            errorMessage: responseData['message'].toString()));
      }
    } on SocketException {
      emit(SearchMemberInternetError(
          errorMessage: "Internet connection error!"));
    } catch (e) {
      emit(SearchMemberFailed(
          errorMessage: "Something went wrong: ${e.toString()}"));
    }
  }
}
