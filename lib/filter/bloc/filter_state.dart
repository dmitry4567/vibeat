part of 'filter_bloc.dart';

class FilterState extends Equatable {
  final List<FilterItem> filters;

  const FilterState({required this.filters});

  factory FilterState.initial() {
    return const FilterState(
      filters: [
        FilterItem(
          name: "Жанр",
          iconName: Icons.category,
          pathScreen: 'filter_genre',
          choose: false,
        ),
        FilterItem(
          name: "Тэг",
          iconName: Icons.tag,
          pathScreen: 'filter_tag',
          choose: false,
        ),
        FilterItem(
          name: "Bpm",
          iconName: Icons.speed,
          pathScreen: 'filter_bpm',
          choose: false,
        ),
        FilterItem(
          name: "Тональность",
          iconName: Icons.tune,
          pathScreen: 'filter_key',
          choose: false,
        ),
        FilterItem(
          name: "Настроение",
          iconName: Icons.mood,
          pathScreen: 'filter_mood',
          choose: false,
        ),
      ],
    );
  }

  FilterState copyWith({List<FilterItem>? filters}) {
    return FilterState(filters: filters ?? this.filters);
  }

  @override
  List<Object?> get props => [filters];
}
