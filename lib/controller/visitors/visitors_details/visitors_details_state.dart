part of 'visitors_details_cubit.dart';

@immutable
sealed class VisitorsDetailsState {}

final class VisitorsDetailsInitial extends VisitorsDetailsState {}

final class VisitorsDetailsLoading extends VisitorsDetailsState {}

final class VisitorsDetailsLoaded extends VisitorsDetailsState {
  final List<VisitorsDetails> visitorDetails;

  VisitorsDetailsLoaded({required this.visitorDetails});
}

final class VisitorsDetailsFailed extends VisitorsDetailsState {
  final String errorMsg;
  VisitorsDetailsFailed({required this.errorMsg});
}

final class VisitorsDetailsInternetError extends VisitorsDetailsState {
  final String errorMsg;
  VisitorsDetailsInternetError({required this.errorMsg});
}

final class VisitorsDetailsMessage extends VisitorsDetailsState {
  final String msg;
  VisitorsDetailsMessage({required this.msg});
}

final class VisitorsDetailsLogout extends VisitorsDetailsState {}
