import 'package:freezed_annotation/freezed_annotation.dart';

part 'beatmaker.freezed.dart';
part 'beatmaker.g.dart';

@freezed
abstract class Beatmaker with _$Beatmaker {
  const factory Beatmaker({
    required String id,
    required String username,
    required String profilepicture,
    required Metadata metadata,
  }) = _Beatmaker;

  factory Beatmaker.fromJson(Map<String, Object?> json) =>
      _$BeatmakerFromJson(json);
}

@freezed
abstract class Metadata with _$Metadata {
  const factory Metadata({
    required String id,
    required String vkUrl,
    required String telegramUrl,
    required String description,
  }) = _Metadata;

  factory Metadata.fromJson(Map<String, Object?> json) =>
      _$MetadataFromJson(json);
}
