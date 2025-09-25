import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:ghp_society_management/constants/config.dart';
import 'package:ghp_society_management/constants/export.dart';
import 'package:ghp_society_management/model/incoming_documents_model.dart';
import 'package:ghp_society_management/network/api_manager.dart';
part 'incoming_documents_state.dart';

class IncomingDocumentsCubit extends Cubit<IncomingDocumentsState> {
  IncomingDocumentsCubit() : super(IncomingDocumentsInitial());

  final ApiManager apiManager = ApiManager();

  List<IncomingRequestData> documentList = [];
  int currentPage = 1;
  bool hasMore = true;
  bool isLoadingMore = false;

  /// Fetch Incoming Documents
  Future<void> fetchIncomingDocuments(
      {String? filter, bool loadMore = false}) async {
    if (loadMore) {
      if (isLoadingMore || !hasMore) return;
      isLoadingMore = true;
      emit(IncomingDocumentsLoadingMore());
    } else {
      currentPage = 1;
      documentList.clear();
      hasMore = true;
      emit(IncomingDocumentsLoading());
    }

    try {
      final response = await apiManager.getRequest(
          "${Config.baseURL + Routes.getIncomingDocuments}${filter ?? ''}&page=$currentPage",usePropertyID: true);

      final responseData = json.decode(response.body);

      if (response.statusCode == 200) {
        if (responseData['status']) {
          final newDocuments =
              (responseData['data']['incoming_requests']['data'] as List)
                  .map((e) => IncomingRequestData.fromJson(e))
                  .toList();
          currentPage =
              responseData['data']['incoming_requests']['current_page'];
          final int lastPage =
              responseData['data']['incoming_requests']['last_page'];

          hasMore = currentPage < lastPage;

          if (loadMore) {
            documentList.addAll(newDocuments);
          } else {
            documentList = newDocuments;
          }

          emit(IncomingDocumentsLoaded(incomingDocuments: documentList));
        } else {
          emit(IncomingDocumentsFailed(
              errorMsg: responseData['message'] ?? "Something went wrong."));
        }
      } else if (response.statusCode == 401) {
        emit(IncomingDocumentsLogout());
      } else {
        emit(IncomingDocumentsFailed(
            errorMsg:
                "Error: ${response.statusCode}, ${response.reasonPhrase}"));
      }
    } on SocketException {
      emit(IncomingDocumentsInternetError(
          errorMsg: "Internet Connection Error!"));
    } catch (e) {
      emit(IncomingDocumentsFailed(errorMsg: e.toString()));
    } finally {
      isLoadingMore = false;
    }
  }

  /// Load More Documents
  void loadMoreDocuments() {
    if (state is IncomingDocumentsLoaded && hasMore) {
      fetchIncomingDocuments(loadMore: true);
    }
  }
}
