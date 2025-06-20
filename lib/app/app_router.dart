import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:vibeat/app/app_router.gr.dart';
import 'package:vibeat/features/signIn/presentation/bloc/auth_bloc.dart';

@AutoRouterConfig()
class AppRouter extends RootStackRouter {
  @override
  List<AutoRoute> get routes => [
        AutoRoute(
          path: '/',
          page: DashboardRoute.page,
          guards: [AuthGuard()],
          children: [
            AutoRoute(
              path: 'head',
              page: const EmptyShellRoute('head'),
              children: [
                AutoRoute(path: '', page: HeadRoute.page),
                AutoRoute(path: 'head/playlistMood', page: PlaylistMoodRoute.page),
              ],
            ),
            AutoRoute(
              path: 'search',
              page: const EmptyShellRoute('search'),
              children: [
                AutoRoute(path: '', page: SearchRoute.page),
                AutoRoute(path: 'head/playlist', page: PlaylistRoute.page),
                AutoRoute(path: 'search/filter', page: FilterRoute.page),
                AutoRoute(
                    path: 'search/filter_genre', page: FilterGenreRoute.page),
                AutoRoute(path: 'search/filter_tag', page: FilterTagRoute.page),
                AutoRoute(path: 'search/filter_bpm', page: FilterBpmRoute.page),
                AutoRoute(path: 'search/filter_key', page: FilterKeyRoute.page),
                AutoRoute(
                    path: 'search/filter_mood', page: FilterMoodRoute.page),
                AutoRoute(path: 'search/result', page: ResultRoute.page),
              ],
            ),
            AutoRoute(path: 'favorite', page: FavoriteRoute.page),
            AutoRoute(path: 'cart', page: CartRoute.page),
          ],
        ),
        AutoRoute(
          path: '/anketa',
          page: AnketaRoute.page,
        ),
        AutoRoute(
          path: '/signIn',
          initial: true,
          page: SignInRoute.page,
        ),
        AutoRoute(
          path: '/signUp',
          page: SignUpRoute.page,
        ),
        AutoRoute(
          path: '/profile',
          page: ProfileRoute.page,
        ),
        CustomRoute(
          path: '/player',
          page: PlayerRoute.page,
          customRouteBuilder: <T>(
            BuildContext context,
            Widget child,
            AutoRoutePage<T> page,
          ) {
            return PageRouteBuilder<T>(
              fullscreenDialog: page.fullscreenDialog,
              transitionsBuilder:
                  (context, animation, secondaryAnimation, child) {
                const curve = Curves.ease;
                final tween =
                    Tween(begin: const Offset(0, 1), end: Offset.zero);
                final curvedAnimation = CurvedAnimation(
                  parent: animation,
                  curve: curve,
                );

                return SlideTransition(
                  position: tween.animate(curvedAnimation),
                  child: child,
                );
              },
              transitionDuration: const Duration(milliseconds: 400),
              settings: page,
              pageBuilder: (_, __, ___) => child,
            );
          },
        ),
      ];
}

class AuthGuard extends AutoRouteGuard {
  @override
  void onNavigation(NavigationResolver resolver, StackRouter router) {
    final authBloc = GetIt.I<AuthBloc>();

    // Проверяем текущее состояние авторизации
    final currentState = authBloc.state;
    if (currentState is Authenticated) {
      resolver.next(); // Продолжаем навигацию без анимации
    } else {
      authBloc.add(AuthCheckRequested());

      // Подписываемся на изменения состояния
      authBloc.stream
          .firstWhere(
              (state) => state is Authenticated || state is Unauthenticated)
          .then((state) {
        if (state is Authenticated) {
          resolver.next();
        } else {
          router.replace(const SignInRoute());
        }
      });
    }
  }
}
