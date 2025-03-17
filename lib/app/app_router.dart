import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:vibeat/app/app_router.gr.dart';

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
              path: 'home',
              page: HomeRoute.page,
            ),
            AutoRoute(
              path: 'search',
              initial: true,
              page: const EmptyShellRoute('search'),
              children: [
                AutoRoute(
                  path: '',
                  page: SearchRoute.page,
                ),
                AutoRoute(
                  path: 'search/filter',
                  page: FilterRoute.page,
                ),
                AutoRoute(
                  path: 'search/filter_genre',
                  page: FilterGenreRoute.page,
                ),
                AutoRoute(
                  path: 'search/result',
                  page: ResultRoute.page,
                ),
              ],
            ),
            AutoRoute(
              path: 'favorite',
              page: FavoriteRoute.page,
            ),
            AutoRoute(
              path: 'cart',
              page: CartRoute.page,
            ),
          ],
        ),
        AutoRoute(
          path: '/signIn',
          page: SignInRoute.page,
        ),
        AutoRoute(
          path: '/profile',
          page: ProfileRoute.page,
        ),
        CustomRoute(
          path: '/player',
          page: PlayerRoute.page,
          customRouteBuilder:
              <T>(BuildContext context, Widget child, AutoRoutePage<T> page) {
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
                    position: tween.animate(curvedAnimation), child: child);
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
    final isAuthenticated = true;

    if (!isAuthenticated) {
      router.push(const SignInRoute());
    } else {
      resolver.next(true);
    }
  }
}
