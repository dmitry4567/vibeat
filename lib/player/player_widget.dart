import 'package:audio_waveforms/audio_waveforms.dart' as af;
import 'package:auto_route/auto_route.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:vibeat/player/bloc/player_bloc.dart';
import 'package:vibeat/player/widgets/conditionalMarquee.dart';
import 'package:vibeat/player/widgets/player_control_widget.dart';
import 'package:vibeat/utils/image_extractor.dart';

import '../utils/theme.dart';

@RoutePage()
class PlayerScreen extends StatefulWidget {
  const PlayerScreen({super.key});

  @override
  State<PlayerScreen> createState() => _PlayerScreenState();
}

class _PlayerScreenState extends State<PlayerScreen> {
  // static String host = "localhost";
  static String host = "192.168.0.136";

  List<String> listOfAudioUrl = [
    "http://$host:3000/music/1.wav",
    "http://$host:3000/music/2.wav",
    "http://$host:3000/music/3.wav",
    "http://$host:3000/music/4.wav",
    "http://$host:3000/music/5.wav",
  ];

  List<String> listOfPhotoUrl = [
    "http://$host:3000/photo/1.png",
    "http://$host:3000/photo/2.png",
    "http://$host:3000/photo/3.png",
    "http://$host:3000/photo/4.png",
    "http://$host:3000/photo/5.png",
  ];

  List<String> listOfName = [
    "Detroit",
    "Verno - icantluvv feat Goga",
    "Rany",
    "В руках",
    "на луне",
  ];

  List<String> listOfBitmaker = [
    "No name",
    "smokeynagato",
    "No name",
    "No name",
    "No name",
  ];

  List<String> listOfPrice = [
    "5000",
    "8000",
    "2000",
    "15000",
    "15000",
  ];

  List<int> fragmentsMusic = [0, 14, 24, 52, 62];

  List<String> fragmentsNames = ['Verse', 'Chorus', 'Verse', 'Verse', 'Chorus'];

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
  // List<Color> listOfColorsBackground = [];

  double? screenWidth;
  double? coverWidth;
  double? percentWidthCover;
  PageController _pageController = PageController();

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

  @override
  void initState() {
    super.initState();
    controller.stopPlayer();

    screenWidth = 390.0;
    coverWidth = 390 - 60.0;

    percentWidthCover = (coverWidth! * 100.0) / screenWidth!;

    _pageController = PageController(
      viewportFraction: percentWidthCover! / 100,
      initialPage: 0,
    );

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final currentIndex = context.read<PlayerBloc>().state.currentTrackIndex;

      _pageController.jumpToPage(currentIndex);
    });

    // _downloadAudioFile();
  }

  bool isDownloading = false;

  // Future<void> _downloadAudioFile() async {
  //   if (isDownloading) {
  //     if (kDebugMode) {
  //       print('Download already in progress, skipping duplicate call.');
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
  //     if (kDebugMode) print('Audio file already exists at: $path');
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
  //       if (kDebugMode) print('File downloaded and saved: $path');

  //       // Proceed to play the file after successful download
  //       await _playAudioFile(path);
  //     } else {
  //       throw Exception(
  //           'Failed to download audio file: ${response.statusCode}');
  //     }
  //   } catch (e) {
  //     if (kDebugMode) print('Error downloading audio file: $e');
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
  //     if (kDebugMode) print('Error preparing or starting the player: $e');
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
  //     print('Ошибка: $e');
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

  Future<void> _togglePreviousFragment() async {
    if (numberOfFragments > 0) {
      setState(() {
        numberOfFragments -= 1;
      });
      await controller.seekTo(fragmentsMusic[numberOfFragments] * 1100);
    }
  }

  Future<void> _toggleRepeat() async {
    setState(() {
      isRepeat = !isRepeat;
    });
  }

  Future<void> _toggleNextFragment() async {
    if (numberOfFragments < fragmentsNames.length - 1) {
      setState(() {
        numberOfFragments += 1;
      });
      await controller.seekTo(fragmentsMusic[numberOfFragments] * 1100);
    }
  }

  Future<void> _getColorsBackground(String imageUrl) async {
    List<Color> colors =
        await ImageExtractor().extractTopAndBottomCenterColors(imageUrl);

    setState(() {
      listOfColors.add([colors[0], colors[1]]);
      // listOfColorsBackground = colors;
    });
  }

  // @override
  // void dispose() {
  //   _pageController.dispose();
  //   controller.stopAllPlayers();
  //   super.dispose();
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        onVerticalDragUpdate: (details) {
          if (details.primaryDelta! > 20) {
            Navigator.of(context).pop();
          }
        },
        child: Stack(
          children: [
            Stack(
              children: [
                Positioned.fill(
                  child: TweenAnimationBuilder<List<Color>>(
                    duration: const Duration(milliseconds: 500),
                    tween: ColorListTween(
                      listOfColors[0],
                      listOfColors[currentAudioIndex],
                    ),
                    builder: (context, List<Color> colors, child) {
                      return Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: colors,
                          ),
                        ),
                      );
                    },
                  ),
                ),
                Positioned.fill(
                  child: Container(color: Colors.black.withOpacity(0.5)),
                ),
              ],
            ),
            Column(
              children: [
                Stack(
                  children: [
                    Positioned(
                      top: 0,
                      bottom: 0,
                      left: 0,
                      right: 0,
                      child: Container(
                        width: coverWidth,
                        height: coverWidth,
                        decoration: BoxDecoration(
                          color: Colors.transparent,
                          borderRadius: BorderRadius.circular(6.0),
                          boxShadow: const [
                            // BoxShadow(
                            //   color: Colors.white24,
                            //   blurRadius: 50,
                            //   spreadRadius: 0,
                            // ),
                          ],
                        ),
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(top: 90),
                      height: coverWidth,
                      child: BlocBuilder<PlayerBloc, PlayerState>(
                        buildWhen: (previous, current) {
                          return previous.trackList.length !=
                              current.trackList.length;
                        },
                        builder: (context, state) {
                          return PageView.builder(
                            controller: _pageController,
                            itemCount: state.trackList.length,
                            onPageChanged: (value) {
                              // if (value > state.currentTrackIndex &&
                              //     _pageController.page!.isFinite) {
                              //   context
                              //       .read<PlayerBloc>()
                              //       .add(NextTrackEvent());
                              // } else if (value < state.currentTrackIndex &&
                              //     _pageController.page!.isFinite) {
                              //   context
                              //       .read<PlayerBloc>()
                              //       .add(PreviousTrackEvent());
                              // }

                              // _pageController.nextPage(
                              //   duration: const Duration(milliseconds: 500),
                              //   curve: Curves.fastLinearToSlowEaseIn,
                              // );

                              // context.read<PlayerBloc>().add(NextTrack());

                              // await controller.stopPlayer();
                              // isPlaying = false;

                              // currentAudioIndex = value;

                              // _downloadAudioFile();
                              // _getColorsBackground(listOfPhotoUrl[currentAudioIndex]);
                            },
                            itemBuilder: (context, index) {
                              double scale =
                                  (index == _pageController.initialPage)
                                      ? 1.0
                                      : 0.9;
                              return AnimatedBuilder(
                                animation: _pageController,
                                builder: (context, child) {
                                  if (_pageController.position.haveDimensions) {
                                    double currentPage = _pageController.page ??
                                        _pageController.initialPage.toDouble();
                                    scale =
                                        (1 - (currentPage - index).abs() * 0.3)
                                            .clamp(0.9, 1.0);
                                  }
                                  return Transform.scale(
                                    scale: scale,
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(12.0),
                                      child: CachedNetworkImage(
                                        imageUrl:
                                            state.trackList[index].photoUrl,
                                        width: coverWidth,
                                        height: coverWidth,
                                        fit: BoxFit.cover,
                                        errorWidget:
                                            (context, imageUrl, error) =>
                                                Text(error.toString()),
                                      ),
                                    ),
                                  );
                                },
                              );
                            },
                          );
                        },
                      ),
                    ),
                  ],
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

                            BlocBuilder<PlayerBloc, PlayerState>(
                                buildWhen: (previous, current) =>
                                    previous.currentTrackIndex !=
                                    current.currentTrackIndex,
                                builder: (context, state) {
                                  return ConditionalMarquee(
                                    text: state
                                        .trackList[state.currentTrackIndex]
                                        .name,
                                    style: AppTextStyles.headline1,
                                  );
                                }),

                            const SizedBox(
                              height: 2,
                            ),
                            BlocBuilder<PlayerBloc, PlayerState>(
                              buildWhen: (previous, current) =>
                                  previous.currentTrackIndex !=
                                  current.currentTrackIndex,
                              builder: (context, state) {
                                return Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(top: 1),
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
                              },
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Row(
                          children: [
                            IconButton(
                              onPressed: () {},
                              icon: const Icon(
                                Icons.shopping_cart,
                              ),
                              color: AppColors.iconPrimary,
                            ),
                            IconButton(
                              onPressed: () {},
                              icon: const Icon(
                                Icons.favorite_border,
                              ),
                              color: AppColors.iconPrimary,
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
                PlayerControlWidget(pageController: _pageController),
                const SizedBox(height: 18),
                Container(
                  margin: const EdgeInsets.only(top: 18, left: 18, right: 18),
                  width: double.infinity,
                  height: 160,
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
                              padding: const EdgeInsets.only(top: 5, left: 12),
                              child: BlocBuilder<PlayerBloc, PlayerState>(
                                buildWhen: (previous, current) =>
                                    previous.indexFragment !=
                                    current.indexFragment,
                                builder: (context, state) {
                                  return Text(
                                    state.fragmentsNames[state.indexFragment],
                                    style: AppTextStyles.bodyPrice1.copyWith(
                                      fontSize: 12,
                                      color: Colors.white,
                                      height: 1.375,
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
                                  final Offset localPosition =
                                      box.globalToLocal(details.globalPosition);
                                  final double percent =
                                      localPosition.dx / box.size.width;
                                  final duration = context
                                      .read<PlayerBloc>()
                                      .player
                                      .duration;

                                  if (duration != null) {
                                    final position =
                                        duration.inMilliseconds * percent;
                                    context.read<PlayerBloc>().player.seek(
                                          Duration(
                                              milliseconds: position.round()),
                                        );
                                  }
                                },
                                onHorizontalDragUpdate: (details) {
                                  final RenderBox box =
                                      context.findRenderObject() as RenderBox;
                                  final Offset localPosition =
                                      box.globalToLocal(details.globalPosition);
                                  final double percent =
                                      (localPosition.dx / box.size.width)
                                          .clamp(0.0, 1.0);

                                  context.read<PlayerBloc>().add(
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
                                    context.read<PlayerBloc>().player.seek(
                                          Duration(
                                              milliseconds: position.round()),
                                        );
                                  }
                                  // context.read<PlayerBloc>().add(
                                  //        UpdateDragProgressEvent(null),
                                  //     );
                                },
                                child: BlocBuilder<PlayerBloc, PlayerState>(
                                    buildWhen: (previous, current) =>
                                        previous.progress / 100 !=
                                        current.progress / 100,
                                    builder: (context, state) {
                                      return CustomPaint(
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
                                            100),
                                      );
                                    }),
                              ),
                            ),
                          ),
                          // Padding(
                          //   padding: const EdgeInsets.only(
                          //       top: 5, left: 12, right: 12),
                          //   child: BlocBuilder<PlayerBloc, PlayerState>(
                          //     builder: (context, state) {
                          //       final player =
                          //           context.read<PlayerBloc>().player;
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
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                BlocBuilder<PlayerBloc, PlayerState>(
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
                                BlocBuilder<PlayerBloc, PlayerState>(
                                  buildWhen: (previous, current) =>
                                      previous.duration != current.duration,
                                  builder: (context, state) {
                                    final totalSeconds =
                                        state.duration?.inSeconds ?? 0;

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
                              GestureDetector(
                                onTap: () {
                                  context.read<PlayerBloc>().add(
                                        PreviousFragmentEvent(),
                                      );
                                },
                                child: SvgPicture.asset(
                                    "assets/svg/left_arrow.svg"),
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              // InkWell(
                              //   onTap: () {
                              //     context.read<PlayerBloc>().add(
                              //           ToggleLoopFragmentEvent(),
                              //         );
                              //   },
                              //   child: Container(
                              //     decoration: BoxDecoration(
                              //       color: state.loopCurrentFragment
                              //           ? Colors.white
                              //           : Colors.white.withOpacity(0.4),
                              //       borderRadius: const BorderRadius.all(
                              //           Radius.circular(12)),
                              //     ),
                              //     width: 64,
                              //     height: 47,
                              //     child: Icon(
                              //       Icons.repeat_one,
                              //       color: state.loopCurrentFragment
                              //           ? Colors.black.withOpacity(0.5)
                              //           : const Color.fromARGB(
                              //               255, 255, 255, 255),
                              //     ),
                              //   ),
                              // ),
                              const SizedBox(
                                width: 10,
                              ),
                              GestureDetector(
                                onTap: () {
                                  context.read<PlayerBloc>().add(
                                        NextFragmentEvent(),
                                      );
                                },
                                child: SvgPicture.asset(
                                    "assets/svg/right_arrow.svg"),
                              ),
                            ],
                          ),
                        ],
                      ),
                      Positioned(
                        left: 12,
                        bottom: 14,
                        child: Column(
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                SvgPicture.asset("assets/svg/bpm.svg"),
                                const SizedBox(
                                  width: 4,
                                ),
                                Text(
                                  "163",
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
                                  "Em",
                                  style: AppTextStyles.timePlayer.copyWith(
                                    color: Colors.white.withOpacity(0.8),
                                    fontSize: 12,
                                    height: 0.9,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Positioned(
                        right: 4,
                        bottom: 2,
                        child: IconButton(
                          onPressed: () async {},
                          icon: const Icon(Icons.info_outline),
                          color: AppColors.iconPrimary,
                        ),
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
