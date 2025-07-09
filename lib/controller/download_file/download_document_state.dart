part of 'download_document_cubit.dart';

@immutable
sealed class DownloadDocumentState {}

final class DownloadDocumentInitial extends DownloadDocumentState {}

final class DownloadDocumentLoading extends DownloadDocumentState {}

final class DownloadDocumentSuccess extends DownloadDocumentState {
  final String successMsg;
  DownloadDocumentSuccess({required this.successMsg});
}

final class DownloadDocumentDownloading extends DownloadDocumentState {}

final class DownloadDocumentFailed extends DownloadDocumentState {
  final String errorMsg;
  DownloadDocumentFailed({required this.errorMsg});
}

final class DownloadDocumentInternetError extends DownloadDocumentState {
  final String errorMsg;
  DownloadDocumentInternetError({required this.errorMsg});
}

final class DownloadDocumentTimeout extends DownloadDocumentState {
  final String errorMsg;
  DownloadDocumentTimeout({required this.errorMsg});
}

final class QRSuccess extends DownloadDocumentState {
  final String successMsg;
  QRSuccess({required this.successMsg});
}

final class QRDownloading extends DownloadDocumentState {}

final class QRFailed extends DownloadDocumentState {
  final String errorMsg;
  QRFailed({required this.errorMsg});
}

final class QRInternetError extends DownloadDocumentState {
  final String errorMsg;
  QRInternetError({required this.errorMsg});
}

final class QRTimeout extends DownloadDocumentState {
  final String errorMsg;
  QRTimeout({required this.errorMsg});
}
