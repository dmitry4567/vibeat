import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:vibeat/app/app_router.gr.dart';
import 'package:vibeat/app/injection_container.dart';
import 'package:vibeat/filter/result.dart';
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
  final List<BeatEntity> beats;

  @override
  State<PlaylistScreen> createState() => _PlaylistScreenState();
}

class _PlaylistScreenState extends State<PlaylistScreen> {
  @override
  Widget build(BuildContext context) {
    const double paddingWidth = 18.0;
    const double marginRight = 20.0;

    final size = MediaQuery.of(context).size;
    final width = size.width * 0.38;
    final gridItemWidth = (size.width - paddingWidth * 2 - 20) / 2;
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.appbar,
        forceMaterialTransparency: true,
        title: Text(
          widget.title,
          style: AppTextStyles.bodyAppbar,
        ),
      ),
      body: Scrollbar(
        thumbVisibility: false,
        trackVisibility: true,
        interactive: true,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: paddingWidth),
          child: CustomScrollView(
            slivers: [
              SliverPadding(
                padding: const EdgeInsets.only(top: 8, bottom: 80),
                sliver: SliverGrid(
                  delegate: SliverChildBuilderDelegate(
                    childCount: widget.beats.length,
                    (context, index) {
                      return Skeletonizer(
                        enabled: false,
                        child: NewBeatWidget(
                          openPlayer: () {
                            sl<PlayerBloc>()
                                .add(PlayCurrentBeatEvent(widget.beats, index));

                            context.router.navigate(const PlayerRoute());
                          },
                          beat: widget.beats[index],
                          index: index,
                          width: width,
                          marginRight: 0,
                          gridItemWidth: gridItemWidth,
                          isLoading: false,
                        ),
                      );
                    },
                  ),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisExtent: gridItemWidth + 71,
                    crossAxisSpacing: 20,
                    mainAxisSpacing: 20,
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

class BeatWidget extends StatelessWidget {
  final double gridItemWidth;
  final BeatEntity beat;

  const BeatWidget({
    super.key,
    required this.gridItemWidth,
    required this.beat,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        context.router.push(InfoBeat(
          beatId: beat.id,
        ));
      },
      child: ClipRRect(
        borderRadius: const BorderRadius.all(
          Radius.circular(6),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image.asset(
            //   fit: BoxFit.fitWidth,
            //   width: gridItemWidth,
            //   "assets/images/image1.png",
            // ),
            Image.network(
              fit: BoxFit.fitHeight,
              width: gridItemWidth,
              height: gridItemWidth,
              beat.picture,
              // loadingBuilder: (context, child, loadingProgress) => Skeletonizer(
              //   enabled: true,
              //   child: ClipRRect(
              //     borderRadius: const BorderRadius.all(Radius.circular(6)),
              //     child: Container(
              //       width: gridItemWidth,
              //       height: gridItemWidth,
              //       color: Colors.red,
              //     ),
              //   ),
              // ),
            ),
            const SizedBox(height: 6),
            Text(
              "${beat.price} RUB",
              style: AppTextStyles.bodyPrice2,
            ),
            Text(
              beat.name,
              style: AppTextStyles.headline1,
              overflow: TextOverflow.ellipsis,
            ),
            GestureDetector(
              onTap: () {
                context.router
                    .push(InfoBeatmaker(beatmakerId: beat.beatmakerId));
              },
              child: Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Row(
                        children: [
                          const SizedBox(
                            width: 12,
                            height: 12,
                            child: CircleAvatar(
                              backgroundImage: NetworkImage(
                                'https://mimigram.ru/wp-content/uploads/2020/07/chto-takoe-foto.jpg',
                              ),
                            ),
                          ),
                          const SizedBox(width: 4),
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
                              beat.plays.toString(),
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
    );
  }
}
