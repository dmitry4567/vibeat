import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:vibeat/main.gr.dart';
import 'package:vibeat/player/bloc/player_bloc.dart';
import 'package:vibeat/utils/theme.dart';
import 'package:vibeat/widgets/custom_error.dart';

Future<void> main() async {
  ErrorWidget.builder = (FlutterErrorDetails errorDetails) {
    return CustomError(errorDetails: errorDetails);
  };

  // await JustAudioBackground.init(
  //   androidNotificationChannelId: 'com.ryanheise.bg_demo.channel.audio',
  //   androidNotificationChannelName: 'Audio playback',
  //   androidNotificationOngoing: true,
  // );

  runApp(
    MultiBlocProvider(providers: [
      BlocProvider(
        create: (_) => PlayerBloc(),
      ),
    ], child: const MainApp()),
  );
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  final ThemeMode _themeMode = ThemeMode.system;

  final _router = AppRouter();

  @override
  void initState() {
    super.initState();

    context.read<PlayerBloc>().add(GetRecommendEvent());
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: _router.config(),
      theme: AppTheme.darkTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: _themeMode,
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

@RoutePage()
class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(context) {
    return AutoTabsScaffold(
      backgroundColor: AppColors.background,
      routes: const [
        HomeRoute(),
        SearchRoute(),
        FavoriteRoute(),
        CartRoute(),
      ],
      animationDuration: Duration.zero,
      bottomNavigationBuilder: (_, tabsRouter) {
        return Theme(
          data: ThemeData(
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent,
          ),
          child: BottomNavigationBar(
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
                  tabsRouter.activeIndex == 0
                      ? Icons.home
                      : Icons.home_outlined,
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
          ),
        );
      },
    );
  }
}
