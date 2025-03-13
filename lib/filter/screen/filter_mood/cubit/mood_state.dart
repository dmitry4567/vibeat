part of 'mood_cubit.dart';


abstract class MoodState extends Equatable {
  final List<MoodModel> moods;
  final List<MoodModel> selectedMoods;
  final String searchQuery;

  const MoodState({
    required this.moods,
    required this.selectedMoods,
    this.searchQuery = '',
  });

  @override
  List<Object> get props => [moods, selectedMoods, searchQuery];
}

class MoodInitial extends MoodState {
  MoodInitial() : super(moods: [], selectedMoods: []);
}

class MoodLoading extends MoodState {
  MoodLoading() : super(moods: [], selectedMoods: []);
}

class MoodError extends MoodState {
  MoodError() : super(moods: [], selectedMoods: []);
}

class MoodLoaded extends MoodState {
  const MoodLoaded({
    required List<MoodModel> moods,
    required List<MoodModel> selectedMoods,
    String searchQuery = '',
  }) : super(
          moods: moods,
          selectedMoods: selectedMoods,
          searchQuery: searchQuery,
        );
}
