import 'dart:async';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:ghp_society_management/constants/download_share_gatepass.dart';
import 'package:ghp_society_management/network/api_manager.dart';
import 'package:meta/meta.dart';
import 'package:screenshot/screenshot.dart';
import '../../model/outgoing_document_model.dart';
part 'download_document_state.dart';

class DownloadDocumentCubit extends Cubit<DownloadDocumentState> {
  DownloadDocumentCubit() : super(DownloadDocumentInitial());
  ApiManager apiManager = ApiManager();

  downloadDocument(List<FileElement> documents) async {
    emit(DownloadDocumentLoading());
    try {
      bool imageDownloading = await apiManager.downloadFiles(documents);
      if (imageDownloading) {
        emit(DownloadDocumentSuccess(
            successMsg: "File downloaded successfully"));
      } else {
        emit(DownloadDocumentFailed(errorMsg: "File download error!"));
      }
    } on SocketException {
      emit(DownloadDocumentInternetError(
          errorMsg: 'Internet Connection Failed!'));
    } on TimeoutException {
      emit(DownloadDocumentTimeout(errorMsg: 'server timeout exception'));
    } catch (e) {
      emit(DownloadDocumentFailed(errorMsg: "File download error!"));
    }
  }

  /// qr code download
  downloadQRCode(ScreenshotController screenshotController) async {
    emit(QRDownloading());
    try {
      bool imageDownloading = await captureAndDownloadPng(screenshotController);
      if (imageDownloading) {
        emit(QRSuccess(successMsg: "Gate pass downloaded successfully"));
      } else {
        emit(QRFailed(errorMsg: "Gate pass download error!"));
      }
    } on SocketException {
      emit(QRInternetError(errorMsg: 'Internet Connection Failed!'));
    } on TimeoutException {
      emit(QRTimeout(errorMsg: 'server timeout exception'));
    } catch (e) {
      emit(QRFailed(errorMsg: "Gate pass download error!"));
    }
  }
}
