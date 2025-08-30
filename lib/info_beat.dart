import 'dart:convert';
import 'package:auto_route/auto_route.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vibeat/app/injection_container.dart';
import 'package:vibeat/core/api_client.dart';
import 'package:vibeat/filter/result.dart';
import 'package:vibeat/filter/screen/filter_key/model/key_model.dart';
import 'package:vibeat/utils/theme.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:http/http.dart' as http;

@RoutePage()
class InfoBeat extends StatefulWidget {
  const InfoBeat({super.key, required this.beatId});

  final String beatId;

  @override
  State<InfoBeat> createState() => _InfoBeatState();
}

class _InfoBeatState extends State<InfoBeat> {
  BeatEntity beat = const BeatEntity(
    id: "",
    isCurrentPlaying: false,
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
  bool isLike = false;

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
  void initState() {
    super.initState();
    initializeDateFormatting('ru');

    getLikesCountByBeat();
    getBeatInfo();
  }

  Future<void> postNewLike() async {
    final apiClient = sl<ApiClient>().dio;

    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    final ip = sharedPreferences.getString("ip");

    final responseLike = await apiClient.post(
      "http://$ip:8080/activityBeat/postNewLike",
      data: {
        'beatId': widget.beatId,
      },
    );

    if (responseLike.statusCode == 205) {
      final responseDelete = await apiClient
          .delete("http://$ip:8080/activityBeat/${widget.beatId}");

      if (responseDelete.statusCode == 200) {
        setState(() {
          // countLikes -= 1;
          isLike = false;
        });
      }
      return;
    }

    if (responseLike.statusCode == 201) {
      setState(() {
        isLike = true;
      });
      // setState(() {
      //   isLike = !isLike;
      //   countLikes += isLike ? 1 : -1;
      // });
    } else {}
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
        beat = BeatEntity.fromJson(data, "false");
      });
    }
  }

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
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Column(
                              children: [
                                Container(
                                  alignment: AlignmentDirectional.topCenter,
                                  child: MaterialButton(
                                    onPressed: () async {
                                      await postNewLike();
                                    },
                                    color: Colors.white.withOpacity(0.1),
                                    textColor: Colors.white,
                                    shape: const CircleBorder(),
                                    child: Icon(
                                      isLike
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
                                                      'https://mimigram.ru/wp-content/uploads/2020/07/chto-takoe-foto.jpg',
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
