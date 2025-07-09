part of 'resident_checkouts_details_cubit.dart';

@immutable
sealed class ResidentCheckoutsHistoryDetailsState {}

final class ResidentCheckoutsHistoryDetailsInitial
    extends ResidentCheckoutsHistoryDetailsState {}

final class ResidentCheckoutsHistoryDetailsLoading
    extends ResidentCheckoutsHistoryDetailsState {}

final class ResidentCheckoutsHistoryDetailsLoaded
    extends ResidentCheckoutsHistoryDetailsState {
  final ResidentCheckoutsHistoryDetailsModal
      residentCheckoutsHistoryDetailsModal;

  ResidentCheckoutsHistoryDetailsLoaded(
      {required this.residentCheckoutsHistoryDetailsModal});
}

final class ResidentCheckoutsHistoryDetailsError
    extends ResidentCheckoutsHistoryDetailsState {
  final String errorMsg;
  ResidentCheckoutsHistoryDetailsError({required this.errorMsg});
}
