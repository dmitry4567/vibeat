part of 'all_beats_of_beatmaker_bloc.dart';

abstract class AllBeatsOfBeatmakerEvent {}

class GetBeats extends AllBeatsOfBeatmakerEvent {
  final String beatmakerId;

  GetBeats(this.beatmakerId);
}