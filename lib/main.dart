import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:vibeat/main.gr.dart';

void main() {
  runApp(MainApp());
}

class MainApp extends StatelessWidget {
  final _router = AppRouter();

  MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: _router.config(),
    );
  }
}

@AutoRouterConfig()
class AppRouter extends RootStackRouter {
  @override
  List<AutoRoute> get routes => [
        AutoRoute(
          path: '/',
          page: DashboardRoute.page,
          children: [
            AutoRoute(
              path: 'home',
              initial: true,
              page: HomeRoute.page,
            ),
            AutoRoute(
              path: 'search',
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
                final tween = Tween(begin: const Offset(0, 1), end: Offset.zero);
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

@RoutePage()
class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(context) {
    return AutoTabsScaffold(
      routes: const [
        HomeRoute(),
        SearchRoute(),
        FavoriteRoute(),
        CartRoute(),
      ],
      bottomNavigationBuilder: (_, tabsRouter) {
        return BottomNavigationBar(
          iconSize: 32,
          currentIndex: tabsRouter.activeIndex,
          onTap: (index) {
            if (tabsRouter.activeIndex == index) {
              tabsRouter.stackRouterOfIndex(index)?.popUntilRoot();
            } else {
              tabsRouter.setActiveIndex(index);
            }
          },
          type: BottomNavigationBarType.fixed,
          backgroundColor: Colors.black,
          elevation: 0,
          items: [
            BottomNavigationBarItem(
              icon: Icon(
                tabsRouter.activeIndex == 0 ? Icons.home : Icons.home_outlined,
                color: tabsRouter.activeIndex == 0
                    ? Colors.white
                    : const Color(0xff666666),
              ),
              label: '',
            ),
            BottomNavigationBarItem(
              icon: Icon(
                tabsRouter.activeIndex == 0
                    ? Icons.search
                    : Icons.search_outlined,
                color: tabsRouter.activeIndex == 1
                    ? Colors.white
                    : const Color(0xff666666),
              ),
              label: '',
            ),
            BottomNavigationBarItem(
              icon: Icon(
                tabsRouter.activeIndex == 2
                    ? Icons.favorite
                    : Icons.favorite_outline,
                color: tabsRouter.activeIndex == 2
                    ? Colors.white
                    : const Color(0xff666666),
              ),
              label: '',
            ),
            BottomNavigationBarItem(
              icon: Icon(
                tabsRouter.activeIndex == 3
                    ? Icons.shopping_cart
                    : Icons.shopping_cart_outlined,
                color: tabsRouter.activeIndex == 3
                    ? Colors.white
                    : const Color(0xff666666),
              ),
              label: '',
            ),
          ],
        );
      },
    );
  }
}
