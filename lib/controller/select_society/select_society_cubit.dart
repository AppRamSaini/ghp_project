import 'dart:convert';
import 'dart:io';
import 'package:bloc/bloc.dart';
import 'package:ghp_society_management/constants/config.dart';
import 'package:ghp_society_management/constants/export.dart';
import 'package:ghp_society_management/model/select_society_model.dart';
import 'package:ghp_society_management/network/api_manager.dart';
import 'package:meta/meta.dart';
import 'package:http/http.dart' as http;

part 'select_society_state.dart';

class SelectSocietyCubit extends Cubit<SelectSocietyState> {
  SelectSocietyCubit() : super(SelectSocietyInitial());

  final ApiManager apiManager = ApiManager();
  List<SocietyList> societyList = [];

  int currentPage = 1;
  bool isLoadingMore = false;
  bool hasMore = true;

  Future<void> fetchSocietyList({bool loadMore = false}) async {
    if (loadMore) {
      if (isLoadingMore || !hasMore) return;
      isLoadingMore = true;
      emit(SelectSocietyLoadMore());
    } else {
      societyList.clear();
      currentPage = 1;
      emit(SelectSocietyLoading());
    }

    try {
      final url = "${Config.baseURL}${Routes.society}?page=$currentPage";
      var response = await http.get(Uri.parse(url));
      // final response = await apiManager.getRequest('https://dev-society.ghpjaipur.com/api/user/v1/societies');
      final resData = json.decode(response.body.toString());
      //
      print('res ---->>>>>>>>>>>>>>$response');

      if (response.statusCode == 200 && resData['status']) {
        final newSocietyList = (resData['data']['societies']['data'] as List)
            .map((e) => SocietyList.fromJson(e))
            .toList();

        currentPage = resData['data']['societies']['current_page'];
        final lastPage = resData['data']['societies']['last_page'];
        hasMore = currentPage < lastPage;

        if (loadMore) {
          societyList.addAll(newSocietyList);
        } else {
          societyList = newSocietyList;
        }


        emit(SelectSocietyLoaded(selectedSociety: societyList));
      } else {
        emit(SelectSocietyFailed(errorMsg: resData['message'].toString()));
      }
    } on SocketException {
      emit(SelectSocietyInternetError(errorMsg: "Internet Connection Error!"));
    } catch (e) {
      emit(SelectSocietyFailed(errorMsg: "Error: ${e.toString()}"));
    } finally {
      isLoadingMore = false;
    }
  }

  void searchSociety(String query) {
    if (query.trim().isEmpty) {
      emit(SelectSocietyLoaded(selectedSociety: societyList));
      return;
    }

    final List<SocietyList> filteredList = societyList.where((event) {
      return event.name.toString().toLowerCase().contains(query.toLowerCase());
    }).toList();

    print('Searched Results: ${filteredList.map((e) => e.name)}');

    emit(SelectSocietySearchedLoaded(selectedSociety: filteredList));
  }

  void loadMoreSocieties() {
    if (state is SelectSocietyLoaded && hasMore && !isLoadingMore) {
      currentPage++;
      fetchSocietyList(loadMore: true);
    }
  }
}
