part of 'create_sell_property_cubit.dart';

@immutable
sealed class CreateSellPropertyState {}

final class CreateSellPropertyInitial extends CreateSellPropertyState {}

final class CreateSellPropertyLoading extends CreateSellPropertyState {}

final class CreateSellPropertySuccessfully extends CreateSellPropertyState {}

final class CreateSellPropertyFailed extends CreateSellPropertyState {}

final class CreateSellPropertyInternetError extends CreateSellPropertyState {}

final class CreateSellPropertyLogout extends CreateSellPropertyState {}
