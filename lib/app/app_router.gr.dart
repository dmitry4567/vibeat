// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouterGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:auto_route/auto_route.dart' as _i20;
import 'package:flutter/material.dart' as _i21;
import 'package:vibeat/app/bottom_nav_bar.dart' as _i3;
import 'package:vibeat/favorite.dart' as _i4;
import 'package:vibeat/features/anketa/presentation/pages/anketa.dart' as _i1;
import 'package:vibeat/features/signIn/presentation/pages/signIn.dart' as _i18;
import 'package:vibeat/features/signIn/presentation/pages/signUp.dart' as _i19;
import 'package:vibeat/filter/filter.dart' as _i9;
import 'package:vibeat/filter/result.dart' as _i16;
import 'package:vibeat/filter/screen/filter_bpm/filter_bpm.dart' as _i5;
import 'package:vibeat/filter/screen/filter_genre/filter_genre.dart' as _i6;
import 'package:vibeat/filter/screen/filter_genre/model/genre_model.dart'
    as _i23;
import 'package:vibeat/filter/screen/filter_key/filter_key.dart' as _i7;
import 'package:vibeat/filter/screen/filter_key/model/key_model.dart' as _i25;
import 'package:vibeat/filter/screen/filter_mood/filter_mood.dart' as _i8;
import 'package:vibeat/filter/screen/filter_mood/model/mood_model.dart' as _i22;
import 'package:vibeat/filter/screen/filter_tag/filter_tag.dart' as _i10;
import 'package:vibeat/filter/screen/filter_tag/model/tag_model.dart' as _i24;
import 'package:vibeat/head/head.dart' as _i11;
import 'package:vibeat/player/player_widget.dart' as _i12;
import 'package:vibeat/playlist/playlist_widget.dart' as _i14;
import 'package:vibeat/playlist/playlistMood_widget.dart' as _i13;
import 'package:vibeat/profile.dart' as _i15;
import 'package:vibeat/search.dart' as _i17;
import 'package:vibeat/settings.dart' as _i2;

/// generated route for
/// [_i1.AnketaScreen]
class AnketaRoute extends _i20.PageRouteInfo<void> {
  const AnketaRoute({List<_i20.PageRouteInfo>? children})
      : super(
          AnketaRoute.name,
          initialChildren: children,
        );

  static const String name = 'AnketaRoute';

  static _i20.PageInfo page = _i20.PageInfo(
    name,
    builder: (data) {
      return const _i1.AnketaScreen();
    },
  );
}

/// generated route for
/// [_i2.CartScreen]
class CartRoute extends _i20.PageRouteInfo<void> {
  const CartRoute({List<_i20.PageRouteInfo>? children})
      : super(
          CartRoute.name,
          initialChildren: children,
        );

  static const String name = 'CartRoute';

  static _i20.PageInfo page = _i20.PageInfo(
    name,
    builder: (data) {
      return const _i2.CartScreen();
    },
  );
}

/// generated route for
/// [_i3.DashboardPage]
class DashboardRoute extends _i20.PageRouteInfo<void> {
  const DashboardRoute({List<_i20.PageRouteInfo>? children})
      : super(
          DashboardRoute.name,
          initialChildren: children,
        );

  static const String name = 'DashboardRoute';

  static _i20.PageInfo page = _i20.PageInfo(
    name,
    builder: (data) {
      return const _i3.DashboardPage();
    },
  );
}

/// generated route for
/// [_i4.FavoriteScreen]
class FavoriteRoute extends _i20.PageRouteInfo<void> {
  const FavoriteRoute({List<_i20.PageRouteInfo>? children})
      : super(
          FavoriteRoute.name,
          initialChildren: children,
        );

  static const String name = 'FavoriteRoute';

  static _i20.PageInfo page = _i20.PageInfo(
    name,
    builder: (data) {
      return const _i4.FavoriteScreen();
    },
  );
}

/// generated route for
/// [_i5.FilterBpmScreen]
class FilterBpmRoute extends _i20.PageRouteInfo<void> {
  const FilterBpmRoute({List<_i20.PageRouteInfo>? children})
      : super(
          FilterBpmRoute.name,
          initialChildren: children,
        );

  static const String name = 'FilterBpmRoute';

  static _i20.PageInfo page = _i20.PageInfo(
    name,
    builder: (data) {
      return _i5.FilterBpmScreen();
    },
  );
}

/// generated route for
/// [_i6.FilterGenreScreen]
class FilterGenreRoute extends _i20.PageRouteInfo<void> {
  const FilterGenreRoute({List<_i20.PageRouteInfo>? children})
      : super(
          FilterGenreRoute.name,
          initialChildren: children,
        );

  static const String name = 'FilterGenreRoute';

  static _i20.PageInfo page = _i20.PageInfo(
    name,
    builder: (data) {
      return const _i6.FilterGenreScreen();
    },
  );
}

/// generated route for
/// [_i7.FilterKeyScreen]
class FilterKeyRoute extends _i20.PageRouteInfo<void> {
  const FilterKeyRoute({List<_i20.PageRouteInfo>? children})
      : super(
          FilterKeyRoute.name,
          initialChildren: children,
        );

  static const String name = 'FilterKeyRoute';

  static _i20.PageInfo page = _i20.PageInfo(
    name,
    builder: (data) {
      return const _i7.FilterKeyScreen();
    },
  );
}

/// generated route for
/// [_i8.FilterMoodScreen]
class FilterMoodRoute extends _i20.PageRouteInfo<void> {
  const FilterMoodRoute({List<_i20.PageRouteInfo>? children})
      : super(
          FilterMoodRoute.name,
          initialChildren: children,
        );

  static const String name = 'FilterMoodRoute';

  static _i20.PageInfo page = _i20.PageInfo(
    name,
    builder: (data) {
      return const _i8.FilterMoodScreen();
    },
  );
}

/// generated route for
/// [_i9.FilterScreen]
class FilterRoute extends _i20.PageRouteInfo<void> {
  const FilterRoute({List<_i20.PageRouteInfo>? children})
      : super(
          FilterRoute.name,
          initialChildren: children,
        );

  static const String name = 'FilterRoute';

  static _i20.PageInfo page = _i20.PageInfo(
    name,
    builder: (data) {
      return const _i9.FilterScreen();
    },
  );
}

/// generated route for
/// [_i10.FilterTagScreen]
class FilterTagRoute extends _i20.PageRouteInfo<void> {
  const FilterTagRoute({List<_i20.PageRouteInfo>? children})
      : super(
          FilterTagRoute.name,
          initialChildren: children,
        );

  static const String name = 'FilterTagRoute';

  static _i20.PageInfo page = _i20.PageInfo(
    name,
    builder: (data) {
      return const _i10.FilterTagScreen();
    },
  );
}

/// generated route for
/// [_i11.HeadScreen]
class HeadRoute extends _i20.PageRouteInfo<void> {
  const HeadRoute({List<_i20.PageRouteInfo>? children})
      : super(
          HeadRoute.name,
          initialChildren: children,
        );

  static const String name = 'HeadRoute';

  static _i20.PageInfo page = _i20.PageInfo(
    name,
    builder: (data) {
      return const _i11.HeadScreen();
    },
  );
}

/// generated route for
/// [_i12.PlayerScreen]
class PlayerRoute extends _i20.PageRouteInfo<void> {
  const PlayerRoute({List<_i20.PageRouteInfo>? children})
      : super(
          PlayerRoute.name,
          initialChildren: children,
        );

  static const String name = 'PlayerRoute';

  static _i20.PageInfo page = _i20.PageInfo(
    name,
    builder: (data) {
      return const _i12.PlayerScreen();
    },
  );
}

/// generated route for
/// [_i13.PlaylistMoodScreen]
class PlaylistMoodRoute extends _i20.PageRouteInfo<PlaylistMoodRouteArgs> {
  PlaylistMoodRoute({
    _i21.Key? key,
    required _i22.MoodModel mood,
    List<_i20.PageRouteInfo>? children,
  }) : super(
          PlaylistMoodRoute.name,
          args: PlaylistMoodRouteArgs(
            key: key,
            mood: mood,
          ),
          initialChildren: children,
        );

  static const String name = 'PlaylistMoodRoute';

  static _i20.PageInfo page = _i20.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<PlaylistMoodRouteArgs>();
      return _i13.PlaylistMoodScreen(
        key: args.key,
        mood: args.mood,
      );
    },
  );
}

class PlaylistMoodRouteArgs {
  const PlaylistMoodRouteArgs({
    this.key,
    required this.mood,
  });

  final _i21.Key? key;

  final _i22.MoodModel mood;

  @override
  String toString() {
    return 'PlaylistMoodRouteArgs{key: $key, mood: $mood}';
  }
}

/// generated route for
/// [_i14.PlaylistScreen]
class PlaylistRoute extends _i20.PageRouteInfo<PlaylistRouteArgs> {
  PlaylistRoute({
    _i21.Key? key,
    required String title,
    required List<_i16.BeatEntity> beats,
    List<_i20.PageRouteInfo>? children,
  }) : super(
          PlaylistRoute.name,
          args: PlaylistRouteArgs(
            key: key,
            title: title,
            beats: beats,
          ),
          initialChildren: children,
        );

  static const String name = 'PlaylistRoute';

  static _i20.PageInfo page = _i20.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<PlaylistRouteArgs>();
      return _i14.PlaylistScreen(
        key: args.key,
        title: args.title,
        beats: args.beats,
      );
    },
  );
}

class PlaylistRouteArgs {
  const PlaylistRouteArgs({
    this.key,
    required this.title,
    required this.beats,
  });

  final _i21.Key? key;

  final String title;

  final List<_i16.BeatEntity> beats;

  @override
  String toString() {
    return 'PlaylistRouteArgs{key: $key, title: $title, beats: $beats}';
  }
}

/// generated route for
/// [_i15.ProfileScreen]
class ProfileRoute extends _i20.PageRouteInfo<void> {
  const ProfileRoute({List<_i20.PageRouteInfo>? children})
      : super(
          ProfileRoute.name,
          initialChildren: children,
        );

  static const String name = 'ProfileRoute';

  static _i20.PageInfo page = _i20.PageInfo(
    name,
    builder: (data) {
      return const _i15.ProfileScreen();
    },
  );
}

/// generated route for
/// [_i16.ResultScreen]
class ResultRoute extends _i20.PageRouteInfo<ResultRouteArgs> {
  ResultRoute({
    _i21.Key? key,
    List<_i23.GenreModel>? genres,
    List<_i24.TagModel>? tags,
    List<_i25.KeyModel>? keys,
    List<_i22.MoodModel>? moods,
    int? bpmFrom,
    int? bpmTo,
    List<_i20.PageRouteInfo>? children,
  }) : super(
          ResultRoute.name,
          args: ResultRouteArgs(
            key: key,
            genres: genres,
            tags: tags,
            keys: keys,
            moods: moods,
            bpmFrom: bpmFrom,
            bpmTo: bpmTo,
          ),
          initialChildren: children,
        );

  static const String name = 'ResultRoute';

  static _i20.PageInfo page = _i20.PageInfo(
    name,
    builder: (data) {
      final args =
          data.argsAs<ResultRouteArgs>(orElse: () => const ResultRouteArgs());
      return _i16.ResultScreen(
        key: args.key,
        genres: args.genres,
        tags: args.tags,
        keys: args.keys,
        moods: args.moods,
        bpmFrom: args.bpmFrom,
        bpmTo: args.bpmTo,
      );
    },
  );
}

class ResultRouteArgs {
  const ResultRouteArgs({
    this.key,
    this.genres,
    this.tags,
    this.keys,
    this.moods,
    this.bpmFrom,
    this.bpmTo,
  });

  final _i21.Key? key;

  final List<_i23.GenreModel>? genres;

  final List<_i24.TagModel>? tags;

  final List<_i25.KeyModel>? keys;

  final List<_i22.MoodModel>? moods;

  final int? bpmFrom;

  final int? bpmTo;

  @override
  String toString() {
    return 'ResultRouteArgs{key: $key, genres: $genres, tags: $tags, keys: $keys, moods: $moods, bpmFrom: $bpmFrom, bpmTo: $bpmTo}';
  }
}

/// generated route for
/// [_i17.SearchScreen]
class SearchRoute extends _i20.PageRouteInfo<void> {
  const SearchRoute({List<_i20.PageRouteInfo>? children})
      : super(
          SearchRoute.name,
          initialChildren: children,
        );

  static const String name = 'SearchRoute';

  static _i20.PageInfo page = _i20.PageInfo(
    name,
    builder: (data) {
      return const _i17.SearchScreen();
    },
  );
}

/// generated route for
/// [_i18.SignInScreen]
class SignInRoute extends _i20.PageRouteInfo<void> {
  const SignInRoute({List<_i20.PageRouteInfo>? children})
      : super(
          SignInRoute.name,
          initialChildren: children,
        );

  static const String name = 'SignInRoute';

  static _i20.PageInfo page = _i20.PageInfo(
    name,
    builder: (data) {
      return const _i18.SignInScreen();
    },
  );
}

/// generated route for
/// [_i19.SignUpScreen]
class SignUpRoute extends _i20.PageRouteInfo<void> {
  const SignUpRoute({List<_i20.PageRouteInfo>? children})
      : super(
          SignUpRoute.name,
          initialChildren: children,
        );

  static const String name = 'SignUpRoute';

  static _i20.PageInfo page = _i20.PageInfo(
    name,
    builder: (data) {
      return const _i19.SignUpScreen();
    },
  );
}
