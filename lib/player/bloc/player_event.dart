part of 'player_bloc.dart';

abstract class PlayerEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class GetRecommendEvent extends PlayerEvent {}

class PlayAudioEvent extends PlayerEvent {}

class PauseAudioEvent extends PlayerEvent {}

class StopAudioEvent extends PlayerEvent {}

class NextTrackEvent extends PlayerEvent {}

class PreviousTrackEvent extends PlayerEvent {}

class NextFragmentEvent extends PlayerEvent {}

class PreviousFragmentEvent extends PlayerEvent {}

class ToggleRepeatEvent extends PlayerEvent {}

class ToggleLoopFragmentEvent extends PlayerEvent {}

class UpdatePositionEvent extends PlayerEvent {
  final Duration position;

  UpdatePositionEvent(this.position);

  @override
  List<Object?> get props => [position];
}

class UpdateCurrentTrackEvent extends PlayerEvent {
  final int index;

  UpdateCurrentTrackEvent(this.index);

  @override
  List<Object?> get props => [index];
}

class UpdateDragProgressEvent extends PlayerEvent {
  final double? progress;

  UpdateDragProgressEvent(this.progress);

  @override
  List<Object?> get props => [progress];
}

class LoadNextTrackEvent extends PlayerEvent {
  final String trackUrl;
  LoadNextTrackEvent(this.trackUrl);

  @override
  List<Object?> get props => [trackUrl];
}

class UpdatePlayerBottomEvent extends PlayerEvent {
  final bool value;
  UpdatePlayerBottomEvent(this.value);
}

///
///
///

class PlayCurrentBeatEvent extends PlayerEvent {
  final List<BeatEntity> beats;
  final int index;

  PlayCurrentBeatEvent(this.beats, this.index);

  @override
  List<Object?> get props => [beats];
}

class NextBeatInPlaylistEvent extends PlayerEvent {
  NextBeatInPlaylistEvent();

  @override
  List<Object?> get props => [];
}
