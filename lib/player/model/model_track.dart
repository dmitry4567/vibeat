import 'package:just_audio/just_audio.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:vibeat/features/favorite/domain/entities/beat.dart';

class TrackAudioSource extends ProgressiveAudioSource {
  final String id;
  final String name;
  final String bitmaker;
  final int price;
  final String photoUrl;
  final String trackUrl;
  final int bpm;
  final String tune;
  List<TimeStamp>? timeStamps;

  TrackAudioSource({
    required this.id,
    required this.name,
    required this.bitmaker,
    required this.price,
    required this.trackUrl,
    required this.photoUrl,
    required this.bpm,
    required this.tune,
    this.timeStamps,
  }) : super(
          Uri.parse(trackUrl),
          tag: MediaItem(
            id: id,
            album: "Album name",
            artist: bitmaker,
            title: name,
            artUri: Uri.parse(photoUrl),
          ),
        );
}