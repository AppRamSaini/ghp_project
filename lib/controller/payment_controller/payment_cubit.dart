import 'dart:convert';
import 'dart:io';
import 'package:bloc/bloc.dart';
import 'package:ghp_society_management/constants/config.dart';
import 'package:ghp_society_management/constants/local_storage.dart';
import 'package:ghp_society_management/network/api_manager.dart';
import 'package:meta/meta.dart';

part 'payment_state.dart';

class PaymentCubit extends Cubit<PaymentState> {
  PaymentCubit() : super(PaymentInitial());
  ApiManager apiManager = ApiManager();

  payBillPaymentApi({var paymentBody}) async {
    emit(PaymentLoading());
    try {
      var token = LocalStorage.localStorage.getString('token');
      var responseData = await apiManager.postRequest(
          paymentBody,
          Config.baseURL + Routes.billPayment,
          {'Authorization': 'Bearer $token', 'Accept': 'application/json'});

      var data = json.decode((responseData.body.toString()));

      print("---------->>>>$data");
      print(responseData.statusCode);

      if (responseData.statusCode == 201) {
        if (data['status']) {
          emit(PaymentSuccessfully(successMsg: data['message']));
        } else {
          emit(PaymentFailed(errorMsg: data['message']));
        }
      } else if (responseData.statusCode == 401) {
        emit(PaymentLogout());
      } else {
        emit(PaymentFailed(errorMsg: data['message']));
      }
    } on SocketException {
      emit(PaymentInternetError());
    } catch (e) {
      emit(PaymentFailed(errorMsg: e.toString()));
    }
  }
}
