// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouterGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:auto_route/auto_route.dart' as _i15;
import 'package:flutter/material.dart' as _i16;
import 'package:vibeat/anketa/anketa.dart' as _i1;
import 'package:vibeat/app/bottom_nav_bar.dart' as _i3;
import 'package:vibeat/favorite.dart' as _i4;
import 'package:vibeat/filter.dart' as _i6;
import 'package:vibeat/filter_genre.dart' as _i5;
import 'package:vibeat/home.dart' as _i7;
import 'package:vibeat/info_beat.dart' as _i8;
import 'package:vibeat/info_beatmaker.dart' as _i9;
import 'package:vibeat/player/player_widget.dart' as _i10;
import 'package:vibeat/profile.dart' as _i11;
import 'package:vibeat/result.dart' as _i12;
import 'package:vibeat/search.dart' as _i13;
import 'package:vibeat/settings.dart' as _i2;
import 'package:vibeat/signIn/signIn.dart' as _i14;

/// generated route for
/// [_i1.AnketaScreen]
class AnketaRoute extends _i15.PageRouteInfo<void> {
  const AnketaRoute({List<_i15.PageRouteInfo>? children})
      : super(
          AnketaRoute.name,
          initialChildren: children,
        );

  static const String name = 'AnketaRoute';

  static _i15.PageInfo page = _i15.PageInfo(
    name,
    builder: (data) {
      return const _i1.AnketaScreen();
    },
  );
}

/// generated route for
/// [_i2.CartScreen]
class CartRoute extends _i15.PageRouteInfo<void> {
  const CartRoute({List<_i15.PageRouteInfo>? children})
      : super(
          CartRoute.name,
          initialChildren: children,
        );

  static const String name = 'CartRoute';

  static _i15.PageInfo page = _i15.PageInfo(
    name,
    builder: (data) {
      return const _i2.CartScreen();
    },
  );
}

/// generated route for
/// [_i3.DashboardPage]
class DashboardRoute extends _i15.PageRouteInfo<void> {
  const DashboardRoute({List<_i15.PageRouteInfo>? children})
      : super(
          DashboardRoute.name,
          initialChildren: children,
        );

  static const String name = 'DashboardRoute';

  static _i15.PageInfo page = _i15.PageInfo(
    name,
    builder: (data) {
      return const _i3.DashboardPage();
    },
  );
}

/// generated route for
/// [_i4.FavoriteScreen]
class FavoriteRoute extends _i15.PageRouteInfo<void> {
  const FavoriteRoute({List<_i15.PageRouteInfo>? children})
      : super(
          FavoriteRoute.name,
          initialChildren: children,
        );

  static const String name = 'FavoriteRoute';

  static _i15.PageInfo page = _i15.PageInfo(
    name,
    builder: (data) {
      return const _i4.FavoriteScreen();
    },
  );
}

/// generated route for
/// [_i5.FilterGenreScreen]
class FilterGenreRoute extends _i15.PageRouteInfo<void> {
  const FilterGenreRoute({List<_i15.PageRouteInfo>? children})
      : super(
          FilterGenreRoute.name,
          initialChildren: children,
        );

  static const String name = 'FilterGenreRoute';

  static _i15.PageInfo page = _i15.PageInfo(
    name,
    builder: (data) {
      return const _i5.FilterGenreScreen();
    },
  );
}

/// generated route for
/// [_i6.FilterScreen]
class FilterRoute extends _i15.PageRouteInfo<FilterRouteArgs> {
  FilterRoute({
    _i16.Key? key,
    List<_i15.PageRouteInfo>? children,
  }) : super(
          FilterRoute.name,
          args: FilterRouteArgs(key: key),
          initialChildren: children,
        );

  static const String name = 'FilterRoute';

  static _i15.PageInfo page = _i15.PageInfo(
    name,
    builder: (data) {
      final args =
          data.argsAs<FilterRouteArgs>(orElse: () => const FilterRouteArgs());
      return _i6.FilterScreen(key: args.key);
    },
  );
}

class FilterRouteArgs {
  const FilterRouteArgs({this.key});

  final _i16.Key? key;

  @override
  String toString() {
    return 'FilterRouteArgs{key: $key}';
  }
}

/// generated route for
/// [_i7.HomeScreen]
class HomeRoute extends _i15.PageRouteInfo<void> {
  const HomeRoute({List<_i15.PageRouteInfo>? children})
      : super(
          HomeRoute.name,
          initialChildren: children,
        );

  static const String name = 'HomeRoute';

  static _i15.PageInfo page = _i15.PageInfo(
    name,
    builder: (data) {
      return const _i7.HomeScreen();
    },
  );
}

/// generated route for
/// [_i8.InfoBeat]
class InfoBeat extends _i15.PageRouteInfo<void> {
  const InfoBeat({List<_i15.PageRouteInfo>? children})
      : super(
          InfoBeat.name,
          initialChildren: children,
        );

  static const String name = 'InfoBeat';

  static _i15.PageInfo page = _i15.PageInfo(
    name,
    builder: (data) {
      return const _i8.InfoBeat();
    },
  );
}

/// generated route for
/// [_i9.InfoBeatmaker]
class InfoBeatmaker extends _i15.PageRouteInfo<void> {
  const InfoBeatmaker({List<_i15.PageRouteInfo>? children})
      : super(
          InfoBeatmaker.name,
          initialChildren: children,
        );

  static const String name = 'InfoBeatmaker';

  static _i15.PageInfo page = _i15.PageInfo(
    name,
    builder: (data) {
      return const _i9.InfoBeatmaker();
    },
  );
}

/// generated route for
/// [_i10.PlayerScreen]
class PlayerRoute extends _i15.PageRouteInfo<void> {
  const PlayerRoute({List<_i15.PageRouteInfo>? children})
      : super(
          PlayerRoute.name,
          initialChildren: children,
        );

  static const String name = 'PlayerRoute';

  static _i15.PageInfo page = _i15.PageInfo(
    name,
    builder: (data) {
      return const _i10.PlayerScreen();
    },
  );
}

/// generated route for
/// [_i11.ProfileScreen]
class ProfileRoute extends _i15.PageRouteInfo<void> {
  const ProfileRoute({List<_i15.PageRouteInfo>? children})
      : super(
          ProfileRoute.name,
          initialChildren: children,
        );

  static const String name = 'ProfileRoute';

  static _i15.PageInfo page = _i15.PageInfo(
    name,
    builder: (data) {
      return const _i11.ProfileScreen();
    },
  );
}

/// generated route for
/// [_i12.ResultScreen]
class ResultRoute extends _i15.PageRouteInfo<void> {
  const ResultRoute({List<_i15.PageRouteInfo>? children})
      : super(
          ResultRoute.name,
          initialChildren: children,
        );

  static const String name = 'ResultRoute';

  static _i15.PageInfo page = _i15.PageInfo(
    name,
    builder: (data) {
      return const _i12.ResultScreen();
    },
  );
}

/// generated route for
/// [_i13.SearchScreen]
class SearchRoute extends _i15.PageRouteInfo<void> {
  const SearchRoute({List<_i15.PageRouteInfo>? children})
      : super(
          SearchRoute.name,
          initialChildren: children,
        );

  static const String name = 'SearchRoute';

  static _i15.PageInfo page = _i15.PageInfo(
    name,
    builder: (data) {
      return const _i13.SearchScreen();
    },
  );
}

/// generated route for
/// [_i14.SignInScreen]
class SignInRoute extends _i15.PageRouteInfo<void> {
  const SignInRoute({List<_i15.PageRouteInfo>? children})
      : super(
          SignInRoute.name,
          initialChildren: children,
        );

  static const String name = 'SignInRoute';

  static _i15.PageInfo page = _i15.PageInfo(
    name,
    builder: (data) {
      return const _i14.SignInScreen();
    },
  );
}
