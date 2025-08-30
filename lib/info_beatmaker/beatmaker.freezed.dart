// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'beatmaker.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Beatmaker {
  String get id;
  String get username;
  String get profilepicture;
  Metadata get metadata;

  /// Create a copy of Beatmaker
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $BeatmakerCopyWith<Beatmaker> get copyWith =>
      _$BeatmakerCopyWithImpl<Beatmaker>(this as Beatmaker, _$identity);

  /// Serializes this Beatmaker to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is Beatmaker &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.username, username) ||
                other.username == username) &&
            (identical(other.profilepicture, profilepicture) ||
                other.profilepicture == profilepicture) &&
            (identical(other.metadata, metadata) ||
                other.metadata == metadata));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, id, username, profilepicture, metadata);

  @override
  String toString() {
    return 'Beatmaker(id: $id, username: $username, profilepicture: $profilepicture, metadata: $metadata)';
  }
}

/// @nodoc
abstract mixin class $BeatmakerCopyWith<$Res> {
  factory $BeatmakerCopyWith(Beatmaker value, $Res Function(Beatmaker) _then) =
      _$BeatmakerCopyWithImpl;
  @useResult
  $Res call(
      {String id, String username, String profilepicture, Metadata metadata});

  $MetadataCopyWith<$Res> get metadata;
}

/// @nodoc
class _$BeatmakerCopyWithImpl<$Res> implements $BeatmakerCopyWith<$Res> {
  _$BeatmakerCopyWithImpl(this._self, this._then);

  final Beatmaker _self;
  final $Res Function(Beatmaker) _then;

  /// Create a copy of Beatmaker
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? username = null,
    Object? profilepicture = null,
    Object? metadata = null,
  }) {
    return _then(_self.copyWith(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      username: null == username
          ? _self.username
          : username // ignore: cast_nullable_to_non_nullable
              as String,
      profilepicture: null == profilepicture
          ? _self.profilepicture
          : profilepicture // ignore: cast_nullable_to_non_nullable
              as String,
      metadata: null == metadata
          ? _self.metadata
          : metadata // ignore: cast_nullable_to_non_nullable
              as Metadata,
    ));
  }

  /// Create a copy of Beatmaker
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $MetadataCopyWith<$Res> get metadata {
    return $MetadataCopyWith<$Res>(_self.metadata, (value) {
      return _then(_self.copyWith(metadata: value));
    });
  }
}

/// @nodoc
@JsonSerializable()
class _Beatmaker implements Beatmaker {
  const _Beatmaker(
      {required this.id,
      required this.username,
      required this.profilepicture,
      required this.metadata});
  factory _Beatmaker.fromJson(Map<String, dynamic> json) =>
      _$BeatmakerFromJson(json);

  @override
  final String id;
  @override
  final String username;
  @override
  final String profilepicture;
  @override
  final Metadata metadata;

  /// Create a copy of Beatmaker
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$BeatmakerCopyWith<_Beatmaker> get copyWith =>
      __$BeatmakerCopyWithImpl<_Beatmaker>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$BeatmakerToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _Beatmaker &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.username, username) ||
                other.username == username) &&
            (identical(other.profilepicture, profilepicture) ||
                other.profilepicture == profilepicture) &&
            (identical(other.metadata, metadata) ||
                other.metadata == metadata));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, id, username, profilepicture, metadata);

  @override
  String toString() {
    return 'Beatmaker(id: $id, username: $username, profilepicture: $profilepicture, metadata: $metadata)';
  }
}

/// @nodoc
abstract mixin class _$BeatmakerCopyWith<$Res>
    implements $BeatmakerCopyWith<$Res> {
  factory _$BeatmakerCopyWith(
          _Beatmaker value, $Res Function(_Beatmaker) _then) =
      __$BeatmakerCopyWithImpl;
  @override
  @useResult
  $Res call(
      {String id, String username, String profilepicture, Metadata metadata});

  @override
  $MetadataCopyWith<$Res> get metadata;
}

/// @nodoc
class __$BeatmakerCopyWithImpl<$Res> implements _$BeatmakerCopyWith<$Res> {
  __$BeatmakerCopyWithImpl(this._self, this._then);

  final _Beatmaker _self;
  final $Res Function(_Beatmaker) _then;

  /// Create a copy of Beatmaker
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? id = null,
    Object? username = null,
    Object? profilepicture = null,
    Object? metadata = null,
  }) {
    return _then(_Beatmaker(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      username: null == username
          ? _self.username
          : username // ignore: cast_nullable_to_non_nullable
              as String,
      profilepicture: null == profilepicture
          ? _self.profilepicture
          : profilepicture // ignore: cast_nullable_to_non_nullable
              as String,
      metadata: null == metadata
          ? _self.metadata
          : metadata // ignore: cast_nullable_to_non_nullable
              as Metadata,
    ));
  }

  /// Create a copy of Beatmaker
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $MetadataCopyWith<$Res> get metadata {
    return $MetadataCopyWith<$Res>(_self.metadata, (value) {
      return _then(_self.copyWith(metadata: value));
    });
  }
}

/// @nodoc
mixin _$Metadata {
  String get id;
  String get vkUrl;
  String get telegramUrl;
  String get description;

  /// Create a copy of Metadata
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $MetadataCopyWith<Metadata> get copyWith =>
      _$MetadataCopyWithImpl<Metadata>(this as Metadata, _$identity);

  /// Serializes this Metadata to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is Metadata &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.vkUrl, vkUrl) || other.vkUrl == vkUrl) &&
            (identical(other.telegramUrl, telegramUrl) ||
                other.telegramUrl == telegramUrl) &&
            (identical(other.description, description) ||
                other.description == description));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, id, vkUrl, telegramUrl, description);

  @override
  String toString() {
    return 'Metadata(id: $id, vkUrl: $vkUrl, telegramUrl: $telegramUrl, description: $description)';
  }
}

/// @nodoc
abstract mixin class $MetadataCopyWith<$Res> {
  factory $MetadataCopyWith(Metadata value, $Res Function(Metadata) _then) =
      _$MetadataCopyWithImpl;
  @useResult
  $Res call({String id, String vkUrl, String telegramUrl, String description});
}

/// @nodoc
class _$MetadataCopyWithImpl<$Res> implements $MetadataCopyWith<$Res> {
  _$MetadataCopyWithImpl(this._self, this._then);

  final Metadata _self;
  final $Res Function(Metadata) _then;

  /// Create a copy of Metadata
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? vkUrl = null,
    Object? telegramUrl = null,
    Object? description = null,
  }) {
    return _then(_self.copyWith(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      vkUrl: null == vkUrl
          ? _self.vkUrl
          : vkUrl // ignore: cast_nullable_to_non_nullable
              as String,
      telegramUrl: null == telegramUrl
          ? _self.telegramUrl
          : telegramUrl // ignore: cast_nullable_to_non_nullable
              as String,
      description: null == description
          ? _self.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _Metadata implements Metadata {
  const _Metadata(
      {required this.id,
      required this.vkUrl,
      required this.telegramUrl,
      required this.description});
  factory _Metadata.fromJson(Map<String, dynamic> json) =>
      _$MetadataFromJson(json);

  @override
  final String id;
  @override
  final String vkUrl;
  @override
  final String telegramUrl;
  @override
  final String description;

  /// Create a copy of Metadata
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$MetadataCopyWith<_Metadata> get copyWith =>
      __$MetadataCopyWithImpl<_Metadata>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$MetadataToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _Metadata &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.vkUrl, vkUrl) || other.vkUrl == vkUrl) &&
            (identical(other.telegramUrl, telegramUrl) ||
                other.telegramUrl == telegramUrl) &&
            (identical(other.description, description) ||
                other.description == description));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, id, vkUrl, telegramUrl, description);

  @override
  String toString() {
    return 'Metadata(id: $id, vkUrl: $vkUrl, telegramUrl: $telegramUrl, description: $description)';
  }
}

/// @nodoc
abstract mixin class _$MetadataCopyWith<$Res>
    implements $MetadataCopyWith<$Res> {
  factory _$MetadataCopyWith(_Metadata value, $Res Function(_Metadata) _then) =
      __$MetadataCopyWithImpl;
  @override
  @useResult
  $Res call({String id, String vkUrl, String telegramUrl, String description});
}

/// @nodoc
class __$MetadataCopyWithImpl<$Res> implements _$MetadataCopyWith<$Res> {
  __$MetadataCopyWithImpl(this._self, this._then);

  final _Metadata _self;
  final $Res Function(_Metadata) _then;

  /// Create a copy of Metadata
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? id = null,
    Object? vkUrl = null,
    Object? telegramUrl = null,
    Object? description = null,
  }) {
    return _then(_Metadata(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      vkUrl: null == vkUrl
          ? _self.vkUrl
          : vkUrl // ignore: cast_nullable_to_non_nullable
              as String,
      telegramUrl: null == telegramUrl
          ? _self.telegramUrl
          : telegramUrl // ignore: cast_nullable_to_non_nullable
              as String,
      description: null == description
          ? _self.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

// dart format on
