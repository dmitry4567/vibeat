import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:vibeat/app/app_router.gr.dart';
import 'package:vibeat/app/injection_container.dart';
import 'package:vibeat/core/constants/strings.dart';
import 'package:vibeat/core/hooks/grid_type.dart';
import 'package:vibeat/features/favorite/data/models/beat_model.dart';
import 'package:vibeat/features/favorite/presentation/bloc/favorite_bloc.dart';
import 'package:vibeat/player/bloc/player_bloc.dart';
import 'package:vibeat/utils/theme.dart';
import 'package:vibeat/widgets/beat_widget.dart';

@RoutePage()
class FavoriteScreen extends StatefulWidget {
  const FavoriteScreen({super.key});

  @override
  State<FavoriteScreen> createState() => _FavoriteScreenState();
}

class _FavoriteScreenState extends State<FavoriteScreen> {
  @override
  void initState() {
    super.initState();

    context.read<FavoriteBloc>().add(GetFavoriteBeatsEvent());
  }

  @override
  Widget build(BuildContext context) {
    const double paddingWidth = 18.0;

    final size = MediaQuery.of(context).size;
    final width = size.width * 0.38;
    final gridItemWidth = (size.width - paddingWidth * 2 - 20) / 2;

    return HookBuilder(
      builder: (context) {
        final (grid, toggleGridType, setGridType) = useSharedPrefBool(
          AppStrings.gridType,
          defaultValue: false,
        );

        return Scaffold(
          backgroundColor: AppColors.background,
          appBar: AppBar(
            centerTitle: true,
            backgroundColor: AppColors.appbar,
            forceMaterialTransparency: true,
            title: const Text(
              "Избранное",
              style: AppTextStyles.bodyAppbar,
            ),
            actions: [
              IconButton(
                onPressed: () {
                  toggleGridType();
                },
                icon: Icon(
                  grid ? Icons.grid_view : Icons.format_list_bulleted,
                ),
              ),
            ],
          ),
          body: CustomScrollView(
            slivers: [
              SliverPadding(
                padding: const EdgeInsets.only(top: 8, bottom: 80),
                sliver: BlocBuilder<FavoriteBloc, FavoriteState>(
                  builder: (context, state) {
                    if (state is FavoriteBeatsLoaded) {
                      if (state.favoriteBeats.isEmpty) {
                        return const SliverFillRemaining(
                          hasScrollBody: false,
                          child: Center(
                            child: Text(
                              "Нет данных",
                              style: TextStyle(
                                color: Colors.white,
                              ),
                            ),
                          ),
                        );
                      } else {
                        return grid
                            ? SliverPadding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: paddingWidth),
                                sliver: SliverGrid(
                                  gridDelegate:
                                      SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 2,
                                    mainAxisExtent: gridItemWidth + 71,
                                    crossAxisSpacing: 20,
                                    mainAxisSpacing: 20,
                                  ),
                                  delegate: SliverChildBuilderDelegate(
                                    childCount: state.favoriteBeats.length,
                                    (context, index) {
                                      return Skeletonizer(
                                        enabled: false,
                                        child: NewBeatWidget(
                                          openPlayer: () {
                                            sl<PlayerBloc>().add(
                                                PlayCurrentBeatEvent(
                                                    state.favoriteBeats,
                                                    index));

                                            context.router
                                                .navigate(const PlayerRoute());
                                          },
                                          openInfoBeat: () {
                                            context.router.navigate(
                                              InfoBeat(
                                                beatId: state
                                                    .favoriteBeats[index].id,
                                              ),
                                            );
                                          },
                                          index: index,
                                          width: width,
                                          marginRight: 0,
                                          gridItemWidth: gridItemWidth,
                                          isLoading: false,
                                          beat: state.favoriteBeats[index],
                                          typeOfBeat: TypeOfBeat.favoritebeat,
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              )
                            : SliverList.builder(
                                itemCount: state.favoriteBeats.length,
                                itemBuilder: (context, index) {
                                  return Skeletonizer(
                                    enabled: false,
                                    child: Material(
                                      color: Colors.transparent,
                                      child: InkWell(
                                        onTap: () {
                                          sl<PlayerBloc>().add(
                                            PlayCurrentBeatEvent(
                                              state.favoriteBeats,
                                              index,
                                            ),
                                          );

                                          // context.router.navigate(const PlayerRoute());
                                        },
                                        child: BeatRowWidget(
                                          index: index,
                                          isCurrentPlaying: false,
                                          beat: state.favoriteBeats[index],
                                          buttonMore: true,
                                          funcMore: () {},
                                          typeOfBeat: TypeOfBeat.favoritebeat,
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              );
                      }
                    } else if (state is GettingFavoritesBeats) {
                      return grid
                          ? SliverPadding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: paddingWidth),
                              sliver: SliverGrid(
                                gridDelegate:
                                    SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2,
                                  mainAxisExtent: gridItemWidth + 71,
                                  crossAxisSpacing: 20,
                                  mainAxisSpacing: 20,
                                ),
                                delegate: SliverChildBuilderDelegate(
                                  childCount: 4,
                                  (context, index) {
                                    return Skeletonizer(
                                      enabled: true,
                                      child: NewBeatWidget(
                                        openPlayer: () {},
                                        openInfoBeat: () {},
                                        index: index,
                                        width: width,
                                        marginRight: 0,
                                        gridItemWidth: gridItemWidth,
                                        isLoading: true,
                                        beat: BeatModel.placeholder(),
                                        typeOfBeat: TypeOfBeat.favoritebeat,
                                      ),
                                    );
                                  },
                                ),
                              ),
                            )
                          : SliverList.builder(
                              itemCount: 4,
                              itemBuilder: (context, index) {
                                return Skeletonizer(
                                  enabled: true,
                                  child: InkWell(
                                    onTap: () {},
                                    child: BeatRowWidget(
                                      index: index,
                                      isCurrentPlaying: false,
                                      beat: BeatModel.placeholder(),
                                      buttonMore: true,
                                      funcMore: () {},
                                      typeOfBeat: TypeOfBeat.favoritebeat,
                                    ),
                                  ),
                                );
                              },
                            );
                    } else if (state is FavoriteBeatsNoInternetError) {
                      return const SliverFillRemaining(
                        hasScrollBody: false,
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.signal_wifi_connected_no_internet_4,
                                size: 60,
                              ),
                              SizedBox(
                                height: 4,
                              ),
                              Text(
                                "Нет подключения к интернету",
                                style: TextStyle(
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }
                    return const SliverToBoxAdapter();
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

// Scrollbar(
//         thumbVisibility: false,
//         trackVisibility: true,
//         interactive: true,
//         child:
