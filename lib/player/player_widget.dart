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

  List<List<Color>> listOfColors = [
    [const Color(0xffDBDBDB), const Color(0xffDADADA)],
    [
      const Color.fromARGB(255, 12, 12, 12),
      const Color.fromARGB(115, 54, 53, 53)
    ],
    [
      const Color.fromARGB(255, 28, 132, 218),
      const Color.fromARGB(255, 71, 169, 75)
    ],
    [
      const Color.fromARGB(255, 12, 12, 12),
      const Color.fromARGB(115, 54, 53, 53)
    ],
    [
      const Color.fromARGB(255, 12, 12, 12),
      const Color.fromARGB(115, 54, 53, 53)
    ],
  ];

  double? screenWidth;
  double? coverWidth;
  double? percentWidthCover;

  af.PlayerController controller = af.PlayerController();
  String? audioFilePath;
  int currentAudioIndex = 0;

  bool isLoading = true;
  bool isPlaying = false;
  bool isRepeat = false;
  int timePlayer = 0;
  int endTimePlayer = 0;
  int numberOfFragments = 0;
  String currentFragmentName = '...';

  PageController _pageController = PageController();
  final int _currentPage = 0;
  final bool _isAnimating = false;

  final double _positionY = 0.0; // Позиция по Y
  final double _startPositionY = 0.0; // Начальная позиция при касании
  double _maxPosition = 0.0; // Максимальное смещение

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
      final mediaQuery = MediaQuery.of(context);
      _maxPosition = mediaQuery.size.height;

      // Устанавливаем начальную страницу после построения виджета
      _pageController.jumpToPage(currentIndex);
    });
  }

  // void _pageListener() {
  //   if (_pageController.position.isScrollingNotifier.value) {
  //     _isAnimating = true;
  //   } else if (_isAnimating) {
  //     _isAnimating = false;
  //     // Анимация завершена
  //     print('Анимация завершена, текущая страница: $_currentPage');
  //   }
  // }

  @override
  void dispose() {
    _animationController.dispose();
    _pageController.dispose();
    // _pageController.removeListener(_pageListener);
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

      // Рассчитываем скорость свайпа
      if (_recentVelocities.length >= 5) {
        _recentVelocities.removeAt(0);
      }
      _recentVelocities.add(details.primaryDelta!);

      // Вычисляем среднюю скорость
      _velocity = _recentVelocities.isNotEmpty
          ? _recentVelocities.reduce((a, b) => a + b) / _recentVelocities.length
          : 0.0;
    });
  }

  void _onVerticalDragEnd(DragEndDetails details) {
    // Если скорость свайпа достаточно высокая или сдвинули достаточно далеко - быстро закрываем
    final bool isFastSwipe =
        _velocity > 3.0; // Порог скорости для быстрого закрытия
    final bool isFarEnough = _offsetY > 200; // Порог расстояния

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

  // Обработка быстрого тапа для закрытия
  void _onTapDown(TapDownDetails details) {
    // Если тап в верхней части экрана - закрываем
    if (details.globalPosition.dy < 100) {
      _closeWithAnimation();
    }
  }

  bool isDownloading = false;

  // Future<void> _downloadAudioFile() async {
  //   if (isDownloading) {
  //     if (kDebugMode) {
  //       'Download already in progress, skipping duplicate call.');
  //     }
  //     return;
  //   }

  //   setState(() {
  //     isLoading = true;
  //     isDownloading = true;
  //   });

  //   final Directory directory = await getApplicationDocumentsDirectory();
  //   final String path = '${directory.path}/audio$currentAudioIndex.wav';
  //   final File audioFile = File(path);

  //   // Check if the file already exists and is not empty
  //   if (await audioFile.exists() && await audioFile.length() > 0) {
  //     if (kDebugMode) 'Audio file already exists at: $path');
  //     await _playAudioFile(path);
  //     setState(() {
  //       isLoading = false;
  //       isDownloading = false;
  //     });
  //     return;
  //   }

  //   try {
  //     final response =
  //         await http.get(Uri.parse(listOfAudioUrl[currentAudioIndex]));

  //     if (response.statusCode == 200) {
  //       // Write the downloaded file
  //       await audioFile.writeAsBytes(response.bodyBytes);
  //       if (kDebugMode) 'File downloaded and saved: $path');

  //       // Proceed to play the file after successful download
  //       await _playAudioFile(path);
  //     } else {
  //       throw Exception(
  //           'Failed to download audio file: ${response.statusCode}');
  //     }
  //   } catch (e) {
  //     if (kDebugMode) 'Error downloading audio file: $e');
  //   } finally {
  //     setState(() {
  //       isLoading = false;
  //       isDownloading = false;
  //     });
  //   }
  // }

// Helper function to handle playing the audio file
  // Future<void> _playAudioFile(String path) async {
  //   audioFilePath = path;
  //   controller.updateFrequency = UpdateFrequency.high;

  //   try {
  //     await controller.preparePlayer(path: audioFilePath!, noOfSamples: 55);
  //     // await controller.startPlayer();

  //     setState(() {
  //       // isPlaying = true;
  //       endTimePlayer = 0;
  //       timePlayer = 0;
  //       numberOfFragments = 0;
  //       currentFragmentName = fragmentsNames[numberOfFragments];
  //     });

  //     // Listen for duration changes
  //     controller.onCurrentDurationChanged.listen((value) {
  //       setState(() {
  //         timePlayer = value ~/ 1000;
  //       });
  //       _updateFragment();
  //     });
  //   } catch (e) {
  //     if (kDebugMode) 'Error preparing or starting the player: $e');
  //   }
  // }
  // Future<void> _downloadAudioFile() async {
  //   setState(() {
  //     isLoading = true;
  //   });

  //   try {
  //     final response =
  //         await http.get(Uri.parse(listOfAudioUrl[currentAudioIndex]));

  //     if (response.statusCode == 200) {
  //       final Directory directory = await getApplicationDocumentsDirectory();
  //       final String path = '${directory.path}/audio$currentAudioIndex.wav';
  //       final File audioFile = File(path);

  //       await audioFile.writeAsBytes(response.bodyBytes);

  //       audioFilePath = path;
  //       controller.updateFrequency = UpdateFrequency.high;

  //       await controller
  //           .preparePlayer(path: audioFilePath!, noOfSamples: 55)
  //           .then((value) async {
  //         // await controller.startPlayer();
  //       });

  //       setState(() {
  //         isLoading = false;
  //         // isPlaying = true;
  //         endTimePlayer = 0;
  //         timePlayer = 0;
  //         numberOfFragments = 0;
  //         currentFragmentName = fragmentsNames[numberOfFragments];
  //       });

  //       endTimePlayer = (await controller.getDuration()) ~/ 1000;

  //       controller.onCurrentDurationChanged.listen((value) {
  //         setState(() {
  //           timePlayer = value ~/ 1000;
  //           _updateFragment();
  //         });
  //       });
  //     } else {
  //       throw Exception('Не удалось загрузить аудиофайл');
  //     }
  //   } catch (e) {
  //     'Ошибка: $e');
  //   }
  // }

  // void _updateFragment() {
  //   for (int i = 0; i < fragmentsMusic.length - 1; i++) {
  //     if (timePlayer >= fragmentsMusic[i] &&
  //         timePlayer < fragmentsMusic[i + 1]) {
  //       numberOfFragments = i;
  //       currentFragmentName = fragmentsNames[i];
  //       break;
  //     }
  //   }

  //   if (timePlayer >= fragmentsMusic.last) {
  //     numberOfFragments = fragmentsMusic.length - 1;
  //     currentFragmentName = fragmentsNames.last;
  //   }
  // }

  // Future<void> _playNextAudio() async {
  //   if (currentAudioIndex < listOfAudioUrl.length - 1) {
  //     currentAudioIndex++;
  //     await controller.stopPlayer(); // Остановить текущий плеер

  //     _downloadAudioFile(); // Загрузить новый аудиофайл

  //     _pageController.nextPage(
  //       duration: const Duration(milliseconds: 500),
  //       curve: Curves.fastLinearToSlowEaseIn,
  //     );
  //   }
  // }

  // Future<void> _playPreviousAudio() async {
  //   if (currentAudioIndex > 0) {
  //     currentAudioIndex--;
  //     await controller.stopPlayer(); // Остановить текущий плеер

  //     _downloadAudioFile(); // Загрузить новый аудиофайл

  //     _pageController.previousPage(
  //       duration: const Duration(milliseconds: 500),
  //       curve: Curves.fastLinearToSlowEaseIn,
  //     );
  //   }
  // }

  // Future<void> _togglePlayPause() async {
  //   if (isPlaying) {
  //     await controller.pausePlayer();
  //   } else {
  //     if (audioFilePath != null) {
  //       await controller.startPlayer();
  //     }
  //   }
  //   setState(() {
  //     isPlaying = !isPlaying;
  //   });
  // }

  // @override
  // void dispose() {
  //   _pageController.dispose();
  //   controller.stopAllPlayers();
  //   super.dispose();
  // }

  String? imageUrl;
  Color primaryColor = const Color(0xFFF5F5F5);
  Color secondaryColor = const Color(0xFFE0E0E0);
  bool isLoadingImage = false;
  Uint8List? imageBytes;

  Future<void> loadImageAndColors(String url) async {
    setState(() {
      isLoading = true;
    });

    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final bytes = response.bodyBytes;
        final image = await decodeImageFromList(bytes);
        final byteData = await image.toByteData();
        final pixels = byteData!.buffer.asUint8List();

        // Анализируем цвета изображения
        final colors = _analyzeImageColors(pixels, image.width, image.height);

        setState(() {
          imageBytes = bytes;
          primaryColor = colors['primary']!;
          secondaryColor = colors['secondary']!;
          isLoadingImage = false;
        });
      } else {
        setState(() {
          isLoadingImage = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Ошибка загрузки: ${response.statusCode}')),
        );
      }
    } catch (e) {
      setState(() {
        isLoadingImage = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Ошибка: $e')),
      );
    }
  }

  Map<String, Color> _analyzeImageColors(
      Uint8List pixels, int width, int height) {
    final colorMap = <Color, int>{};
    const sampleStep = 10; // Шаг выборки пикселей для ускорения анализа

    // Собираем статистику по цветам
    for (int y = 0; y < height; y += sampleStep) {
      for (int x = 0; x < width; x += sampleStep) {
        final offset = (y * width + x) * 4;
        final color = Color.fromARGB(
          255,
          pixels[offset],
          pixels[offset + 1],
          pixels[offset + 2],
        );
        colorMap[color] = (colorMap[color] ?? 0) + 1;
      }
    }

    // Сортируем цвета по частоте встречаемости
    final sortedColors = colorMap.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    // Выбираем два наиболее часто встречающихся, но контрастных цвета
    Color primary = sortedColors.first.key;
    Color secondary = primary;

    for (final entry in sortedColors) {
      if (_colorDistance(primary, entry.key) > 100) {
        secondary = entry.key;
        break;
      }
    }

    return {'primary': primary, 'secondary': secondary};
  }

  double _colorDistance(Color c1, Color c2) {
    // Вычисляем "расстояние" между цветами в RGB пространстве
    return sqrt(pow(c1.red - c2.red, 2) +
        pow(c1.green - c2.green, 2) +
        pow(c1.blue - c2.blue, 2));
  }

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
        // onVerticalDragUpdate: (details) {
        //   if (details.primaryDelta! > 20) {
        //     Navigator.of(context).pop();
        //   }
        // },
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
                  BlocBuilder<PlayerBloc, PlayerStateApp>(
                    buildWhen: (previous, current) =>
                        previous.colorsOfBackground !=
                        current.colorsOfBackground,
                    builder: (context, state) {
                      if (state.colorsOfBackground != Colors.black) {
                        final hsl =
                            HSLColor.fromColor(state.colorsOfBackground);

                        return Positioned.fill(
                          child: ClipRRect(
                            // borderRadius: const BorderRadius.only(
                            //   topRight: Radius.circular(55),
                            //   topLeft: Radius.circular(55),
                            // ),
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
                                        .withLightness((hsl.lightness + 0.2)
                                            .clamp(0.5, 0.7))
                                        .toColor(),
                                    state.colorsOfBackground,
                                    hsl
                                        .withLightness((hsl.lightness * 0.7)
                                            .clamp(0.3, 0.5))
                                        .toColor(),
                                    hsl
                                        .withLightness((hsl.lightness * 0.4)
                                            .clamp(0.15, 0.25))
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
                  ),
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
                              // SizedBox(
                              //   height: 25,
                              //   child: Marquee(
                              //     text: listOfName[currentAudioIndex],
                              //     style: AppTextStyles.headline1,
                              //     scrollAxis: Axis.horizontal,
                              //     crossAxisAlignment: CrossAxisAlignment.start,
                              //     blankSpace: 20.0,
                              //     velocity: 50.0,
                              //     startAfter: const Duration(seconds: 1),
                              //     pauseAfterRound: const Duration(seconds: 1),
                              //   ),
                              // ),

                              BlocBuilder<PlayerBloc, PlayerStateApp>(
                                // buildWhen: (previous, current) =>
                                // previous.currentTrackIndex !=
                                // current.currentTrackIndex,
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
                                              .name.trim(),
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

                              // BlocBuilder<PlayerBloc, PlayerStateApp>(
                              //     buildWhen: (previous, current) =>
                              //         previous.currentTrackIndex !=
                              //         current.currentTrackIndex,
                              //     builder: (context, state) {
                              //       if (state.trackList.isNotEmpty) {
                              //         // return Container(
                              //         //   width: 200,
                              //         //   child: ConditionalMarquee(
                              //         //     text: state
                              //         //         .trackList[state.currentTrackIndex]
                              //         //         .name,
                              //         //     style: AppTextStyles.headline1,
                              //         //   ),
                              //         // );
                              //         return Text(
                              //           state.trackList[state.currentTrackIndex]
                              //               .name,
                              //           style: AppTextStyles.headline1,
                              //           maxLines: 1,
                              //           overflow: TextOverflow.ellipsis,
                              //         );
                              //       }
                              //       return Container();
                              //       // return const Skeletonizer(
                              //       //   child: Text(
                              //       //     "kusgifsef",
                              //       //     style: AppTextStyles.headline1,
                              //       //     maxLines: 1,
                              //       //     overflow: TextOverflow.ellipsis,
                              //       //   ),
                              //       // );
                              //     }),

                              const SizedBox(
                                height: 2,
                              ),
                              BlocBuilder<PlayerBloc, PlayerStateApp>(
                                // buildWhen: (previous, current) =>
                                //     previous.currentTrackIndex !=
                                //     current.currentTrackIndex,
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
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Padding(
                                padding:
                                    const EdgeInsets.only(top: 5, left: 12),
                                child: BlocBuilder<PlayerBloc, PlayerStateApp>(
                                  buildWhen: (previous, current) =>
                                      previous.indexFragment !=
                                          current.indexFragment ||
                                      previous.isTimeStamps !=
                                          current.isTimeStamps,
                                  builder: (context, state) {
                                    return AnimatedSwitcher(
                                      duration:
                                          const Duration(milliseconds: 300),
                                      child: Align(
                                        key: ValueKey<String>(state.isTimeStamps
                                            ? state.fragmentsNames[
                                                state.indexFragment]
                                            : ""),
                                        alignment: Alignment
                                            .centerLeft, // или нужное выравнивание
                                        child: Text(
                                          state.isTimeStamps
                                              ? state.fragmentsNames[
                                                  state.indexFragment]
                                              : "",
                                          style:
                                              AppTextStyles.bodyPrice1.copyWith(
                                            fontSize: 12,
                                            color: Colors.white,
                                            height: 1.375,
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.only(top: 5),
                              child: Container(
                                height: 54,
                                margin:
                                    const EdgeInsets.symmetric(horizontal: 16),
                                child: GestureDetector(
                                  onTapDown: (details) {
                                    final RenderBox box =
                                        context.findRenderObject() as RenderBox;

                                    final Offset localPosition = box
                                        .globalToLocal(details.globalPosition);

                                    final double percent =
                                        localPosition.dx / box.size.width;

                                    // final duration = context
                                    //     .read<PlayerBloc>()
                                    //     .player
                                    //     .duration;

                                    // if (duration != null) {
                                    //   final position =
                                    //       duration.inMilliseconds * percent;
                                    //   sl<PlayerBloc>().player.seek(
                                    //         Duration(
                                    //             milliseconds: position.round()),
                                    //       );
                                    // }
                                  },
                                  onHorizontalDragUpdate: (details) {
                                    final RenderBox box =
                                        context.findRenderObject() as RenderBox;
                                    final Offset localPosition = box
                                        .globalToLocal(details.globalPosition);
                                    final double percent =
                                        (localPosition.dx / box.size.width)
                                            .clamp(0.0, 1.0);

                                    sl<PlayerBloc>().add(
                                      UpdateDragProgressEvent(percent),
                                    );
                                  },
                                  onHorizontalDragEnd: (details) {
                                    final duration = context
                                        .read<PlayerBloc>()
                                        .player
                                        .duration;
                                    final progress = context
                                        .read<PlayerBloc>()
                                        .state
                                        .dragProgress;

                                    if (duration != null && progress != null) {
                                      final position =
                                          duration.inMilliseconds * progress;

                                      sl<PlayerBloc>().player.seek(
                                            Duration(
                                                milliseconds: position.round()),
                                          );
                                    }
                                    sl<PlayerBloc>().add(
                                      UpdateDragProgressEvent(null),
                                    );
                                  },
                                  child:
                                      BlocBuilder<PlayerBloc, PlayerStateApp>(
                                    buildWhen: (previous, current) =>
                                        previous.progress != current.progress ||
                                        previous.waveformData !=
                                            current.waveformData,
                                    builder: (context, state) {
                                      return AnimatedSwitcher(
                                        duration:
                                            const Duration(milliseconds: 300),
                                        transitionBuilder: (Widget child,
                                            Animation<double> animation) {
                                          return FadeTransition(
                                            opacity: animation,
                                            child: child,
                                          );
                                        },
                                        child: CustomPaint(
                                          key: ValueKey(
                                              state.waveformData.hashCode),
                                          painter: WaveformPainter(
                                            waveformData: state.waveformData,
                                            progress: state.dragProgress != null
                                                ? state.dragProgress!
                                                : state.progress,
                                            fixedWaveColor:
                                                Colors.white.withOpacity(0.4),
                                            liveWaveColor: Colors.white,
                                            spacing: 4,
                                            scaleFactor: 54,
                                            waveCap: StrokeCap.round,
                                          ),
                                          size: Size(
                                            MediaQuery.of(context).size.width -
                                                32,
                                            100,
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ),
                            ),
                            // Padding(
                            //   padding: const EdgeInsets.only(
                            //       top: 5, left: 12, right: 12),
                            //   child: BlocBuilder<PlayerBloc, PlayerStateApp>(
                            //     builder: (context, state) {
                            //       final player =
                            //           di.sl<PlayerBloc>().player;
                            //       final position = player.position;
                            //       final duration = player.duration;

                            //       final currentSeconds = position.inSeconds;
                            //       final totalSeconds = duration?.inSeconds ?? 0;

                            //       return Row(
                            //         mainAxisAlignment:
                            //             MainAxisAlignment.spaceBetween,
                            //         children: [
                            //           Text(
                            //             "${(currentSeconds ~/ 60).toString().padLeft(2, '0')}:${(currentSeconds % 60).toString().padLeft(2, '0')}",
                            //             style: AppTextStyles.timePlayer,
                            //           ),
                            //           Text(
                            //             "${(totalSeconds ~/ 60).toString().padLeft(2, '0')}:${(totalSeconds % 60).toString().padLeft(2, '0')}",
                            //             style: AppTextStyles.timePlayer,
                            //           )
                            //         ],
                            //       );
                            //     },
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
                        Positioned(
                          left: 12,
                          bottom: 14,
                          child: BlocBuilder<PlayerBloc, PlayerStateApp>(
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
                                        state.trackList[state.currentTrackIndex]
                                            .bpm
                                            .toString(),
                                        style:
                                            AppTextStyles.timePlayer.copyWith(
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
                                        state.trackList[state.currentTrackIndex].tune,
                                        style:
                                            AppTextStyles.timePlayer.copyWith(
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
                          ),
                        ),
                        BlocBuilder<PlayerBloc, PlayerStateApp>(
                          builder: (context, state) {
                            return Positioned(
                              right: 4,
                              bottom: 2,
                              child: IconButton(
                                onPressed: () {
                                  final router = context.router;
                                  final beatId = state
                                      .trackList[state.currentTrackIndex].id;

                                  context.maybePop().then((_) {
                                    Future.delayed(
                                            const Duration(milliseconds: 300))
                                        .then((_) {
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
                        ),
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

class ColorListTween extends Tween<List<Color>> {
  ColorListTween(List<Color> begin, List<Color> end)
      : super(begin: begin, end: end);

  @override
  List<Color> lerp(double t) {
    return List.generate(begin!.length, (index) {
      return Color.lerp(
          begin![index], end![index], t)!; // Interpolating each color
    });
  }
}