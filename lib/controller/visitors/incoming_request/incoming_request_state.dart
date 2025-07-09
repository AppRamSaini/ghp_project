part of 'incoming_request_cubit.dart';

@immutable
sealed class IncomingRequestState {}

final class IncomingRequestInitial extends IncomingRequestState {}

final class IncomingRequestLoading extends IncomingRequestState {}

final class IncomingRequestLoaded extends IncomingRequestState {
  final IncomingVisitorsModel incomingVisitorsRequest;
  IncomingRequestLoaded({required this.incomingVisitorsRequest});
}

final class IncomingRequestFailed extends IncomingRequestState {
  final String errorMsg;
  IncomingRequestFailed({required this.errorMsg});
}

final class IncomingRequestInternetError extends IncomingRequestState {}

final class IncomingRequestLogout extends IncomingRequestState {}
