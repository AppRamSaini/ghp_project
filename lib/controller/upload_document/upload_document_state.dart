part of 'upload_document_cubit.dart';

@immutable
sealed class UploadDocumentState {}

final class UploadDocumentInitial extends UploadDocumentState {}

final class UploadDocumentLoading extends UploadDocumentState {}

final class UploadDocumentSuccessfully extends UploadDocumentState {
  final String successMsg;
  UploadDocumentSuccessfully({required this.successMsg});
}

final class UploadDocumentFailed extends UploadDocumentState {
  final String errorMsg;
  UploadDocumentFailed({required this.errorMsg});
}

final class UploadDocumentInternetError extends UploadDocumentState {}
