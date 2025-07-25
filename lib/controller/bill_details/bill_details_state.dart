part of 'bill_details_cubit.dart';

abstract class BillsDetailsState {}

class InitialBillDetails extends BillsDetailsState {}

class BillDetailsLoading extends BillsDetailsState {}

class BillDetailsLoaded extends BillsDetailsState {
  final List<Bill> bills;

  BillDetailsLoaded({required this.bills});
}

class BillDetailsFailed extends BillsDetailsState {}

class BillDetailsInternetError extends BillsDetailsState {}
