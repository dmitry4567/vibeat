import 'dart:typed_data';
import 'dart:math';
import 'package:http/http.dart' as http;
import 'package:audio_waveforms/audio_waveforms.dart' as af;
import 'package:auto_route/auto_route.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:vibeat/app/app_router.gr.dart';
import 'package:vibeat/app/injection_container.dart';
import 'package:vibeat/features/favorite/data/datasources/favorite_local_data_source.dart';
import 'package:vibeat/features/favorite/presentation/bloc/favorite_bloc.dart';
import 'package:vibeat/player/bloc/player_bloc.dart';
import 'package:vibeat/player/widgets/like_button.dart';
import 'package:vibeat/player/widgets/player_control_widget.dart';

import '../utils/theme.dart';

@RoutePage()
class PlayerScreen extends StatefulWidget {
  const PlayerScreen({super.key});

  @override
  State<PlayerScreen> createState() => _PlayerScreenState();
}

class _PlayerScreenState extends State<PlayerScreen>
    with SingleTickerProviderStateMixin {
  double _offsetY = 0.0;
  double _startY = 0.0;
  late AnimationController _animationController;
  late Animation<double> _offsetAnimation;

  bool _isClosing = false;
  double _velocity = 0.0;
  final List<double> _recentVelocities = [];

  double? screenWidth;
  double? coverWidth;
  double? percentWidthCover;

  af.PlayerController controller = af.PlayerController();

  bool isLoading = true;

  PageController _pageController = PageController();

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );

    // Убираем получение initialPage из состояния, так как оно может быть устаревшим
    controller.stopPlayer();

    screenWidth = 390.0;
    coverWidth = 390 - 60.0;
    percentWidthCover = (coverWidth! * 100.0) / screenWidth!;

    final currentIndex = sl<PlayerBloc>().state.currentTrackIndex;

    // Создаем PageController без initialPage, он будет установлен позже
    _pageController = PageController(
      viewportFraction: percentWidthCover! / 100,
      initialPage: currentIndex,
    );

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _pageController.jumpToPage(currentIndex);
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    _pageController.dispose();
    super.dispose();
  }

  void _onVerticalDragStart(DragStartDetails details) {
    _startY = details.globalPosition.dy;
    _animationController.stop();
    _isClosing = false;
    _recentVelocities.clear();
  }

  void _onVerticalDragUpdate(DragUpdateDetails details) {
    setState(() {
      _offsetY = details.globalPosition.dy - _startY;

      if (_recentVelocities.length >= 5) {
        _recentVelocities.removeAt(0);
      }
      _recentVelocities.add(details.primaryDelta!);

      _velocity = _recentVelocities.isNotEmpty
          ? _recentVelocities.reduce((a, b) => a + b) / _recentVelocities.length
          : 0.0;
    });
  }

  void _onVerticalDragEnd(DragEndDetails details) {
    final bool isFastSwipe = _velocity > 3.0;
    final bool isFarEnough = _offsetY > 200;

    if (isFastSwipe || isFarEnough) {
      _closeWithAnimation();
    } else {
      _startReturnAnimation();
    }
  }

  void _closeWithAnimation() {
    if (_isClosing) return;
    _isClosing = true;

    final closeTween = Tween<double>(
      begin: _offsetY,
      end: MediaQuery.of(context).size.height,
    );

    final closeAnimation = closeTween.animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ),
    );

    closeAnimation
      ..addListener(() {
        setState(() {
          _offsetY = closeAnimation.value;
        });
      })
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          Navigator.of(context).pop();
        }
      });

    _animationController.duration = Duration(
      milliseconds: (400 * (_velocity > 5.0 ? 0.5 : 1.0)).toInt(),
    );

    _animationController.forward(from: 0.0);
  }

  void _startReturnAnimation() {
    final returnTween = Tween<double>(
      begin: _offsetY,
      end: 0.0,
    );

    _offsetAnimation = returnTween.animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeOutQuad,
      ),
    )..addListener(() {
        setState(() {
          _offsetY = _offsetAnimation.value;
        });
      });

    _animationController.duration = const Duration(milliseconds: 300);
    _animationController.forward(from: 0.0);
  }

  Color primaryColor = const Color(0xFFF5F5F5);
  Color secondaryColor = const Color(0xFFE0E0E0);
  bool isLoadingImage = false;
  Uint8List? imageBytes;

  void state() {
    super.setState(() {
      if (!mounted) return;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: GestureDetector(
        onVerticalDragStart: _onVerticalDragStart,
        onVerticalDragUpdate: _onVerticalDragUpdate,
        onVerticalDragEnd: _onVerticalDragEnd,
        child: Transform.translate(
          offset: Offset(0, _offsetY > 0 ? _offsetY : 0),
          child: Stack(
            children: [
              Stack(
                children: [
                  Positioned.fill(
                    child: Container(
                      color: Colors.black,
                    ),
                  ),
                  const BackgroundColor(),
                ],
              ),
              Column(
                children: [
                  ImagesPageBuilder(
                    coverWidth: coverWidth!,
                    pageController: _pageController,
                  ),
                  const SizedBox(height: 20),
                  Container(
                    padding: const EdgeInsets.only(left: 30),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              BlocBuilder<PlayerBloc, PlayerStateApp>(
                                buildWhen: (previous, current) =>
                                    previous.currentTrackIndex !=
                                        current.currentTrackIndex ||
                                    previous.trackList != current.trackList,
                                builder: (context, state) {
                                  if (state.trackList.isNotEmpty) {
                                    return AnimatedSwitcher(
                                      duration:
                                          const Duration(milliseconds: 300),
                                      transitionBuilder: (child, animation) {
                                        return FadeTransition(
                                          opacity: animation,
                                          child: child,
                                        );
                                      },
                                      child: Container(
                                        alignment: Alignment.centerLeft,
                                        key: ValueKey<int>(
                                            state.currentTrackIndex),
                                        child: Text(
                                          state
                                              .trackList[
                                                  state.currentTrackIndex]
                                              .name
                                              .trim(),
                                          style: AppTextStyles.headline1,
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                    );
                                  }
                                  return Container();
                                },
                              ),
                              const SizedBox(
                                height: 2,
                              ),
                              BlocBuilder<PlayerBloc, PlayerStateApp>(
                                buildWhen: (previous, current) =>
                                    previous.currentTrackIndex !=
                                    current.currentTrackIndex,
                                builder: (context, state) {
                                  if (state.trackList.isNotEmpty) {
                                    return Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(top: 1),
                                          child: Text(
                                            "${state.trackList[state.currentTrackIndex].bitmaker}  |  ",
                                            style: AppTextStyles.bodyText1,
                                          ),
                                        ),
                                        Text(
                                          "₽${state.trackList[state.currentTrackIndex].price}",
                                          style: AppTextStyles.bodyPrice1,
                                        ),
                                      ],
                                    );
                                  }
                                  return const Text("null");
                                },
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          child: Row(
                            children: [
                              IconButton(
                                onPressed: () {
                                  sl<FavoriteLocalDataSource>().clearAllDB();
                                },
                                icon: const Icon(
                                  Icons.shopping_cart_outlined,
                                ),
                                color: AppColors.iconPrimary,
                              ),
                              BlocBuilder<PlayerBloc, PlayerStateApp>(
                                buildWhen: (previous, current) =>
                                    previous.currentTrackIndex !=
                                    current.currentTrackIndex,
                                builder: (context, state) {
                                  return LikeButton(
                                    isLiked: context
                                        .read<FavoriteBloc>()
                                        .isFavoriteBeat(
                                            state.currentTrackBeatId)
                                        .getOrElse(() => false),
                                    beatId: state.currentTrackBeatId,
                                  );
                                },
                              ),
                              IconButton(
                                onPressed: () {},
                                icon: const Icon(Icons.share),
                                color: AppColors.iconPrimary,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  PlayerControlWidget(
                    pageController: _pageController,
                  ),
                  const SizedBox(height: 18),
                  Container(
                    margin: const EdgeInsets.only(top: 18, left: 18, right: 18),
                    width: double.infinity,
                    height: 164,
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.all(Radius.circular(6)),
                      border: Border.all(
                        color: Colors.white.withOpacity(0.4),
                        width: 0.5,
                      ),
                      color: Colors.white.withOpacity(0.1),
                    ),
                    child: Stack(
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            // Align(
                            //   alignment: Alignment.centerLeft,
                            //   child: Padding(
                            //     padding:
                            //         const EdgeInsets.only(top: 5, left: 12),
                            //     child: BlocBuilder<PlayerBloc, PlayerStateApp>(
                            //       buildWhen: (previous, current) =>
                            //           previous.indexFragment !=
                            //               current.indexFragment ||
                            //           previous.isTimeStamps !=
                            //               current.isTimeStamps,
                            //       builder: (context, state) {
                            //         return AnimatedSwitcher(
                            //           duration:
                            //               const Duration(milliseconds: 300),
                            //           child: Align(
                            //             key: ValueKey<String>(state.isTimeStamps
                            //                 ? state.fragmentsNames[
                            //                     state.indexFragment]
                            //                 : ""),
                            //             alignment: Alignment
                            //                 .centerLeft, // или нужное выравнивание
                            //             child: Text(
                            //               state.isTimeStamps
                            //                   ? state.fragmentsNames[
                            //                       state.indexFragment]
                            //                   : "",
                            //               style:
                            //                   AppTextStyles.bodyPrice1.copyWith(
                            //                 fontSize: 12,
                            //                 color: Colors.white,
                            //                 height: 1.375,
                            //               ),
                            //             ),
                            //           ),
                            //         );
                            //       },
                            //     ),
                            //   ),
                            // ),
                            // Container(
                            //   padding: const EdgeInsets.only(top: 5),
                            //   child: Container(
                            //     height: 54,
                            //     margin:
                            //         const EdgeInsets.symmetric(horizontal: 16),
                            //     child: GestureDetector(
                            //       onTapDown: (details) {
                            //         final RenderBox box =
                            //             context.findRenderObject() as RenderBox;

                            //         final Offset localPosition = box
                            //             .globalToLocal(details.globalPosition);

                            //         final double percent =
                            //             localPosition.dx / box.size.width;
                            //       },
                            //       onHorizontalDragUpdate: (details) {
                            //         final RenderBox box =
                            //             context.findRenderObject() as RenderBox;
                            //         final Offset localPosition = box
                            //             .globalToLocal(details.globalPosition);
                            //         final double percent =
                            //             (localPosition.dx / box.size.width)
                            //                 .clamp(0.0, 1.0);

                            //         sl<PlayerBloc>().add(
                            //           UpdateDragProgressEvent(percent),
                            //         );
                            //       },
                            //       onHorizontalDragEnd: (details) {
                            //         final duration = context
                            //             .read<PlayerBloc>()
                            //             .player
                            //             .duration;
                            //         final progress = context
                            //             .read<PlayerBloc>()
                            //             .state
                            //             .dragProgress;

                            //         if (duration != null && progress != null) {
                            //           final position =
                            //               duration.inMilliseconds * progress;

                            //           sl<PlayerBloc>().player.seek(
                            //                 Duration(
                            //                     milliseconds: position.round()),
                            //               );
                            //         }
                            //         sl<PlayerBloc>().add(
                            //           UpdateDragProgressEvent(null),
                            //         );
                            //       },
                            //       child:
                            //           BlocBuilder<PlayerBloc, PlayerStateApp>(
                            //         buildWhen: (previous, current) =>
                            //             previous.progress != current.progress ||
                            //             previous.waveformData !=
                            //                 current.waveformData,
                            //         builder: (context, state) {
                            //           return AnimatedSwitcher(
                            //             duration:
                            //                 const Duration(milliseconds: 300),
                            //             transitionBuilder: (Widget child,
                            //                 Animation<double> animation) {
                            //               return FadeTransition(
                            //                 opacity: animation,
                            //                 child: child,
                            //               );
                            //             },
                            //             child: CustomPaint(
                            //               key: ValueKey(
                            //                   state.waveformData.hashCode),
                            //               painter: WaveformPainter(
                            //                 waveformData: state.waveformData,
                            //                 progress: state.dragProgress != null
                            //                     ? state.dragProgress!
                            //                     : state.progress,
                            //                 fixedWaveColor:
                            //                     Colors.white.withOpacity(0.4),
                            //                 liveWaveColor: Colors.white,
                            //                 spacing: 4,
                            //                 scaleFactor: 54,
                            //                 waveCap: StrokeCap.round,
                            //               ),
                            //               size: Size(
                            //                 MediaQuery.of(context).size.width -
                            //                     32,
                            //                 100,
                            //               ),
                            //             ),
                            //           );
                            //         },
                            //       ),
                            //     ),
                            //   ),
                            // ),
                            Padding(
                              padding: const EdgeInsets.only(
                                  top: 5, left: 12, right: 12),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  BlocBuilder<PlayerBloc, PlayerStateApp>(
                                    buildWhen: (previous, current) =>
                                        previous.position.inSeconds !=
                                        current.position.inSeconds,
                                    builder: (context, state) {
                                      return Text(
                                        "${(state.position.inSeconds ~/ 60).toString().padLeft(2, '0')}:${(state.position.inSeconds % 60).toString().padLeft(2, '0')}",
                                        style: AppTextStyles.timePlayer,
                                      );
                                    },
                                  ),
                                  BlocBuilder<PlayerBloc, PlayerStateApp>(
                                    buildWhen: (previous, current) =>
                                        previous.duration != current.duration,
                                    builder: (context, state) {
                                      final totalSeconds =
                                          state.duration.inSeconds ?? 0;

                                      return Text(
                                        "${(totalSeconds ~/ 60).toString().padLeft(2, '0')}:${(totalSeconds % 60).toString().padLeft(2, '0')}",
                                        style: AppTextStyles.timePlayer,
                                      );
                                    },
                                  ),
                                ],
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                BlocBuilder<PlayerBloc, PlayerStateApp>(
                                  buildWhen: (previous, current) =>
                                      previous.isTimeStamps !=
                                      current.isTimeStamps,
                                  builder: (context, state) {
                                    return GestureDetector(
                                      onTap: () {
                                        sl<PlayerBloc>().add(
                                          PreviousFragmentEvent(),
                                        );
                                      },
                                      child: state.isTimeStamps
                                          ? SvgPicture.asset(
                                              "assets/svg/left_arrow.svg")
                                          : SvgPicture.asset(
                                              color:
                                                  Colors.white.withOpacity(0.4),
                                              "assets/svg/left_arrow.svg"),
                                    );
                                  },
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                BlocBuilder<PlayerBloc, PlayerStateApp>(
                                  buildWhen: (previous, current) =>
                                      previous.loopCurrentFragment !=
                                          current.loopCurrentFragment ||
                                      previous.isTimeStamps !=
                                          current.isTimeStamps,
                                  builder: (context, state) {
                                    if (state.isTimeStamps) {
                                      return InkWell(
                                        onTap: () {
                                          sl<PlayerBloc>().add(
                                            ToggleLoopFragmentEvent(),
                                          );
                                        },
                                        child: Container(
                                          decoration: BoxDecoration(
                                            color: state.loopCurrentFragment
                                                ? Colors.white
                                                : Colors.white.withOpacity(0.4),
                                            borderRadius:
                                                const BorderRadius.all(
                                                    Radius.circular(12)),
                                          ),
                                          width: 64,
                                          height: 47,
                                          child: Icon(
                                            Icons.repeat_one,
                                            color: state.loopCurrentFragment
                                                ? Colors.black.withOpacity(0.5)
                                                : const Color.fromARGB(
                                                    255, 255, 255, 255),
                                          ),
                                        ),
                                      );
                                    }

                                    return Container(
                                      decoration: BoxDecoration(
                                        color: Colors.white.withOpacity(0.3),
                                        borderRadius: const BorderRadius.all(
                                            Radius.circular(12)),
                                      ),
                                      width: 64,
                                      height: 47,
                                      child: Icon(
                                        Icons.repeat_one,
                                        color: Colors.white.withOpacity(0.3),
                                      ),
                                    );
                                  },
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                BlocBuilder<PlayerBloc, PlayerStateApp>(
                                  buildWhen: (previous, current) =>
                                      previous.isTimeStamps !=
                                      current.isTimeStamps,
                                  builder: (context, state) {
                                    return GestureDetector(
                                      onTap: () {
                                        sl<PlayerBloc>().add(
                                          NextFragmentEvent(),
                                        );
                                      },
                                      child: state.isTimeStamps
                                          ? SvgPicture.asset(
                                              "assets/svg/right_arrow.svg")
                                          : SvgPicture.asset(
                                              color:
                                                  Colors.white.withOpacity(0.4),
                                              "assets/svg/right_arrow.svg"),
                                    );
                                  },
                                ),
                              ],
                            ),
                          ],
                        ),
                        const Positioned(
                          left: 12,
                          bottom: 14,
                          child: BpmTuneWidget(),
                        ),
                        const InfoBeatWidget(),
                      ],
                    ),
                  ),
                ],
              ),
              Positioned(
                top: 40,
                child: IconButton(
                  onPressed: () {
                    context.maybePop();
                  },
                  icon: const Icon(
                    Icons.keyboard_arrow_down,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class BpmTuneWidget extends StatelessWidget {
  const BpmTuneWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PlayerBloc, PlayerStateApp>(
      buildWhen: (previous, current) =>
          previous.currentTrackIndex != current.currentTrackIndex,
      builder: (context, state) {
        return Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                SvgPicture.asset("assets/svg/bpm.svg"),
                const SizedBox(
                  width: 4,
                ),
                Text(
                  state.trackList.isNotEmpty
                      ? state.trackList[state.currentTrackIndex].bpm.toString()
                      : "---",
                  style: AppTextStyles.timePlayer.copyWith(
                    color: Colors.white.withOpacity(0.8),
                    fontSize: 12,
                    height: 0.9,
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 6,
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                const SizedBox(
                  width: 1,
                ),
                SvgPicture.asset("assets/svg/tune.svg"),
                const SizedBox(
                  width: 9,
                ),
                Text(
                  state.trackList.isNotEmpty
                      ? state.trackList[state.currentTrackIndex].tune
                      : "---",
                  style: AppTextStyles.timePlayer.copyWith(
                    color: Colors.white.withOpacity(0.8),
                    fontSize: 12,
                    height: 0.9,
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }
}

class InfoBeatWidget extends StatelessWidget {
  const InfoBeatWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PlayerBloc, PlayerStateApp>(
      buildWhen: (previous, current) =>
          previous.currentTrackIndex != current.currentTrackIndex,
      builder: (context, state) {
        return Positioned(
          right: 4,
          bottom: 2,
          child: IconButton(
            onPressed: () {
              final router = context.router;
              final beatId = state.trackList[state.currentTrackIndex].id;

              context.maybePop().then((_) {
                Future.delayed(const Duration(milliseconds: 300)).then((_) {
                  router.push(
                    InfoBeatRoute(
                      beatId: beatId,
                    ),
                  );
                });
              });
            },
            icon: const Icon(Icons.info_outline),
            color: AppColors.iconPrimary,
          ),
        );
      },
    );
  }
}

class BackgroundColor extends StatelessWidget {
  const BackgroundColor({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PlayerBloc, PlayerStateApp>(
      buildWhen: (previous, current) =>
          previous.colorsOfBackground != current.colorsOfBackground,
      builder: (context, state) {
        if (state.colorsOfBackground != Colors.black) {
          final hsl = HSLColor.fromColor(state.colorsOfBackground);

          return Positioned.fill(
            child: ClipRRect(
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
                width: double.infinity,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      hsl
                          .withLightness((hsl.lightness + 0.2).clamp(0.5, 0.7))
                          .toColor(),
                      state.colorsOfBackground,
                      hsl
                          .withLightness((hsl.lightness * 0.7).clamp(0.3, 0.5))
                          .toColor(),
                      hsl
                          .withLightness(
                              (hsl.lightness * 0.4).clamp(0.15, 0.25))
                          .toColor(),
                    ],
                    stops: const [0.0, 0.4, 0.7, 1.0],
                  ),
                ),
              ),
            ),
          );
        }
        return Container();
      },
    );
  }
}

class ImagesPageBuilder extends StatefulWidget {
  const ImagesPageBuilder({
    super.key,
    required this.coverWidth,
    required this.pageController,
  });

  final double coverWidth;
  final PageController pageController;

  @override
  State<ImagesPageBuilder> createState() => _ImagesPageBuilderState();
}

class _ImagesPageBuilderState extends State<ImagesPageBuilder> {
  int currentPage = 0;
  int targetPage = 0;
  bool isScrollingByFinger = false;
  bool _wasManualScroll = false;
  int _lastExternalTrackIndex = 0;
  bool _isUserInitiatedScroll = false;
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    // Немедленно переходим к правильной странице после инициализации
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final state = sl<PlayerBloc>().state;

      if (state.isInitialized && state.trackList.isNotEmpty) {
        widget.pageController.jumpToPage(state.currentTrackIndex);

        setState(() {
          _isInitialized = true;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned(
          top: 0,
          bottom: 0,
          left: 0,
          right: 0,
          child: Container(
            width: widget.coverWidth,
            height: widget.coverWidth,
            decoration: BoxDecoration(
              color: Colors.transparent,
              borderRadius: BorderRadius.circular(6.0),
            ),
          ),
        ),
        Container(
          margin: const EdgeInsets.only(top: 90),
          height: widget.coverWidth,
          child: BlocConsumer<PlayerBloc, PlayerStateApp>(
            buildWhen: (previous, current) =>
                previous.currentTrackIndex != current.currentTrackIndex ||
                previous.trackList != current.trackList,
            listener: (context, state) async {
              final bool isExternalChange =
                  state.currentTrackIndex != _lastExternalTrackIndex &&
                      !isScrollingByFinger &&
                      !_wasManualScroll;

              if (isExternalChange) {
                _lastExternalTrackIndex = state.currentTrackIndex;

                final int currentPageValue =
                    widget.pageController.page?.round() ?? 0;

                if (state.currentTrackIndex != currentPageValue) {
                  // Используем jumpToPage для немедленного перехода
                  widget.pageController.animateToPage(
                    state.currentTrackIndex,
                    duration: const Duration(milliseconds: 500),
                    curve: Curves.linearToEaseOut,
                  );
                }
              }
            },
            builder: (context, state) {
              if (_isInitialized && state.trackList.isEmpty) {
                return Center(
                  child: Skeletonizer(
                    enabled: true,
                    child: Container(
                      width: widget.coverWidth,
                      height: widget.coverWidth,
                      color: Colors.grey,
                    ),
                  ),
                );
              }
              return NotificationListener<ScrollNotification>(
                onNotification: (ScrollNotification notification) {
                  if (notification is ScrollStartNotification) {
                    // Запоминаем, был ли скролл инициирован пользователем
                    _isUserInitiatedScroll = notification.dragDetails != null;
                    isScrollingByFinger = _isUserInitiatedScroll;
                    _wasManualScroll = _isUserInitiatedScroll;
                  } else if (notification is ScrollUpdateNotification) {
                    final page = widget.pageController.page ?? 0.0;
                    targetPage = page.round();
                  } else if (notification is ScrollEndNotification) {
                    // Используем сохраненный флаг вместо проверки dragDetails
                    if (_isUserInitiatedScroll && targetPage != currentPage) {
                      currentPage = targetPage;
                      context
                          .read<PlayerBloc>()
                          .add(UpdateCurrentTrackIndexEvent(currentPage));
                    }

                    // Сбрасываем флаги после окончания скролла
                    isScrollingByFinger = false;
                    _wasManualScroll = false;
                    _isUserInitiatedScroll = false;
                  }
                  return false;
                },
                child: PageView.custom(
                  controller: widget.pageController,
                  childrenDelegate: SliverChildBuilderDelegate(
                    (context, index) {
                      double scale = 1.0;
                      return AnimatedBuilder(
                        animation: widget.pageController,
                        builder: (context, child) {
                          // if (widget.pageController.position.haveDimensions) {
                          double currentPageValue =
                              widget.pageController.page ??
                                  widget.pageController.initialPage.toDouble();
                          scale = (1 - (currentPageValue - index).abs() * 0.3)
                              .clamp(0.9, 1.0);
                          // }
                          return Transform.scale(
                            scale: scale,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(12.0),
                              child: CachedNetworkImage(
                                imageUrl: state.trackList[index].photoUrl,
                                width: widget.coverWidth,
                                height: widget.coverWidth,
                                fit: BoxFit.cover,
                                errorWidget: (context, imageUrl, error) =>
                                    ClipRRect(
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(6)),
                                  child: Container(
                                    color: Colors.grey,
                                    child: const Icon(
                                      Icons.error,
                                      size: 40,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      );
                    },
                    childCount: state.trackList.length,
                    addAutomaticKeepAlives: true,
                    addRepaintBoundaries: true,
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

class WaveformPainter extends CustomPainter {
  final List<double> waveformData;
  final double progress;
  final Color fixedWaveColor;
  final Color liveWaveColor;
  final double spacing;
  final double scaleFactor;
  final StrokeCap waveCap;

  WaveformPainter({
    required this.waveformData,
    required this.progress,
    required this.fixedWaveColor,
    required this.liveWaveColor,
    required this.spacing,
    required this.scaleFactor,
    required this.waveCap,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (waveformData.isEmpty) return;

    final paint = Paint()
      ..strokeCap = waveCap
      ..strokeWidth = 3;

    final barWidth = (size.width - (waveformData.length - 1) * spacing) /
        waveformData.length;
    final progressWidth = size.width * progress;
    final center = size.height / 2;

    // Draw background (unplayed) waveform
    paint.color = fixedWaveColor;
    _drawWaveform(
        canvas, size, paint, barWidth, center, 0, waveformData.length);

    // Draw progress (played) waveform
    paint.color = liveWaveColor;
    final progressBars = (progressWidth / (barWidth + spacing)).floor();
    _drawWaveform(canvas, size, paint, barWidth, center, 0, progressBars);
  }

  void _drawWaveform(Canvas canvas, Size size, Paint paint, double barWidth,
      double center, int start, int end) {
    for (var i = start; i < end && i < waveformData.length; i++) {
      final x = i * (barWidth + spacing);
      final amplitude = waveformData[i].clamp(0.1, 1.0);
      final barHeight = amplitude * scaleFactor;

      // Draw the bar
      final topY = center - barHeight / 2;
      final bottomY = center + barHeight / 2;
      canvas.drawLine(
        Offset(x + barWidth / 2, topY),
        Offset(x + barWidth / 2, bottomY),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(WaveformPainter oldDelegate) {
    return oldDelegate.progress != progress ||
        oldDelegate.waveformData != waveformData ||
        oldDelegate.fixedWaveColor != fixedWaveColor ||
        oldDelegate.liveWaveColor != liveWaveColor ||
        oldDelegate.spacing != spacing ||
        oldDelegate.scaleFactor != scaleFactor ||
        oldDelegate.waveCap != waveCap;
  }
}
