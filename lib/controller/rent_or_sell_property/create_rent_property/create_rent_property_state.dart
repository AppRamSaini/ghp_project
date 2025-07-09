part of 'create_rent_property_cubit.dart';

@immutable
sealed class CreateRentPropertyState {}

final class CreateRentPropertyInitial extends CreateRentPropertyState {}

final class CreateRentPropertyLoading extends CreateRentPropertyState {}

final class CreateRentPropertySuccessfully extends CreateRentPropertyState {}

final class CreateRentPropertyFailed extends CreateRentPropertyState {}

final class CreateRentPropertyInternetError extends CreateRentPropertyState {}

final class CreateRentPropertyLogout extends CreateRentPropertyState {}
