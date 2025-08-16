part of 'document_count_cubit.dart';

@immutable
sealed class DocumentCountState {}

final class DocumentCountInitial extends DocumentCountState {}

final class DocumentCountLoading extends DocumentCountState {}

final class DocumentCountLoaded extends DocumentCountState {
  final int incomingRequestCount;
  final int outGoingRequestCount;

  DocumentCountLoaded(
      {required this.incomingRequestCount, required this.outGoingRequestCount});
}

final class DocumentCountFailed extends DocumentCountState {
  final String errorMsg;

  DocumentCountFailed({required this.errorMsg});
}

final class DocumentCountInternetError extends DocumentCountState {
  final String errorMsg;

  DocumentCountInternetError({required this.errorMsg});
}

final class UnAuthenticatedUser extends DocumentCountState {}
