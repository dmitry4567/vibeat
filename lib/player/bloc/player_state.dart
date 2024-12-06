part of 'player_bloc.dart';

class PlayerState extends Equatable {
  final bool isPlaying;
  final bool isRepeat;
  final bool loopCurrentFragment;
  final int currentTrackIndex;
  final String pathTrack;
  final int currentTime;
  final int endTime;
  final List<int> fragmentsMusic;
  final List<String> fragmentsNames;
  final int indexFragment;
  final List<Track> trackList;
  final List<double> waveformData;
  final double? dragProgress;

  double get progress =>
      dragProgress ?? (endTime > 0 ? currentTime / (endTime * 1000) : 0.0);

  const PlayerState({
    required this.isPlaying,
    required this.isRepeat,
    required this.loopCurrentFragment,
    required this.currentTrackIndex,
    required this.pathTrack,
    required this.currentTime,
    required this.endTime,
    required this.fragmentsMusic,
    required this.fragmentsNames,
    this.indexFragment = 0,
    required this.trackList,
    this.waveformData = const [],
    this.dragProgress,
  });

  factory PlayerState.initial() {
    return const PlayerState(
      isPlaying: false,
      isRepeat: false,
      loopCurrentFragment: false,
      currentTrackIndex: 0,
      pathTrack: "",
      currentTime: 0,
      endTime: 0,
      fragmentsMusic: [0, 3, 10],
      fragmentsNames: ['Verse', 'Chorus', 'ver2'],
      indexFragment: 0,
      trackList: [],
      waveformData: [],
    );
  }

  PlayerState copyWith({
    bool? isPlaying,
    bool? isRepeat,
    bool? loopCurrentFragment,
    int? currentTrackIndex,
    String? pathTrack,
    int? currentTime,
    int? endTime,
    List<int>? fragmentsMusic,
    List<String>? fragmentsNames,
    int? indexFragment,
    List<Track>? trackList,
    List<double>? waveformData,
    double? dragProgress,
  }) {
    return PlayerState(
      isPlaying: isPlaying ?? this.isPlaying,
      isRepeat: isRepeat ?? this.isRepeat,
      loopCurrentFragment: loopCurrentFragment ?? this.loopCurrentFragment,
      currentTrackIndex: currentTrackIndex ?? this.currentTrackIndex,
      pathTrack: pathTrack ?? this.pathTrack,
      currentTime: currentTime ?? this.currentTime,
      endTime: endTime ?? this.endTime,
      fragmentsMusic: fragmentsMusic ?? this.fragmentsMusic,
      fragmentsNames: fragmentsNames ?? this.fragmentsNames,
      indexFragment: indexFragment ?? this.indexFragment,
      trackList: trackList ?? this.trackList,
      waveformData: waveformData ?? this.waveformData,
      dragProgress: dragProgress,
    );
  }

  @override
  List<Object?> get props => [
        isPlaying,
        isRepeat,
        loopCurrentFragment,
        currentTrackIndex,
        pathTrack,
        currentTime,
        endTime,
        fragmentsMusic,
        fragmentsNames,
        indexFragment,
        trackList,
        waveformData,
        dragProgress,
      ];
}
