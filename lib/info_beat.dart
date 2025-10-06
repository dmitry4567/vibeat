import 'dart:convert';
import 'package:auto_route/auto_route.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vibeat/app/app_router.gr.dart';
import 'package:vibeat/app/injection_container.dart';
import 'package:vibeat/features/favorite/data/models/beat_model.dart';
import 'package:vibeat/features/favorite/presentation/bloc/favorite_bloc.dart';
import 'package:vibeat/filter/screen/filter_key/model/key_model.dart';
import 'package:vibeat/player/bloc/player_bloc.dart';
import 'package:vibeat/search.dart';
import 'package:vibeat/utils/theme.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:http/http.dart' as http;

@RoutePage()
class InfoBeatScreen extends StatefulWidget {
  const InfoBeatScreen({
    super.key,
    required this.beatId,
  });

  final String beatId;

  @override
  State<InfoBeatScreen> createState() => _InfoBeatState();
}

class _InfoBeatState extends State<InfoBeatScreen> {
  BeatModel beat = const BeatModel(
    id: "",
    name: "",
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
      name: "Em",
      key: "",
      isSelected: false,
    ),
    bpm: 0,
    createAt: 0,
  );

  int countLikes = 0;
  bool isLiked = false;

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

  List<BeatModel> beatData = [];

  @override
  void initState() {
    super.initState();
    initializeDateFormatting('ru');

    getLikesCountByBeat();
    getBeatInfo();
    getSimilarBeats();

    isLiked = context
        .read<FavoriteBloc>()
        .isFavoriteBeat(widget.beatId)
        .getOrElse(() => false);
  }

  // Future<void> postNewLike() async {
  //   final apiClient = sl<ApiClient>().dio;

  //   SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
  //   final ip = sharedPreferences.getString("ip");

  //   final responseLike = await apiClient.post(
  //     "http://$ip:8080/activityBeat/postNewLike",
  //     data: {
  //       'beatId': widget.beatId,
  //     },
  //   );

  //   if (responseLike.statusCode == 205) {
  //     final responseDelete = await apiClient
  //         .delete("http://$ip:8080/activityBeat/${widget.beatId}");

  //     if (responseDelete.statusCode == 200) {
  //       setState(() {
  //         // countLikes -= 1;
  //         isLike = false;
  //       });
  //     }
  //     return;
  //   }

  //   if (responseLike.statusCode == 201) {
  //     setState(() {
  //       isLike = true;
  //     });
  //     // setState(() {
  //     //   isLike = !isLike;
  //     //   countLikes += isLike ? 1 : -1;
  //     // });
  //   } else {}
  // }

  List<BeatModel> placeholderBeat = List.generate(
    5,
    (index) => const BeatModel(
      id: "",
      name: "",
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

  void getSimilarBeats() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    final ip = sharedPreferences.getString("ip");

    final response = await http.post(
      Uri.parse("http://192.168.0.135:8003/similar_tracks"),
      // Uri.parse("http://$ip:8080/similar_tracks"),
      headers: {
        'Content-Type': 'application/json',
      },
      body: json.encode({'track_id': widget.beatId}),
    );

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);

      setState(() {
        beatData = data.map((json) => BeatModel.fromJson(json)).toList();
      });
    }
    if (response.statusCode == 500) {
      beatData = [];
    }
  }

  void getLikesCountByBeat() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    final ip = sharedPreferences.getString("ip");

    final response = await http.get(
      Uri.parse(
          "http://$ip:8080/activityBeat/viewLikesCountByBeatId/${widget.beatId}"),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      dynamic data = json.decode(response.body)['data'];

      if (!mounted) return;

      setState(() {
        countLikes = data['count'];
      });
    }
  }

  void getBeatInfo() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    final ip = sharedPreferences.getString("ip");

    final response = await http.get(
      Uri.parse("http://$ip:8080/beat/byBeatId/${widget.beatId}"),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      dynamic data = json.decode(response.body)['data'];

      if (!mounted) return;

      setState(() {
        beat = BeatModel.fromJson(data);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    const double paddingWidth = 18.0;
    const double marginRight = 20.0;

    final size = MediaQuery.of(context).size;
    final width = size.width * 0.38;
    final gridItemWidth = (size.width - paddingWidth * 2 - 20) / 2;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            centerTitle: true,
            automaticallyImplyLeading: true,
            stretch: true,
            primary: true,
            backgroundColor: AppColors.background,
            excludeHeaderSemantics: true,
            expandedHeight: 450.0, //375
            floating: false,
            pinned: false,
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                fit: StackFit.expand,
                children: [
                  beat.picture != ""
                      ? Image.network(
                          beat.picture,
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
              titlePadding: const EdgeInsets.all(0),
              title: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 9),
                        child: Text(
                          beat.name,
                          maxLines: 2,
                          style: AppTextStyles.bodyAppbar.copyWith(
                            fontSize: 26,
                            height: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      SingleChildScrollView(
                        primary: false,
                        scrollDirection: Axis.horizontal,
                        physics: const NeverScrollableScrollPhysics(),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Column(
                              children: [
                                Container(
                                  alignment: AlignmentDirectional.topCenter,
                                  child: MaterialButton(
                                    onPressed: () async {
                                      if (isLiked) {
                                        sl<FavoriteBloc>().add(
                                            DeleteFavoriteEvent(
                                                beatId: widget.beatId));

                                        isLiked = false;
                                        countLikes -= 1;
                                        setState(() {});
                                      } else {
                                        sl<FavoriteBloc>().add(AddFavoriteEvent(
                                            beatId: widget.beatId));

                                        isLiked = true;
                                        countLikes += 1;
                                        setState(() {});
                                      }
                                    },
                                    color: Colors.white.withOpacity(0.1),
                                    textColor: Colors.white,
                                    shape: const CircleBorder(),
                                    child: Icon(
                                      isLiked
                                          ? Icons.favorite
                                          : Icons.favorite_outline,
                                      size: 18,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  countLikes.toString(),
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
                                    onPressed: () {
                                      sl<PlayerBloc>().add(
                                        PlayCurrentBeatEvent([beat], 0),
                                      );

                                      context.router
                                          .navigate(const PlayerRoute());
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
                                ),
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
                  // const SizedBox(height: 20),
                  // const Divider(
                  //   height: 0.5,
                  //   color: Color(0xff1E1E1E),
                  // ),
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
                        beat.genres.isNotEmpty
                            ? beat.genres.map((e) => e.name).join(", ")
                            : "-",
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
                        "Тональность",
                        style: AppTextStyles.bodyText1.copyWith(
                          fontSize: 16,
                        ),
                      ),
                      Text(
                        "Em",
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
                        "160",
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
                        "Angry, Dark, Slow",
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
                        DateFormat('d MMMM yyyy г.', 'ru').format(
                          DateTime.fromMillisecondsSinceEpoch(
                            beat.createAt * 1000,
                          ),
                        ),
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
                children: beat.tags
                    .asMap()
                    .entries
                    .map(
                      (entry) => TagCard(
                        index: entry.key,
                        text: entry.value.name,
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
                    beat.description.isNotEmpty ? beat.description : "-",
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
                      children: beatData.isNotEmpty
                          ? List.generate(beatData.length, (index) {
                              return Skeletonizer(
                                enabled: false,
                                child: NewBeatWidget(
                                  openPlayer: () {
                                    sl<PlayerBloc>().add(
                                        PlayCurrentBeatEvent(beatData, index));

                                    context.router
                                        .navigate(const PlayerRoute());
                                  },
                                  openInfoBeat: () {
                                    context.router.push(
                                      InfoBeatRoute(beatId: beatData[index].id),
                                    );
                                  },
                                  openInfoBeatmaker: () {
                                    context.router.navigate(
                                      InfoBeatmakerRoute(
                                        beatmakerId:
                                            beatData[index].beatmakerId,
                                      ),
                                    );
                                  },
                                  isLoading: false,
                                  index: index,
                                  beat: beatData[index],
                                  width: width,
                                  marginRight: marginRight,
                                  gridItemWidth: gridItemWidth,
                                ),
                              );
                            })
                          : List.generate(placeholderBeat.length, (index) {
                              return Skeletonizer(
                                enabled: true,
                                child: NewBeatWidget(
                                  openPlayer: () {},
                                  openInfoBeat: () {},
                                  openInfoBeatmaker: () {},
                                  isLoading: true,
                                  index: index,
                                  beat: const BeatModel(
                                    id: "",
                                    name: "sefsesfseff",
                                    description: "sefsef",
                                    picture: "",
                                    beatmakerId: "",
                                    beatmakerName: "sefsef",
                                    url: "",
                                    price: 0,
                                    plays: 0,
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
                                  width: width,
                                  marginRight: marginRight,
                                  gridItemWidth: gridItemWidth,
                                ),
                              );
                            }),
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
          color: const Color.fromRGBO(50, 50, 50, 1),
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: Colors.white.withOpacity(0.35),
        ),
      ),
    );
  }
}
