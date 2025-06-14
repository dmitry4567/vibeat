import 'dart:convert';
import 'dart:developer';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:vibeat/filter/screen/filter_genre/model/genre_model.dart';
import 'package:vibeat/filter/screen/filter_key/model/key_model.dart';
import 'package:vibeat/filter/screen/filter_mood/model/mood_model.dart';
import 'package:vibeat/filter/screen/filter_tag/model/tag_model.dart';
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
  });

  final List<GenreModel>? genres;
  final List<TagModel>? tags;
  final List<KeyModel>? keys;
  final List<MoodModel>? moods;
  final int? bpmFrom;
  final int? bpmTo;

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
  }

  void getBeatData() async {
    final Map<String, dynamic> filters = {};

    if (widget.genres?.isNotEmpty ?? false) {
      filters['genres'] = widget.genres!.map((genre) => genre.key).toList();
    }
    if (widget.tags?.isNotEmpty ?? false) {
      filters['tags'] = widget.tags!.map((tag) => tag.id).toList();
    }
    if (widget.moods?.isNotEmpty ?? false) {
      filters['moods'] = widget.keys!.map((key) => key.key).toList();
    }
    if (widget.bpmFrom != 0 && widget.bpmTo != 0) {
      filters['max_bpm'] = widget.bpmTo;
      filters['min_bpm'] = widget.bpmFrom;
    }

    log(filters.toString());

    final response = await http.post(
      Uri.parse('http://192.168.0.135:7771/api/beat/filteredBeats'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(filters),
    );

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body)['data'];

      log(data.toString());

      setState(() {
        beatData = data.map((json) => BeatEntity.fromJson(json)).toList();
      });
    }
    if (response.statusCode == 500) {
      beatData = [];
    }
  }

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
        title: const Text(
          'Биты',
          style: AppTextStyles.bodyAppbar,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: paddingWidth),
        child: CustomScrollView(
          slivers: [
            data.isNotEmpty
                ? SliverPersistentHeader(
                    pinned: true,
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
                      child: BeatWidget(
                        gridItemWidth: gridItemWidth,
                        beat: beatData[index],
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
    return ClipRRect(
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
                          'https://upload.wikimedia.org/wikipedia/commons/b/b6/Image_created_with_a_mobile_phone.png',
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
                        style: AppTextStyles.bodyText2.copyWith(fontSize: 10),
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
    );
  }
}

class BeatEntity {
  final String name;
  final String picture;
  final String beatmakerName;
  final String url;
  final int price;
  final int plays;

  const BeatEntity({
    required this.name,
    required this.picture,
    required this.beatmakerName,
    required this.url,
    required this.price,
    required this.plays,
  });

  BeatEntity copyWith({
    String? name,
    String? picture,
    String? beatmakerName,
    String? url,
    int? price,
    int? plays,
  }) {
    return BeatEntity(
      name: name ?? this.name,
      picture: picture ?? this.picture,
      beatmakerName: beatmakerName ?? this.beatmakerName,
      url: url ?? this.url,
      price: price ?? this.price,
      plays: plays ?? this.plays,
    );
  }

  factory BeatEntity.fromJson(Map<String, dynamic> json) {
    return BeatEntity(
      name: json['name'].toString(),
      picture:
          "http://storage.yandexcloud.net/imagesall/${json['picture'].toString()}",
      // picture: "http://i.ytimg.com/vi_webp/kGcnGpRterE/maxresdefault.webp",
      beatmakerName: json['beatmakerName'].toString(),
      url: json['url'].toString(),
      price: int.parse(json['price'].toString()),
      plays: int.parse(json['plays'].toString()),
    );
  }
}
