import 'dart:math';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:super_context_menu/super_context_menu.dart';
import 'package:vibeat/app/app_router.gr.dart';
import 'package:vibeat/features/favorite/data/models/beat_model.dart';
import 'package:vibeat/features/favorite/presentation/bloc/favorite_bloc.dart';
import 'package:vibeat/utils/theme.dart';

enum TypeOfBeat {
  defaultBeat,
  favoritebeat,
}

Menu defaultBeat(BuildContext context, BeatModel beat) => Menu(
      children: [
        MenuAction(
          title: 'Перейти к битмейкеру',
          image: MenuImage.icon(
            Icons.person_outline,
          ),
          callback: () async {
            await Future.delayed(
              const Duration(
                milliseconds: 300,
              ),
            );
            WidgetsBinding.instance.addPostFrameCallback((_) {
              context.pushRoute(
                InfoBeatmaker(
                  beatmakerId: beat.beatmakerId,
                ),
              );
            });
          },
        ),
        MenuSeparator(),
        MenuAction(
          title: 'Поделится битом',
          image: MenuImage.icon(
            Icons.ios_share,
          ),
          callback: () {},
        ),
        MenuAction(
          title: 'Перейти к биту',
          image: MenuImage.icon(
            Icons.music_note_outlined,
          ),
          callback: () async {
            await Future.delayed(
              const Duration(
                milliseconds: 300,
              ),
            );
            WidgetsBinding.instance.addPostFrameCallback((_) {
              context.pushRoute(
                InfoBeat(
                  beatId: beat.id,
                ),
              );
            });
          },
        ),
      ],
    );

Menu favoriteBeat(BuildContext context, BeatModel beat) => Menu(
      children: [
        MenuAction(
          title: 'Перейти к битмейкеру',
          image: MenuImage.icon(
            Icons.person_outline,
          ),
          callback: () async {
            await Future.delayed(
              const Duration(
                milliseconds: 300,
              ),
            );
            WidgetsBinding.instance.addPostFrameCallback((_) {
              context.pushRoute(
                InfoBeatmaker(
                  beatmakerId: beat.beatmakerId,
                ),
              );
            });
          },
        ),
        MenuSeparator(),
        MenuAction(
          title: 'Поделится битом',
          image: MenuImage.icon(
            Icons.ios_share,
          ),
          callback: () {},
        ),
        MenuAction(
          title: 'Перейти к биту',
          image: MenuImage.icon(
            Icons.music_note_outlined,
          ),
          callback: () async {
            await Future.delayed(
              const Duration(
                milliseconds: 300,
              ),
            );
            WidgetsBinding.instance.addPostFrameCallback((_) {
              context.pushRoute(
                InfoBeat(beatId: beat.id),
              );
            });
          },
        ),
        MenuSeparator(),
        MenuAction(
          title: 'Удалить из избранного',
          image: MenuImage.icon(
            Icons.delete_outline,
          ),
          callback: () async {
            await Future.delayed(
              const Duration(
                milliseconds: 300,
              ),
            );
            WidgetsBinding.instance.addPostFrameCallback((_) {
              context.read<FavoriteBloc>().add(
                    DeleteFavoriteEvent(beatId: beat.id),
                  );
            });
          },
        ),
      ],
    );

class NewBeatWidget extends StatelessWidget {
  final BeatModel beat;
  final int index;
  final double width;
  final double marginRight;
  final double gridItemWidth;
  final bool isLoading;
  final VoidCallback openPlayer;
  final VoidCallback openInfoBeat;
  final TypeOfBeat typeOfBeat;

  const NewBeatWidget({
    super.key,
    required this.beat,
    required this.index,
    required this.width,
    required this.marginRight,
    required this.gridItemWidth,
    required this.isLoading,
    required this.openPlayer,
    required this.openInfoBeat,
    required this.typeOfBeat,
  });

  @override
  Widget build(BuildContext context) {
    Random random = Random();

    return ContextMenuWidget(
      child: ClipRRect(
        borderRadius: const BorderRadius.all(Radius.circular(6)),
        child: Container(
          margin: EdgeInsets.only(right: marginRight),
          width: width,
          color: AppColors.background,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GestureDetector(
                onTap: openPlayer,
                child: ClipRRect(
                  borderRadius: const BorderRadius.all(Radius.circular(6)),
                  child: Image.network(
                    fit: BoxFit.fitHeight,
                    width: gridItemWidth,
                    height: gridItemWidth - marginRight,
                    beat.picture,
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) {
                        return child;
                      }
                      return Skeletonizer(
                        enabled: true,
                        child: ClipRRect(
                          borderRadius:
                              const BorderRadius.all(Radius.circular(6)),
                          child: SizedBox(
                            width: gridItemWidth,
                            height: gridItemWidth - marginRight,
                          ),
                        ),
                      );
                    },
                    errorBuilder: (context, error, stackTrace) {
                      return !isLoading
                          ? ClipRRect(
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(6)),
                              child: Container(
                                width: gridItemWidth,
                                height: gridItemWidth - marginRight,
                                color: Colors.grey,
                                child: const Icon(Icons.error),
                              ),
                            )
                          : ClipRRect(
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(6)),
                              child: Container(
                                width: gridItemWidth,
                                height: gridItemWidth - marginRight,
                                color: Colors.grey,
                              ),
                            );
                    },
                  ),
                ),
              ),
              // Image.asset(
              //   fit: BoxFit.fitWidth,
              //   width: width,
              //   "assets/images/image1.png",
              // ),
              GestureDetector(
                onTap: openInfoBeat,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 4),
                    Text(
                      "${getRandomNumber(10, 20) * 100} RUB",
                      style: AppTextStyles.bodyPrice2,
                    ),
                    Text(
                      beat.name,
                      style: AppTextStyles.headline1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),

              GestureDetector(
                onTap: () {
                  context.router
                      .navigate(InfoBeatmaker(beatmakerId: beat.beatmakerId));
                },
                child: Padding(
                  padding: const EdgeInsets.only(top: 6),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Row(
                          children: [
                            // isLoading
                            //     ? ClipRRect(
                            //         borderRadius: const BorderRadius.all(
                            //             Radius.circular(6)),
                            //         child: Container(
                            //           width: 12,
                            //           height: 12,
                            //           color: Colors.grey,
                            //         ),
                            //       )
                            //     : ClipRRect(
                            //         borderRadius: const BorderRadius.all(
                            //             Radius.circular(6)),
                            //         child: Image.network(
                            //           fit: BoxFit.fitHeight,
                            //           width: 12,
                            //           height: 12,
                            //           'https://mimigram.ru/wp-content/uploads/2020/07/chto-takoe-foto.jpg',
                            //           loadingBuilder:
                            //               (context, child, loadingProgress) {
                            //             if (loadingProgress == null) {
                            //               return child;
                            //             }
                            //             return Skeletonizer(
                            //               enabled: true,
                            //               child: ClipRRect(
                            //                 borderRadius: const BorderRadius.all(
                            //                     Radius.circular(6)),
                            //                 child: Container(
                            //                   width: 12,
                            //                   height: 12,
                            //                   color: Colors.black,
                            //                 ),
                            //               ),
                            //             );
                            //           },
                            //           errorBuilder: (context, error, stackTrace) {
                            //             return ClipRRect(
                            //               borderRadius: const BorderRadius.all(
                            //                   Radius.circular(6)),
                            //               child: Container(
                            //                 width: 12,
                            //                 height: 12,
                            //                 color: Colors.black,
                            //               ),
                            //             );
                            //           },
                            //         ),
                            //       ),
                            // const SizedBox(width: 4),
                            Expanded(
                              child: Container(
                                padding: const EdgeInsets.only(
                                  right: 5,
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const SizedBox(height: 2),
                                    Text(
                                      beat.beatmakerName == ''
                                          ? "beatmaker1"
                                          : beat.beatmakerName,
                                      style: AppTextStyles.bodyText2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Row(
                        children: [
                          Icon(
                            Icons.volume_down_outlined,
                            size: 12,
                            color: AppColors.unselectedItemColor,
                          ),
                          Column(
                            children: [
                              const SizedBox(height: 1),
                              Text(
                                random.nextInt(1000).toString(),
                                style: AppTextStyles.bodyText2
                                    .copyWith(fontSize: 10),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      menuProvider: (_) {
        switch (typeOfBeat) {
          case TypeOfBeat.defaultBeat:
            return defaultBeat(context, beat);
          case TypeOfBeat.favoritebeat:
            return favoriteBeat(context, beat);
        }
      },
    );
  }
}

class BeatRowWidget extends StatelessWidget {
  BeatRowWidget({
    super.key,
    required this.index,
    required this.isCurrentPlaying,
    required this.beat,
    required this.buttonMore,
    required this.typeOfBeat,
    this.funcMore,
  });

  final int index;
  final bool isCurrentPlaying;
  final BeatModel beat;
  final TypeOfBeat typeOfBeat;
  bool buttonMore = false;
  VoidCallback? funcMore;

  @override
  Widget build(BuildContext context) {
    return ContextMenuWidget(
      child: Container(
        color: isCurrentPlaying
            ? Colors.white.withOpacity(0.08)
            : AppColors.background,
        padding: const EdgeInsets.only(
          left: 18,
          // right: 18,
          top: 10,
          bottom: 10,
        ),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.all(Radius.circular(6)),
              child: Image.network(
                fit: BoxFit.fitHeight,
                width: 60,
                height: 60,
                beat.picture,
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) {
                    return child;
                  }
                  return const Skeletonizer(
                    enabled: true,
                    child: ClipRRect(
                      borderRadius: BorderRadius.all(Radius.circular(6)),
                      child: SizedBox(
                        width: 60,
                        height: 60,
                      ),
                    ),
                  );
                },
                errorBuilder: (context, error, stackTrace) {
                  return ClipRRect(
                    borderRadius: const BorderRadius.all(Radius.circular(6)),
                    child: Container(
                      width: 60,
                      height: 60,
                      color: Colors.grey,
                    ),
                  );
                },
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Text(
                    "${beat.price} RUB",
                    style: AppTextStyles.bodyPrice2.copyWith(height: 1),
                  ),
                  const SizedBox(height: 6),
                  SizedBox(
                    width: 280,
                    child: Text(
                      beat.name,
                      style: AppTextStyles.headline1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(height: 6),
                ],
              ),
            ),
            buttonMore
                ? IconButton(
                    onPressed: () {
                      // showModalBottomSheet(
                      //     context: context,
                      //     builder: (BuildContext context) {
                      //       return Container();
                      //     });
                    },
                    icon: const Icon(Icons.more_vert),
                  )
                : const SizedBox(),
          ],
        ),
      ),
      menuProvider: (_) {
        switch (typeOfBeat) {
          case TypeOfBeat.defaultBeat:
            return defaultBeat(context, beat);
          case TypeOfBeat.favoritebeat:
            return favoriteBeat(context, beat);
        }
      },
    );
  }
}

// GestureDetector(
//                                   onTap: () {},
//                                   child: Container(
//                                     width: 42,
//                                     height: 42,
//                                     decoration: BoxDecoration(
//                                       color: Colors.white.withOpacity(0.1),
//                                       shape: BoxShape.circle,
//                                     ),
//                                     alignment: AlignmentDirectional.center,
//                                     child: const Icon(
//                                       Icons.favorite_outline,
//                                       size: 20,
//                                     ),
//                                   ),
//                                 ),
//                                 const SizedBox(height: 6),
//                                 Text(
//                                   "0",
//                                   style: AppTextStyles.bodyAppbar.copyWith(
//                                     fontSize: 10,
//                                   ),
//                                 ),

int getRandomNumber(int min, int max) {
  Random random = Random();
  return min + random.nextInt(max - min + 1);
}
