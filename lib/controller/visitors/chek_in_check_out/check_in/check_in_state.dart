part of 'check_in_cubit.dart';

@immutable
sealed class CheckInState {}

final class CheckInInitial extends CheckInState {}

final class CheckInLoading extends CheckInState {}

final class CheckInSuccessfully extends CheckInState {
  final String successMsg;
  CheckInSuccessfully({required this.successMsg});
}

final class CheckInFailed extends CheckInState {
  final String errorMsg;
  CheckInFailed({required this.errorMsg});
}

final class CheckInInternetError extends CheckInState {}

final class CheckInLogout extends CheckInState {}
