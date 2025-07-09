part of 'property_element_cubit.dart';
@immutable
sealed class PropertyElementState {}

final class PropertyElementInitial extends PropertyElementState {}

final class PropertyElementLoading extends PropertyElementState {}

final class PropertyElementLoaded extends PropertyElementState {
  final List<PropertyElement> propertyElementDataList;

  PropertyElementLoaded({required this.propertyElementDataList});
}

final class PropertyElementFailed extends PropertyElementState {}

final class PropertyElementInternetError
    extends PropertyElementState {}
