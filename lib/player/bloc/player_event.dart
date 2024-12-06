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

class UpdateCurrentTime extends PlayerEvent {
  final int currentTime;

  UpdateCurrentTime(this.currentTime);

  @override
  List<Object?> get props => [currentTime];
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
