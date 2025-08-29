part of 'all_beats_of_beatmaker_bloc.dart';

class AllBeatsOfBeatmakerState extends Equatable {
  final List<BeatEntity> beats;
  final bool isLoading;

  const AllBeatsOfBeatmakerState({
    this.beats = const [],
    this.isLoading = false,
  });

  AllBeatsOfBeatmakerState copyWith({
    List<BeatEntity>? beats,
    bool? isLoading,
  }) {
    return AllBeatsOfBeatmakerState(
      beats: beats ?? this.beats,
      isLoading: isLoading ?? this.isLoading,
    );
  }

  @override
  List<Object> get props => [beats, isLoading];
}
