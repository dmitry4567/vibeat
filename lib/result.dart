import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:vibeat/utils/theme.dart';

@RoutePage()
class ResultScreen extends StatelessWidget {
  const ResultScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    const paddingWidth = 18.0;
    final gridItemWidth = (size.width - paddingWidth * 2 - 20) /
        2;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.appbar,
        forceMaterialTransparency: true,
        title: const Text(
          'Биты',
          style: AppTextStyles.bodyAppbar,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: paddingWidth),
        child: CustomScrollView(
          slivers: [
            SliverPersistentHeader(
              pinned: true,
              delegate: _ResultHeaderDelegate(),
            ),
            SliverPadding(
              padding: const EdgeInsets.only(top: 8, bottom: 80),
              sliver: SliverGrid(
                delegate: SliverChildBuilderDelegate(
                  (context, index) => Skeletonizer(
                    enabled: false,
                    child: ClipRRect(
                      borderRadius: const BorderRadius.all(
                        Radius.circular(6),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Image.asset(
                            fit: BoxFit.fitWidth,
                            width: gridItemWidth,
                            "assets/images/image1.png",
                          ),
                          const SizedBox(height: 6),
                          const Text(
                            "1000 RUB",
                            style: AppTextStyles.bodyPrice2,
                          ),
                          const Text(
                            "Detroit type beat sefsef sef",
                            style: AppTextStyles.headline1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 8),
                          Row(
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
                                          'https://img-cdn.pixlr.com/image-generator/history/65bb506dcb310754719cf81f/ede935de-1138-4f66-8ed7-44bd16efc709/medium.webp',
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
                                          children: [
                                            const SizedBox(height: 2),
                                            Text(
                                              "Rany sefsefsefsefsef se fs ef se fsefsefseefsefsef",
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
                                        "100k",
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
                        ],
                      ),
                    ),
                  ),
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

class _ResultHeaderDelegate extends SliverPersistentHeaderDelegate {
  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      padding: const EdgeInsets.only(top: 20, bottom: 20),
      color: AppColors.background,
      height: maxExtent,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            "Результаты поиска",
            style: AppTextStyles.headline2,
          ),
          const SizedBox(
            height: 20,
          ),
          Container(
            padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(12)),
              color: Color(0xff1E1E1E),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "Жанр: ",
                  style: TextStyle(
                    fontSize: 14,
                    fontFamily: "Poppins",
                    fontWeight: FontWeight.w400,
                    color: Colors.white.withOpacity(0.3),
                    letterSpacing: -0.41,
                    // height: 1,
                  ),
                ),
                const Text(
                  "Detroit",
                  style: TextStyle(
                    fontSize: 14,
                    fontFamily: "Poppins",
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                    letterSpacing: -0.41,
                    // height: 1,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  double get maxExtent => 113.0;

  @override
  double get minExtent => 113.0;

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) =>
      false;
}
