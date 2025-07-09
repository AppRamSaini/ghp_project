part of 'service_request_cubit.dart';

@immutable
sealed class ServiceRequestState {}

final class ServiceRequestInitial extends ServiceRequestState {}

final class ServiceRequestsLoading extends ServiceRequestState {}

final class ServiceRequestsLoaded extends ServiceRequestState {
  final List<ServiceRequestModel> serviceHistory;
  ServiceRequestsLoaded({required this.serviceHistory});
}

final class ServiceRequestsFailed extends ServiceRequestState {}

final class ServiceRequestsInternetError extends ServiceRequestState {}

final class ServiceRequestsTimeout extends ServiceRequestState {}

final class ServiceRequestsLogout extends ServiceRequestState {}
