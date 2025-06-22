import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:vibeat/utils/theme.dart';
import 'package:skeletonizer/skeletonizer.dart';

@RoutePage()
class InfoBeatmaker extends StatefulWidget {
  const InfoBeatmaker({super.key});

  @override
  State<InfoBeatmaker> createState() => _InfoBeatmakerState();
}

class _InfoBeatmakerState extends State<InfoBeatmaker> {
  @override
  Widget build(BuildContext context) {
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
                      'smokeynagato',
                      style: AppTextStyles.bodyAppbar.copyWith(
                        fontSize: 26,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      '100 подписчиков',
                      style: AppTextStyles.bodyText2,
                    ),
                    const SizedBox(height: 8),
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
            padding: const EdgeInsets.only(top: 16, left: 18, right: 10),
            sliver: SliverToBoxAdapter(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Все биты', style: AppTextStyles.headline2),
                  TextButton(
                    onPressed: () {},
                    child: Text(
                      "Посмотреть еще",
                      style: AppTextStyles.bodyPrice1.copyWith(
                        color: AppColors.primary,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.only(top: 8),
            sliver: SliverList.builder(
              itemCount: 5,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.only(
                    left: 18,
                    right: 18,
                    bottom: 20,
                  ),
                  child: Skeletonizer(
                    enabled: false,
                    child: Row(
                      children: [
                        Image.asset(
                          fit: BoxFit.fitWidth,
                          width: 60,
                          "assets/images/image1.png",
                        ),
                        const SizedBox(width: 8),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Text(
                              "1000 RUB",
                              style:
                                  AppTextStyles.bodyPrice2.copyWith(height: 1),
                            ),
                            const SizedBox(height: 6),
                            const Text(
                              "Detroit type beat",
                              style: AppTextStyles.headline1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 6),
                            Row(
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
                                Container(
                                  padding: const EdgeInsets.only(
                                    right: 5,
                                  ),
                                  child: Column(
                                    children: [
                                      const SizedBox(height: 2),
                                      Text(
                                        "smokeynagato",
                                        style: AppTextStyles.bodyText2,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                );
              },
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
                  const Divider(
                    height: 0.5,
                    color: Color(0xff1E1E1E),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    "СТАТИСТИКА",
                    style: AppTextStyles.bodyPrice1.copyWith(
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Дата регистрация",
                        style: AppTextStyles.bodyText1.copyWith(
                          fontSize: 16,
                        ),
                      ),
                      Text(
                        "10 января 2025 г.",
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
                        "Прослушивания",
                        style: AppTextStyles.bodyText1.copyWith(
                          fontSize: 16,
                        ),
                      ),
                      Text(
                        "100k",
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
                        "Всего битов",
                        style: AppTextStyles.bodyText1.copyWith(
                          fontSize: 16,
                        ),
                      ),
                      Text(
                        "200",
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
                        "Всего лайков",
                        style: AppTextStyles.bodyText1.copyWith(
                          fontSize: 16,
                        ),
                      ),
                      Text(
                        "190",
                        style: AppTextStyles.bodyPrice1.copyWith(
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
                  const Divider(
                    height: 0.5,
                    color: Color(0xff1E1E1E),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    "КОНТАКТЫ",
                    style: AppTextStyles.bodyPrice1.copyWith(
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TextButton(
                        onPressed: () {},
                        style: TextButton.styleFrom(
                          backgroundColor: const Color(0xff28A8E9),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                        child: Row(
                          children: [
                            Text(
                              "Telegram",
                              style: AppTextStyles.headline1.copyWith(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(width: 10),
                            SvgPicture.asset(
                              "assets/svg/open_app.svg",
                            ),
                            const SizedBox(width: 2),
                          ],
                        ),
                      ),
                      const SizedBox(width: 7),
                      Container(
                        height: 38,
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [
                              Color(0xffF68F01),
                              Color(0xffF204BE),
                            ],
                            begin: Alignment.centerLeft,
                            end: Alignment.centerRight,
                          ),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: TextButton(
                          onPressed: () {},
                          style: TextButton.styleFrom(
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                16,
                              ),
                            ),
                          ),
                          child: Row(
                            children: [
                              Text(
                                "Instagram",
                                style: AppTextStyles.headline1.copyWith(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(width: 10),
                              SvgPicture.asset(
                                "assets/svg/open_app.svg",
                              ),
                              const SizedBox(width: 2),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(width: 7),
                      TextButton(
                        onPressed: () {},
                        style: TextButton.styleFrom(
                          backgroundColor: const Color(0xff0177FF),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                        child: Row(
                          children: [
                            Text(
                              "VK",
                              style: AppTextStyles.headline1.copyWith(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(width: 10),
                            SvgPicture.asset(
                              "assets/svg/open_app.svg",
                            ),
                            const SizedBox(width: 2),
                          ],
                        ),
                      ),
                    ],
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
