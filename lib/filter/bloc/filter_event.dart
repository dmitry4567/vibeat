part of 'filter_bloc.dart';

abstract class FilterEvent extends Equatable {
  const FilterEvent();
}

class ToggleFilter extends FilterEvent {
  final int index;

  const ToggleFilter(this.index);

  @override
  List<Object?> get props => [index];
}

class CleanFilter extends FilterEvent {
  @override
  List<Object?> get props => [];
}