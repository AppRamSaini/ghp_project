part of 'service_categories_cubit.dart';

@immutable
sealed class ServiceCategoriesState {}

final class ServiceCategoriesInitial extends ServiceCategoriesState {}

final class ServiceCategoriesLoading extends ServiceCategoriesState {}

final class ServiceCategoriesLoaded extends ServiceCategoriesState {
  final List<ServiceCategoriesModel> serviceCategories;

  ServiceCategoriesLoaded({required this.serviceCategories});
}

final class ServiceCategoriesSearchLoaded extends ServiceCategoriesState {
  final List<ServiceCategory> serviceCategories;

  ServiceCategoriesSearchLoaded({required this.serviceCategories});
}

final class ServiceCategoriesFailed extends ServiceCategoriesState {
  final String errorMsg;
  ServiceCategoriesFailed({required this.errorMsg});
}

final class ServiceCategoriesInternetError extends ServiceCategoriesState {}

final class ServiceCategoriesLogout extends ServiceCategoriesState {}
