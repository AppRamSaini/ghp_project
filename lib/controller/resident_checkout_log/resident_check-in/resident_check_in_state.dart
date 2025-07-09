part of 'resident_check_in_cubit.dart';

@immutable
sealed class ResidentCheckInState {}

final class ResidentCheckInInitial extends ResidentCheckInState {}

final class ResidentCheckInLoading extends ResidentCheckInState {}

final class ResidentCheckInSuccessfully extends ResidentCheckInState {
  final String successMsg;
  ResidentCheckInSuccessfully({required this.successMsg});
}

final class ResidentCheckInFailed extends ResidentCheckInState {
  final String errorMsg;
  ResidentCheckInFailed({required this.errorMsg});
}
