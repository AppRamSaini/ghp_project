part of 'incoming_documents_cubit.dart';

@immutable
sealed class IncomingDocumentsState {}

final class IncomingDocumentsInitial extends IncomingDocumentsState {}

final class IncomingDocumentsLoading extends IncomingDocumentsState {}

final class IncomingDocumentsLoaded extends IncomingDocumentsState {
  final List<IncomingRequestData> incomingDocuments;

  IncomingDocumentsLoaded({required this.incomingDocuments});
}

class IncomingDocumentsSearchLoaded extends IncomingDocumentsState {
  final List<IncomingRequestData> searchList;
  IncomingDocumentsSearchLoaded({required this.searchList});
  List<Object> get props => [];
}

final class IncomingDocumentsFailed extends IncomingDocumentsState {
  final String errorMsg;
  IncomingDocumentsFailed({required this.errorMsg});
}

final class IncomingDocumentsInternetError extends IncomingDocumentsState {
  final String errorMsg;
  IncomingDocumentsInternetError({required this.errorMsg});
}

final class IncomingDocumentsTimeout extends IncomingDocumentsState {
  final String errorMsg;
  IncomingDocumentsTimeout({required this.errorMsg});
}

final class IncomingDocumentsLogout extends IncomingDocumentsState {}

final class IncomingDocumentsLoadingMore extends IncomingDocumentsState {}

final class IncomingDocumentsEmpty extends IncomingDocumentsState {}
