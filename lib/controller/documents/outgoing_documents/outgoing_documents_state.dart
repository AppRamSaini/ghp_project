part of 'outgoing_documents_cubit.dart';

@immutable
sealed class OutgoingDocumentsState {}

final class OutgoingDocumentsInitial extends OutgoingDocumentsState {}

final class OutgoingDocumentsLoading extends OutgoingDocumentsState {}

final class OutgoingDocumentsLoaded extends OutgoingDocumentsState {
  final List<RequestData> outgoingDocuments;

  OutgoingDocumentsLoaded({required this.outgoingDocuments});
}

class OutgoingDocumentsSearchLoaded extends OutgoingDocumentsState {
  final List<RequestData> searchList;
  OutgoingDocumentsSearchLoaded({required this.searchList});
  List<Object> get props => [];
}

final class OutgoingDocumentsFailed extends OutgoingDocumentsState {
  final String errorMsg;
  OutgoingDocumentsFailed({required this.errorMsg});
}

final class OutgoingDocumentsInternetError extends OutgoingDocumentsState {
  final String errorMsg;
  OutgoingDocumentsInternetError({required this.errorMsg});
}

final class OutgoingDocumentsTimeout extends OutgoingDocumentsState {
  final String errorMsg;
  OutgoingDocumentsTimeout({required this.errorMsg});
}

final class OutgoingDocumentsLogout extends OutgoingDocumentsState {}
