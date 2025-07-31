import 'dart:convert';
import 'dart:io';

import 'package:ghp_society_management/constants/export.dart';
import 'package:ghp_society_management/model/select_society_model.dart';
import 'package:ghp_society_management/network/api_manager.dart';

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
      final response = await apiManager.getRequest(
          'https://dev-society.ghpjaipur.com/api/user/v1/societies');
      final resData = json.decode(response.body.toString());

      if (response.statusCode == 200 && resData['status'] == true) {
        final societiesData = resData['data']?['societies']?['data'];

        currentPage = resData['data']['societies']['current_page'] ?? 1;
        final lastPage = resData['data']['societies']['last_page'] ?? 1;
        hasMore = currentPage < lastPage;

        if (societiesData is List) {
          final newSocieties =
              societiesData.map((e) => SocietyList.fromJson(e)).toList();

          if (loadMore) {
            societyList.addAll(newSocieties);
          } else {
            societyList = newSocieties;
          }
          emit(SelectSocietyLoaded(selectedSociety: societyList));
        } else {
          emit(SelectSocietyFailed(errorMsg: "Invalid data format received."));
        }
      } else {
        emit(SelectSocietyFailed(
            errorMsg:
                resData['message']?.toString() ?? "Something went wrong"));
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
