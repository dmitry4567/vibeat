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
import 'package:vibeat/info_beatmaker/info_beatmaker.dart';
import 'package:vibeat/player/bloc/player_bloc.dart';
import 'package:vibeat/search.dart';
import 'package:vibeat/utils/theme.dart';

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
                onPressed: toggleGridType,
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
                sliver: _FavoriteContent(
                  grid: grid,
                  paddingWidth: paddingWidth,
                  gridItemWidth: gridItemWidth,
                  width: width,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _FavoriteContent extends StatelessWidget {
  final bool grid;
  final double paddingWidth;
  final double gridItemWidth;
  final double width;

  const _FavoriteContent({
    required this.grid,
    required this.paddingWidth,
    required this.gridItemWidth,
    required this.width,
  });

  @override
  Widget build(BuildContext context) {
    return BlocSelector<FavoriteBloc, FavoriteState, List<BeatModel>>(
      selector: (state) {
        // Выбираем только список битов, игнорируем другие изменения состояния
        if (state is FavoriteBeatsLoaded) {
          return state.favoriteBeats;
        }
        return [];
      },
      builder: (context, favoriteBeats) {
        if (favoriteBeats.isEmpty) {
          return _buildEmptyState();
        }

        return grid
            ? _buildGridView(favoriteBeats)
            : _buildListView(favoriteBeats);
      },
    );
  }

  Widget _buildEmptyState() {
    return const SliverFillRemaining(
      hasScrollBody: false,
      child: Center(
        child: Text(
          "Нет данных",
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }

  Widget _buildGridView(List<BeatModel> favoriteBeats) {
    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: 18.0),
      sliver: SliverGrid(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisExtent: gridItemWidth + 71,
          crossAxisSpacing: 20,
          mainAxisSpacing: 20,
        ),
        delegate: SliverChildBuilderDelegate(
          childCount: favoriteBeats.length,
          (context, index) {
            return Skeletonizer(
              enabled: false,
              child: NewBeatWidget(
                openPlayer: () {
                  sl<PlayerBloc>().add(
                    PlayCurrentBeatEvent(favoriteBeats, index),
                  );
                  context.router.navigate(const PlayerRoute());
                },
                openInfoBeat: () {
                  context.router.navigate(
                    InfoBeatRoute(beatId: favoriteBeats[index].id),
                  );
                },
                openInfoBeatmaker: () {
                  context.router.navigate(
                    InfoBeatmakerRoute(
                      beatmakerId: favoriteBeats[index].beatmakerId,
                    ),
                  );
                },
                index: index,
                width: width,
                marginRight: 0,
                gridItemWidth: gridItemWidth,
                isLoading: false,
                beat: favoriteBeats[index],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildListView(List<BeatModel> favoriteBeats) {
    return BlocSelector<PlayerBloc, PlayerStateApp, String?>(
      selector: (state) => state.currentTrackBeatId,
      builder: (context, currentTrackBeatId) {
        return SliverList.builder(
          addAutomaticKeepAlives: false,
          addRepaintBoundaries: false,
          itemCount: favoriteBeats.length,
          itemBuilder: (context, index) {
            final playerBloc = sl<PlayerBloc>();

            return Skeletonizer(
              enabled: false,
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () {
                    playerBloc.add(
                      PlayCurrentBeatEvent(favoriteBeats, index),
                    );
                  },
                  child: BeatRowWidget(
                    key: ValueKey(favoriteBeats[index].id),
                    index: index,
                    isCurrentPlaying: favoriteBeats[index].id == currentTrackBeatId,
                    beat: favoriteBeats[index],
                    buttonMore: true,
                    funcMore: () {},
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}