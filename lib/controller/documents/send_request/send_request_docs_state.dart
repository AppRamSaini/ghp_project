part of 'send_request_docs_cubit.dart';

@immutable
sealed class SendDocsRequestState {}

final class SendDocsRequestInitial extends SendDocsRequestState {}

final class SendDocsRequestLoading extends SendDocsRequestState {}

final class SendDocsRequestSuccessfully extends SendDocsRequestState {
  final String successMsg;
  SendDocsRequestSuccessfully({required this.successMsg});
}

final class SendDocsRequestFailed extends SendDocsRequestState {
  final String errorMsg;
  SendDocsRequestFailed({required this.errorMsg});
}

final class SendDocsRequestInternetError extends SendDocsRequestState {
  final String errorMsg;
  SendDocsRequestInternetError({required this.errorMsg});
}

final class SendDocsRequestLogout extends SendDocsRequestState {}
