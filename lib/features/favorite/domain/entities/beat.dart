import 'package:equatable/equatable.dart';
import 'package:vibeat/filter/screen/filter_genre/model/genre_model.dart';
import 'package:vibeat/filter/screen/filter_key/model/key_model.dart';
import 'package:vibeat/filter/screen/filter_mood/model/mood_model.dart';
import 'package:vibeat/filter/screen/filter_tag/model/tag_model.dart';

class Beat extends Equatable {
  const Beat({
    required this.id,
    required this.name,
    required this.description,
    required this.picture,
    required this.beatmakerId,
    required this.beatmakerName,
    required this.url,
    required this.price,
    required this.plays,
    required this.genres,
    required this.moods,
    required this.tags,
    required this.key,
    required this.bpm,
    required this.timeStamps,
    required this.createAt,
  });

  const Beat.empty()
      : this(
          id: '0',
          name: '',
          description: '',
          picture: '',
          beatmakerId: '',
          beatmakerName: '',
          url: '',
          price: 0,
          plays: 0,
          genres: const [],
          moods: const [],
          tags: const [],
          key: const KeyModel(
            isSelected: false,
            key: "",
            name: "",
          ),
          bpm: 0,
          timeStamps: const [],
          createAt: 0,
        );

  final String id;
  final String name;
  final String description;
  final String picture;
  final String beatmakerId;
  final String beatmakerName;
  final String url;
  final int price;
  final int plays;
  final List<GenreModel> genres;
  final List<MoodModel> moods;
  final List<TagModel> tags;
  final KeyModel key;
  final int bpm;
  final List<TimeStamp> timeStamps;
  final int createAt;

  @override
  List<Object?> get props => [
        id,
        name,
        description,
        picture,
        beatmakerId,
        beatmakerName,
        url,
        price,
        plays,
        genres,
        moods,
        tags,
        key,
        bpm,
        timeStamps,
        createAt,
      ];
}

class TimeStamp extends Equatable {
  final String id;
  final String title;
  final int startTime;
  final int endTime;

  const TimeStamp({
    required this.id,
    required this.title,
    required this.startTime,
    required this.endTime,
  });

  @override
  List<Object?> get props => [
        id,
        title,
        startTime,
        endTime,
      ];
}
