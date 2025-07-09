part of 'cancel_complaints_cubit.dart';

@immutable
sealed class CancelComplaintsState {}

final class CancelComplaintsInitial extends CancelComplaintsState {}

final class CancelComplaintsLoading extends CancelComplaintsState {}

final class CancelComplaintsSuccessfully extends CancelComplaintsState {}

final class CancelComplaintsFailed extends CancelComplaintsState {}

final class CancelComplaintsInternetError extends CancelComplaintsState {}

final class CancelComplaintsLogout extends CancelComplaintsState {}
