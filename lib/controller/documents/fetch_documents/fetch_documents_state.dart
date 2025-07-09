part of 'fetch_documents_cubit.dart';

@immutable
sealed class FetchDocumentsState {}

final class FetchDocumentsInitial extends FetchDocumentsState {}

final class FetchDocumentsLoading extends FetchDocumentsState {}

final class FetchDocumentsLoaded extends FetchDocumentsState {
  final List<Datum> fetchDocuments;
  FetchDocumentsLoaded({required this.fetchDocuments});
}

final class FetchDocumentsFailed extends FetchDocumentsState {
  final String errorMsg;
  FetchDocumentsFailed({required this.errorMsg});
}

final class FetchDocumentsInternetError extends FetchDocumentsState {}

final class FetchDocumentsLogout extends FetchDocumentsState {}
