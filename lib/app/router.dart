import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:vibeat/player/bloc/player_bloc.dart';
import 'dart:developer' as d;

// class AppRouteObserver2 extends RouteObserver<PageRoute<dynamic>> {
//   @override
//   void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
//     super.didPush(route, previousRoute);
//     d.log('New route pushed: ${route.settings.name}');
//   }

//   @override
//   void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
//     super.didPop(route, previousRoute);
//     d.log('Route popped: ${route.settings.name}');
//   }

//   @override
//   void didReplace({Route<dynamic>? newRoute, Route<dynamic>? oldRoute}) {
//     super.didReplace(newRoute: newRoute, oldRoute: oldRoute);
//     d.log('Route replaced: ${newRoute?.settings.name}');
//   }
// }

class MyAutoRouterObserver extends AutoRouterObserver {
  final PlayerBloc bloc;

  MyAutoRouterObserver(this.bloc);

  @override
  void didInitTabRoute(TabPageRoute route, TabPageRoute? previousRoute) {
    super.didInitTabRoute(route, previousRoute);
    d.log("init " + route.path);
  }

  @override
  void didChangeTabRoute(TabPageRoute route, TabPageRoute previousRoute) {
    super.didChangeTabRoute(route, previousRoute);
    d.log("change " + route.path);

    if (route.path == "search") {
      bloc.add(UpdatePlayerBottomEvent(true));
      return;
    }

    // d.log("didChangeTabRoute  " + route.name.toString());
    // здесь прописать открытие снизу виджета плеера
  }

  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didPush(route, previousRoute);

    d.log("push " + route.settings.name.toString());

    final routeData = (route.settings as AutoRoutePage).routeData;

    if (route.settings.name == "ResultRoute") {
      bloc.add(UpdatePlayerBottomEvent(true));
      return;
    }

    if (route.settings.name == "SearchRoute") {
      return;
    }

    if (route.settings.name == "FilterRoute") {
      bloc.add(UpdatePlayerBottomEvent(false));
      return;
    }

    // if (route.settings.name != "DashboardRoute") {
    //   bloc.add(UpdatePlayerBottomEvent(false));
    //   return;
    // }

    // if (route.settings is AutoRoutePage) {
    //   final routeData = (route.settings as AutoRoutePage).routeData;
    // }
  }

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didPop(route, previousRoute);
    d.log("pop prev " + previousRoute!.settings.name.toString());
    d.log("pop " + route.settings.name.toString());

    final routeData = (route.settings as AutoRoutePage).routeData;

    // if (route.settings.name == "ResultRoute") {
    //   bloc.add(UpdatePlayerBottomEvent(false));
    //   return;
    // }

    if (route.settings.name == "FilterRoute" ||
        route.settings.name == "ProfileRoute") {
      bloc.add(UpdatePlayerBottomEvent(true));
      return;
    }

    if (startsWithLowerCase(route.settings.name.toString()) ||
        route.settings.name == "PlayerRoute") {
      bloc.add(UpdatePlayerBottomEvent(true));
      return;
    }

    if (previousRoute.settings.name == "SearchRoute" ||
        route.settings.name == "PlaylistRoute") {
      bloc.add(UpdatePlayerBottomEvent(true));
      return;
    }
  }
}

bool startsWithLowerCase(String str) {
  if (str.isEmpty) return false;
  String firstChar = str[0];
  return firstChar == firstChar.toLowerCase() &&
      firstChar != firstChar.toUpperCase();
}
