part of 'staff_side_checkouts_history_cubit.dart';

@immutable
sealed class StaffSideResidentCheckoutsHistoryState {}

final class StaffSideResidentCheckoutsHistoryInitial
    extends StaffSideResidentCheckoutsHistoryState {}

final class StaffSideResidentCheckoutsHistoryLoading
    extends StaffSideResidentCheckoutsHistoryState {}

final class StaffSideResidentCheckoutsHistoryLoaded
    extends StaffSideResidentCheckoutsHistoryState {
  final List<ResidentCheckoutsHistoryList> residentCheckoutsHistoryList;
  StaffSideResidentCheckoutsHistoryLoaded(
      {required this.residentCheckoutsHistoryList});
}

final class StaffSideResidentCheckoutsHistorySearchLoaded
    extends StaffSideResidentCheckoutsHistoryState {
  final List<ResidentCheckoutsHistoryList> residentCheckoutsHistoryList;
  StaffSideResidentCheckoutsHistorySearchLoaded(
      {required this.residentCheckoutsHistoryList});
}

final class StaffSideResidentCheckoutsHistoryError
    extends StaffSideResidentCheckoutsHistoryState {
  final String errorMsg;
  StaffSideResidentCheckoutsHistoryError({required this.errorMsg});
}

final class StaffSideResidentCheckoutsHistoryLoadingMore
    extends StaffSideResidentCheckoutsHistoryState {}
