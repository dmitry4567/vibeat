part of 'player_bloc.dart';

class PlayerStateApp extends Equatable {
  final bool isInitialized;
  final bool playerBottom;
  final bool isPlaying;
  final bool isPause;
  final bool isRepeat;
  final bool isEnd;
  final bool isLiked;
  final bool loopCurrentFragment;
  final int currentTrackIndex;
  final String currentTrackBeatId;
  final String pathTrack;
  final Duration position;
  final Duration duration;
  final Color colorsOfBackground;
  final bool isTimeStamps;
  final List<int> fragmentsMusic;
  final List<String> fragmentsNames;
  final int indexFragment;
  final List<TrackAudioSource> trackList;
  final List<double> waveformData;
  final double? dragProgress;

  double get progress =>
      dragProgress ??
      (duration.inMilliseconds > 0
          ? position.inMilliseconds / duration.inMilliseconds
          : 0.0);

  const PlayerStateApp({
    required this.isInitialized,
    required this.playerBottom,
    required this.isPlaying,
    required this.isPause,
    required this.isRepeat,
    required this.isEnd,
    this.isLiked = false,
    required this.loopCurrentFragment,
    required this.currentTrackIndex,
    required this.currentTrackBeatId,
    required this.pathTrack,
    required this.position,
    required this.duration,
    required this.colorsOfBackground,
    required this.isTimeStamps,
    required this.fragmentsMusic,
    required this.fragmentsNames,
    this.indexFragment = 0,
    required this.trackList,
    this.waveformData = const [],
    this.dragProgress,
  });

  factory PlayerStateApp.initial() {
    return const PlayerStateApp(
      isInitialized: false,
      playerBottom: true,
      isPlaying: false,
      isPause: false,
      isRepeat: false,
      isEnd: false,
      isLiked: false,
      loopCurrentFragment: false,
      currentTrackIndex: 0,
      currentTrackBeatId: "",
      pathTrack: "",
      position: Duration.zero,
      duration: Duration.zero,
      colorsOfBackground: Colors.grey,
      isTimeStamps: false,
      fragmentsMusic: [0, 30, 60, 120],
      fragmentsNames: ['Verse', 'Chorus', 'Bridge', 'Verse'],
      indexFragment: 0,
      trackList: [],
      waveformData: [],
    );
  }

  PlayerStateApp copyWith({
    bool? isInitialized,
    bool? playerBottom,
    bool? isPlaying,
    bool? isPause,
    bool? isRepeat,
    bool? isEnd,
    bool? isLiked,
    bool? loopCurrentFragment,
    int? currentTrackIndex,
    String? currentTrackBeatId,
    String? pathTrack,
    Duration? position,
    Duration? duration,
    bool? isTimeStamps,
    Color? colorsOfBackground,
    List<int>? fragmentsMusic,
    List<String>? fragmentsNames,
    int? indexFragment,
    List<TrackAudioSource>? trackList,
    List<double>? waveformData,
    double? dragProgress,
  }) {
    return PlayerStateApp(
      isInitialized: isInitialized ?? this.isInitialized,
      playerBottom: playerBottom ?? this.playerBottom,
      isPlaying: isPlaying ?? this.isPlaying,
      isPause: isPause ?? this.isPause,
      isRepeat: isRepeat ?? this.isRepeat,
      isEnd: isEnd ?? this.isEnd,
      isLiked: isLiked ?? this.isLiked,
      loopCurrentFragment: loopCurrentFragment ?? this.loopCurrentFragment,
      currentTrackIndex: currentTrackIndex ?? this.currentTrackIndex,
      currentTrackBeatId: currentTrackBeatId ?? this.currentTrackBeatId,
      pathTrack: pathTrack ?? this.pathTrack,
      position: position ?? this.position,
      duration: duration ?? this.duration,
      colorsOfBackground: colorsOfBackground ?? this.colorsOfBackground,
      isTimeStamps: isTimeStamps ?? this.isTimeStamps,
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
        isInitialized,
        playerBottom,
        isPlaying,
        isRepeat,
        isPause,
        isEnd,
        isLiked,
        loopCurrentFragment,
        currentTrackIndex,
        currentTrackBeatId,
        pathTrack,
        position,
        duration,
        colorsOfBackground,
        isTimeStamps,
        fragmentsMusic,
        fragmentsNames,
        indexFragment,
        trackList,
        waveformData,
        dragProgress,
      ];
}