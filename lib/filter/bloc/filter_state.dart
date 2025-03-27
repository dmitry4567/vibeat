part of 'filter_bloc.dart';

class FilterState extends Equatable {
  final List<FilterItem> filters;

  const FilterState({
    required this.filters,
  });

  factory FilterState.initial() {
    return FilterState(
      filters: [
        FilterItem(
          name: "Жанр",
          iconName: Icons.category,
          pathScreen: 'filter_genre',
        ),
        FilterItem(
          name: "Тэг",
          iconName: Icons.tag,
          pathScreen: 'filter_tag',
        ),
        FilterItem(
          name: "Bpm",
          iconName: Icons.speed,
          pathScreen: 'filter_bpm',
        ),
        FilterItem(
          name: "Тональность",
          iconName: Icons.tune,
          pathScreen: 'filter_key',
        ),
        FilterItem(
          name: "Настроение",
          iconName: Icons.mood,
          pathScreen: 'filter_mood',
        ),
      ],
    );
  }

  FilterState copyWith({
    bool? isPlaying,
  }) {
    return FilterState(
      filters: filters ?? this.filters,
    );
  }

  @override
  List<Object?> get props => [
        filters,
      ];
}
