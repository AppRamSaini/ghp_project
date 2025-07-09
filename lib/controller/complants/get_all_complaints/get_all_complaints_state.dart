part of 'get_all_complaints_cubit.dart';

abstract class GetAllComplaintsState {}

class GetAllInitialComplaints extends GetAllComplaintsState {}

class GetAllComplaintsLoading extends GetAllComplaintsState {}

class GetAllComplaintsLoaded extends GetAllComplaintsState {
  final List<ComplaintList> complaints;
  GetAllComplaintsLoaded({required this.complaints});
}

class GetAllComplaintsFailed extends GetAllComplaintsState {
  final String errorMsg;
  GetAllComplaintsFailed({required this.errorMsg});
}

class GetAllComplaintsInternetError extends GetAllComplaintsState {
  final String errorMsg;
  GetAllComplaintsInternetError({required this.errorMsg});
}

class GetAllComplaintsLogout extends GetAllComplaintsState {}

final class IncomingDocumentsLoadingMore extends GetAllComplaintsState {}

final class GetAllComplaintsEmpty extends GetAllComplaintsState {}

class GetAllComplaintsTimeout extends GetAllComplaintsState {
  final String errorMsg;
  GetAllComplaintsTimeout({required this.errorMsg});
}
