import 'dart:convert';
import 'dart:developer';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:vibeat/filter/result.dart';
import 'package:vibeat/filter/screen/filter_mood/model/mood_model.dart';
import 'package:vibeat/utils/theme.dart';
import 'package:http/http.dart' as http;

@RoutePage()
class PlaylistMoodScreen extends StatefulWidget {
  const PlaylistMoodScreen({super.key, required this.mood});

  final MoodModel mood;

  @override
  State<PlaylistMoodScreen> createState() => _PlaylistMoodScreenState();
}

class _PlaylistMoodScreenState extends State<PlaylistMoodScreen> {
  List<BeatEntity> beatData = [];

  @override
  void initState() {
    super.initState();

    getBeatByMood();
  }

  void getBeatByMood() async {
    final response = await http.get(
      Uri.parse(
          'http://192.168.0.135:7771/api/beat/beatsByMoodId/${widget.mood.key}'),
      headers: {'Content-Type': 'application/json'},
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
        title: Text(
          widget.mood.name,
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
