part of 'scan_visitors_cubit.dart';

@immutable
sealed class ScanVisitorsState {}

final class ScanVisitorsInitial extends ScanVisitorsState {}

final class ScanVisitorsLoading extends ScanVisitorsState {}

final class ScanVisitorsLoaded extends ScanVisitorsState {
  final List<VisitorsDetails> visitorsDetails;

  ScanVisitorsLoaded({required this.visitorsDetails});
}

final class ScanVisitorsFailed extends ScanVisitorsState {
  final String errorMsg;
  ScanVisitorsFailed({required this.errorMsg});
}

final class ScanVisitorsInternetError extends ScanVisitorsState {
  final String errorMsg;
  ScanVisitorsInternetError({required this.errorMsg});
}

final class ScanVisitorsMessage extends ScanVisitorsState {
  final String msg;
  ScanVisitorsMessage({required this.msg});
}

final class CallToFetchListAPI extends ScanVisitorsState {
  final String status;
  CallToFetchListAPI({required this.status});
}

final class ScanVisitorsCheckedIn extends ScanVisitorsState {}

final class ScanVisitorsCheckedOut extends ScanVisitorsState {}
