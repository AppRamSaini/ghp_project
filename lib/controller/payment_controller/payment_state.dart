part of 'payment_cubit.dart';

@immutable
sealed class PaymentState {}

final class PaymentInitial extends PaymentState {}

final class PaymentLoading extends PaymentState {}

final class PaymentSuccessfully extends PaymentState {
  final String successMsg;
  PaymentSuccessfully({required this.successMsg});
}

final class PaymentFailed extends PaymentState {
  final String errorMsg;
  PaymentFailed({required this.errorMsg});
}

final class PaymentInternetError extends PaymentState {}

final class PaymentLogout extends PaymentState {}
