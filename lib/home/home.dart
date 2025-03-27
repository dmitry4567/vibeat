import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:vibeat/utils/theme.dart';

@RoutePage()
class HeadScreen extends StatefulWidget {
  const HeadScreen({super.key});

  @override
  State<HeadScreen> createState() => _HeadScreenState();
}

class _HeadScreenState extends State<HeadScreen> {
  final List<String> tags = [
    '#hardstyle',
    '#lo-fi',
    '#drill',
    '#love_music',
    '#winter',
    '#detroit',
    '#hardstyle',
    '#lo-fi',
    '#drill',
    '#love_music',
    '#winter',
    '#detroit',
  ];

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final width = size.width * 0.38;
    const double marginRight = 20.0;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 18),
        child: CustomScrollView(
          slivers: [
            const SliverAppBar(
              pinned: true,
              backgroundColor: AppColors.background,
            ),
            const SliverToBoxAdapter(
              child: Text(
                'Главная',
                style: TextStyle(
                  fontSize: 30,
                  fontFamily: "Helvetica",
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            const SliverPadding(
              padding: EdgeInsets.only(top: 40),
              sliver: SliverToBoxAdapter(
                child: Text(
                  'Специально для вас',
                  style: TextStyle(
                    fontSize: 20,
                    fontFamily: "Helvetica",
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Container(
                padding: const EdgeInsets.only(top: 20),
                height: 177,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: 20,
                  itemBuilder: (context, index) {
                    return Container(
                      margin: const EdgeInsets.only(right: 10),
                      width: 177,
                      color: Colors.red,
                      child: Center(
                        child: Text('Item $index'),
                      ),
                    );
                  },
                ),
              ),
            ),
            const SliverPadding(
              padding: EdgeInsets.only(top: 32),
              sliver: SliverToBoxAdapter(
                child: Text(
                  'По настроению',
                  style: TextStyle(
                    fontSize: 20,
                    fontFamily: "Helvetica",
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Container(
                padding: const EdgeInsets.only(top: 20),
                height: 177,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: 20,
                  itemBuilder: (context, index) {
                    return Container(
                      margin: const EdgeInsets.only(right: 10),
                      width: 177,
                      color: Colors.red,
                      child: Center(
                        child: Text('Item $index'),
                      ),
                    );
                  },
                ),
              ),
            ),
            const SliverPadding(
              padding: EdgeInsets.only(top: 32),
              sliver: SliverToBoxAdapter(
                child: Text(
                  'От редакции',
                  style: TextStyle(
                    fontSize: 20,
                    fontFamily: "Helvetica",
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Container(
                padding: const EdgeInsets.only(top: 20),
                height: 177,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: 20,
                  itemBuilder: (context, index) {
                    return Container(
                      margin: const EdgeInsets.only(right: 10),
                      width: 177,
                      color: Colors.red,
                      child: Center(
                        child: Text('Item $index'),
                      ),
                    );
                  },
                ),
              ),
            ),
            const SliverPadding(
              padding: EdgeInsets.only(top: 32),
              sliver: SliverToBoxAdapter(
                child: Text(
                  'Теги в тренде',
                  style: TextStyle(
                    fontSize: 20,
                    fontFamily: "Helvetica",
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.only(top: 20),
              sliver: SliverToBoxAdapter(
                child: Wrap(
                  spacing: 8.0,
                  runSpacing: 8.0,
                  children: tags.map((tag) => TagItem(tag: tag)).toList(),
                ),
              ),
            ),
            const SliverPadding(
              padding: EdgeInsets.only(top: 32),
              sliver: SliverToBoxAdapter(
                child: Text(
                  'Новые биты популярных авторов',
                  style: TextStyle(
                    fontSize: 20,
                    fontFamily: "Helvetica",
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.only(top: 20),
              sliver: SliverToBoxAdapter(
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: List.generate(
                      6,
                      (index) {
                        return Skeletonizer(
                          enabled: false,
                          child: ClipRRect(
                            borderRadius: const BorderRadius.all(
                              Radius.circular(6),
                            ),
                            child: GestureDetector(
                              onTap: () {},
                              child: Container(
                                width: width,
                                margin:
                                    const EdgeInsets.only(right: marginRight),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Image.asset(
                                      fit: BoxFit.fitWidth,
                                      width: width,
                                      "assets/images/image1.png",
                                    ),
                                    const SizedBox(
                                      height: 6,
                                    ),
                                    const Text(
                                      "1000 RUB",
                                      style: AppTextStyles.bodyPrice2,
                                    ),
                                    const Text(
                                      "Detroit type beat sefsef sef",
                                      style: AppTextStyles.headline1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    const SizedBox(
                                      height: 8,
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
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
                                              const SizedBox(
                                                width: 4,
                                              ),
                                              Expanded(
                                                child: Container(
                                                  padding:
                                                      const EdgeInsets.only(
                                                    right: 5,
                                                  ),
                                                  child: Column(
                                                    children: [
                                                      const SizedBox(
                                                        height: 2,
                                                      ),
                                                      Text(
                                                        "Rany sefsefsefsefsef se fs ef se fsefsefseefsefsef",
                                                        style: AppTextStyles
                                                            .bodyText2,
                                                        overflow: TextOverflow
                                                            .ellipsis,
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
                                              color:
                                                  AppColors.unselectedItemColor,
                                            ),
                                            Column(
                                              children: [
                                                const SizedBox(
                                                  height: 1,
                                                ),
                                                Text(
                                                  "100k",
                                                  style: AppTextStyles.bodyText2
                                                      .copyWith(fontSize: 10),
                                                  overflow:
                                                      TextOverflow.ellipsis,
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
                        );
                      },
                    ),
                  ),
                ),
              ),
            ),
            const SliverPadding(
              padding: EdgeInsets.only(top: 32),
              sliver: SliverToBoxAdapter(
                child: Text(
                  'Биты новоприбывших авторов',
                  style: TextStyle(
                    fontSize: 20,
                    fontFamily: "Helvetica",
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.only(top: 20),
              sliver: SliverToBoxAdapter(
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: List.generate(
                      6,
                      (index) {
                        return Skeletonizer(
                          enabled: false,
                          child: ClipRRect(
                            borderRadius: const BorderRadius.all(
                              Radius.circular(6),
                            ),
                            child: GestureDetector(
                              onTap: () {},
                              child: Container(
                                width: width,
                                margin:
                                    const EdgeInsets.only(right: marginRight),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Image.asset(
                                      fit: BoxFit.fitWidth,
                                      width: width,
                                      "assets/images/image1.png",
                                    ),
                                    const SizedBox(
                                      height: 6,
                                    ),
                                    const Text(
                                      "1000 RUB",
                                      style: AppTextStyles.bodyPrice2,
                                    ),
                                    const Text(
                                      "Detroit type beat sefsef sef",
                                      style: AppTextStyles.headline1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    const SizedBox(
                                      height: 8,
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
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
                                              const SizedBox(
                                                width: 4,
                                              ),
                                              Expanded(
                                                child: Container(
                                                  padding:
                                                      const EdgeInsets.only(
                                                    right: 5,
                                                  ),
                                                  child: Column(
                                                    children: [
                                                      const SizedBox(
                                                        height: 2,
                                                      ),
                                                      Text(
                                                        "Rany sefsefsefsefsef se fs ef se fsefsefseefsefsef",
                                                        style: AppTextStyles
                                                            .bodyText2,
                                                        overflow: TextOverflow
                                                            .ellipsis,
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
                                              color:
                                                  AppColors.unselectedItemColor,
                                            ),
                                            Column(
                                              children: [
                                                const SizedBox(
                                                  height: 1,
                                                ),
                                                Text(
                                                  "100k",
                                                  style: AppTextStyles.bodyText2
                                                      .copyWith(fontSize: 10),
                                                  overflow:
                                                      TextOverflow.ellipsis,
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
                        );
                      },
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class TagItem extends StatelessWidget {
  final String tag;

  const TagItem({super.key, required this.tag});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 8,
        vertical: 6,
      ),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [
            Color(0xff6E4985),
            Color(0xff44255C),
          ],
        ),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        tag,
        style: const TextStyle(
          color: AppColors.textPrimary,
          fontWeight: FontWeight.w400,
          fontFamily: "Poppins",
          fontSize: 16,
        ),
      ),
    );
  }
}
