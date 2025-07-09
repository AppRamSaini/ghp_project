part of 'service_providers_cubit.dart';

@immutable
sealed class ServiceProvidersState {}

final class ServiceProvidersInitial extends ServiceProvidersState {}

final class ServiceProvidersLoading extends ServiceProvidersState {}

final class ServiceProvidersLoaded extends ServiceProvidersState {
  final List<ServiceProvidersModel> serviceProviders;

  ServiceProvidersLoaded({required this.serviceProviders});
}

final class ServiceProvidersSearchLoaded extends ServiceProvidersState {
  final List<Datum> serviceProviders;

  ServiceProvidersSearchLoaded({required this.serviceProviders});
}

final class ServiceProvidersFailed extends ServiceProvidersState {
  final String errorMsg;
  ServiceProvidersFailed({required this.errorMsg});
}

final class ServiceProvidersInternetError extends ServiceProvidersState {}

final class ServiceProvidersLogout extends ServiceProvidersState {}
