part of 'document_elements_cubit.dart';

@immutable
sealed class DocumentElementsState {}

final class DocumentElementsInitial extends DocumentElementsState {}

final class DocumentElementLoading extends DocumentElementsState {}

final class DocumentElementLoaded extends DocumentElementsState {
  final List<DocumentElementModel> documentElement;

  DocumentElementLoaded({required this.documentElement});
}

final class DocumentElementFailed extends DocumentElementsState {}

final class DocumentElementInternetError extends DocumentElementsState {}

final class DocumentElementLogout extends DocumentElementsState {}
