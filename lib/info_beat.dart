import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:vibeat/utils/theme.dart';
import 'package:skeletonizer/skeletonizer.dart';

@RoutePage()
class InfoBeat extends StatefulWidget {
  const InfoBeat({super.key});

  @override
  State<InfoBeat> createState() => _InfoBeatState();
}

class _InfoBeatState extends State<InfoBeat> {
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
    const double marginRight = 20.0;

    final size = MediaQuery.of(context).size;
    final width = size.width * 0.38;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            stretch: true,
            backgroundColor: AppColors.background,
            excludeHeaderSemantics: true,
            expandedHeight: 450.0, //375
            floating: false,
            pinned: false,
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                fit: StackFit.expand,
                children: [
                  Image.network(
                    'https://sun9-63.userapi.com/impg/I_VmpgvyUNSas3TeQcD9cMpEsWtV6LDXOjDM0A/IG8fKJyhALQ.jpg?size=270x270&quality=95&sign=dfd23dbdcb75df2ba50bee0db00e3633&c_uniq_tag=kGLLQ5z1e3ezZUsn-MBxtz4nfWH3lHV3twPptGaJq8U&type=audio&quot',
                    fit: BoxFit.cover,
                  ),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Container(
                      height: 375,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Colors.black.withOpacity(0.8),
                            Colors.transparent,
                          ],
                          begin: Alignment.bottomCenter,
                          end: Alignment.topCenter,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              title: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      'Jerky Beats',
                      style: AppTextStyles.bodyAppbar.copyWith(
                        fontSize: 26,
                      ),
                    ),
                    const SizedBox(height: 12),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Column(
                            children: [
                              Container(
                                alignment: AlignmentDirectional.topCenter,
                                child: MaterialButton(
                                  onPressed: () {},
                                  color: Colors.white.withOpacity(0.1),
                                  textColor: Colors.white,
                                  shape: const CircleBorder(),
                                  child: const Icon(
                                    Icons.favorite,
                                    size: 18,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                "200",
                                style: AppTextStyles.bodyAppbar.copyWith(
                                  fontSize: 10,
                                ),
                              )
                            ],
                          ),
                          Column(
                            children: [
                              Container(
                                alignment: AlignmentDirectional.topCenter,
                                child: MaterialButton(
                                  onPressed: () {},
                                  color: AppColors.primary,
                                  textColor: Colors.white,
                                  shape: const CircleBorder(),
                                  child: const Icon(
                                    Icons.play_arrow,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                "Слушать",
                                style: AppTextStyles.bodyAppbar.copyWith(
                                  fontSize: 10,
                                ),
                              )
                            ],
                          ),
                          Column(
                            children: [
                              Container(
                                alignment: AlignmentDirectional.topCenter,
                                child: MaterialButton(
                                  onPressed: () {},
                                  color: Colors.white.withOpacity(0.1),
                                  textColor: Colors.white,
                                  shape: const CircleBorder(),
                                  child: const Icon(
                                    Icons.share,
                                    size: 18,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                "Поделиться",
                                style: AppTextStyles.bodyAppbar.copyWith(
                                  fontSize: 10,
                                ),
                              )
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.only(
              top: 8,
              left: 18,
              right: 18,
            ),
            sliver: SliverList(
              delegate: SliverChildListDelegate(
                [
                  const SizedBox(height: 20),
                  const Divider(
                    height: 0.5,
                    color: Color(0xff1E1E1E),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    "О КОМПОЗИЦИИ",
                    style: AppTextStyles.bodyPrice1.copyWith(
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Жанр",
                        style: AppTextStyles.bodyText1.copyWith(
                          fontSize: 16,
                        ),
                      ),
                      Text(
                        "Jerk",
                        style: AppTextStyles.bodyText1.copyWith(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Тональность",
                        style: AppTextStyles.bodyText1.copyWith(
                          fontSize: 16,
                        ),
                      ),
                      Text(
                        "C#",
                        style: AppTextStyles.bodyPrice1.copyWith(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "BPM",
                        style: AppTextStyles.bodyText1.copyWith(
                          fontSize: 16,
                        ),
                      ),
                      Text(
                        "120",
                        style: AppTextStyles.bodyPrice1.copyWith(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Настроение",
                        style: AppTextStyles.bodyText1.copyWith(
                          fontSize: 16,
                        ),
                      ),
                      Text(
                        "Грустное",
                        style: AppTextStyles.bodyPrice1.copyWith(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Дата публикации",
                        style: AppTextStyles.bodyText1.copyWith(
                          fontSize: 16,
                        ),
                      ),
                      Text(
                        "10 января 2023 г.",
                        style: AppTextStyles.bodyText1.copyWith(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  const Divider(
                    height: 0.5,
                    color: Color(0xff1E1E1E),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    "ТЕГИ",
                    style: AppTextStyles.bodyPrice1.copyWith(
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.only(
                top: 20,
                left: 18,
                right: 18,
              ),
              child: Wrap(
                spacing: 8.0,
                runSpacing: 8.0,
                children: tags
                    .asMap()
                    .entries
                    .map(
                      (entry) => TagCard(
                        index: entry.key,
                        text: entry.value,
                      ),
                    )
                    .toList(),
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.only(
              top: 8,
              left: 18,
              right: 18,
            ),
            sliver: SliverList(
              delegate: SliverChildListDelegate(
                [
                  const SizedBox(height: 20),
                  const Divider(
                    height: 0.5,
                    color: Color(0xff1E1E1E),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    "ОПИСАНИЕ",
                    style: AppTextStyles.bodyPrice1.copyWith(
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    "ыушгршгыуа ыуграгшыгуп ашыпуа шыпуш ашынпуагнып уагып уагнып уагнпы уга ыгнупа гын агны агап ышгуп аыушап гыу апыгупа шыупашы пуша ышупашыуаш ыпшуаышупашы уаыш уашыгупашг",
                    style: AppTextStyles.bodyText1.copyWith(
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 20),
                  MaterialButton(
                    padding: const EdgeInsets.all(0),
                    onPressed: () {},
                    child: Row(
                      children: [
                        Icon(
                          Icons.flag_outlined,
                          color: Colors.white.withOpacity(0.8),
                        ),
                        const SizedBox(width: 6),
                        Text(
                          "Пожаловаться",
                          style: AppTextStyles.headline1.copyWith(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            // height: 1
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 40),
                  const Text('Похожие биты', style: AppTextStyles.headline2),
                  const SizedBox(height: 20),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: List.generate(
                        5,
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
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
                                                    backgroundImage:
                                                        NetworkImage(
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
                                                color: AppColors
                                                    .unselectedItemColor,
                                              ),
                                              Column(
                                                children: [
                                                  const SizedBox(
                                                    height: 1,
                                                  ),
                                                  Text(
                                                    "100k",
                                                    style: AppTextStyles
                                                        .bodyText2
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
                  const SizedBox(height: 80),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class TagCard extends StatelessWidget {
  const TagCard({
    super.key,
    required this.index,
    required this.text,
  });

  final int index;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 11,
        vertical: 5,
      ),
      decoration: BoxDecoration(
        color: Colors.transparent,
        border: Border.all(
          color: const Color(0xff1E1E1E),
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: Colors.white.withOpacity(0.3),
        ),
      ),
    );
  }
}
