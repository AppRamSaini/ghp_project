part of 'accept_request_cubit.dart';

@immutable
sealed class AcceptRequestState {}

final class AcceptRequestInitial extends AcceptRequestState {}

final class AcceptRequestLoading extends AcceptRequestState {}

final class AcceptRequestSuccessfully extends AcceptRequestState {
  final String successMsg;
  AcceptRequestSuccessfully({required this.successMsg});
}

final class AcceptRequestFailed extends AcceptRequestState {
  final String errorMsg;
  AcceptRequestFailed({required this.errorMsg});
}

final class AcceptRequestInternetError extends AcceptRequestState {
  final String errorMsg;
  AcceptRequestInternetError({required this.errorMsg});
}

final class AcceptRequestLogout extends AcceptRequestState {}
