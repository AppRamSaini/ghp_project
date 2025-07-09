part of 'service_request_history_cubit.dart';

@immutable
abstract class ServiceRequestHistoryState {}

class ServiceRequestHistoryInitial extends ServiceRequestHistoryState {}

class ServiceRequestHistoryLoading extends ServiceRequestHistoryState {}

class ServiceRequestHistoryLoadingMore extends ServiceRequestHistoryState {}

class ServiceRequestHistoryLoaded extends ServiceRequestHistoryState {
  final List<ServiceHistoryModel> serviceHistory;
  ServiceRequestHistoryLoaded({required this.serviceHistory});
}

class ServiceRequestHistoryEmpty extends ServiceRequestHistoryState {}

class ServiceRequestHistoryFailed extends ServiceRequestHistoryState {
  final String errorMsg;
  ServiceRequestHistoryFailed({required this.errorMsg});
}

class ServiceRequestHistoryInternetError extends ServiceRequestHistoryState {}

class ServiceRequestHistoryTimeout extends ServiceRequestHistoryState {}

class ServiceRequestHistoryLogout extends ServiceRequestHistoryState {}
