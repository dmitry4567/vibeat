part of 'player_bloc.dart';


class PlayerState extends Equatable {
  final bool isPlaying;
  final bool isRepeat;
  final int currentTrackIndex;
  final int currentTime;
  final int endTime;
  final List<Track> trackList;

  const PlayerState({
    required this.isPlaying,
    required this.isRepeat,
    required this.currentTrackIndex,
    required this.currentTime,
    required this.endTime,
    required this.trackList,
  });

  PlayerState copyWith({
    bool? isPlaying,
    bool? isRepeat,
    int? currentTrackIndex,
    int? currentTime,
    int? endTime,
    List<Track>? trackList,
  }) {
    return PlayerState(
      isPlaying: isPlaying ?? this.isPlaying,
      isRepeat: isRepeat ?? this.isRepeat,
      currentTrackIndex: currentTrackIndex ?? this.currentTrackIndex,
      currentTime: currentTime ?? this.currentTime,
      endTime: endTime ?? this.endTime,
      trackList: trackList ?? this.trackList,
    );
  }

  @override
  List<Object?> get props => [
        isPlaying,
        isRepeat,
        currentTrackIndex,
        currentTime,
        endTime,
        trackList,
      ];
}