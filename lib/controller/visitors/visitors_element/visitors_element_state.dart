part of 'visitors_element_cubit.dart';

@immutable
sealed class VisitorsElementState {}

final class VisitorsElementInitial extends VisitorsElementState {}

final class VisitorsElementLoading extends VisitorsElementState {}

final class VisitorsElementLoaded extends VisitorsElementState {
  final List<VisitorElementModel> visitorsElement;

  VisitorsElementLoaded({required this.visitorsElement});
}

final class VisitorsElementFailed extends VisitorsElementState {}
final class VisitorsElementLogout extends VisitorsElementState {}


final class VisitorsElementInternetError extends VisitorsElementState {}
