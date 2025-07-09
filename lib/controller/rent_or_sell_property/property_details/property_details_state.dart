part of 'property_details_cubit.dart';

abstract class PropertyDetailsState {}

class PropertyDetailsInitial extends PropertyDetailsState {}

class PropertyDetailsLoading extends PropertyDetailsState {}

class PropertyDetailsLoaded extends PropertyDetailsState {
  final List<Property> detailsList;
  PropertyDetailsLoaded({
    required this.detailsList,
  });
}

class PropertyDetailsFailed extends PropertyDetailsState {
  final String errorMdg;
  PropertyDetailsFailed({required this.errorMdg});
}

class PropertyDetailsInternetError extends PropertyDetailsState {
  final String errorMdg;
  PropertyDetailsInternetError({required this.errorMdg});
}
