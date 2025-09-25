part of 'property_listing_cubit.dart';

@immutable
sealed class PropertyListingState {}

final class PropertyListingInitial extends PropertyListingState {}

final class PropertyListingLoading extends PropertyListingState {}

final class PropertyListingLoaded extends PropertyListingState {
  final PropertyListingModel propertyList;

  PropertyListingLoaded({required this.propertyList});
}

final class PropertyListingSearchLoaded extends PropertyListingState {
  final List<PropertyList> propertyList;

  PropertyListingSearchLoaded({required this.propertyList});
}

final class PropertyListingError extends PropertyListingState {
  final String errorMsg;

  PropertyListingError({required this.errorMsg});
}

final class PropertyListingLoadingMore extends PropertyListingState {}

final class UnAuthenticatedUser extends PropertyListingState {}
