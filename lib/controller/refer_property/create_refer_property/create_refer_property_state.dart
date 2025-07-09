part of 'create_refer_property_cubit.dart';

@immutable
sealed class CreateReferPropertyState {}

final class CreateReferPropertyInitial extends CreateReferPropertyState {}

final class CreateReferPropertyLoading extends CreateReferPropertyState {}

final class CreateReferPropertysuccessfully extends CreateReferPropertyState {}

final class CreateReferPropertyFailed extends CreateReferPropertyState {}

final class CreateReferPropertyInternetError extends CreateReferPropertyState {}

final class CreateReferPropertyLogout extends CreateReferPropertyState {}
