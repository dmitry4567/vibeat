import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:vibeat/app/app_router.gr.dart';
import 'package:vibeat/app/injection_container.dart';
import 'package:vibeat/core/constants/strings.dart';
import 'package:vibeat/core/hooks/grid_type.dart';
import 'package:vibeat/features/favorite/data/models/beat_model.dart';
import 'package:vibeat/info_beatmaker/info_beatmaker.dart';
import 'package:vibeat/player/bloc/player_bloc.dart';
import 'package:vibeat/search.dart';
import 'package:vibeat/utils/theme.dart';

@RoutePage()
class PlaylistScreen extends StatefulWidget {
  const PlaylistScreen({
    super.key,
    required this.title,
    required this.beats,
  });

  final String title;
  final List<BeatModel> beats;

  @override
  State<PlaylistScreen> createState() => _PlaylistScreenState();
}

class _PlaylistScreenState extends State<PlaylistScreen> {
  @override
  Widget build(BuildContext context) {
    const double paddingWidth = 18.0;

    final size = MediaQuery.of(context).size;
    final width = size.width * 0.38;
    final gridItemWidth = (size.width - paddingWidth * 2 - 20) / 2;

    return HookBuilder(builder: (context) {
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
          title: Text(
            widget.title,
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
        body: Scrollbar(
          thumbVisibility: false,
          trackVisibility: true,
          interactive: true,
          child: Padding(
            padding: const EdgeInsets.only(top: 8),
            child: CustomScrollView(
              slivers: [
                grid
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
                            childCount: widget.beats.length,
                            (context, index) {
                              return Skeletonizer(
                                enabled: false,
                                child: NewBeatWidget(
                                  openPlayer: () {
                                    sl<PlayerBloc>().add(PlayCurrentBeatEvent(
                                        widget.beats, index));

                                    context.router
                                        .navigate(const PlayerRoute());
                                  },
                                  openInfoBeat: () {
                                    context.router.navigate(
                                      InfoBeatRoute(
                                        beatId: widget.beats[index].id,
                                      ),
                                    );
                                  },
                                  openInfoBeatmaker: () {
                                    context.router.navigate(
                                      InfoBeatmakerRoute(
                                        beatmakerId:
                                            widget.beats[index].beatmakerId,
                                      ),
                                    );
                                  },
                                  index: index,
                                  width: width,
                                  marginRight: 0,
                                  gridItemWidth: gridItemWidth,
                                  isLoading: false,
                                  beat: widget.beats[index],
                                ),
                              );
                            },
                          ),
                        ),
                      )
                    : SliverList.builder(
                        itemCount: widget.beats.length,
                        itemBuilder: (context, index) {
                          return Skeletonizer(
                            enabled: false,
                            child: Material(
                              color: Colors.transparent,
                              child: InkWell(
                                onTap: () {
                                  sl<PlayerBloc>().add(
                                    PlayCurrentBeatEvent(
                                      widget.beats,
                                      index,
                                    ),
                                  );

                                  // context.router.navigate(const PlayerRoute());
                                },
                                child: BeatRowWidget(
                                  index: index,
                                  isCurrentPlaying: false,
                                  beat: widget.beats[index],
                                  buttonMore: true,
                                  funcMore: () {},
                                ),
                              ),
                            ),
                          );
                        },
                      ),
              ],
            ),
          ),
        ),
      );
    });
  }
}
