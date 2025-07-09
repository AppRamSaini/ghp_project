part of 'resident_checkout_cubit.dart';

@immutable
sealed class ResidentCheckOutState {}

final class ResidentCheckOutInitial extends ResidentCheckOutState {}

final class ResidentCheckOutLoading extends ResidentCheckOutState {}

final class ResidentCheckOutSuccessfully extends ResidentCheckOutState {
  final String successMsg;
  ResidentCheckOutSuccessfully({required this.successMsg});
}

final class ResidentCheckOutFailed extends ResidentCheckOutState {
  final String errorMsg;
  ResidentCheckOutFailed({required this.errorMsg});
}
