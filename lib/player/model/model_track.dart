import 'package:just_audio/just_audio.dart';
import 'package:just_audio_background/just_audio_background.dart';

class TrackAudioSource extends ProgressiveAudioSource {
  final String id;
  final String name;
  final String bitmaker;
  final int price;
  final String photoUrl;
  final String trackUrl;

  TrackAudioSource({
    required this.id,
    required this.name,
    required this.bitmaker,
    required this.price,
    required this.trackUrl,
    required this.photoUrl,
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
