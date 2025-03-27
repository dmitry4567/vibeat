import 'package:auto_route/auto_route.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vibeat/app/app_router.gr.dart';
import 'package:vibeat/player/bloc/player_bloc.dart';
import 'package:vibeat/utils/theme.dart';

@RoutePage()
class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(context) {
    return Stack(
      children: [
        AutoTabsScaffold(
          bottomSheet: SizedBox(
            height: 80,
            child: BlocBuilder<PlayerBloc, PlayerState>(
              builder: (context, state) {
                if (state.trackList.isNotEmpty) {
                  final track = state.trackList[state.currentTrackIndex];

                  return GestureDetector(
                    onTap: () {
                      context.router.push(const PlayerRoute());
                    },
                    child: Container(
                      color: Colors.black,
                      padding: const EdgeInsets.only(
                        left: 18,
                        right: 18,
                        top: 12,
                        bottom: 12,
                      ),
                      child: Container(
                        padding: const EdgeInsets.only(left: 8, right: 8),
                        decoration: BoxDecoration(
                          color: const Color(0xff1E1E1E),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Row(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(4),
                              child: CachedNetworkImage(
                                imageUrl: track.photoUrl,
                                height: 38,
                                width: 38,
                                fit: BoxFit.cover,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    track.name,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                      fontFamily: "Poppins",
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  Text(
                                    track.bitmaker,
                                    style: TextStyle(
                                      color: Colors.white.withOpacity(0.5),
                                      fontSize: 12,
                                      fontWeight: FontWeight.w400,
                                      fontFamily: "Helvetica",
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ),
                            ),
                            Row(
                              children: [
                                IconButton(
                                  icon: const Icon(
                                    Icons.favorite,
                                    size: 20,
                                  ),
                                  onPressed: () {},
                                ),
                                IconButton(
                                  icon: Icon(
                                    state.isPlaying == true
                                        ? Icons.pause
                                        : Icons.play_arrow,
                                    color: Colors.white,
                                    size: 28,
                                  ),
                                  onPressed: () {
                                    if (state.isPlaying) {
                                      context
                                          .read<PlayerBloc>()
                                          .add(PauseAudioEvent());
                                    } else {
                                      context
                                          .read<PlayerBloc>()
                                          .add(PlayAudioEvent());
                                    }
                                  },
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                }
                return const SizedBox();
              },
            ),
          ),
          backgroundColor: AppColors.background,
          routes: const [
            HeadRoute(),
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
        ),
      ],
    );
  }
}
