import 'dart:convert';
import 'dart:io';
import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:ghp_society_management/constants/config.dart';
import 'package:ghp_society_management/model/my_bill_details_model.dart';
import 'package:ghp_society_management/network/api_manager.dart';
import 'package:ghp_society_management/view/session_dialogue.dart';

part 'bill_details_state.dart';

class BillDetailsCubit extends Cubit<BillsDetailsState> {
  BillDetailsCubit() : super(InitialBillDetails());

  ApiManager apiManager = ApiManager();
  List<Bill> bills = []; // List to store all bills

  /// FETCH MY BILLS (without pagination)
  Future<void> fetchMyBillsDetails(BuildContext context, String id) async {
    if (state is BillDetailsLoading) return;

    emit(BillDetailsLoading());
    try {
      // Make API request
      var response = await apiManager
          .getRequest("${Config.baseURL}${Routes.getBillDetails}$id");
      if (response.statusCode == 200) {
        // Parse response data
        var responseData = jsonDecode(response.body);

        // Map the JSON response to a list of Bill objects
        var newBills = (responseData['data']['bill'] as List)
            .map((e) => Bill.fromJson(e))
            .toList();
        bills = newBills;
        emit(BillDetailsLoaded(bills: bills));
      } else if (response.statusCode == 401) {
         sessionExpiredDialog(context);
      } else {
        // Emit failure if the status code isn't 200
        emit(BillDetailsFailed());
      }
    } on SocketException {
      // Handle network error
      emit(BillDetailsInternetError());
    } catch (e) {
      // Handle any other errors
      emit(BillDetailsFailed());
    }
  }
}
