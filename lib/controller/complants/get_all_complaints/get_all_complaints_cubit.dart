import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:bloc/bloc.dart';
import 'package:ghp_society_management/constants/config.dart';
import 'package:ghp_society_management/model/complaints_model.dart';
import 'package:ghp_society_management/network/api_manager.dart';
import 'package:http/http.dart';

part 'get_all_complaints_state.dart';

class GetAllComplaintsCubit extends Cubit<GetAllComplaintsState> {
  GetAllComplaintsCubit() : super(GetAllInitialComplaints());
  ApiManager apiManager = ApiManager();
  List<ComplaintList> complaintsLIst = [];
// Variables for pagination
  int currentPage = 1;
  bool isLoadingMore = false;

  fetchComplaintsAPI({bool loadMore = false}) async {
    if (loadMore) {
      if (isLoadingMore) return; // Prevent multiple simultaneous API calls
      isLoadingMore = true;
      emit(IncomingDocumentsLoadingMore());
    } else {
      currentPage = 1; // Reset page number when not loading more
      complaintsLIst.clear(); // Clear previous data
      emit(GetAllComplaintsLoading());
    }

    try {
      Response response = await apiManager
          .getRequest("${Config.baseURL}${Routes.fetchComplaints}$currentPage");

      var res = json.decode(response.body.toString());

      if (response.statusCode == 200) {
        if (res['status']) {
          List dataList = res['data']['complaints']['data'];

          if (dataList.isEmpty) {
            if (loadMore) {
              emit(GetAllComplaintsLoaded(complaints: complaintsLIst));
            } else {
              emit(GetAllComplaintsEmpty());
            }
          } else {
            var incomingDocuments = GetAllComplaintsModel.fromJson(res);
            complaintsLIst.addAll(incomingDocuments.data!.complaints!.data!);
            currentPage++;
            emit(GetAllComplaintsLoaded(complaints: complaintsLIst));
          }
        } else {
          emit(GetAllComplaintsFailed(errorMsg: res['message'].toString()));
        }
      } else if (response.statusCode == 401) {
        emit(GetAllComplaintsLogout());
      } else {
        emit(GetAllComplaintsFailed(errorMsg: res['message'].toString()));
      }
    } on SocketException {
      emit(GetAllComplaintsInternetError(
          errorMsg: 'Internet connection failed!'));
    } on TimeoutException {
      emit(GetAllComplaintsTimeout(errorMsg: 'Server timeout exception'));
    } catch (e) {
      emit(GetAllComplaintsFailed(errorMsg: "Error ${e.toString()}"));
    } finally {
      isLoadingMore = false; // Reset loading state
    }
  }

  // /// FETCH MY BILLS
  // Future<void> fetchComplaintsAPI() async {
  //   if (state is GetAllComplaintsLoading || !hasMore) return;
  //   emit(GetAllComplaintsLoading());
  //   try {
  //     var response = await apiManager.getRequest(
  //         "${Config.baseURL}${Routes.fetchComplaints}$page;
  //     var responseData = jsonDecode(response.body);
  //     if (response.statusCode == 200) {
  //       if (responseData['status']) {
  //         var newComplaints =
  //             (responseData['data']['complaints']['data'] as List)
  //                 .map((e) => ComplaintsList.fromJson(e))
  //                 .toList();
  //         currentPage = responseData['data']['complaints']['current_page'];
  //         int lastPage = responseData['data']['complaints']['last_page'];
  //         hasMore = currentPage < lastPage;
  //         if (page == 1) {
  //           complaintsLIst =
  //               newComplaints; // For the first page, replace the list
  //         } else {
  //           complaintsLIst.addAll(
  //               newComplaints); // For subsequent pages, append new bills
  //         }
  //         emit(GetAllComplaintsLoaded(
  //             complaints: complaintsLIst,
  //             currentPage: currentPage,
  //             hasMore: hasMore));
  //       } else {
  //         emit(GetAllComplaintsFailed(
  //             errorMsg: responseData['message'].toString()));
  //       }
  //     } else if (response.statusCode == 401) {
  //       emit(GetAllComplaintsLogout());
  //     } else {
  //       emit(GetAllComplaintsFailed(
  //           errorMsg:
  //               responseData['message'].toString())); // Handle failure response
  //     }
  //   } on SocketException {
  //     emit(GetAllComplaintsInternetError()); // Handle network issues
  //   } catch (e) {
  //     emit(GetAllComplaintsFailed(
  //         errorMsg: e.toString())); // Handle general errors
  //   }
  // }
  //
  // void loadMoreProperty() {
  //   if (state is GetAllComplaintsLoaded && hasMore) {
  //     fetchComplaintsAPI(page: currentPage + 1); // Load more bills
  //   }
  // }
}
