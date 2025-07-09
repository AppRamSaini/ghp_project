part of 'check_out_cubit.dart';

@immutable
sealed class CheckOutState {}

final class CheckOutInitial extends CheckOutState {}

final class CheckOutLoading extends CheckOutState {}

final class CheckOutSuccessfully extends CheckOutState {
  final String successMsg;
  CheckOutSuccessfully({required this.successMsg});
}

final class CheckOutFailed extends CheckOutState {
  final String errorMsg;
  CheckOutFailed({required this.errorMsg});
}

final class CheckOutInternetError extends CheckOutState {}

final class CheckOutLogout extends CheckOutState {}
