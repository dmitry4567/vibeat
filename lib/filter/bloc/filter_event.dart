part of 'filter_bloc.dart';

abstract class FilterEvent extends Equatable {
  const FilterEvent();
}

class ToggleFilter extends FilterEvent {
  final int index;
  final bool value;

  const ToggleFilter(this.index, this.value);

  @override
  List<Object?> get props => [index, value];
}

class CleanFilter extends FilterEvent {
  @override
  List<Object?> get props => [];
}
