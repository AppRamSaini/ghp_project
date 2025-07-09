part of 'buy_or_rent_property_cubit.dart';

abstract class BuyRentPropertyState {}

class BuyRentPropertyInitial extends BuyRentPropertyState {}

class BuyRentPropertyLoading extends BuyRentPropertyState {}

class BuyRentPropertyLoaded extends BuyRentPropertyState {
  final List<PropertyList> list;
  final int currentPage;
  final bool hasMore;

  BuyRentPropertyLoaded(
      {required this.list, required this.currentPage, required this.hasMore});
}

class BuyRentPropertyFailed extends BuyRentPropertyState {
  final String errorMsg;
  BuyRentPropertyFailed({required this.errorMsg});
}

class BuyRentPropertyError extends BuyRentPropertyState {}

class BuyRentPropertyLogout extends BuyRentPropertyState {}

class BuyRentPropertyLoadingMore extends BuyRentPropertyState {}

class BuyRentPropertyInternetError extends BuyRentPropertyState {
  final String errorMsg;
  BuyRentPropertyInternetError({required this.errorMsg});
}
