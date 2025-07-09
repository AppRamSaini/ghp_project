part of 'get_complaints_cubit.dart';

abstract class ComplaintsState {}

class InitialComplaints extends ComplaintsState {}

class ComplaintsLoading extends ComplaintsState {}

class ComplaintsLoaded extends ComplaintsState {
  final List<ComplaintCategory> complaints;

  ComplaintsLoaded({required this.complaints});
}

class ComplaintsFailed extends ComplaintsState {
  final String errorMsg;
  ComplaintsFailed({required this.errorMsg});
}

class ComplaintsInternetError extends ComplaintsState {}

class ComplaintsLogout extends ComplaintsState {}
