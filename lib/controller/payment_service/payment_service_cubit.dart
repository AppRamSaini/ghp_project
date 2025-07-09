import 'dart:io';
import 'package:flutter/material.dart';
import 'package:bloc/bloc.dart';
import 'package:ghp_society_management/network/api_manager.dart';

part 'payment_service_state.dart';

class PaymentServiceCubit extends Cubit<PaymentServiceState> {
  PaymentServiceCubit() : super(PaymentServiceInitial());
  ApiManager apiManager = ApiManager();

  makePayment(notificationBody) async {
    emit(PaymentServiceLoading());
    try {
      emit(PaymentServiceSuccessfully());
    } on SocketException {
      emit(PaymentServiceInternetError(
          errorMessage: 'Internet connection error'));
    } catch (e) {
      emit(PaymentServiceFailed(errorMessage: 'An error occurred $e '));
    }
  }
}
