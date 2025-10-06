import 'package:auto_route/auto_route.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vibeat/app/app_router.gr.dart';
import 'package:vibeat/app/injection_container.dart';
import 'package:vibeat/custom_functions.dart';
import 'package:vibeat/features/favorite/presentation/bloc/favorite_bloc.dart';
import 'package:vibeat/player/bloc/player_bloc.dart';
import 'package:vibeat/player/widgets/like_button.dart';
import 'package:vibeat/utils/theme.dart';

@RoutePage()
class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  final CarouselSliderController _carouselController =
      CarouselSliderController();

  final double coverWidth = 330;
  int currentPage = 0;
  int targetPage = 0;
  bool isScrolling = false;
  bool _isProgrammaticChange = false;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final initialIndex = sl<PlayerBloc>().state.currentTrackIndex;

      if (initialIndex > 0) {
        _carouselController.jumpToPage(initialIndex);
        currentPage = initialIndex;
      }
    });
  }

  @override
  Widget build(context) {
    return Scaffold(
      body: Stack(
        children: [
          BlocListener<FavoriteBloc, FavoriteState>(
            listener: (context, state) {
              if (state is FavoriteBeatsError) {
                ScaffoldMessenger.of(context)
                    .showSnackBar(setupSnackBar(state.message));
              }
            },
            child: AutoTabsScaffold(
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
                  data: ThemeData(splashColor: Colors.transparent),
                  child: SizedBox(
                    height: MediaQuery.of(context).padding.bottom + 64,
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
                            size: 30,
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
                            size: 30,
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
                            size: 30,
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
                            size: 30,
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
                  ),
                );
              },
            ),
          ),
          Positioned(
            left: 0,
            right: 0,
            // bottom: 96,
            bottom: MediaQuery.of(context).padding.bottom + 64,
            child: BlocConsumer<PlayerBloc, PlayerStateApp>(
              buildWhen: (previous, current) =>
                  previous.playerBottom != current.playerBottom ||
                  previous.trackList != current.trackList ||
                  previous.isPlaying != current.isPlaying,
              listenWhen: (previous, current) =>
                  previous.currentTrackIndex != current.currentTrackIndex,
              listener: (context, state) {
                if (state.currentTrackIndex != currentPage) {
                  _isProgrammaticChange = true;
                  currentPage = state.currentTrackIndex;

                  if (_carouselController.ready) {
                    _carouselController.jumpToPage(state.currentTrackIndex);
                  }
                }
              },
              builder: (context, state) {
                if (state.trackList.isNotEmpty && state.playerBottom) {
                  return Container(
                    height: 80,
                    decoration: const BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(12),
                        topRight: Radius.circular(12),
                      ),
                    ),
                    child: CarouselSlider(
                      carouselController: _carouselController,
                      options: CarouselOptions(
                        height: 80,
                        viewportFraction: 0.92,
                        enlargeCenterPage: false,
                        enableInfiniteScroll: false,
                        initialPage: state.currentTrackIndex,
                        onPageChanged: (index, reason) {
                          if (_isProgrammaticChange) {
                            _isProgrammaticChange = false;
                            return;
                          }

                          if (!isScrolling) {
                            currentPage = index;
                            sl<PlayerBloc>().add(
                              UpdateCurrentTrackIndexEvent(index),
                            );
                          }
                        },
                      ),
                      items: state.trackList.map((track) {
                        return Builder(
                          builder: (BuildContext context) {
                            return Container(
                              width: MediaQuery.of(context).size.width,
                              margin:
                                  const EdgeInsets.symmetric(horizontal: 8.0),
                              child: GestureDetector(
                                onTap: () {
                                  context.router.push(const PlayerRoute());
                                },
                                child: Container(
                                  padding: const EdgeInsets.only(
                                    top: 12,
                                    bottom: 12,
                                  ),
                                  child: Container(
                                    padding: const EdgeInsets.only(
                                      left: 8,
                                      right: 8,
                                    ),
                                    decoration: BoxDecoration(
                                      color: const Color(0xff1E1E1E),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Row(
                                      children: [
                                        ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(4),
                                          child: CachedNetworkImage(
                                            imageUrl: track.photoUrl,
                                            width: 38,
                                            height: 38,
                                            fit: BoxFit.cover,
                                            errorWidget:
                                                (context, imageUrl, error) =>
                                                    Text(
                                              error.toString(),
                                            ),
                                          ),
                                        ),
                                        const SizedBox(width: 8),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
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
                                                  color: Colors.white
                                                      .withOpacity(0.5),
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
                                            BlocBuilder<PlayerBloc,
                                                PlayerStateApp>(
                                              buildWhen: (previous, current) =>
                                                  previous.currentTrackIndex !=
                                                  current.currentTrackIndex,
                                              builder: (context, state) {
                                                return LikeButton(
                                                  isLiked: context
                                                      .read<FavoriteBloc>()
                                                      .isFavoriteBeat(state
                                                          .currentTrackBeatId)
                                                      .getOrElse(() => false),
                                                  beatId:
                                                      state.currentTrackBeatId,
                                                );
                                              },
                                            ),
                                            IconButton(
                                              icon: Icon(
                                                state.isPlaying == true
                                                    ? Icons.pause
                                                    : Icons.play_arrow,
                                                color: Colors.white,
                                                size: 30,
                                              ),
                                              onPressed: () {
                                                if (state.isPlaying) {
                                                  sl<PlayerBloc>().add(
                                                    PauseAudioEvent(),
                                                  );
                                                } else {
                                                  sl<PlayerBloc>().add(
                                                    PlayAudioEvent(),
                                                  );
                                                }
                                              },
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        );
                      }).toList(),
                    ),
                  );
                }
                return const SizedBox();
              },
            ),
          ),
        ],
      ),
    );
  }
}
