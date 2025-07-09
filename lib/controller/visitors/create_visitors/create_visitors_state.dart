part of 'create_visitors_cubit.dart';

@immutable
sealed class CreateVisitorsState {}

final class CreateVisitorsInitial extends CreateVisitorsState {}

final class CreateVisitorsLoading extends CreateVisitorsState {}

final class CreateVisitorsSuccessfully extends CreateVisitorsState {
  final String visitorsId;
  final String visitorsClassificationTypes;

  CreateVisitorsSuccessfully(
      {required this.visitorsId, required this.visitorsClassificationTypes});
}

final class CreateVisitorsFailed extends CreateVisitorsState {
  final String errorMsg;
  CreateVisitorsFailed({required this.errorMsg});
}

final class CreateVisitorsInternetError extends CreateVisitorsState {}

final class CreateVisitorsLogut extends CreateVisitorsState {}
