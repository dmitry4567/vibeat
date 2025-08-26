import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:vibeat/app/app_router.gr.dart';
import 'package:vibeat/filter/result.dart';
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
    final size = MediaQuery.of(context).size;
    const paddingWidth = 18.0;
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
      body: Padding(
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
                      child: BeatWidget(
                        gridItemWidth: gridItemWidth,
                        beat: widget.beats[index],
                      ),
                    );
                  },
                ),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisExtent: gridItemWidth + 67,
                  crossAxisSpacing: 20,
                  mainAxisSpacing: 20,
                ),
              ),
            ),
          ],
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
                context.router.push(const InfoBeatmaker());
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
