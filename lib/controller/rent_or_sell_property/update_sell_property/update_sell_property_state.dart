part of 'update_sell_property_cubit.dart';
@immutable
sealed class UpdateSellPropertyState {}

final class UpdateSellPropertyInitial extends UpdateSellPropertyState {}

final class UpdateSellPropertyLoading extends UpdateSellPropertyState {}

final class UpdateSellPropertySuccessfully extends UpdateSellPropertyState {}

final class UpdateSellPropertyFailed extends UpdateSellPropertyState {}

final class UpdateSellPropertyInternetError extends UpdateSellPropertyState {}
