import 'dart:convert';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:vibeat/app/app_router.gr.dart';
import 'package:vibeat/app/injection_container.dart';
import 'package:vibeat/app/injection_container.dart' as di;
import 'package:vibeat/filter/result.dart';
import 'package:vibeat/filter/screen/filter_key/model/key_model.dart';
import 'package:vibeat/info_beatmaker/beatmaker.dart';
import 'package:vibeat/info_beatmaker/widgets/bloc/all_beats_of_beatmaker_bloc.dart';
import 'package:vibeat/player/bloc/player_bloc.dart';
import 'package:vibeat/utils/theme.dart';
import 'package:skeletonizer/skeletonizer.dart';

@RoutePage()
class InfoBeatmaker extends StatefulWidget {
  const InfoBeatmaker({super.key, required this.beatmakerId});

  final String beatmakerId;

  @override
  State<InfoBeatmaker> createState() => _InfoBeatmakerState();
}

class _InfoBeatmakerState extends State<InfoBeatmaker> {
  Beatmaker beatmaker = const Beatmaker(
    id: '',
    username: '',
    profilepicture: '',
    metadata: Metadata(
      id: '',
      vkUrl: '',
      telegramUrl: '',
      description: '',
    ),
  );

  List<BeatEntity> placeholderBeat = List.generate(
    5,
    (index) => const BeatEntity(
      id: "",
      name: "jbksbfkdrbgjkdr",
      description: "",
      picture: "",
      beatmakerId: "",
      beatmakerName: "",
      url: "",
      price: 1000,
      plays: 1000,
      genres: [],
      moods: [],
      tags: [],
      key: KeyModel(
        name: "",
        key: "",
        isSelected: false,
      ),
      bpm: 0,
      createAt: 0,
    ),
  );

  String? likesCountByBeatmaker;

  @override
  void initState() {
    super.initState();

    getBeatmakerInfo();
    getLikesCountByBeatmaker();
    // getBeatsOfBeatmaker();
    context.read<AllBeatsOfBeatmakerBloc>().add(GetBeats(widget.beatmakerId));
  }

  void getBeatmakerInfo() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    final ip = sharedPreferences.getString("ip");

    final response = await http.get(
      Uri.parse("http://$ip:7773/api/userById/${widget.beatmakerId}"),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      dynamic data = json.decode(response.body)['data'];

      if (!mounted) return;

      setState(() {
        beatmaker = Beatmaker.fromJson(data);
      });
    }
  }

  void getLikesCountByBeatmaker() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    final ip = sharedPreferences.getString("ip");

    final response = await http.get(
      Uri.parse(
          "http://$ip:8080/activityBeat/viewLikesCountByUserId/${widget.beatmakerId}"),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      dynamic data = json.decode(response.body)['data'];

      if (!mounted) return;

      setState(() {
        likesCountByBeatmaker = data['count'].toString();
      });
    }
  }

  // void getBeatsOfBeatmaker() async {
  //   final response = await http.get(
  //     Uri.parse(
  //         "http://192.168.0.135:7771/api/beat/byBeatmakerId/${widget.beatmakerId}"),
  //     headers: {'Content-Type': 'application/json'},
  //   );

  //   if (response.statusCode == 200) {
  //     List<dynamic> data = json.decode(response.body)['data'];

  //     if (!mounted) return;

  //     setState(() {
  //       beatsOfBeatmaker =
  //           data.map((beat) => BeatEntity.fromJson(beat)).toList();
  //     });
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: CustomScrollView(
          slivers: [
            SliverAppBar(
              centerTitle: true,
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
                    // Image.network(
                    //   'https://sun9-63.userapi.com/impg/I_VmpgvyUNSas3TeQcD9cMpEsWtV6LDXOjDM0A/IG8fKJyhALQ.jpg?size=270x270&quality=95&sign=dfd23dbdcb75df2ba50bee0db00e3633&c_uniq_tag=kGLLQ5z1e3ezZUsn-MBxtz4nfWH3lHV3twPptGaJq8U&type=audio&quot',
                    //   fit: BoxFit.cover,
                    // ),
                    beatmaker.profilepicture != ""
                        ? Image.network(
                            beatmaker.profilepicture,
                            fit: BoxFit.cover,
                          )
                        : Skeletonizer(
                            enabled: true,
                            child: Container(
                              width: 10,
                              height: 10,
                              color: AppColors.appbar,
                            ),
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
                        beatmaker.username,
                        style: AppTextStyles.bodyAppbar.copyWith(
                          fontSize: 26,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        '0 подписчиков',
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
                                    elevation: 0,
                                    textColor: Colors.white,
                                    shape: const CircleBorder(),
                                    child: const Icon(
                                      Icons.favorite_outline,
                                      size: 18,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  likesCountByBeatmaker ?? "0",
                                  style: AppTextStyles.bodyAppbar.copyWith(
                                    fontSize: 10,
                                  ),
                                )

                                // GestureDetector(
                                //   onTap: () {},
                                //   child: Container(
                                //     width: 42,
                                //     height: 42,
                                //     decoration: BoxDecoration(
                                //       color: Colors.white.withOpacity(0.1),
                                //       shape: BoxShape.circle,
                                //     ),
                                //     alignment: AlignmentDirectional.center,
                                //     child: const Icon(
                                //       Icons.favorite_outline,
                                //       size: 20,
                                //     ),
                                //   ),
                                // ),
                                // const SizedBox(height: 6),
                                // Text(
                                //   "0",
                                //   style: AppTextStyles.bodyAppbar.copyWith(
                                //     fontSize: 10,
                                //   ),
                                // )
                              ],
                            ),
                            Column(
                              children: [
                                Container(
                                  alignment: AlignmentDirectional.topCenter,
                                  child: MaterialButton(
                                    onPressed: () {
                                      // sl<PlayerBloc>().add(PlayCurrentBeatEvent(
                                      //     di
                                      //         .sl<AllBeatsOfBeatmakerBloc>()
                                      //         .state
                                      //         .beats,
                                      //     0));

                                      // context.router
                                      //     .navigate(const PlayerRoute());
                                    },
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
                                    elevation: 0,
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
              padding: const EdgeInsets.only(top: 12, left: 18, right: 10),
              sliver: SliverToBoxAdapter(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Все биты', style: AppTextStyles.headline2),
                    TextButton(
                      onPressed: () {
                        context.router.push(
                          PlaylistRoute(
                            title: "Все биты",
                            beats: context
                                .read<AllBeatsOfBeatmakerBloc>()
                                .state
                                .beats,
                          ),
                        );
                      },
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
              padding: const EdgeInsets.only(top: 6),
              sliver: BlocBuilder<AllBeatsOfBeatmakerBloc,
                  AllBeatsOfBeatmakerState>(
                builder: (context, state) {
                  if (state.isLoading) {
                    return SliverList.builder(
                      itemCount: placeholderBeat.length,
                      itemBuilder: (context, index) {
                        return Skeletonizer(
                          enabled: true,
                          child: BeatRowWidget(
                            index: index,
                            isCurrentPlaying: false,
                            beat: placeholderBeat[index],
                          ),
                        );
                      },
                    );
                  }
                  if (state.beats.isNotEmpty) {
                    return BlocBuilder<PlayerBloc, PlayerStateApp>(
                      buildWhen: (previous, current) =>
                          previous.currentTrackBeatId !=
                          current.currentTrackBeatId,
                      builder: (context, statePlayer) {
                        return SliverList.builder(
                          itemCount: 5,
                          itemBuilder: (context, index) {
                            return Material(
                              color: Colors.transparent,
                              child: InkWell(
                                  onTap: () {
                                    sl<PlayerBloc>().add(
                                      PlayCurrentBeatEvent(
                                        state.beats,
                                        index,
                                      ),
                                    );

                                    // context.router.navigate(const PlayerRoute());
                                  },
                                  child: BeatRowWidget(
                                    index: index,
                                    isCurrentPlaying: state.beats[index].id ==
                                        statePlayer.currentTrackBeatId,
                                    beat: state.beats[index],
                                  )),
                            );
                          },
                        );
                      },
                    );
                  }
                  return const SliverToBoxAdapter();
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
                          "Дата регистрации",
                          style: AppTextStyles.bodyText1.copyWith(
                            fontSize: 16,
                          ),
                        ),
                        Text(
                          "-",
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
                          "-",
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
                        BlocBuilder<AllBeatsOfBeatmakerBloc,
                            AllBeatsOfBeatmakerState>(
                          buildWhen: (previous, current) =>
                              previous.beats.length != current.beats.length,
                          builder: (context, state) {
                            if (state.beats.isEmpty) {
                              Skeletonizer(
                                enabled: true,
                                child: Text(
                                  "450",
                                  style: AppTextStyles.bodyPrice1.copyWith(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              );
                            }
                            return Text(
                              state.beats.length.toString(),
                              style: AppTextStyles.bodyPrice1.copyWith(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            );
                          },
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
                          "-",
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
                      beatmaker.metadata.description,
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
                        beatmaker.metadata.telegramUrl != ""
                            ? TextButton(
                                onPressed: () {
                                  launchUrl(
                                      Uri.parse(beatmaker.metadata.telegramUrl),
                                      mode: LaunchMode.externalApplication);
                                },
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
                              )
                            : const SizedBox(),
                        const SizedBox(width: 7),
                        // Container(
                        //   height: 38,
                        //   decoration: BoxDecoration(
                        //     gradient: const LinearGradient(
                        //       colors: [
                        //         Color(0xffF68F01),
                        //         Color(0xffF204BE),
                        //       ],
                        //       begin: Alignment.centerLeft,
                        //       end: Alignment.centerRight,
                        //     ),
                        //     borderRadius: BorderRadius.circular(16),
                        //   ),
                        //   child: TextButton(
                        //     onPressed: () {},
                        //     style: TextButton.styleFrom(
                        //       foregroundColor: Colors.white,
                        //       shape: RoundedRectangleBorder(
                        //         borderRadius: BorderRadius.circular(
                        //           16,
                        //         ),
                        //       ),
                        //     ),
                        //     child: Row(
                        //       children: [
                        //         Text(
                        //           "Instagram",
                        //           style: AppTextStyles.headline1.copyWith(
                        //             fontSize: 16,
                        //             fontWeight: FontWeight.w600,
                        //           ),
                        //         ),
                        //         const SizedBox(width: 10),
                        //         SvgPicture.asset(
                        //           "assets/svg/open_app.svg",
                        //         ),
                        //         const SizedBox(width: 2),
                        //       ],
                        //     ),
                        //   ),
                        // ),
                        // const SizedBox(width: 7),
                        beatmaker.metadata.vkUrl != ""
                            ? TextButton(
                                onPressed: () {
                                  launchUrl(Uri.parse(beatmaker.metadata.vkUrl),
                                      mode: LaunchMode.externalApplication);
                                },
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
                              )
                            : const SizedBox(),
                      ],
                    ),
                    const SizedBox(height: 80),
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

class BeatRowWidget extends StatelessWidget {
  const BeatRowWidget({
    super.key,
    required this.index,
    required this.isCurrentPlaying,
    required this.beat,
  });

  final int index;
  final bool isCurrentPlaying;
  final BeatEntity beat;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: isCurrentPlaying
          ? AppColors.primary.withOpacity(0.2)
          : Colors.transparent,
      padding: const EdgeInsets.only(
        left: 18,
        right: 18,
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
          // Image.network(
          //   fit: BoxFit.cover,
          //   width: 60,
          //   beatsOfBeatmaker[index].picture,
          // ),
          const SizedBox(width: 8),
          Column(
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
              const Row(
                children: [
                  // const SizedBox(
                  //   width: 12,
                  //   height: 12,
                  //   child: CircleAvatar(
                  //     backgroundImage: NetworkImage(
                  //       'https://mimigram.ru/wp-content/uploads/2020/07/chto-takoe-foto.jpg',
                  //     ),
                  //   ),
                  // ),
                  // const SizedBox(width: 4),
                  // Container(
                  //   padding: const EdgeInsets.only(
                  //     right: 5,
                  //   ),
                  //   child: Column(
                  //     children: [
                  //       const SizedBox(height: 2),
                  //       Text(
                  //         "smokeynagato",
                  //         style: AppTextStyles.bodyText2,
                  //         overflow: TextOverflow.ellipsis,
                  //       ),
                  //     ],
                  //   ),
                  // ),
                ],
              ),
            ],
          )
        ],
      ),
    );
  }
}
