part of 'resend_request_cubit.dart';

@immutable
sealed class ResendRequestState {}

final class ResendRequestInitial extends ResendRequestState {}

final class ResendRequestLoading extends ResendRequestState {}

final class ResendRequestSuccessfully extends ResendRequestState {
  final String successMsg;
  final String visitorsId;
  ResendRequestSuccessfully(
      {required this.successMsg, required this.visitorsId});
}

final class ResendRequestFailed extends ResendRequestState {
  final String errorMsg;
  ResendRequestFailed({required this.errorMsg});
}

final class ResendRequestInternetError extends ResendRequestState {
  final String errorMsg;
  ResendRequestInternetError({required this.errorMsg});
}

final class ResendRequestLogout extends ResendRequestState {}
