import 'dart:convert';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:ghp_society_management/constants/config.dart';
import 'package:ghp_society_management/model/ledger_bill_model.dart';
import 'package:ghp_society_management/network/api_manager.dart';

part 'ledger_state.dart';

class LedgerBillCubit extends Cubit<LedgerBillState> {
  LedgerBillCubit() : super(LedgerBillInitial());

  final ApiManager apiManager = ApiManager();

  List<LedgerData> ledgerBillDataList = [];
  int currentPage = 1;
  bool hasMore = true;
  bool isLoadingMore = false;

  /// Fetch Notifications
  Future<void> fetchLedgerBillDataApi({bool loadMore = false}) async {
    if (loadMore) {
      if (isLoadingMore || !hasMore) return;
      isLoadingMore = true;
      emit(LedgerBillLoadingMore());
    } else {
      currentPage = 1;
      ledgerBillDataList.clear();
      emit(LedgerBillLoading());
    }

    try {
      final response =
          await apiManager.getRequest("${Routes.ledgerBill}?page=$currentPage");

      final responseData = jsonDecode(response.body);

      if (response.statusCode == 200) {
        if (responseData['status'] == true) {
          final List<LedgerData> newLedgerBillData =
              (responseData['data']['ledger']['data'] as List)
                  .map((e) => LedgerData.fromJson(e))
                  .toList();

          final int lastPage = responseData['data']['ledger']['last_page'];

          hasMore = currentPage < lastPage; // Check if more pages exist

          if (loadMore) {
            for (var item in newLedgerBillData) {
              if (!ledgerBillDataList.contains(item)) {
                ledgerBillDataList.add(item);
              }
            }
          } else {
            ledgerBillDataList = newLedgerBillData;
          }

          currentPage++;

          emit(LedgerBillLoaded(
              ledgerDataList: ledgerBillDataList,
              currentPage: currentPage,
              hasMore: hasMore));
        } else {
          emit(LedgerBillFailed(
              errorMsg: responseData['message'] ?? "Something went wrong."));
        }
      } else if (response.statusCode == 401) {
        emit(LedgerBillLogout());
      } else {
        emit(LedgerBillFailed(
            errorMsg:
                "Error: ${response.statusCode}, ${response.reasonPhrase}"));
      }
    } on SocketException {
      emit(LedgerBillInternetError(errorMsg: "Internet Connection Error!"));
    } catch (e) {
      emit(LedgerBillFailed(errorMsg: e.toString()));
    } finally {
      isLoadingMore = false;
    }
  }

  /// Load More Notifications
  void loadMoreBillLedgerData() {
    if (state is LedgerBillLoaded && hasMore) {
      fetchLedgerBillDataApi(loadMore: true);
    }
  }
}
