part of 'update_rent_property_cubit.dart';

@immutable
sealed class UpdateRentPropertyState {}

final class UpdateRentPropertyInitial extends UpdateRentPropertyState {}

final class UpdateRentPropertyLoading extends UpdateRentPropertyState {}

final class UpdateRentPropertySuccessfully extends UpdateRentPropertyState {}

final class UpdateRentPropertyFailed extends UpdateRentPropertyState {}

final class UpdateRentPropertyInternetError extends UpdateRentPropertyState {}
