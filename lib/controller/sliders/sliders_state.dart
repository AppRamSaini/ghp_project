


part of 'sliders_cubit.dart';

abstract class SlidersState {}

class InitialSliders extends SlidersState {}

class SlidersLoading extends SlidersState {}

class SlidersLoaded extends SlidersState {
  final List<SliderList> sliders;

  SlidersLoaded({required this.sliders});
}

class SlidersFailed extends SlidersState {}

class SlidersInternetError extends SlidersState {}
