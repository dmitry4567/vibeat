import 'package:vibeat/features/favorite/domain/entities/beat.dart';
import 'package:vibeat/filter/screen/filter_genre/model/genre_model.dart';
import 'package:vibeat/filter/screen/filter_key/model/key_model.dart';
import 'package:vibeat/filter/screen/filter_mood/model/mood_model.dart';
import 'package:vibeat/filter/screen/filter_tag/model/tag_model.dart';

class BeatModel extends Beat {
  const BeatModel({
    required super.id,
    required super.name,
    required super.description,
    required super.picture,
    required super.beatmakerId,
    required super.beatmakerName,
    required super.url,
    required super.price,
    required super.plays,
    required super.genres,
    required super.moods,
    required super.tags,
    required super.key,
    required super.bpm,
    required super.timeStamps,
    required super.createAt,
  });

  const BeatModel.placeholder()
      : this(
          id: "",
          name: "sefsesfseff",
          description: "sefsef",
          picture: "",
          beatmakerId: "",
          beatmakerName: "sefsef",
          url: "",
          price: 0,
          plays: 0,
          genres: const [],
          moods: const [],
          tags: const [],
          key: const KeyModel(
            name: "",
            key: "",
            isSelected: false,
          ),
          bpm: 0,
          timeStamps: const [],
          createAt: 0,
        );

  BeatModel copyWith({
    String? id,
    String? name,
    String? description,
    String? picture,
    String? beatmakerId,
    String? beatmakerName,
    String? url,
    int? price,
    int? plays,
    List<GenreModel>? genres,
    List<MoodModel>? moods,
    List<TagModel>? tags,
    KeyModel? key,
    List<TimeStampModel>? timeStamps,
    int? bpm,
    int? createAt,
  }) {
    return BeatModel(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      picture: picture ?? this.picture,
      beatmakerId: beatmakerId ?? this.beatmakerId,
      beatmakerName: beatmakerName ?? this.beatmakerName,
      url: url ?? this.url,
      price: price ?? this.price,
      plays: plays ?? this.plays,
      genres: genres ?? this.genres,
      moods: moods ?? this.moods,
      tags: tags ?? this.tags,
      key: key ?? this.key,
      bpm: bpm ?? this.bpm,
      timeStamps: timeStamps ?? this.timeStamps,
      createAt: createAt ?? this.createAt,
    );
  }

  factory BeatModel.fromJson(Map<String, dynamic> json) {
    return BeatModel(
      id: json['id'].toString(),
      name: json['name'].toString(),
      description:
          json['description'] != null ? json['description'].toString() : '',
      picture: 'http://${json['picture'].toString()}',
      beatmakerId: json['beatmakerId'].toString(),
      beatmakerName: json['beatmakerName'].toString(),
      url: json['url'].toString(),
      price: int.parse(json['price'].toString()),
      plays: json['plays'] != null ? int.parse(json['plays'].toString()) : 0,
      genres: json['genres'] != null
          ? (json['genres'] as List<dynamic>)
              .map((genre) => GenreModel.fromJson(genre))
              .toList()
          : [],
      moods: json['moods'] != null
          ? (json['moods'] as List<dynamic>)
              .map((mood) => MoodModel.fromJson(mood))
              .toList()
          : [],
      tags: json['tags'] != null
          ? (json['tags'] as List<dynamic>)
              .map((tag) => TagModel.fromJson(tag))
              .toList()
          : [],
      key: json['keynote'] != null
          ? KeyModel.fromJson(json['keynote'])
          : const KeyModel(key: '', name: '', isSelected: false),
      bpm: json['bpm'] != null ? int.parse(json['bpm'].toString()) : 0,
      timeStamps: json['timestamps'] != null
          ? (json['timestamps'] as List<dynamic>)
              .map((timestamp) => TimeStampModel.fromJson(timestamp))
              .toList()
          : [],
      createAt: json['created_at'] != null
          ? int.parse(json['created_at'].toString())
          : 0,
    );
  }
}

class TimeStampModel extends TimeStamp {
  const TimeStampModel({
    required super.id,
    required super.title,
    required super.startTime,
    required super.endTime,
  });

  factory TimeStampModel.fromJson(Map<String, dynamic> json) {
    return TimeStampModel(
      id: json['id'].toString(),
      title: json['title'].toString(),
      startTime: int.parse(json['start_time'].toString()),
      endTime: int.parse(json['end_time'].toString()),
    );
  }
}
