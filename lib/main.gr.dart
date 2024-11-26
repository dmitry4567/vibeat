// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouterGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:auto_route/auto_route.dart' as _i11;
import 'package:flutter/material.dart' as _i12;
import 'package:vibeat/favorite.dart' as _i3;
import 'package:vibeat/filter.dart' as _i5;
import 'package:vibeat/filter_genre.dart' as _i4;
import 'package:vibeat/home.dart' as _i6;
import 'package:vibeat/main.dart' as _i2;
import 'package:vibeat/player.dart' as _i7;
import 'package:vibeat/profile.dart' as _i8;
import 'package:vibeat/result.dart' as _i9;
import 'package:vibeat/search.dart' as _i10;
import 'package:vibeat/settings.dart' as _i1;

/// generated route for
/// [_i1.CartScreen]
class CartRoute extends _i11.PageRouteInfo<void> {
  const CartRoute({List<_i11.PageRouteInfo>? children})
      : super(
          CartRoute.name,
          initialChildren: children,
        );

  static const String name = 'CartRoute';

  static _i11.PageInfo page = _i11.PageInfo(
    name,
    builder: (data) {
      return const _i1.CartScreen();
    },
  );
}

/// generated route for
/// [_i2.DashboardPage]
class DashboardRoute extends _i11.PageRouteInfo<void> {
  const DashboardRoute({List<_i11.PageRouteInfo>? children})
      : super(
          DashboardRoute.name,
          initialChildren: children,
        );

  static const String name = 'DashboardRoute';

  static _i11.PageInfo page = _i11.PageInfo(
    name,
    builder: (data) {
      return const _i2.DashboardPage();
    },
  );
}

/// generated route for
/// [_i3.FavoriteScreen]
class FavoriteRoute extends _i11.PageRouteInfo<void> {
  const FavoriteRoute({List<_i11.PageRouteInfo>? children})
      : super(
          FavoriteRoute.name,
          initialChildren: children,
        );

  static const String name = 'FavoriteRoute';

  static _i11.PageInfo page = _i11.PageInfo(
    name,
    builder: (data) {
      return const _i3.FavoriteScreen();
    },
  );
}

/// generated route for
/// [_i4.FilterGenreScreen]
class FilterGenreRoute extends _i11.PageRouteInfo<void> {
  const FilterGenreRoute({List<_i11.PageRouteInfo>? children})
      : super(
          FilterGenreRoute.name,
          initialChildren: children,
        );

  static const String name = 'FilterGenreRoute';

  static _i11.PageInfo page = _i11.PageInfo(
    name,
    builder: (data) {
      return const _i4.FilterGenreScreen();
    },
  );
}

/// generated route for
/// [_i5.FilterScreen]
class FilterRoute extends _i11.PageRouteInfo<FilterRouteArgs> {
  FilterRoute({
    _i12.Key? key,
    List<_i11.PageRouteInfo>? children,
  }) : super(
          FilterRoute.name,
          args: FilterRouteArgs(key: key),
          initialChildren: children,
        );

  static const String name = 'FilterRoute';

  static _i11.PageInfo page = _i11.PageInfo(
    name,
    builder: (data) {
      final args =
          data.argsAs<FilterRouteArgs>(orElse: () => const FilterRouteArgs());
      return _i5.FilterScreen(key: args.key);
    },
  );
}

class FilterRouteArgs {
  const FilterRouteArgs({this.key});

  final _i12.Key? key;

  @override
  String toString() {
    return 'FilterRouteArgs{key: $key}';
  }
}

/// generated route for
/// [_i6.HomeScreen]
class HomeRoute extends _i11.PageRouteInfo<void> {
  const HomeRoute({List<_i11.PageRouteInfo>? children})
      : super(
          HomeRoute.name,
          initialChildren: children,
        );

  static const String name = 'HomeRoute';

  static _i11.PageInfo page = _i11.PageInfo(
    name,
    builder: (data) {
      return const _i6.HomeScreen();
    },
  );
}

/// generated route for
/// [_i7.PlayerScreen]
class PlayerRoute extends _i11.PageRouteInfo<void> {
  const PlayerRoute({List<_i11.PageRouteInfo>? children})
      : super(
          PlayerRoute.name,
          initialChildren: children,
        );

  static const String name = 'PlayerRoute';

  static _i11.PageInfo page = _i11.PageInfo(
    name,
    builder: (data) {
      return const _i7.PlayerScreen();
    },
  );
}

/// generated route for
/// [_i8.ProfileScreen]
class ProfileRoute extends _i11.PageRouteInfo<void> {
  const ProfileRoute({List<_i11.PageRouteInfo>? children})
      : super(
          ProfileRoute.name,
          initialChildren: children,
        );

  static const String name = 'ProfileRoute';

  static _i11.PageInfo page = _i11.PageInfo(
    name,
    builder: (data) {
      return const _i8.ProfileScreen();
    },
  );
}

/// generated route for
/// [_i9.ResultScreen]
class ResultRoute extends _i11.PageRouteInfo<void> {
  const ResultRoute({List<_i11.PageRouteInfo>? children})
      : super(
          ResultRoute.name,
          initialChildren: children,
        );

  static const String name = 'ResultRoute';

  static _i11.PageInfo page = _i11.PageInfo(
    name,
    builder: (data) {
      return const _i9.ResultScreen();
    },
  );
}

/// generated route for
/// [_i10.SearchScreen]
class SearchRoute extends _i11.PageRouteInfo<void> {
  const SearchRoute({List<_i11.PageRouteInfo>? children})
      : super(
          SearchRoute.name,
          initialChildren: children,
        );

  static const String name = 'SearchRoute';

  static _i11.PageInfo page = _i11.PageInfo(
    name,
    builder: (data) {
      return const _i10.SearchScreen();
    },
  );
}
