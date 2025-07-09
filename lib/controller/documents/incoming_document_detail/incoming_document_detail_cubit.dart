// import 'dart:async';
// import 'dart:convert';
// import 'dart:io';
//
// import 'package:bloc/bloc.dart';
// import 'package:http/http.dart';
// import 'package:meta/meta.dart';
// import 'package:township/constants/api_manager.dart';
// import 'package:township/constants/config.dart';
// import 'package:township/model/incoming_document_detail_model.dart';
//
// part 'incoming_document_detail_state.dart';
//
// class IncomingDocumentDetailCubit extends Cubit<IncomingDocumentDetailState> {
//   IncomingDocumentDetailCubit() : super(IncomingDocumentDetailInitial());
//
//   ApiManager apiManager = ApiManager();
//   List<IncomingDocumentDetailModel> incomingList = [];
//
//   incomingDocumentDetail(complaintId) async {
//     emit(IncomingDocumentDetailLoading());
//     try {
//       Response response;
//
//       response = await apiManager.getRequest(
//           "${Config.baseUrl}${Routes.incomingDocumentDetail}?complaintId=$complaintId");
//
//       if (response.statusCode == 200) {
//         var incomingDocumentDetail =
//             IncomingDocumentDetailModel.fromJson(jsonDecode(response.body));
//
//         incomingList = [incomingDocumentDetail];
//
//         emit(IncomingDocumentDetailLoaded(
//             incomingDocumentDetail: [incomingDocumentDetail]));
//       } else if (response.statusCode == 401 || response.statusCode == 403) {
//         emit(IncomingDocumentDetailLogout());
//       } else {
//         emit(IncomingDocumentDetailFailed());
//       }
//     } on SocketException {
//       emit(IncomingDocumentDetailInternetError());
//     } on TimeoutException {
//       emit(IncomingDocumentDetailTimeout());
//     } catch (e) {
//       emit(IncomingDocumentDetailFailed());
//     }
//   }
// }
