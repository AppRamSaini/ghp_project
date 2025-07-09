part of 'my_bills_cubit.dart';

abstract class MyBillsState {}

class MyBillsInitial extends MyBillsState {}

class MyBillsLoading extends MyBillsState {}

class MyBillsLoaded extends MyBillsState {
  final List<Datum> bills;
  final int currentPage;
  final bool hasMore;
  final int amount; // Add this field
  final int paidAmount; // Add this field

  MyBillsLoaded({
    required this.bills,
    required this.currentPage,
    required this.hasMore,
    required this.amount,
    required this.paidAmount,
  });
}

class MyBillsFailed extends MyBillsState {
  final String errorMsg;
  MyBillsFailed({required this.errorMsg});
}

class MyBillsInternetError extends MyBillsState {}

class MyBillsLogout extends MyBillsState {}
