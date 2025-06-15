part of 'player_bloc.dart';

class PlayerState extends Equatable {
  final bool playerBottom;
  final bool isPlaying;
  final bool isRepeat;
  final bool loopCurrentFragment;
  final int currentTrackIndex;
  final String pathTrack;
  final Duration position;
  final Duration duration;
  final List<List<Color>> colorsOfBackground;
  final List<int> fragmentsMusic;
  final List<String> fragmentsNames;
  final int indexFragment;
  final List<Track> trackList;
  final List<double> waveformData;
  final double? dragProgress;

  double get progress =>
      dragProgress ??
      (duration.inMilliseconds > 0
          ? position.inMilliseconds / duration.inMilliseconds
          : 0.0);

  const PlayerState({
    required this.playerBottom,
    required this.isPlaying,
    required this.isRepeat,
    required this.loopCurrentFragment,
    required this.currentTrackIndex,
    required this.pathTrack,
    required this.position,
    required this.duration,
    this.colorsOfBackground = const [],
    required this.fragmentsMusic,
    required this.fragmentsNames,
    this.indexFragment = 0,
    required this.trackList,
    this.waveformData = const [],
    this.dragProgress,
  });

  factory PlayerState.initial() {
    return const PlayerState(
      playerBottom: true,
      isPlaying: false,
      isRepeat: false,
      loopCurrentFragment: false,
      currentTrackIndex: 0,
      pathTrack: "",
      position: Duration.zero,
      duration: Duration.zero,
      colorsOfBackground: [],
      fragmentsMusic: [0, 3, 10],
      fragmentsNames: ['Verse', 'Chorus', 'ver2'],
      indexFragment: 0,
      trackList: [],
      waveformData: [],
    );
  }

  PlayerState copyWith({
    bool? playerBottom,
    bool? isPlaying,
    bool? isRepeat,
    bool? loopCurrentFragment,
    int? currentTrackIndex,
    String? pathTrack,
    Duration? position,
    Duration? duration,
    List<List<Color>>? colorsOfBackground,
    List<int>? fragmentsMusic,
    List<String>? fragmentsNames,
    int? indexFragment,
    List<Track>? trackList,
    List<double>? waveformData,
    double? dragProgress,
  }) {
    return PlayerState(
      playerBottom: playerBottom ?? this.playerBottom,
      isPlaying: isPlaying ?? this.isPlaying,
      isRepeat: isRepeat ?? this.isRepeat,
      loopCurrentFragment: loopCurrentFragment ?? this.loopCurrentFragment,
      currentTrackIndex: currentTrackIndex ?? this.currentTrackIndex,
      pathTrack: pathTrack ?? this.pathTrack,
      position: position ?? this.position,
      duration: duration ?? this.duration,
      colorsOfBackground: colorsOfBackground ?? this.colorsOfBackground,
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
    playerBottom,
    isPlaying,
    isRepeat,
    loopCurrentFragment,
    currentTrackIndex,
    pathTrack,
    position,
    duration,
    colorsOfBackground,
    fragmentsMusic,
    fragmentsNames,
    indexFragment,
    trackList,
    waveformData,
    dragProgress,
  ];
}
