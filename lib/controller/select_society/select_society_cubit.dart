import 'dart:convert';
import 'dart:io';
import 'package:bloc/bloc.dart';
import 'package:ghp_society_management/constants/config.dart';
import 'package:ghp_society_management/constants/export.dart';
import 'package:ghp_society_management/model/select_society_model.dart';
import 'package:ghp_society_management/network/api_manager.dart';
import 'package:meta/meta.dart';
part 'select_society_state.dart';

class SelectSocietyCubit extends Cubit<SelectSocietyState> {
  SelectSocietyCubit() : super(SelectSocietyInitial());
  ApiManager apiManager = ApiManager();
  List<SocietyList> societyList = [];

  int currentPage = 1;
  bool isLoadingMore = false;
  bool hasMore = true;

  fetchSocietyList({bool loadMore = false}) async {
    if (isLoadingMore || !hasMore) {
      isLoadingMore = true;
      emit(SelectSocietyLoadMore());
    } else {
      societyList.clear();
      currentPage = 1;
      emit(SelectSocietyLoading());
    }

    try {
      var response =
          await apiManager.getRequest(Config.baseURL + Routes.society);

      var resData = json.decode(response.body.toString());
      if (response.statusCode == 200) {
        if (resData['status']) {
          var newSocietyList = (resData['data']['societies']['data'] as List)
              .map((e) => SocietyList.fromJson(e))
              .toList();

          // Update pagination data
          currentPage = resData['data']['societies']['current_page'];
          int lastPage = resData['data']['societies']['last_page'];
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
      } else {
        emit(SelectSocietyFailed(errorMsg: resData['message'].toString()));
      }
    } on SocketException {
      emit(SelectSocietyInternetError(errorMsg: "Internet Connection Error!"));
    } catch (e) {
      emit(SelectSocietyFailed(errorMsg: "Error ${e.toString()}"));
    } finally {
      isLoadingMore = false;
    }
  }

  /// search society
  searchSociety(String query) {
    final List<SocietyList> filteredList = societyList.where((event) {
      return event.name.toString().toLowerCase().contains(query.toLowerCase());
    }).toList();

    print('Searched Results: ${filteredList.map((e) => e.name)}');

    emit(SelectSocietySearchedLoaded(selectedSociety: filteredList));
  }

  /// load more data
  void loadMoreNotice() {
    if (state is NoticeModelLoaded && hasMore) {
      fetchSocietyList(loadMore: true); // Load more bills
    }
  }
}
