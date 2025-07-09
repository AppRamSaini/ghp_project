part of 'parcel_counts_cubit.dart';

@immutable
sealed class ParcelCountsState {}

final class ParcelCountsInitial extends ParcelCountsState {}

final class ParcelCountsLoading extends ParcelCountsState {}

final class ParcelCountsLoaded extends ParcelCountsState {
  final int count;
  ParcelCountsLoaded({required this.count});
}

final class ParcelCountsFailed extends ParcelCountsState {}

final class ParcelCountsInternetError extends ParcelCountsState {}

final class ParcelCountsLogout extends ParcelCountsState {}
