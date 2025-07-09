part of 'sos_element_cubit.dart';

@immutable
sealed class SosElementState {}

final class SosElementInitial extends SosElementState {}

final class SosElementLoading extends SosElementState {}

final class SosElementLoaded extends SosElementState {
  final List<SosElementModel> sosElement;

  SosElementLoaded({required this.sosElement});
}

final class SosElementFailed extends SosElementState {}

final class SosElementInternetError extends SosElementState {}

final class SosElementLogout extends SosElementState {}
