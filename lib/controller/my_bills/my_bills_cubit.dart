import 'dart:convert';
import 'dart:io';
import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:ghp_society_management/constants/config.dart';
import 'package:ghp_society_management/constants/local_storage.dart';
import 'package:ghp_society_management/network/api_manager.dart';
import 'package:ghp_society_management/view/session_dialogue.dart';

import '../../model/my_bill_model.dart';

part 'my_bills_state.dart';

class MyBillsCubit extends Cubit<MyBillsState> {
  MyBillsCubit() : super(MyBillsInitial());

  ApiManager apiManager = ApiManager();
  List<Datum> bills = []; // Datum represents individual bills
  int currentPage = 1;
  bool hasMore = true;
  int amount = 0;
  int paidAmount = 0;

  /// FETCH MY BILLS
  Future<void> fetchMyBills(
      {required BuildContext context, String? billTypes, int page = 1}) async {
    final propertyId = LocalStorage.localStorage.getString('property_id');

    // if (state is MyBillsLoading || !hasMore) return;
    emit(MyBillsLoading());
    try {
      // Fetching the response from the API
      var response = await apiManager.getRequest(
          "${Config.baseURL}${Routes.getMyBills(propertyId.toString(),billTypes.toString())}?page=$page",usePropertyID: true);
      var responseData = json.decode(response.body);

      if (response.statusCode == 200) {
        if (responseData['status']) {
          var newBills = (responseData['data']['bills']['data'] as List)
              .map((e) => Datum.fromJson(e))
              .toList();
          currentPage = responseData['data']['bills']['current_page'];
          int lastPage = responseData['data']['bills']['last_page'];
          hasMore = currentPage < lastPage;
          amount = double.parse(
                  responseData['data']['total_unpaid_amount'].toString())
              .toInt();
          paidAmount =
              double.parse(responseData['data']['total_paid_amount'].toString())
                  .toInt();
          if (page == 1) {
            bills = newBills;
          } else {
            bills.addAll(newBills);
          }
          emit(MyBillsLoaded(
              bills: bills,
              currentPage: currentPage,
              hasMore: hasMore,
              paidAmount: paidAmount,
              amount: amount));
        } else {
          print(responseData['data']);

          amount = double.parse(
                  responseData['data']['total_unpaid_amount'].toString())
              .toInt();
          paidAmount =
              double.parse(responseData['data']['total_paid_amount'].toString())
                  .toInt();
          emit(MyBillsFailed(errorMsg: responseData['message'].toString()));
        }
      } else if (response.statusCode == 401) {
        sessionExpiredDialog(context);
      } else {
        emit(MyBillsFailed(
            errorMsg:
                responseData['message'].toString())); // Handle failure response
      }
    } on SocketException {
      emit(MyBillsInternetError()); // Handle network issues
    } catch (e) {
      emit(MyBillsFailed(errorMsg: e.toString())); // Handle general errors
    }
  }

  void loadMoreBills(BuildContext context, String billType) {
    if (state is MyBillsLoaded && hasMore) {
      fetchMyBills(
          context: context,
          billTypes: billType,
          page: currentPage + 1); // Load more bills
    }
  }
}
