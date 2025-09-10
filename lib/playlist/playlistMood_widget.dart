import 'dart:convert';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:vibeat/app/app_router.gr.dart';
import 'package:vibeat/app/injection_container.dart';
import 'package:vibeat/features/favorite/data/models/beat_model.dart';
import 'package:vibeat/filter/result.dart';
import 'package:vibeat/filter/screen/filter_key/model/key_model.dart';
import 'package:vibeat/filter/screen/filter_mood/model/mood_model.dart';
import 'package:vibeat/player/bloc/player_bloc.dart';
import 'package:vibeat/search.dart';
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
  List<BeatModel> beatData = [];
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

  @override
  void initState() {
    super.initState();

    getBeatByMood();
  }

  void getBeatByMood() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    final ip = sharedPreferences.getString("ip");

    final response = await http.get(
      Uri.parse('http://$ip:8080/beat/beatsByMoodId/${widget.mood.key}'),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body)['data'];

      setState(() {
        beatData =
            data.map((json) => BeatModel.fromJson(json)).toList();
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
              sliver: beatData.isNotEmpty
                  ? SliverGrid(
                      delegate: SliverChildBuilderDelegate(
                        childCount: beatData.length,
                        (context, index) {
                          return Skeletonizer(
                            enabled: false,
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
                          );
                        },
                      ),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        mainAxisExtent: gridItemWidth + 71,
                        crossAxisSpacing: 20,
                        mainAxisSpacing: 20,
                      ),
                    )
                  : SliverGrid(
                      delegate: SliverChildBuilderDelegate(
                        childCount: placeholderBeat.length,
                        (context, index) {
                          return Skeletonizer(
                              enabled: true,
                              child: ClipRRect(
                                borderRadius: const BorderRadius.all(
                                  Radius.circular(6),
                                ),
                                child: Container(
                                  width: gridItemWidth,
                                  height: gridItemWidth,
                                  color: Colors.red,
                                ),
                              ));
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
