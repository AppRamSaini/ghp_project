part of 'update_visitors_status_cubit.dart';

@immutable
sealed class UpdateVisitorsStatusState {}

final class UpdateVisitorsStatusInitial extends UpdateVisitorsStatusState {}

final class UpdateVisitorsStatusLoading extends UpdateVisitorsStatusState {}

final class UpdateVisitorsStatusSuccessfully extends UpdateVisitorsStatusState {
  final String successMsg;
  UpdateVisitorsStatusSuccessfully({required this.successMsg});
}

final class UpdateVisitorsStatusFailed extends UpdateVisitorsStatusState {
  final String errorMsg;
  UpdateVisitorsStatusFailed({required this.errorMsg});
}

final class UpdateVisitorsStatusInternetError
    extends UpdateVisitorsStatusState {}

final class UpdateVisitorsStatusLogout extends UpdateVisitorsStatusState {}
