// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'beatmaker.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Beatmaker _$BeatmakerFromJson(Map<String, dynamic> json) => _Beatmaker(
      id: json['id'] as String,
      username: json['username'] as String,
      profilepicture: json['profilepicture'] as String,
      metadata: Metadata.fromJson(json['Metadata'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$BeatmakerToJson(_Beatmaker instance) =>
    <String, dynamic>{
      'id': instance.id,
      'username': instance.username,
      'profilepicture': instance.profilepicture,
      'metadata': instance.metadata,
    };

_Metadata _$MetadataFromJson(Map<String, dynamic> json) => _Metadata(
      id: json['id'] as String,
      vkUrl: json['vkUrl'] as String,
      telegramUrl: json['telegramUrl'] as String,
      description: json['description'] as String,
    );

Map<String, dynamic> _$MetadataToJson(_Metadata instance) => <String, dynamic>{
      'id': instance.id,
      'vkUrl': instance.vkUrl,
      'telegramUrl': instance.telegramUrl,
      'description': instance.description,
    };
