import 'dart:convert';
import 'dart:developer';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:vibeat/app/app_router.gr.dart';
import 'package:vibeat/app/injection_container.dart';
import 'package:vibeat/core/api_client.dart';
import 'package:vibeat/filter/result.dart';
import 'package:vibeat/player/bloc/player_bloc.dart';
import 'package:vibeat/search.dart';
import 'package:vibeat/utils/theme.dart';

@RoutePage()
class FavoriteScreen extends StatefulWidget {
  const FavoriteScreen({super.key});

  @override
  State<FavoriteScreen> createState() => _FavoriteScreenState();
}

class _FavoriteScreenState extends State<FavoriteScreen> {
  List<BeatEntity> beatData = [];

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    ModalRoute.of(context)?.addScopedWillPopCallback(() {
      getFavoriteBeats();
      return Future.value(true);
    });
  }

  @override
  void initState() {
    super.initState();

    getFavoriteBeats();
  }

  Future<void> getFavoriteBeats() async {
    final apiClient = sl<ApiClient>().dio;

    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    final ip = sharedPreferences.getString("ip");

    try {
      final response = await apiClient.get(
        "http://$ip:8080/activityBeat/viewMyLikes",
      );

      if (response.statusCode == 200) {
        // Парсим JSON ответ
        final Map<String, dynamic> responseData = response.data is String
            ? json.decode(response.data)
            : response.data;

        // Проверяем статус и наличие данных
        if (responseData['status'] == true) {
          final List<dynamic> dataList = responseData['data'];

          setState(() {
            beatData = dataList
                .map((item) => BeatEntity.fromJson(item['beat'], "false"))
                .toList();
          });
        } else {
          setState(() {
            beatData = [];
          });
        }
      } else if (response.statusCode == 500) {
        setState(() {
          beatData = [];
        });
      }
    } catch (e) {
      log('Error fetching favorite beats: $e');
      setState(() {
        if (!mounted) return;
        beatData = [];
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
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: AppColors.appbar,
        forceMaterialTransparency: true,
        title: const Text(
          "Избранное",
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
              SliverPadding(
                padding: const EdgeInsets.only(top: 8, bottom: 80),
                sliver: SliverGrid(
                  delegate: SliverChildBuilderDelegate(
                    childCount: beatData.length,
                    (context, index) {
                      return Skeletonizer(
                        enabled: false,
                        child: NewBeatWidget(
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
                          beat: beatData[index],
                          index: index,
                          width: width,
                          marginRight: 0,
                          gridItemWidth: gridItemWidth,
                          isLoading: false,
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
