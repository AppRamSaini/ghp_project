
part of 'payment_service_cubit.dart';

@immutable
sealed class PaymentServiceState {}

final class PaymentServiceInitial extends PaymentServiceState {}

final class PaymentServiceLoading extends PaymentServiceState {}

final class PaymentServiceSuccessfully extends PaymentServiceState {
}

final class PaymentServiceFailed extends PaymentServiceState {
  final String errorMessage;
  PaymentServiceFailed({required this.errorMessage});
}

final class PaymentServiceInternetError extends PaymentServiceState {
  final String errorMessage;
  PaymentServiceInternetError({required this.errorMessage});
}
