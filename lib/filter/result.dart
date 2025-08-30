import 'dart:convert';
import 'dart:developer';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:vibeat/app/app_router.gr.dart';
import 'package:vibeat/app/injection_container.dart';
import 'package:vibeat/filter/screen/filter_genre/model/genre_model.dart';
import 'package:vibeat/filter/screen/filter_key/model/key_model.dart';
import 'package:vibeat/filter/screen/filter_mood/model/mood_model.dart';
import 'package:vibeat/filter/screen/filter_tag/model/tag_model.dart';
import 'package:vibeat/player/bloc/player_bloc.dart';
import 'package:vibeat/search.dart';
import 'package:vibeat/utils/theme.dart';
import 'package:http/http.dart' as http;

@RoutePage()
class ResultScreen extends StatefulWidget {
  const ResultScreen({
    super.key,
    this.genres,
    this.tags,
    this.keys,
    this.moods,
    this.bpmFrom,
    this.bpmTo,
    this.query,
  });

  final List<GenreModel>? genres;
  final List<TagModel>? tags;
  final List<KeyModel>? keys;
  final List<MoodModel>? moods;
  final int? bpmFrom;
  final int? bpmTo;
  final String? query;

  @override
  State<ResultScreen> createState() => _ResultScreenState();
}

class _ResultScreenState extends State<ResultScreen> {
  final List<FeatureModel> data = [];

  List<BeatEntity> beatData = [];

  @override
  void initState() {
    super.initState();

    getBeatData();

    if (widget.genres?.isNotEmpty ?? false) {
      String genresText =
          widget.genres?.map((genre) => genre.name).join(', ') ?? '';

      data.add(FeatureModel(name: 'Жанры', text: genresText));
    }

    if (widget.tags?.isNotEmpty ?? false) {
      String tagsText = widget.tags?.map((tag) => tag.name).join(', ') ?? '';

      data.add(FeatureModel(name: 'Тэги', text: tagsText));
    }

    if (widget.keys?.isNotEmpty ?? false) {
      String keysText = widget.keys?.map((key) => key.name).join(', ') ?? '';

      data.add(FeatureModel(name: 'Тональность', text: keysText));
    }

    if (widget.moods?.isNotEmpty ?? false) {
      String moodsText =
          widget.moods?.map((mood) => mood.name).join(', ') ?? '';

      data.add(FeatureModel(name: 'Настроение', text: moodsText));
    }

    if (widget.bpmFrom != 0 && widget.bpmTo != 0) {
      String bpmText = '${widget.bpmFrom} - ${widget.bpmTo}';

      data.add(FeatureModel(name: 'BPM', text: bpmText));
    }

    if (widget.query != "" && widget.query != null) {
      String textQuery = widget.query!;

      data.add(FeatureModel(name: 'Текст', text: textQuery));
    }
  }

  void getBeatData() async {
    final Map<String, dynamic> filters = {};

    if (widget.genres?.isNotEmpty ?? false) {
      filters['genres'] =
          widget.genres!.map((genre) => int.parse(genre.key)).toList();
    }
    if (widget.tags?.isNotEmpty ?? false) {
      filters['tags'] = widget.tags!.map((tag) => int.parse(tag.id)).toList();
    }
    if (widget.moods?.isNotEmpty ?? false) {
      filters['moods'] = widget.keys!.map((key) => int.parse(key.key)).toList();
    }
    if (widget.bpmFrom != 0 || widget.bpmTo != 0) {
      filters['max_bpm'] = widget.bpmTo;
      filters['min_bpm'] = widget.bpmFrom;
    }

    log(filters.toString());

    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    final ip = sharedPreferences.getString("ip");

    final response = await http.post(
      Uri.parse('http://$ip:8080/beat/filteredBeats'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(filters),
    );

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body)['data'];

      setState(() {
        beatData =
            data.map((json) => BeatEntity.fromJson(json, "false")).toList();
      });
    }
    if (response.statusCode == 500) {
      beatData = [];
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
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: AppColors.appbar,
        forceMaterialTransparency: true,
        title: const Text(
          'Биты',
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
              data.isNotEmpty
                  ? SliverPersistentHeader(
                      pinned: false,
                      delegate: _ResultHeaderDelegate(
                        data: data,
                      ),
                    )
                  : const SliverToBoxAdapter(),
              SliverPadding(
                padding: const EdgeInsets.only(top: 8, bottom: 80),
                sliver: SliverGrid(
                  delegate: SliverChildBuilderDelegate(
                    childCount: beatData.length,
                    (context, index) {
                      return Skeletonizer(
                        enabled: false,
                        child: GestureDetector(
                          onTap: () {
                              sl<PlayerBloc>()
                                .add(PlayCurrentBeatEvent(beatData, index));
        
                            context.router.push(const PlayerRoute());
                          },
                          child: NewBeatWidget(
                            gridItemWidth: gridItemWidth,
                            beat: beatData[index],
                            index: index,
                            width: width,
                            marginRight: 0,
                            isLoading: false,
                            openPlayer: () {
                            
                                  sl<PlayerBloc>()
                                  .add(PlayCurrentBeatEvent(beatData, index));
        
                              context.router.navigate(const PlayerRoute());
                            },
                            openInfoBeat: () {
                              context.router.navigate(
                                InfoBeat(
                                  beatId: beatData[index].id,
                                ),
                              );
                            },
                          ),
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

class _ResultHeaderDelegate extends SliverPersistentHeaderDelegate {
  final List<FeatureModel> data;

  _ResultHeaderDelegate({required this.data});

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
          Expanded(
            child: ListView.builder(
              shrinkWrap: true,
              scrollDirection: Axis.horizontal,
              itemCount: data.length,
              itemBuilder: (context, index) {
                return FeatureCard(
                  index: index,
                  name: data[index].name,
                  text: data[index].text,
                );
              },
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

class FeatureCard extends StatelessWidget {
  const FeatureCard({
    super.key,
    required this.name,
    required this.text,
    required this.index,
  });

  final int index;
  final String name;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(left: index == 0 ? 0 : 6),
      padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(12)),
        color: Color(0xff1E1E1E),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            "$name:  ",
            style: TextStyle(
              fontSize: 14,
              fontFamily: "Poppins",
              fontWeight: FontWeight.w400,
              color: Colors.white.withOpacity(0.3),
              letterSpacing: -0.41,
              // height: 1,
            ),
          ),
          Text(
            text,
            style: const TextStyle(
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
    );
  }
}

class FeatureModel {
  final String name;
  final String text;

  const FeatureModel({required this.name, required this.text});
}

// class BeatWidget extends StatelessWidget {
//   final double gridItemWidth;
//   final BeatEntity beat;

//   const BeatWidget({
//     super.key,
//     required this.gridItemWidth,
//     required this.beat,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return ClipRRect(
//       borderRadius: const BorderRadius.all(
//         Radius.circular(6),
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           // Image.asset(
//           //   fit: BoxFit.fitWidth,
//           //   width: gridItemWidth,
//           //   "assets/images/image1.png",
//           // ),

//           Image.network(
//             fit: BoxFit.fitHeight,
//             width: gridItemWidth,
//             height: gridItemWidth,
//             beat.picture,
//             // loadingBuilder: (context, child, loadingProgress) =>
//             //     Skeletonizer(
//             //   enabled: true,
//             //   child: ClipRRect(
//             //     borderRadius: const BorderRadius.all(Radius.circular(6)),
//             //     child: Container(
//             //       width: gridItemWidth,
//             //       height: gridItemWidth,
//             //       color: Colors.red,
//             //     ),
//             //   ),
//             // ),
//           ),
//           const SizedBox(height: 6),
//           Text(
//             "${beat.price} RUB",
//             style: AppTextStyles.bodyPrice2,
//           ),
//           Text(
//             beat.name,
//             style: AppTextStyles.headline1,
//             overflow: TextOverflow.ellipsis,
//           ),
//           GestureDetector(
//             onTap: () {
//               context.router
//                   .navigate(InfoBeatmaker(beatmakerId: beat.beatmakerId));
//             },
//             child: Padding(
//               padding: const EdgeInsets.only(top: 8),
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   Expanded(
//                     child: Row(
//                       children: [
//                         const SizedBox(
//                           width: 12,
//                           height: 12,
//                           child: CircleAvatar(
//                             backgroundImage: NetworkImage(
//                               'https://mimigram.ru/wp-content/uploads/2020/07/chto-takoe-foto.jpg',
//                             ),
//                           ),
//                         ),
//                         const SizedBox(width: 4),
//                         Expanded(
//                           child: Container(
//                             padding: const EdgeInsets.only(
//                               right: 5,
//                             ),
//                             child: Column(
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               children: [
//                                 const SizedBox(height: 2),
//                                 Text(
//                                   beat.beatmakerName == ''
//                                       ? "beatmaker1"
//                                       : beat.beatmakerName,
//                                   style: AppTextStyles.bodyText2,
//                                   overflow: TextOverflow.ellipsis,
//                                 ),
//                               ],
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                   Row(
//                     children: [
//                       Icon(
//                         Icons.volume_down_outlined,
//                         size: 12,
//                         color: AppColors.unselectedItemColor,
//                       ),
//                       Column(
//                         children: [
//                           const SizedBox(height: 1),
//                           Text(
//                             beat.plays.toString(),
//                             style:
//                                 AppTextStyles.bodyText2.copyWith(fontSize: 10),
//                             overflow: TextOverflow.ellipsis,
//                           ),
//                         ],
//                       ),
//                     ],
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

class BeatEntity {
  final String id;
  final bool isCurrentPlaying;
  final String name;
  final String description;
  final String picture;
  final String beatmakerId;
  final String beatmakerName;
  final String url;
  final int price;
  final int plays;
  final List<GenreModel> genres;
  final List<MoodModel> moods;
  final List<TagModel> tags;
  final KeyModel key;
  final int bpm;
  final int createAt;

  const BeatEntity({
    required this.id,
    required this.isCurrentPlaying,
    required this.name,
    required this.description,
    required this.picture,
    required this.beatmakerId,
    required this.beatmakerName,
    required this.url,
    required this.price,
    required this.plays,
    required this.genres,
    required this.moods,
    required this.tags,
    required this.key,
    required this.bpm,
    required this.createAt,
  });

  BeatEntity copyWith({
    String? id,
    bool? isCurrentPlaying,
    String? name,
    String? description,
    String? picture,
    String? beatmakerId,
    String? beatmakerName,
    String? url,
    int? price,
    int? plays,
    List<GenreModel>? genres,
    List<MoodModel>? moods,
    List<TagModel>? tags,
    KeyModel? key,
    int? bpm,
    int? createAt,
  }) {
    return BeatEntity(
      id: id ?? this.id,
      isCurrentPlaying: isCurrentPlaying ?? this.isCurrentPlaying,
      name: name ?? this.name,
      description: description ?? this.description,
      picture: picture ?? this.picture,
      beatmakerId: beatmakerId ?? this.beatmakerId,
      beatmakerName: beatmakerName ?? this.beatmakerName,
      url: url ?? this.url,
      price: price ?? this.price,
      plays: plays ?? this.plays,
      genres: genres ?? this.genres,
      moods: moods ?? this.moods,
      tags: tags ?? this.tags,
      key: key ?? this.key,
      bpm: bpm ?? this.bpm,
      createAt: createAt ?? this.createAt,
    );
  }

  factory BeatEntity.fromJson(
      Map<String, dynamic> json, String? currentPlayingBeatId) {
    return BeatEntity(
      id: json['id'].toString(),
      isCurrentPlaying:
          json['id'].toString() == currentPlayingBeatId ? true : false,
      name: json['name'].toString(),
      description:
          json['description'] != null ? json['description'].toString() : '',
      picture: 'http://${json['picture'].toString()}',
      // "http://storage.yandexcloud.net/imagesall/${json['picture'].toString()}",
      // picture: "http://i.ytimg.com/vi_webp/kGcnGpRterE/maxresdefault.webp",
      beatmakerId: json['beatmakerId'].toString(),
      beatmakerName: json['beatmakerName'].toString(),
      url: json['url'].toString(),
      price: int.parse(json['price'].toString()),
      plays: int.parse(json['plays'].toString()),
      genres: json['genres'] != null
          ? (json['genres'] as List<dynamic>)
              .map((genre) => GenreModel.fromJson(genre))
              .toList()
          : [],
      moods: json['moods'] != null
          ? (json['moods'] as List<dynamic>)
              .map((mood) => MoodModel.fromJson(mood))
              .toList()
          : [],
      tags: json['tags'] != null
          ? (json['tags'] as List<dynamic>)
              .map((tag) => TagModel.fromJson(tag))
              .toList()
          : [],
      key: json['key'] != null
          ? KeyModel.fromJson(json['key'])
          : const KeyModel(key: '', name: '', isSelected: false),
      bpm: int.parse(json['bpm'].toString()),
      createAt: int.parse(json['created_at'].toString()),
    );
  }
}
