part of 'ledger_cubit.dart';

@immutable
sealed class LedgerBillState {}

final class LedgerBillInitial extends LedgerBillState {}

final class LedgerBillLoading extends LedgerBillState {}

final class LedgerBillLoaded extends LedgerBillState {
  final ledgerDataList;
  final int currentPage;
  final bool hasMore;

  LedgerBillLoaded(
      {required this.ledgerDataList,
      required this.currentPage,
      required this.hasMore});
}

final class LedgerBillFailed extends LedgerBillState {
  final String errorMsg;

  LedgerBillFailed({required this.errorMsg});
}

final class LedgerBillInternetError extends LedgerBillState {
  final String errorMsg;

  LedgerBillInternetError({required this.errorMsg});
}

final class LedgerBillEmpty extends LedgerBillState {}

final class LedgerBillLogout extends LedgerBillState {}

final class LedgerBillLoadingMore extends LedgerBillState {}

final class LedgerBillTimeout extends LedgerBillState {
  final String errorMsg;

  LedgerBillTimeout({required this.errorMsg});
}
