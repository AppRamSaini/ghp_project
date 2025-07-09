part of 'parcel_element_cubit.dart';

@immutable
sealed class ParcelElementsState {}

final class ParcelElementsInitial extends ParcelElementsState {}

final class ParcelElementLoading extends ParcelElementsState {}

final class ParcelElementLoaded extends ParcelElementsState {
  final List<ParcelElementModel> parcelElement;
  ParcelElementLoaded({required this.parcelElement});
}

final class ParcelElementFailed extends ParcelElementsState {}

final class ParcelElementInternetError extends ParcelElementsState {}

final class ParcelElementLogout extends ParcelElementsState {}
